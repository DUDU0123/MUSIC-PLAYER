import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
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
  });

  final AllMusicsModel songModel;

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
                              songId:
                                  AudioController.to.currentPlayingSong.value !=
                                          null
                                      ? AudioController
                                          .to.currentPlayingSong.value!.id
                                      : songModel.id);
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
                        max: AudioController.to.duration.value != null
                            ? AudioController.to.duration.value.inSeconds
                                .toDouble()
                            : 0.0,
                        value: AudioController.to.position.value.inSeconds
                            .toDouble(),
                        onChanged: (value) {
                          AudioController.to.changeToSeconds(value.toInt());
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
                              text: AudioController.to.position.value
                                  .toString()
                                  .split(".")[0],
                              fontSize: 10.sp,
                              color: kGrey,
                            );
                          }),
                          Obx(() {
                            return TextWidgetCommon(
                              text: AudioController.to.duration.value
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
                                text: AudioController
                                            .to.currentPlayingSong.value !=
                                        null
                                    ? AudioController
                                        .to.currentPlayingSong.value!.musicName
                                    : songModel.musicName,
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
                              text:
                                  AudioController.to.currentPlayingSong.value !=
                                          null
                                      ? AudioController.to.currentPlayingSong
                                                  .value!.musicArtistName ==
                                              '<unknown>'
                                          ? 'Unknown Artist'
                                          : AudioController
                                              .to
                                              .currentPlayingSong
                                              .value!
                                              .musicArtistName
                                      : songModel.musicArtistName,
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
                              AudioController.to.playPreviousSong();
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
                              if (AudioController.to.isPlaying.value) {
                                AudioController.to.pauseSong();
                              } else {
                                AudioController.to.audioPlayer.play();
                              }
                              AudioController.to.isPlaying.value =
                                  !AudioController.to.isPlaying.value;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kRed),
                              child: Obx(() {
                                return Icon(
                                  AudioController.to.isPlaying.value
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
                              AudioController.to.playNextSong();
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
                          GetBuilder<AudioController>(
                              init: AudioController.to,
                              builder: (controller) {
                                return IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MusicLyricsPage(
                                          songModel: controller
                                                      .currentPlayingSong
                                                      .value !=
                                                  null
                                              ? controller
                                                  .currentPlayingSong.value!
                                              : songModel,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.lyrics_outlined,
                                    size: 30,
                                    color: kWhite,
                                  ),
                                );
                              }),
                          // song favourite add icon
                          GetBuilder<FavoriteController>(
                              global: true,
                              builder: (favoriteController) {
                                return Obx(() {
                                  return IconButton(
                                    onPressed: () {
                                      FavoriteModel favoriteMusic =
                                          getFavoriteModelFromAllMusicModel(
                                              AudioController
                                                      .to
                                                      .currentPlayingSong
                                                      .value ??
                                                  songModel);
                                      favoriteController.onTapFavorite(
                                          favoriteMusic, context);
                                    },
                                    icon: Icon(
                                      favoriteController.isFavorite(
                                              AudioController
                                                          .to
                                                          .currentPlayingSong
                                                          .value !=
                                                      null
                                                  ? AudioController
                                                      .to
                                                      .currentPlayingSong
                                                      .value!
                                                      .id
                                                  : 0)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: favoriteController.isFavorite(
                                              AudioController
                                                          .to
                                                          .currentPlayingSong
                                                          .value !=
                                                      null
                                                  ? AudioController
                                                      .to
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
                                AudioController.to.songLoopModesControlling();
                              },
                              child: AudioController.to.isLoopOneSong.value
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
                          GetBuilder<PlaylistController>(
                              init: PlaylistController(),
                              builder: (controller) {
                                return IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      backgroundColor: kMenuBtmSheetColor,
                                      context: context,
                                      builder: (context) {
                                        return MenuBottomSheet(
                                          song: AudioController
                                                      .to
                                                      .currentPlayingSong
                                                      .value !=
                                                  null
                                              ? AudioController
                                                  .to.currentPlayingSong.value!
                                              : songModel,
                                          kScreenHeight: kScreenHeight,
                                          pageType: PageTypeEnum.musicViewPage,
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.more_horiz,
                                    size: 30,
                                    color: kWhite,
                                  ),
                                );
                              }),
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
