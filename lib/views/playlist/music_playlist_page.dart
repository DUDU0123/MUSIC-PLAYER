import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/common_widgets/playlist_delete_error_dialog_box.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/favourites/favourite_music_list_page.dart';
import 'package:music_player/views/playlist/playlist_song_list_page.dart';
import 'package:music_player/views/playlist/widgets/playlist_single_tile_widget.dart';
import 'package:music_player/views/recently_played/recently_played_page.dart';

class MusicPlaylistPage extends StatefulWidget {
  const MusicPlaylistPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.playlistController,
    required this.allMusicController,
  });
  final FavoriteController favoriteController;
  final AudioController audioController;
  final PlaylistController playlistController;
  final AllMusicsModel songModel;
  final AllMusicController allMusicController;

  @override
  State<MusicPlaylistPage> createState() => MusicPlaylistPageState();
}

class MusicPlaylistPageState extends State<MusicPlaylistPage> {
  void refreshUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController newPlaylistController = TextEditingController();
    TextEditingController editPlaylistController = TextEditingController();
    return Scaffold(
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          itemCount: widget.playlistController.listOfPlaylist.length + 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return PlayListSingleTileWidget(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NewPlayListDialogBoxWidget(
                        editOrNew: "New Playlist",
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
                title: "New Playlist",
                iconName: Icons.add_circle_outline_outlined,
                iconColor: kGreen,
              );
            } else if (index == 1) {
              return PlayListSingleTileWidget(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FavouriteMusicListPage(
                        allMusicController: widget.allMusicController,
                        instance: this,
                        playlistController: widget.playlistController,
                        favouriteController: widget.favoriteController,
                        audioController: widget.audioController,
                        songModel: widget.songModel,
                      ),
                    ),
                  );
                },
                title: "Favourites",
                iconName: Icons.favorite_outline,
                iconColor: kRed,
              );
            } else if (index == 2) {
              return Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: PlayListSingleTileWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecentlyPlayedPage(
                          allMusicController: widget.allMusicController,
                          songModel: widget.songModel,
                          favoriteController: widget.favoriteController,
                        ),
                      ),
                    );
                  },
                  title: "Recently Played",
                  iconName: Icons.access_time_rounded,
                  iconColor: kBlue,
                ),
              );
            }
            return Obx(() {
              return ContainerTileWidget(
                deletePlaylistMethod: () {
                  showDialog(
                    context: context,
                    builder: (context) => index ==
                            widget.playlistController.listOfPlaylist.length + 2
                        ? DeleteDialogBox(
                            contentText: "Do you want to delete the playlist?",
                            deleteAction: () {
                              widget.playlistController
                                  .playlistDelete(index: index - 3);
                              Navigator.pop(context);
                              snackBarCommonWidget(context,
                                  contentText: "Deleted Successfully");
                            },
                          )
                        : const PlaylistDeleteErrorDialogBox(),
                  );
                },
                editPlaylistNameMethod: () {
                  int playlistIndex = index - 3;
                  String currentPlaylistName = PlaylistController.to
                      .getPlaylistName(index: playlistIndex);

                  editPlaylistController.text = currentPlaylistName;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NewPlayListDialogBoxWidget(
                        editOrNew: "Edit Playlist",
                        onPressed: () {
                          PlaylistController.to.playlistUpdateName(
                            index: index - 3,
                            newPlaylistName: editPlaylistController.text,
                          );
                          Navigator.pop(context);
                          snackBarCommonWidget(context,
                              contentText: "Edited Successfully");
                        },
                        playlsitNameGiverController: editPlaylistController,
                      );
                    },
                  );
                },
                onTap: () async {
                  var playlistSongs = await widget.playlistController
                      .getPlayListSongs(widget.playlistController
                          .getPlaylistID(index: index - 3));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlaylistSongListPage(
                        allMusicController: widget.allMusicController,
                        playlistController: widget.playlistController,
                        audioController: widget.audioController,
                        playlistSongsList: playlistSongs,
                        songModel: widget.songModel,
                        favoriteController: widget.favoriteController,
                        playlistId: widget.playlistController
                            .getPlaylistID(index: index - 3),
                        playlistName: widget.playlistController.getPlaylistName(
                          index: index - 3,
                        ),
                      ),
                    ),
                  );
                },
                title: PlaylistController.to.getPlaylistName(index: index - 3),
                pageType: PageTypeEnum.playListPage,
              );
            });
          },
        );
      }),
    );
  }
}
