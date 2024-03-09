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
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

// class MusicAlbumPage extends StatelessWidget {
//   MusicAlbumPage({
//     super.key,
//     required this.favoriteController,
//     required this.songModel,
//     required this.audioController,
//     required this.playlistController,
//   });
//   final FavoriteController favoriteController;
//   final AllMusicsModel songModel;
//   final AudioController audioController;
//   final PlaylistController playlistController;
//   AllMusicController allMusicController = Get.put(AllMusicController());

//   @override
//   Widget build(BuildContext context) {
//     log(allMusicController.artistMap.length.toString());
//     return Scaffold(
//       body: FutureBuilder(
//         future: allMusicController.fetchAllAlbumMusicData(),
//         builder: (context, snapshot) {
//            if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(color: kRed,),
//                 );
//               } else if (snapshot.hasError) {
//                 return const DefaultCommonWidget(
//                     text: "Error on loading songs");
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const DefaultCommonWidget(
//                   text: "No artists available",
//                 );
//               }
//           return Obx(() {
//               return ListView.builder(
//                 itemCount: allMusicController.albumsMap.length,
//                 padding: EdgeInsets.symmetric(vertical: 15.h),
//                 itemBuilder: (context, index) {
//                   log("Loading items in album page");
//                   String albumName =
//                       allMusicController.albumsMap.keys.elementAt(index);
//                   // Getting albumSongs
//                   final List<AllMusicsModel> albumSongs =
//                       allMusicController.albumsMap[albumName]!;
//                   log('AlbumsSONG : ${albumSongs.length}');
//                   return ContainerTileWidget(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => AlbumSongListPage(
//                             playlistController: playlistController,
//                             allMusicController: allMusicController,
//                             audioController: audioController,
//                             songModel: songModel,
//                             favoriteController: favoriteController,
//                             albumName: albumName,
//                             albumSongs: albumSongs,
//                           ),
//                         ),
//                       );
//                     },
//                     pageType: PageTypeEnum.albumPage,
//                     songLength: albumSongs.length,
//                     title: albumName,
//                   );
//                 },
//               );
//             });
          
//         },
//       ),
//     );
//   }
// }

class MusicAlbumPage extends StatefulWidget {
  MusicAlbumPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.playlistController, required this.allMusicController,
  });
  final FavoriteController favoriteController;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final PlaylistController playlistController;
  final AllMusicController allMusicController;

  @override
  State<MusicAlbumPage> createState() => _MusicAlbumPageState();
}

class _MusicAlbumPageState extends State<MusicAlbumPage> {
  
  @override
  void initState() {
    widget.allMusicController.fetchAllAlbumMusicData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: widget.allMusicController.albumsMap,
        builder: (BuildContext context, Map<String, List<AllMusicsModel>> albums, Widget?_) {
          return  ListView.builder(
                itemCount: albums.length,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                itemBuilder: (context, index) {
                  log("Loading items in album page");
                  String albumName =
                      albums.keys.elementAt(index);
                  // Getting albumSongs
                  final List<AllMusicsModel> albumSongs =
                     albums[albumName]!;
                  log('AlbumsSONG : ${albumSongs.length}');
                  return GetBuilder<AllMusicController>(
                    init: widget.allMusicController,
                    builder: (controller) {
                      return ContainerTileWidget(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AlbumSongListPage(
                                playlistController: widget.playlistController,
                                allMusicController: widget.allMusicController,
                                audioController: widget.audioController,
                                songModel: widget.songModel,
                                favoriteController: widget.favoriteController,
                                albumName: albumName,
                                albumSongs: albumSongs,
                              ),
                            ),
                          );
                        },
                        pageType: PageTypeEnum.albumPage,
                        songLength: widget.allMusicController.getSongsOfAlbum(albumSongs, albumName).length,
                        title: albumName,
                      );
                    }
                  );
                },
              );
        },
      ),
    );
  }
}
