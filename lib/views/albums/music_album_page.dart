import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/album_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicAlbumPage extends StatelessWidget {
  MusicAlbumPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.playlistController,
  });
  final FavoriteController favoriteController;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final PlaylistController playlistController;
  AllMusicController allMusicController = Get.put(AllMusicController());

  @override
  Widget build(BuildContext context) {
    log(allMusicController.artistMap.length.toString());
    return Scaffold(body: Obx(() {
      return FutureBuilder(
        future: allMusicController.fetchAllAlbumMusicData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: allMusicController.albumsMap.length,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              itemBuilder: (context, index) {
                log("Loading items in album page");
                String albumName =
                    allMusicController.albumsMap.keys.elementAt(index);
                // Getting albumSongs
                final List<AllMusicsModel> albumSongs =
                    allMusicController.albumsMap[albumName]!;
                log('AlbumsSONG : ${albumSongs.length}');
                return ContainerTileWidget(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AlbumSongListPage(
                          playlistController: playlistController,
                          allMusicController: allMusicController,
                          audioController: audioController,
                          songModel: songModel,
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
            );
          }
          return const DefaultCommonWidget(text: "No albums available");
        },
      );
    }));
  }
}
