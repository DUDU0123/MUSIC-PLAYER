import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/new_playlist_dialog_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/playlist/playlist_song_list_page.dart';
import 'package:music_player/views/playlist/widgets/playlist_single_tile_widget.dart';

class MusicPlaylistPage extends StatefulWidget {
  const MusicPlaylistPage({super.key});

  @override
  State<MusicPlaylistPage> createState() => _MusicPlaylistPageState();
}

class _MusicPlaylistPageState extends State<MusicPlaylistPage> {
  TextEditingController newPlaylistController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        itemCount: 10 + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PlayListSingleTileWidget(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return NewPlayListDialogBoxWidget(
                      newPlaylistController: newPlaylistController,
                    );
                  },
                );
              },
              title: "New Playlist",
              iconName: Icons.add_circle_outline_outlined,
              iconColor: kGreen,
            );
          } else if (index == 1) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: PlayListSingleTileWidget(
                onTap: () {},
                title: "Favourites",
                iconName: Icons.favorite_outline,
                iconColor: kRed,
              ),
            );
          }
          return ContainerTileWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlaylistSongListPage(),
                ),
              );
            },
            title: "Playlist ${index - 1}",
            songLength: 2,
            pageType: PageTypeEnum.playListPage,
          );
        },
      ),
    );
  }
}
