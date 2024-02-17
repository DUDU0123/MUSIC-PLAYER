import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
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
  final Function() requestPermission;

  bool isPlaying = false;

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  MusicPlayPageController controller = Get.put(MusicPlayPageController());
  int? currentPlayingSongIndex;

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
    playSong();
  }

  @override
  Widget build(BuildContext context) {
    //final kScreenWidth = MediaQuery.of(context).size.width;
    // final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
          future: widget.requestPermission(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: kRed),
              );
            }else if(snapshot.hasError){
              return const Center(
                child: Text("Error Occured"),
              );
            }
            musicBox.addAll(snapshot.data!.map((song) => AllMusicsModel.fromSongModel(song)));
            return ListView.builder(
              itemCount: musicBox.length,
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              itemBuilder: (context, index) {
                AllMusicsModel song = musicBox.getAt(index)!;
                return MusicTileWidget(
                  songId: song.id,
                  isPlaying:
                      currentPlayingSongIndex == index && widget.isPlaying,
                  onTap: () {
                    Get.find<MusicPlayPageController>().id =
                        song.id;
                    playSong(song.musicUri, index);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return MusicPlayPage(
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
            );
          }),
    );
  }
}
