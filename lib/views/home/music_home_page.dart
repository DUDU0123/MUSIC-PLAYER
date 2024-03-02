import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

class MusicHomePage extends StatelessWidget {
  const MusicHomePage({
    super.key,
    required this.audioController,
    required this.favoriteController,
    required this.allMusicController,
  });

  final AudioController audioController;
  final FavoriteController favoriteController;
  final AllMusicController allMusicController;

  @override
  Widget build(BuildContext context) {
    log("REBUILDING");
    Duration lastPlayedPosition = Duration.zero;
    //  final kScreenWidth = MediaQuery.of(context).size.width;
    //  final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<List<AllMusicsModel>>(
          future: audioController.getAllSongs(),
          builder: (BuildContext context,
              AsyncSnapshot<List<AllMusicsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const DefaultCommonWidget(text: "Error on loading songs");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const DefaultCommonWidget(
                text: "No songs available",
              );
            }
            return Obx(() {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                itemBuilder: (context, index) {
                  //print(widget.musicBox.length);
                  AllMusicsModel song = snapshot.data![index];
                  Get.find<AudioController>().setSong(song);
                  // log("Displaying songs length at $index ${song.musicName}");
                  //  audioController.setCurrentSong(song);
                  // Get.find<AllMusicController>().setCurrentSong(snapshot.data![index]);
                  // log(
                  //     "Helloo BSCABJJKSN :::::: ${allMusicController.oneSong.musicName}");
                  //     log("FROM SONGGG:::::: ${song.musicName}");
                  return MusicTileWidget(
                    audioController: audioController,
                    favoriteController: favoriteController,
                    musicUri: song.musicUri,
                    songId: song.id,
                    songModel: song,
                    pageType: PageTypeEnum.homePage,
                    albumName: song.musicAlbumName,
                    artistName: song.musicArtistName,
                    songTitle: song.musicName,
                    songFormat: song.musicFormat,
                    songPathIndevice: song.musicPathInDevice,
                    songSize: AppUsingCommonFunctions.convertToMBorKB(
                        song.musicFileSize),
                    onTap: () async {
                      audioController.isPlaying.value = true;
                      bool isRecentlyPlayed =
                          audioController.isSongRecentlyPlayed(
                              song, audioController.musicBox.values.toList());
                      if (isRecentlyPlayed) {
                        lastPlayedPosition =
                            audioController.audioPlayer.position;
                      }
                      audioController.playSong(index,
                          isRecentlyPlayed: isRecentlyPlayed,
                          lastPlayedPosition: lastPlayedPosition);
                      // log("FROM SONGGG:::::: ${song.musicName} ${song.id}");
                      //  log("Helloo BSCABJJKSN :::::: ${allMusicController.oneSong.musicName} ${allMusicController.oneSong.id}");

                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return MusicPlayPage(
                            favoriteController: favoriteController,
                            musicUri: song.musicUri,
                            audioController: audioController,
                            albumName: song.musicAlbumName,
                            artistName: song.musicArtistName,
                            songFormat: song.musicFormat,
                            songPathIndevice: song.musicPathInDevice,
                            songSize: AppUsingCommonFunctions.convertToMBorKB(
                                song.musicFileSize),
                            songTitle: song.musicName,
                            songId: song.id,
                            songModel: song,
                          );
                        },
                      );
                    },
                  );
                },
              );
            });
          }),
    );
  }
}
