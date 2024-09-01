import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/add_to_playlist/add_to_playlist_page.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/ontap_text_widget.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/view_details_page.dart/view_details_page.dart';

class MenuBottomSheet extends StatelessWidget {
  MenuBottomSheet({
    super.key,
    required this.kScreenHeight,
    required this.pageType,
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.songFormat,
    required this.songSize,
    required this.songPathIndevice,
    required this.songId,
    required this.musicUri,
    required this.song,
    required this.favouriteController,
    this.playListID,
  });

  final double kScreenHeight;
  final PageTypeEnum pageType;
  final String songName;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  final String musicUri;
  final int songId;
  final AllMusicsModel song;
  final FavoriteController favouriteController;
  final int? playListID;
  AudioController audioController = Get.put(AudioController());

  FavoriteModel? favsong;

  favouriteSong() {
    favsong = FavoriteModel(
      id: song.id,
      musicName: song.musicName,
      musicAlbumName: song.musicAlbumName,
      musicArtistName: song.musicArtistName,
      musicPathInDevice: song.musicPathInDevice,
      musicFormat: song.musicFormat,
      musicUri: song.musicUri,
      musicFileSize: song.musicFileSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    favouriteSong();
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: kTileColor,
        border: Border.all(color: kMenuBtmSheetColor),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.5,
            spreadRadius: 0.5,
            color: kGrey,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: pageType == PageTypeEnum.favoritePage ||
              pageType == PageTypeEnum.musicViewPage ||
              pageType==PageTypeEnum.playListPage||
              pageType == PageTypeEnum.searchPage
          ? kScreenHeight / 2.53
          : kScreenHeight / 2.185,
      child: Column(
        children: [
          OnTapTextWidget(
            text: "Send Song",
            onTap: () async {
              AppUsingCommonFunctions.sendOneSong(song);
              Get.back();
            },
          ),
          OnTapTextWidget(
            text: "View Details",
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewDetailsPage(
                    songName: songName,
                    artistName: artistName,
                    albumName: albumName,
                    songFormat: songFormat,
                    songSize: songSize,
                    songPathIndevice: songPathIndevice,
                  ),
                ),
              );
            },
          ),
          pageType != PageTypeEnum.playListPage
              ? GetBuilder<PlaylistController>(
                  init: PlaylistController(),
                  builder: (controller) {
                    return OnTapTextWidget(
                      text: PlaylistController.to.isInPlaylist(songId)
                          ? "Remove from Playlist"
                          : "Add to Playlist",
                      onTap: () {
                        PlaylistController.to.isInPlaylist(songId)
                            ? PlaylistController.to.onTapRemovefromPlaylistAddToPlaylistPage(
                                songId: songId,
                                playlistId: PlaylistController.to.getPlaylistIDFromAddToPlaylist.value,
                              )
                            : Get.to(() => AddToPlaylistPage(
                                  song: song,
                                ));
                      },
                    );
                  })
              : const SizedBox(),
          GetBuilder<FavoriteController>(builder: (controller) {
            return OnTapTextWidget(
              text: controller.isFavorite(favsong!.id)
                  ? "Remove from Favorites"
                  : "Add to Favorites",
              onTap: () {
                Navigator.pop(context);

                if (favsong != null) {
                  controller.onTapFavorite(favsong!, context);
                }
              },
            );
          }),
          pageType == PageTypeEnum.playListPage
              ? GetBuilder<PlaylistController>(
                  init: PlaylistController(),
                  builder: (controller) {
                    return OnTapTextWidget(
                      text: "Remove From Playlist",
                      onTap: () {
                        if (playListID != null) {
                          controller.onTapRemoveFromPlaylist(
                            songId: songId,
                            playlistId: playListID!,
                          );
                        }
                        Get.back();
                      },
                    );
                  })
              : const SizedBox(),
          pageType != PageTypeEnum.playListPage &&
                  pageType != PageTypeEnum.favoritePage &&
                  pageType != PageTypeEnum.musicViewPage &&
                  pageType != PageTypeEnum.searchPage
              ? GetBuilder<AudioController>(
                  init: audioController,
                  builder: (controller) {
                    return OnTapTextWidget(
                      text: "Delete Song",
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteDialogBox(
                              contentText: "Do you want to delete the song?",
                              deleteAction: () async {
                                controller
                                    .deleteSongsPermentaly([songId], context);
                                Get.back();
                              },
                            );
                          },
                        );
                      },
                    );
                  })
              : const SizedBox(),
          Divider(
            thickness: 1,
            color: kMenuBtmSheetColor,
          ),
          OnTapTextWidget(
            text: "Cancel",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
