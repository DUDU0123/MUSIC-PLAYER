import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/music_view/widgets/artwork_getting_widget.dart';
import 'package:music_player/views/song_lyrics.dart/song_lyrics_page.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicPlayPage extends StatelessWidget {
  const MusicPlayPage({
    super.key,
    required this.songModel,
    // required this.lastPlayedPosition,
    required this.songId,
    required this.songTitle,
    required this.artistName,
    required this.albumName,
    required this.songFormat,
    required this.songSize,
    required this.songPathIndevice,
    required this.audioController,
    required this.musicUri,
    required this.favoriteController,
  });

  final AllMusicsModel songModel;
  final int songId;
  final String songTitle;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  final AudioController audioController;
  final String musicUri;
  final FavoriteController favoriteController;

  FavoriteModel getFavoriteModelFromAllMusicModel(AllMusicsModel allMusic) {
    return FavoriteModel(
      id: allMusic.id,
      musicName: allMusic.musicName,
      musicArtistName: allMusic.musicArtistName,
      musicAlbumName: allMusic.musicAlbumName,
      musicFileSize: allMusic.musicFileSize,
      musicFormat: allMusic.musicFormat,
      musicPathInDevice: allMusic.musicPathInDevice,
      musicUri: allMusic.musicUri,
    );
  }
  //late AllMusicsModel currentPlayingSong;
  // Duration currentPosition = audioController.currentPlaybackPosition;

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: kScreenWidth,
        height: kScreenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1, color: kLightGrey),
                      top: BorderSide(width: 1, color: kLightGrey),
                    )),
                  ),
                ),
                kHeight30,
                Column(
                  children: [
                    Center(
                      child: Container(
                        width: 280.w,
                        height: 280.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              color: kWhite.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 2,
                            )
                          ],
                          borderRadius: BorderRadius.circular(60),
                          color: kMusicIconContainerColor,
                        ),
                        child: Obx(() {
                          return ArtWorkWidgetMusicPlayingPage(
                              songId: audioController
                                          .currentPlayingSong.value !=
                                      null
                                  ? audioController.currentPlayingSong.value!.id
                                  : songId);
                        }),
                      ),
                    ),
                    kHeight15,
                    // Duration Slider
                    Obx(() {
                      return Slider(
                        activeColor: kRed,
                        thumbColor: kRed,
                        inactiveColor: const Color.fromARGB(255, 53, 53, 53),
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
                        max: audioController.duration.value != null
                            ? audioController.duration.value.inSeconds
                                .toDouble()
                            : 0.0,
                        value:
                            audioController.position.value.inSeconds.toDouble(),
                        onChanged: (value) {
                          audioController.changeToSeconds(value.toInt());
                          value = value;
                        },
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            return TextWidgetCommon(
                              text: audioController.position.value
                                  .toString()
                                  .split(".")[0],
                              fontSize: 10.sp,
                              color: kGrey,
                            );
                          }),
                          Obx(() {
                            return TextWidgetCommon(
                              text: audioController.duration.value
                                  .toString()
                                  .split(".")[0],
                              fontSize: 10.sp,
                              color: kGrey,
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: kScreenWidth,
                  height: kScreenHeight / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          // song name
                          SizedBox(
                            width: kScreenWidth / 1.6,
                            child: Obx(() {
                              return TextWidgetCommon(
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                text:
                                    audioController.currentPlayingSong.value !=
                                            null
                                        ? audioController
                                            .currentPlayingSong.value!.musicName
                                        : songTitle,
                                fontSize: 23.sp,
                                color: kWhite,
                                fontWeight: FontWeight.w500,
                              );
                            }),
                          ),
                          kHeight5,
                          // song artist name
                          Obx(() {
                            return TextWidgetCommon(
                              overflow: TextOverflow.ellipsis,
                              text: audioController.currentPlayingSong.value !=
                                      null
                                  ? audioController.currentPlayingSong.value!
                                              .musicArtistName ==
                                          '<unknown>'
                                      ? 'Unknown Artist'
                                      : audioController.currentPlayingSong
                                          .value!.musicArtistName
                                  : artistName,
                              fontSize: 10.sp,
                              color: kGrey,
                              fontWeight: FontWeight.w400,
                            );
                          }),
                        ],
                      ),
                      // control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // play back button
                          GestureDetector(
                            onTap: () {
                              audioController.playPreviousSong();
                            },
                            child: Image.asset(
                              'assets/play_back.png',
                              color: kRed,
                              scale: 18.sp,
                            ),
                          ),
                          // play and pause button
                          GestureDetector(
                            onTap: () {
                              if (audioController.isPlaying.value) {
                                audioController.pauseSong();
                              } else {
                                audioController.audioPlayer.play();
                              }
                              audioController.isPlaying.value =
                                  !audioController.isPlaying.value;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kRed),
                              child: Obx(() {
                                log(audioController.isPlaying.value.toString());
                                return Icon(
                                  audioController.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 40,
                                  color: kWhite,
                                );
                              }),
                            ),
                          ),
                          // play next button
                          GestureDetector(
                            onTap: () {
                              audioController.playNextSong();
                            },
                            child: Image.asset(
                              'assets/play_next.png',
                              color: kRed,
                              scale: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      // song bottom settings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // song current playlist show icon
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MusicLyricsPage(
                                    // currentPlayingsongs:  ,
                                    songModel: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController
                                            .currentPlayingSong.value!
                                        : songModel,
                                    songId: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController
                                            .currentPlayingSong.value!.id
                                        : songId,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.lyrics_outlined,
                              size: 30,
                              color: kWhite,
                            ),
                          ),
                          // song favourite add icon
                          GetBuilder<FavoriteController>(
                              global: true,
                              builder: (favoriteController) {
                                return Obx(() {
                                  return IconButton(
                                    onPressed: () {
                                      FavoriteModel favoriteMusic =
                                          getFavoriteModelFromAllMusicModel(
                                              audioController.currentPlayingSong
                                                      .value ??
                                                  songModel);
                                      favoriteController.onTapFavorite(
                                          favoriteMusic, context);
                                    },
                                    icon: Icon(
                                      favoriteController.isFavorite(
                                              audioController.currentPlayingSong
                                                          .value !=
                                                      null
                                                  ? audioController
                                                      .currentPlayingSong
                                                      .value!
                                                      .id
                                                  : 0)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: favoriteController.isFavorite(
                                              audioController.currentPlayingSong
                                                          .value !=
                                                      null
                                                  ? audioController
                                                      .currentPlayingSong
                                                      .value!
                                                      .id
                                                  : 0)
                                          ? kRed
                                          : kWhite,
                                    ),
                                  );
                                });
                              }),

                          // song loop shuffle

                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                audioController.songLoopModesControlling();
                              },
                              child: audioController.isLoopOneSong.value
                                  ? Image.asset(
                                      "assets/loop_one.png",
                                      scale: 15.sp,
                                      color: kWhite,
                                    )
                                  : Image.asset(
                                      "assets/shuffle.png",
                                      scale: 18.sp,
                                      color: kWhite,
                                    ),
                            );
                          }),

                          // song settings icon
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: kMenuBtmSheetColor,
                                context: context,
                                builder: (context) {
                                  return MenuBottomSheet(
                                    favouriteController: favoriteController,
                                    song: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController
                                            .currentPlayingSong.value!
                                        : songModel,
                                    songId: songId,
                                    musicUri: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController
                                            .currentPlayingSong.value!.musicUri
                                        : musicUri,
                                    kScreenHeight: kScreenHeight,
                                    pageType: PageTypeEnum.musicViewPage,
                                    songName: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController
                                            .currentPlayingSong.value!.musicName
                                        : songTitle,
                                    artistName: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController.currentPlayingSong
                                            .value!.musicArtistName
                                        : artistName,
                                    albumName: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController.currentPlayingSong
                                            .value!.musicAlbumName
                                        : albumName,
                                    songFormat: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController.currentPlayingSong
                                            .value!.musicFormat
                                        : songFormat,
                                    songSize: AppUsingCommonFunctions
                                        .convertToMBorKB(audioController
                                                    .currentPlayingSong.value !=
                                                null
                                            ? audioController.currentPlayingSong
                                                .value!.musicFileSize
                                            : AppUsingCommonFunctions.parseSongSize(songSize)),
                                    songPathIndevice: audioController
                                                .currentPlayingSong.value !=
                                            null
                                        ? audioController.currentPlayingSong
                                            .value!.musicPathInDevice
                                        : songPathIndevice,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              size: 30,
                              color: kWhite,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
