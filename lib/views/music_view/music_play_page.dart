import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayPage extends StatelessWidget {
  MusicPlayPage({
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
    required this.audioController, required this.musicUri, required this.favoriteController,
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

  Duration totalDuration = const Duration();
  Duration currentPosition = const Duration();

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
                        child: ArtWorkWidgetMusicPlayingPage(songId: songId),
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
                            child: TextWidgetCommon(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: songTitle,
                              fontSize: 23.sp,
                              color: kWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          kHeight5,
                          // song artist name
                          TextWidgetCommon(
                            overflow: TextOverflow.ellipsis,
                            text: artistName == '<unknown>'
                                ? 'Unknown Artist'
                                : artistName,
                            fontSize: 10.sp,
                            color: kGrey,
                            fontWeight: FontWeight.w400,
                          ),
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
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => CurrentPlayListPage(
                              //       audioPlayer: widget.audioPlayer,
                              //       indexfromhome: widget.initialIndex,
                              //       musicBox: widget.musicBox,
                              //       songModel: widget.songModel,
                              //       audioSource: widget.audioSource,
                              //       currentPlayingSongIndex:
                              //           widget.currentPlayingSongIndex,
                              //       playSong: widget.playSong,
                              //       songId: currentPlayingSong.id,
                              //       isPlaying: widget.isPlaying,
                              //       songName: currentPlayingSong.musicName,
                              //       artistName:
                              //           currentPlayingSong.musicArtistName,
                              //       albumName:
                              //           currentPlayingSong.musicAlbumName,
                              //       songFormat: currentPlayingSong.musicFormat,
                              //       songSize: currentPlayingSong.musicFileSize
                              //           .toString(),
                              //       songPathIndevice:
                              //           currentPlayingSong.musicPathInDevice,
                              //     ),
                              //   ),
                              // );
                            },
                            icon: Icon(
                              Icons.list,
                              size: 30,
                              color: kWhite,
                            ),
                          ),
                          // song favourite add icon
                          GetBuilder<FavoriteController>(
                              global: true,
                              builder: (favoriteController) {
                                return IconButton(
                                  onPressed: () {
                                    FavoriteModel favoriteMusic =
                                        getFavoriteModelFromAllMusicModel(
                                            songModel);
                                    favoriteController.onTapFavorite(
                                        favoriteMusic, context);
                                  },
                                  icon: Icon(
                                   favoriteController.isFavorite(songId)?Icons.favorite: Icons.favorite_border,
                                    size: 30,
                                    color: favoriteController.isFavorite(songId)
                                        ? kRed
                                        : kWhite,
                                  ),
                                );
                              }),

                          // song loop shuffle

                          // GestureDetector(
                          //   // onTap: songLoopModesControlling,
                          //   child: isLoopingAllSongs
                          //       ? isShufflingSongs
                          //           ? Image.asset(
                          //               "assets/shuffle.png",
                          //               scale: 18.sp,
                          //               color: kWhite,
                          //             )
                          //           : Image.asset(
                          //               "assets/loop_all.png",
                          //               scale: 15.sp,
                          //               color: kWhite,
                          //             )
                          //       : Image.asset(
                          //           "assets/loop_one.png",
                          //           scale: 15.sp,
                          //           color: kWhite,
                          //         ),
                          // ),

                          // song settings icon
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: kMenuBtmSheetColor,
                                context: context,
                                builder: (context) {
                                  return MenuBottomSheet(
                                    favouriteController: favoriteController,
                                    song: songModel,
                                    songId: songId,
                                    musicUri: musicUri,
                                    kScreenHeight: kScreenHeight,
                                    pageType: PageTypeEnum.musicViewPage,
                                    songName: songTitle,
                                    artistName: artistName,
                                    albumName: albumName,
                                    songFormat: songFormat,
                                    songSize: songSize.toString(),
                                    songPathIndevice: songPathIndevice,
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

class ArtWorkWidgetMusicPlayingPage extends StatelessWidget {
  const ArtWorkWidgetMusicPlayingPage({
    super.key,
    required this.songId,
  });
  final int songId;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      type: ArtworkType.AUDIO,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Center(
        child: Icon(
          Icons.music_note,
          size: 200,
          color: kGrey,
        ),
      ),
    );
  }
}
