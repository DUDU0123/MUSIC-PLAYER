import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
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

  //late Future<List<SongModel>> _loadSongsFuture;

  // @override
  @override
  Widget build(BuildContext context) {
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              itemBuilder: (context, index) {
                //print(widget.musicBox.length);
                AllMusicsModel song = snapshot.data![index];
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
                  songSize: "${song.musicFileSize}MB",
                  onTap: () async {
                    bool isRecentlyPlayed =
                        audioController.isSongRecentlyPlayed(
                            song, audioController.musicBox.values.toList());
                    if (isRecentlyPlayed) {
                      lastPlayedPosition = audioController.audioPlayer.position;
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
                          songSize: song.musicFileSize.toString(),
                          songTitle: song.musicName,
                          songId: song.id,
                          songModel: song,
                        );
                      },
                    );
                  },
                  // Check if the song is recently played

                  // if (widget.songModel != null) {
                  //   // checking is Song is recently played
                  // bool isRecentlyPlayed = isSongRecentlyPlayed(
                  //     widget.songModel!, widget.musicBox.values.toList());

                  //   // last played position of the song
                  //   if (widget.currentPlayingSongIndex == widget.index &&
                  //       widget.isPlaying != null &&
                  //       widget.isPlaying!) {
                  //     widget.lastPlayedPosition = widget.audioPlayer.position;
                  //   }
                  //   // playsong implementation
                  //   widget.playSong!(
                  //       url: widget.songModel!.musicUri,
                  //       index: widget.musicBox.keyAt(
                  //           widget.musicBox.values.toList().indexOf(widget.songModel!)),
                  //       isRecentlyPlayed: isRecentlyPlayed);
                  // }
                  // audioController: audioController,
                  // audioPlayer: widget.audioPlayer,
                  // audioSource: audioSource,
                  // index: index,
                  // musicBox: widget.musicBox,

                  // currentPlayingSongIndex: currentPlayingSongIndex,
                  // playSong: ({index, isRecentlyPlayed, url}) {
                  //   playSong(
                  //       index: index,
                  //       url: song.musicUri,
                  //       isRecentlyPlayed: isRecentlyPlayed ?? false);
                  // },

                  // isPlaying: currentPlayingSongIndex == index &&
                  //         widget.isPlaying != null
                  //     ? widget.isPlaying!
                  //     : false,
                );
              },
            );
          }),
    );
  }
}
