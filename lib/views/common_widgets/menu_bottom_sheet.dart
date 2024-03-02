import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/ontap_text_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/add_to_playlist/add_to_playlist_page.dart';
import 'package:music_player/views/view_details_page.dart/view_details_page.dart';
import 'package:share_plus/share_plus.dart';

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
        color: kMenuBtmSheetColor,
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
      height: pageType == PageTypeEnum.playListPage
          ? kScreenHeight / 2.2
          : kScreenHeight / 2.2,
      child: Column(
        children: [
          pageType != PageTypeEnum.playListPage
              ? OnTapTextWidget(
                  text: "Add to Playlist",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddToPlaylistPage(
                          song: song,
                          favoriteController: favouriteController,
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(),
          OnTapTextWidget(
            text: "Send Song",
            onTap: () async {
              if (song != null &&
                  song.musicPathInDevice != null &&
                  song.musicPathInDevice.isNotEmpty) {
                try {
                  List<XFile> files = [XFile(song.musicPathInDevice)];
                  try {
                    await Share.shareXFiles(files);
                  } catch (e) {
                    log(e.toString());
                  }
                } catch (e) {
                  log("Error on send song : $e");
                }
              }
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
          GetBuilder<FavoriteController>(builder: (controller) {
            return OnTapTextWidget(
              text: controller.isFavorite(favsong!.id)
                  ? "Remove from Favorites"
                  : "Add to Favorites",
              onTap: () {
                Navigator.pop(context);
                log("not to favourites");
                if (favsong != null) {
                  log("adding to favourites");
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
          OnTapTextWidget(
            text: "Delete Song",
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return DeleteDialogBox(
                    contentText: "Do you want to delete the song?",
                    deleteAction: () {},
                  );
                },
              );
            },
          ),
          Divider(
            thickness: 1,
            color: kGrey,
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
