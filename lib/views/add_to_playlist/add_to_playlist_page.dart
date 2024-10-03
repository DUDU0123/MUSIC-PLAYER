import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class AddToPlaylistPage extends StatefulWidget {
  const AddToPlaylistPage({super.key, required this.song});
  final AllMusicsModel song;

  @override
  State<AddToPlaylistPage> createState() => _AddToPlaylistPageState();
}

class _AddToPlaylistPageState extends State<AddToPlaylistPage> {
  TextEditingController newPlaylistController = TextEditingController();

  @override
  void dispose() {
    newPlaylistController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return NewPlayListDialogBoxWidget(
                      editOrNew:
                          "Create Playlist and\nClick on the created playlist to add the song",
                      playlsitNameGiverController: newPlaylistController,
                      onPressed: () {
                        PlaylistController.to.playlistCreation(
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
            ),
            GetBuilder<PlaylistController>(
              init: PlaylistController.to,
              builder: (playlistController) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                  itemCount: PlaylistController.to.getAllPlaylist().length,
                  itemBuilder: (context, index) {
                    final playlists = PlaylistController.to.getAllPlaylist();
                    return ListTile(
                      onTap: () {
                        PlaylistController.to.addSongsToDBPlaylist(
                            playlistNewSongsToAdd: [widget.song],
                            playlist: playlists[index]);
                      },
                      title: TextWidgetCommon(
                        text: playlists[index].name,
                        fontSize: 16.sp,
                        color: kWhite,
                      ),
                    );
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
