import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/favourites/favourite_music_list_page.dart';
import 'package:music_player/views/playlist/pages/playlist_song_list_page.dart';
import 'package:music_player/views/playlist/utils/playlist_methods.dart';
import 'package:music_player/views/playlist/widgets/playlist_single_tile_widget.dart';
import 'package:music_player/views/recently_played/recently_played_page.dart';

class MusicPlaylistPage extends StatefulWidget {
  const MusicPlaylistPage({
    super.key,
    required this.songModel,

  });

  final AllMusicsModel songModel;

  @override
  State<MusicPlaylistPage> createState() => MusicPlaylistPageState();
}

class MusicPlaylistPageState extends State<MusicPlaylistPage> {
  TextEditingController newPlaylistController = TextEditingController();
  TextEditingController editPlaylistController = TextEditingController();
  @override
  void dispose() {
    newPlaylistController.dispose();
    editPlaylistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PlayListSingleTileWidget(
              onTap: () {
                newPlaylistController.text = '';
                showDialog(
                  context: context,
                  builder: (context) {
                    return NewPlayListDialogBoxWidget(
                      editOrNew: "New Playlist",
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
              title: "New Playlist",
              iconName: Icons.add_circle_outline_outlined,
              iconColor: kGreen,
            ),
            PlayListSingleTileWidget(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavouriteMusicListPage(
                      instance: this,
                      songModel: widget.songModel,
                    ),
                  ),
                );
              },
              title: "Favourites",
              iconName: Icons.favorite_outline,
              iconColor: kRed,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: PlayListSingleTileWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecentlyPlayedPage(
                        songModel: widget.songModel,
                      ),
                    ),
                  );
                },
                title: "Recently Played",
                iconName: Icons.access_time_rounded,
                iconColor: kBlue,
              ),
            ),
            GetBuilder<PlaylistController>(
                init: PlaylistController.to,
                builder: (context) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    itemCount: PlaylistController.to.getAllPlaylist().length,
                    itemBuilder: (context, index) {
                      final playlists = PlaylistController.to.getAllPlaylist();
                      return ContainerTileWidget(
                        deletePlaylistMethod: () {
                        PlaylistMethods.deletePlaylistMethod(
                              context: context,
                              playlistID: playlists[index].id);
                        },
                        editPlaylistNameMethod: () {
                          editPlaylistController.text = playlists[index].name;
                          PlaylistMethods.playlistNameEditMethod(
                            editPlaylistController: editPlaylistController,
                            context: context,
                            playlist: playlists[index],
                          );
                        },
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaylistSongListPage(
                                playlist: playlists[index],
                                songModel: widget.songModel,
                              ),
                            ),
                          );
                        },
                        title: playlists[index].name,
                        pageType: PageTypeEnum.playListPage,
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}

