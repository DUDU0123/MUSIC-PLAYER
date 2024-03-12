import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class AddToPlaylistPage extends StatelessWidget {
  AddToPlaylistPage({super.key, required this.song});
  final AllMusicsModel song;

  TextEditingController newPlaylistController = TextEditingController();
  PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          appBarText: "Add To Playlist",
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          itemCount: PlaylistController.to.listOfPlaylist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NewPlayListDialogBoxWidget(
                        editOrNew: "Create Playlist and\nClick on the created playlist to add the song",
                        playlsitNameGiverController: newPlaylistController,
                        onPressed: () {
                          PlaylistController.to.playlistCreation(
                            index: index,
                            playlistName: newPlaylistController.text,
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
            PlaylistController.to.getPlaylistIDFromAddToPlaylist.value =
                PlaylistController.to.getPlaylistID(index: index - 1);
            return ListTile(
              onTap: () {
                PlaylistController.to.addSongsToDBPlaylist([song],
                    PlaylistController.to.getPlaylistID(index: index - 1));
              },
              title: TextWidgetCommon(
                text: PlaylistController.to.getPlaylistName(index: index - 1),
                fontSize: 16.sp,
                color: kWhite,
              ),
            );
          },
        );
      }),
    );
  }
}
