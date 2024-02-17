import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/views/albums/album_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicAlbumPage extends StatelessWidget {
  const MusicAlbumPage({super.key});
  // need to ask for a list of album song according to album
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        itemBuilder: (context, index) {
          return ContainerTileWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AlbumSongListPage(),
                ),
              );
            },
            pageType: PageTypeEnum.albumPage,
            songLength: 5,
            title: "Unknown Album",
          );
        },
      ),
    );
  }
}
