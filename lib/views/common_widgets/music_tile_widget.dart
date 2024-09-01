import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/constants/height_width.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTileWidget extends StatefulWidget {
  const MusicTileWidget({
    super.key,
    required this.songTitle,
    this.artistName = "Unknown artist",
    this.albumName = "Unknown album",
    required this.songFormat,
    required this.songSize,
    required this.songPathIndevice,
    required this.pageType,
    required this.songId,
    required this.songModel,
    required this.audioController,
    this.onTap,
    required this.musicUri,
    required this.favoriteController,
    this.playListID,
  });

  final String songTitle;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final int? playListID;
  final String songPathIndevice;
  final PageTypeEnum pageType;
  final int songId;
  final String musicUri;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final void Function()? onTap;
  final FavoriteController favoriteController;
  // Duration lastPlayedPosition = Duration.zero;

  @override
  State<MusicTileWidget> createState() => _MusicTileWidgetState();
}

class _MusicTileWidgetState extends State<MusicTileWidget> {
  @override
  Widget build(BuildContext context) {
    final kScreenHeight = MediaQuery.of(context).size.height;
    final kScreenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 10.h),
              decoration: BoxDecoration(
                color: kTileColor,
                borderRadius: BorderRadius.circular(13.sp),
              ),
              child: Row(
                mainAxisAlignment:
                    widget.pageType != PageTypeEnum.recentlyPlayedPage
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                children: [
                  QueryArtworkWidget(
                    id: widget.songId,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: Container(
                        height: 50.h,
                        width: 50.w,
                        // padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kMenuBtmSheetColor,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: kGrey,
                        )),
                  ),
                  widget.pageType != PageTypeEnum.recentlyPlayedPage
                      ? const SizedBox()
                      : kWidth10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width:
                              widget.pageType != PageTypeEnum.recentlyPlayedPage
                                  ? kScreenWidth / 2.2
                                  : kScreenWidth / 2.1,
                          child: Obx(() {
                            return TextWidgetCommon(
                                overflow: TextOverflow.ellipsis,
                                text: widget.songTitle,
                                fontSize: 16.sp,
                                color: widget.audioController.isPlaying.value &&
                                        widget.audioController
                                                .currentPlayingSong.value?.id ==
                                            widget.songId
                                    ? kRed
                                    : kWhite);
                          })),
                      SizedBox(
                          width:
                              widget.pageType != PageTypeEnum.recentlyPlayedPage
                                  ? kScreenWidth / 2
                                  : kScreenWidth / 1.8,
                          child: Obx(() {
                            return TextWidgetCommon(
                                overflow: TextOverflow.ellipsis,
                                text:
                                    "${widget.artistName == "<unknown>" ? "Unknown Artisit" : widget.artistName}-${widget.albumName == "<unknown>" ? "Unknown Album" : widget.albumName}",
                                fontSize: 10.sp,
                                color: widget.audioController.isPlaying.value &&
                                        widget.audioController
                                                .currentPlayingSong.value?.id ==
                                            widget.songId
                                    ? kRed
                                    : kWhite);
                          })),
                    ],
                  ),
                  Row(
                    children: [
                      widget.pageType != PageTypeEnum.recentlyPlayedPage
                          ? IconButton(onPressed: () {
                              showModalBottomSheet(
                                barrierColor: kTransparent,
                                backgroundColor: kTransparent,
                                context: context,
                                builder: (context) {
                                  return MenuBottomSheet(
                                    playListID: widget.playListID,
                                    favouriteController:
                                        widget.favoriteController,
                                    song: widget.songModel,
                                    musicUri: widget.musicUri,
                                    songId: widget.songId,
                                    kScreenHeight: kScreenHeight,
                                    pageType: widget.pageType,
                                    songName: widget.songTitle,
                                    artistName: widget.artistName,
                                    albumName: widget.albumName,
                                    songFormat: widget.songFormat,
                                    songSize: widget.songSize,
                                    songPathIndevice: widget.songPathIndevice,
                                  );
                                },
                              );
                            }, icon: Obx(() {
                              return Icon(Icons.more_vert,
                                  size: 26.sp,
                                  color:
                                      widget.audioController.isPlaying.value &&
                                              widget
                                                      .audioController
                                                      .currentPlayingSong
                                                      .value
                                                      ?.id ==
                                                  widget.songId
                                          ? kRed
                                          : kWhite);
                            }))
                          : const SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: 45.w,
              top: 30.h,
              child: Obx(() {
                return Icon(
                  Icons.multitrack_audio_rounded,
                  color: widget.audioController.isPlaying.value &&
                          widget.audioController.currentPlayingSong.value?.id ==
                              widget.songId
                      ? kRed
                      : Colors.transparent,
                  size: 26.sp,
                );
              })),

          //     : const SizedBox()
          // : const SizedBox(),
        ],
      ),
    );
  }
}
