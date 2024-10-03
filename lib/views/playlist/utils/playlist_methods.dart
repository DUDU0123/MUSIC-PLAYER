import 'package:flutter/material.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';

class PlaylistMethods {
  static Future<dynamic> deletePlaylistMethod({
    required BuildContext context,
    required int? playlistID,
  }) {
    return showDialog(
      context: context,
      builder: (context) => DeleteDialogBox(
        contentText: "Do you want to delete the playlist?",
        deleteAction: () {
          PlaylistController.to.playlistDelete(
            playlistId: playlistID,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  static Future<dynamic> playlistNameEditMethod({
    required BuildContext context,
    required Playlist playlist,
    required TextEditingController editPlaylistController,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return NewPlayListDialogBoxWidget(
          editOrNew: "Edit Playlist",
          onPressed: () {
            final updatedPlaylist = playlist.copyWith(
              name: editPlaylistController.text,
            );
            PlaylistController.to.playlistUpdateName(
              updatedPlaylist: updatedPlaylist,
            );
            Navigator.pop(context);
            snackBarCommonWidget(context, contentText: "Edited Successfully");
          },
          playlsitNameGiverController: editPlaylistController,
        );
      },
    );
  }
}
