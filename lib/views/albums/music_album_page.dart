import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/album_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicAlbumPage extends StatelessWidget {
  const MusicAlbumPage({
    super.key, required this.favoriteController,
  });
   final FavoriteController favoriteController;

  @override
  Widget build(BuildContext context) {
    AllMusicController allMusicController = Get.put(AllMusicController());
    return Obx(() {
      print('Artist Map Length: ${allMusicController.albumsMap.value.length}');
      return Scaffold(
        body: allMusicController.albumsMap.value.isEmpty
            ? DefaultCommonWidget(text: "No albums available")
            : ListView.builder(
                itemCount: allMusicController.albumsMap.value.length,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                itemBuilder: (context, index) {
                  String albumName =
                      allMusicController.albumsMap.value.keys.elementAt(index);
                  // Getting albumSongs
                  final List<AllMusicsModel> albumSongs =
                      allMusicController.albumsMap.value[albumName]!;
                  print('AlbumsSONG : ${albumSongs.length}');
                  return ContainerTileWidget(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AlbumSongListPage(
                            favoriteController: favoriteController,
                            albumName: albumName,
                            albumSongs: albumSongs,
                          ),
                        ),
                      );
                    },
                    pageType: PageTypeEnum.albumPage,
                    songLength: albumSongs.length,
                    title: albumName,
                  );
                },
              ),
      );
    });
  }
}
