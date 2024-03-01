import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class AddToPlaylistPage extends StatelessWidget {
  AddToPlaylistPage(
      {super.key, required this.favoriteController, required this.song});
  // Here we need to get a list from bottomsettings

  TextEditingController newPlayListController = TextEditingController();
  final FavoriteController favoriteController;
  final AllMusicsModel song;

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
    //  PlaylistController playlistController = Get.find();
    log(song.musicName);
    favouriteSong();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: kRed,
            size: 28.sp,
          ),
        ),
        automaticallyImplyLeading: false,
        title: TextWidgetCommon(
          text: "Add to Playlist",
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: kWhite,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextWidgetCommon(
              text: "Cancel",
              fontSize: 15.sp,
              color: kRed,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: PlaylistController.to.listOfPlaylist.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              onTap: () {
                // add the song into favourite list , no need to go to any pages
                // need to implement the function that on clik on this tile add the song into that playlist
                favoriteController.onTapFavorite(favsong!, context);
              },
              title: TextWidgetCommon(
                text: "Favorites",
                fontSize: 16.sp,
                color: kWhite,
              ),
            );
          } else if (index == 1) {
            return ListTile(
              onTap: () {
                // create a new playlist
                showDialog(
                  context: context,
                  builder: (context) {
                    return NewPlayListDialogBoxWidget(
                      editOrNew: "New Playlist",
                      playlsitNameGiverController: newPlayListController,
                      onPressed: () {
                        PlaylistController.to.playlistCreation(
                          index: index,
                          playlistName: newPlayListController.text,
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              title: TextWidgetCommon(
                text: "New Playlist",
                fontSize: 16.sp,
                color: kWhite,
              ),
            );
          }
          return ListTile(
            onTap: () {
              // only visible playlist name
              // need to implement the function that on clik on this tile add the song into that playlist
              PlaylistController.to.onTapAddToPlaylist(
                selectedSong: song, // pass the selected song
                playlistId:
                    index - 2, // subtract 2 to get the correct playlist id
                context: context,
              );
            },
            title: TextWidgetCommon(
              text: PlaylistController.to.getPlaylistName(index: index - 2),
              fontSize: 16.sp,
              color: kWhite,
            ),
          );
        },
      ),
    );
  }
}
