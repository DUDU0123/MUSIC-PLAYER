import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/add_to_playlist/add_to_playlist_page.dart';
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
    required this.song,
  });
  bool? isSelected;
  final PageTypeEnum pageType;
  final List<AllMusicsModel> songList;
  final FavoriteController favoriteController;
  final AllMusicsModel song;

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
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
      width: kScreenWidth,
      padding: EdgeInsets.only(top: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kMenuBtmSheetColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.pageType != PageTypeEnum.playListPage &&
                      widget.pageType != PageTypeEnum.favoritePage
                  ? IconTextWidget(
                      isSongSelected: widget.isSelected,
                      onTap: () {
                        // need to have the song song details to send the song
                        // also need to check that that the count of song to send is less than or equal to 10
                      },
                      icon: Icons.share_outlined,
                      iconName: "Send",
                    )
                  : IconTextWidget(
                      isSongSelected: widget.isSelected,
                      onTap: () {
                        // need to remove the song
                        switch (widget.pageType) {
                          case PageTypeEnum.favoritePage:
                            widget.favoriteController
                                .removeFromFavorite(widget.songList, context);
                            setState(() {
                              widget.isSelected =
                                  false; // or update based on your logic
                            });
                            break;
                          default:
                        }
                      },
                      icon: Icons.logout_outlined,
                      iconName: "Remove",
                    ),
              widget.pageType != PageTypeEnum.playListPage
                  ? kWidth10
                  : const SizedBox(
                      width: 0,
                    ),
              widget.pageType != PageTypeEnum.playListPage &&
                      widget.pageType != PageTypeEnum.favoritePage
                  ? IconTextWidget(
                      isSongSelected: widget.isSelected,
                      onTap: () {
                        // need to send song details to add song to a playlist
                        widget.isSelected!
                            ? Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddToPlaylistPage(
                                    song: widget.song,
                                    favoriteController:
                                        widget.favoriteController,
                                  ),
                                ),
                              )
                            : null;
                      },
                      icon: Icons.playlist_add,
                      iconName: "Add to Playlist",
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              kWidth10,
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
                                  contentText: "Do you want to delete the song?",
                                  deleteAction: () {
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
                                    log("Remaining songs in Hive box: ${controller.musicBox.length}");
                                    Get.back();
                                  },
                                );
                              },
                            )
                          : const SizedBox();
                    },
                    icon: Icons.delete_outline_outlined,
                    iconName: "Delete",
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
