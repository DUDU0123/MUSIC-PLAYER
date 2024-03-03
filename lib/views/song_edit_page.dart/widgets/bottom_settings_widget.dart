import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/widgets/icon_text_widget.dart';

class BottomSettingsWidget extends StatefulWidget {
  BottomSettingsWidget({
    super.key,
    this.isSelected,
    required this.pageType,
    required this.songList,
    required this.favoriteController,
    required this.song, required this.playlistController,
  });
  bool? isSelected;
  final PageTypeEnum pageType;
  final List<AllMusicsModel> songList;
  final FavoriteController favoriteController;
  final AllMusicsModel song;
  final PlaylistController playlistController;

  @override
  State<BottomSettingsWidget> createState() => _BottomSettingsWidgetState();
}

class _BottomSettingsWidgetState extends State<BottomSettingsWidget> {
  FavoriteModel? favSong;
  AllMusicController allmusicController = Get.put(AllMusicController());
  AudioController audioController = Get.put(AudioController());
  favouriteSong() {
    favSong = FavoriteModel(
      id: widget.song.id,
      musicName: widget.song.musicName,
      musicAlbumName: widget.song.musicAlbumName,
      musicArtistName: widget.song.musicArtistName,
      musicPathInDevice: widget.song.musicPathInDevice,
      musicFormat: widget.song.musicFormat,
      musicUri: widget.song.musicUri,
      musicFileSize: widget.song.musicFileSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    favouriteSong();
    AllMusicController allMusicController = Get.put(AllMusicController());
    final kScreenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 58.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
      width: kScreenWidth,
      padding: EdgeInsets.only(top: 5.h, left: 30.sp, right: 30.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kMenuBtmSheetColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.pageType != PageTypeEnum.playListPage &&
                      widget.pageType != PageTypeEnum.favoritePage
                  ? IconTextWidget(
                      isSongSelected: widget.isSelected,
                      onTap: () {
                        // function to send song
                        AppUsingCommonFunctions.sendMoreSong(widget.songList);
                      },
                      icon: Icons.share_outlined,
                      iconName: "Send",
                    )
                  : widget.pageType == PageTypeEnum.favoritePage
                      ? GetBuilder<FavoriteController>(
                        init: widget.favoriteController,
                        builder: (controller) {
                          return IconTextWidget(
                              isSongSelected: widget.isSelected,
                              onTap: () {
                                controller
                                    .removeFromFavorite(widget.songList, context);
                                setState(() {
                                  widget.isSelected =
                                      false; // or update based on your logic
                                });
                              },
                              icon: Icons.logout_outlined,
                              iconName: "Remove",
                            );
                        }
                      )
                      : GetBuilder<PlaylistController>(
                          init: PlaylistController(),
                          builder: (controller) {
                            return IconTextWidget(
                              isSongSelected: widget.isSelected,
                              onTap: () {
                                controller
                                    .removeSongsFromPlaylist(widget.songList);
                                setState(() {
                                  widget.isSelected =
                                      false; // or update based on your logic
                                });
                              },
                              icon: Icons.logout_outlined,
                              iconName: "Remove",
                            );
                          }),
              GetBuilder<AudioController>(
                  init: AudioController(),
                  builder: (controller) {
                    return IconTextWidget(
                      isSongSelected: widget.isSelected,
                      onTap: () {
                        // need to send song details to delete the song permenantly
                        widget.isSelected!
                            ? showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteDialogBox(
                                    contentText:
                                        "Do you want to delete the song?",
                                    deleteAction: () async {
                                      List<int> selectedSongIds = [];
                                      for (var song in widget.songList) {
                                        if (song.musicSelected == true) {
                                          selectedSongIds.add(song.id);
                                          log(song.id.toString());
                                          log(song.musicName);
                                        }
                                      }
                                      log("Remaining songs in Hive box: ${controller.musicBox.length}");
                                      controller.deleteSongsPermentaly(
                                          selectedSongIds, context);

                                      Get.back();
                                      log("Remaining songs in Hive box: ${controller.musicBox.length}");
                                    },
                                  );
                                },
                              )
                            : const SizedBox();
                      },
                      icon: Icons.delete_outline_outlined,
                      iconName: "Delete",
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
