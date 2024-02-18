import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/music_play_page_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/music_view/music_play_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicHomePage extends StatefulWidget {
  MusicHomePage({
    super.key,
    required this.audioQuery,
    required this.audioPlayer,
    required this.isPlaying,
    required this.requestPermission,
  });

  final OnAudioQuery audioQuery;
  final AudioPlayer audioPlayer;
  final Future<List<SongModel>> Function() requestPermission;

  bool isPlaying = false;

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  bool isSongsLoaded = false;
  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  MusicPlayPageController controller = Get.put(MusicPlayPageController());
  int? currentPlayingSongIndex;
  late ConcatenatingAudioSource audioSource;
  late Future<List<SongModel>> _loadSongsFuture;

  void playSong([String? url, int? index]) {
    try {
      if (url != null) {
        widget.audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(url),
          ),
        );
      }
      widget.audioPlayer.play();
      currentPlayingSongIndex = index;
    } on Exception {
      debugPrint("Can't Play Song PlaySong Not Working Properly Let's fix it");
    }
    setState(() {
      widget.isPlaying = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSongsFuture = widget.requestPermission();
    _loadSongsFuture.then((songs) {
      _loadSongs(songs);
      playSong();
    });
    // Timer(const Duration(seconds: 5), () {
    //   setState(() {
    //     isSongsLoaded = true;
    //   });
    // });
  }

  void _loadSongs(List<SongModel> songs) async {
    try {
      List<AllMusicsModel> allMusics =
          songs.map((song) => AllMusicsModel.fromSongModel(song)).toList();

      for (var music in allMusics) {
        // Check if musicBox already contains the music with the same id
        if (!musicBox.values
            .any((existingMusic) => existingMusic.id == music.id)) {
          musicBox.add(music);
        }
      }
      List<AudioSource> audioSourceList = allMusics.map((music) {
        return AudioSource.uri(
          Uri.parse(music.musicUri),
          tag: MediaItem(
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
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
          future: _loadSongsFuture,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: kRed),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error Occured"),
              );
            }

            return Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: musicBox.length,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  itemBuilder: (context, index) {
                    print(musicBox.length);
                    AllMusicsModel song = musicBox.getAt(index)!;
                    print(
                        "Displaying songs length at $index ${song.musicName}");
                    return MusicTileWidget(
                      songId: song.id,
                      isPlaying:
                          currentPlayingSongIndex == index && widget.isPlaying,
                      onTap: () {
                        Get.find<MusicPlayPageController>().id = song.id;
                        //  playSong(song.musicUri, index);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return MusicPlayPage(
                              initialIndex: index,
                              audioSource: audioSource,
                              songModel: song,
                              audioPlayer: widget.audioPlayer,
                              isPlaying: currentPlayingSongIndex == index &&
                                  widget.isPlaying,
                            );
                          },
                        );
                      },
                      pageType: PageTypeEnum.normalPage,
                      albumName: song.musicAlbumName,
                      artistName: song.musicArtistName,
                      songTitle: song.musicName,
                      songFormat: song.musicFormat,
                      songPathIndevice: song.musicPathInDevice,
                      songSize: "${song.musicFileSize}MB",
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
