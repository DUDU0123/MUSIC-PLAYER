import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/favourites/favourite_music_list_page.dart';
import 'package:music_player/views/playlist/playlist_song_list_page.dart';
import 'package:music_player/views/playlist/widgets/playlist_single_tile_widget.dart';

class MusicPlaylistPage extends StatelessWidget {
  MusicPlaylistPage({super.key, required this.isPlaying});
  final bool isPlaying;

  TextEditingController newPlaylistController = TextEditingController();
  TextEditingController editPlaylistController = TextEditingController();

  final PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          itemCount: playlistController.playlist.length + 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return PlayListSingleTileWidget(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NewPlayListDialogBoxWidget(
                        playlsitNameGiverController: newPlaylistController,
                        onSavePlaylist: (playlistName) {
                          playlistController.playlistCreation(playlistName: playlistName);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                title: "New Playlist",
                iconName: Icons.add_circle_outline_outlined,
                iconColor: kGreen,
              );
            } else if (index == 1) {
              return PlayListSingleTileWidget(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FavouriteMusicListPage(),
                  ));
                },
                title: "Favourites",
                iconName: Icons.favorite_outline,
                iconColor: kRed,
              );
            } else if (index == 2) {
              return Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: PlayListSingleTileWidget(
                  onTap: () {},
                  title: "Recently Played",
                  iconName: Icons.access_time_rounded,
                  iconColor: kBlue,
                ),
              );
            }
            return ContainerTileWidget(
              deletePlaylistMethod: () {
                showDialog(context: context, builder: (context) => DeleteDialogBox(
                  contentText: "Do you want to delete the playlist?",
                  deleteAction: () {
                    playlistController.playlistDelete(index: index);
                    Navigator.pop(context);
                  },
                ),);
                
              },
              editPlaylistNameMethod: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return NewPlayListDialogBoxWidget(
                      onSavePlaylist: (playlistEditedName) {
                        playlistController.playlistUpdateName(
                            index: index, newPlaylistName: playlistEditedName);
                      },
                      playlsitNameGiverController: editPlaylistController,
                    );
                  },
                );
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlaylistSongListPage(
                      
                      isPlaying: isPlaying,
                    ),
                  ),
                );
              },
              title: playlistController.getPlaylistName(index: index - 3),
              songLength: 2,
              pageType: PageTypeEnum.playListPage,
            );
          },
        );
      }),
    );
  }
}