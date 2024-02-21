import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
import 'package:music_player/views/common_widgets/default_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicHomePage extends StatefulWidget {
  MusicHomePage({
    super.key,
    required this.isPlaying,
    required this.audioPlayer,
    required this.musicBox,
    required this.requestPermission,
  });
  bool isPlaying;
  final AudioPlayer audioPlayer;
  final Box<AllMusicsModel> musicBox;

  final Future<List<SongModel>> requestPermission;

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  late Future<List<SongModel>> _loadSongsFuture;
  bool isSongsLoaded = false;
  late ConcatenatingAudioSource? audioSource;
  int? currentPlayingSongIndex;
  Duration lastPlayedPosition = Duration.zero;
  @override
  void initState() {
    super.initState();
    _loadSongsFuture = widget.requestPermission;
    _loadSongsFuture.then((songs) {
      _loadSongs(songs);
    });
    playSong();
    Timer(
        Duration(
          seconds: 1,
        ), () {
      setState(() {
        isSongsLoaded = true;
      });
    });
  }


  // playSongMethod
  void playSong({String? url, int? index, bool? isRecentlyPlayed = false}) {
    try {
      if (url != null && index != null) {
        widget.audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(url),
          ),
          initialPosition: lastPlayedPosition,
        );
      }
      widget.audioPlayer.play();
      currentPlayingSongIndex = index;
      if (isRecentlyPlayed != null) {
        if (!isRecentlyPlayed && index != null) {
          AllMusicsModel song = widget.musicBox.getAt(index)!;
          widget.musicBox.add(song);
          // Update the recently played list
          Box<RecentlyPlayedModel> recentlyPlayedBox =
              Hive.box<RecentlyPlayedModel>('recent');
          RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
                  'recent',
                  defaultValue:
                      RecentlyPlayedModel(recentlyPlayedSongsList: [])) ??
              RecentlyPlayedModel(recentlyPlayedSongsList: []);
          recentlyPlayedModel.addRecentlyPlayedSong(song);
          recentlyPlayedBox.put('recent', recentlyPlayedModel);
        }
      }
    } on Exception {
      debugPrint("Can't Play Song PlaySong Not Working Properly Let's fix it");
    }
    setState(() {
      widget.isPlaying = true;
    });
  }

  void _loadSongs(List<SongModel> songs) async {
    try {
      List<AllMusicsModel> allMusics =
          songs.map((song) => AllMusicsModel.fromSongModel(song)).toList();

      for (var music in allMusics) {
        // Check if musicBox already contains the music with the same id
        if (!widget.musicBox.values
            .any((existingMusic) => existingMusic.id == music.id)) {
          widget.musicBox.add(music);
        }
      }
      List<AudioSource> audioSourceList = allMusics.map((music) {
        return AudioSource.uri(
          Uri.parse(music.musicUri),
          tag: MediaItem(
            duration: Duration(seconds: 2),
            id: music.id.toString(),
            album: music.musicAlbumName,
            title: music.musicName,
            artUri: Uri.parse(music.id.toString()),
          ),
        );
      }).toList();

      setState(() {
        audioSource = ConcatenatingAudioSource(
          children: audioSourceList,
        );
      });
    } catch (e) {
      print("Error loading songs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    if (!isSongsLoaded) {
      return DefaultWidget();
    }
    return Scaffold(
        body: widget.musicBox.isEmpty
            ? DefaultWidget()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.musicBox.length,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                itemBuilder: (context, index) {
                  print(widget.musicBox.length);
                  AllMusicsModel song = widget.musicBox.getAt(index)!;
                  print("Displaying songs length at $index ${song.musicName}");
                  return MusicTileWidget(
                    audioPlayer: widget.audioPlayer,
                    audioSource: audioSource,
                    index: index,
                    musicBox: widget.musicBox,
                    songModel: song,
                    currentPlayingSongIndex: currentPlayingSongIndex,
                    playSong: ({index, isRecentlyPlayed, url}) {
                      playSong(
                          index: index,
                          url: song.musicUri,
                          isRecentlyPlayed: isRecentlyPlayed ?? false);
                    },
                    songId: song.id,
                    isPlaying: currentPlayingSongIndex == index &&
                            widget.isPlaying != null
                        ? widget.isPlaying!
                        : false,
                    pageType: PageTypeEnum.homePage,
                    albumName: song.musicAlbumName,
                    artistName: song.musicArtistName,
                    songTitle: song.musicName,
                    songFormat: song.musicFormat,
                    songPathIndevice: song.musicPathInDevice,
                    songSize: "${song.musicFileSize}MB",
                  );
                },
              ));
  }
}
