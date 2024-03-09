import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/details.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/artist/artist_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

// class MusicArtistPage extends StatelessWidget {
//   const MusicArtistPage({
//     super.key,
//     required this.favoriteController,
//     required this.songModel,
//     required this.audioController,
//     required this.playlistController,
//   });
//   final FavoriteController favoriteController;
//   final AudioController audioController;
//   final AllMusicsModel songModel;
//   final PlaylistController playlistController;

//   @override
//   Widget build(BuildContext context) {
//     AllMusicController allMusicController = Get.put(AllMusicController());
//     return Scaffold(
//         body: FutureBuilder(
//             future: allMusicController.fetchAllArtistMusicData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
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
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return Obx(() {
//                   return ListView.builder(
//                     itemCount: allMusicController.artistMap.length,
//                     padding: EdgeInsets.symmetric(vertical: 15.h),
//                     itemBuilder: (context, index) {
//                       log("Loading");
//                       String artistName =
//                           allMusicController.artistMap.keys.elementAt(index);
//                       // Getting artistSongs
//                       final List<AllMusicsModel> artistSongs =
//                           allMusicController.artistMap[artistName]!;
//                       return ContainerTileWidget(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => ArtistSongListPage(
//                                 playlistController: playlistController,
//                                 allMusicController: allMusicController,
//                                 audioController: audioController,
//                                 songModel: audioController
//                                             .currentPlayingSong.value !=
//                                         null
//                                     ? audioController.currentPlayingSong.value!
//                                     : songModel,
//                                 favoriteController: favoriteController,
//                                 artistName: artistName,
//                                 artistSongs: artistSongs,
//                               ),
//                             ),
//                           );
//                         },
//                         pageType: PageTypeEnum.artistPage,
//                         songLength: artistSongs.length,
//                         title: artistName == '<unknown>'
//                             ? "Unknown Artist"
//                             : artistName,
//                       );
//                     },
//                   );
//                 });
//               }
//               return const DefaultCommonWidget(text: "No artists available");
//             }));
//   }
// }

class MusicArtistPage extends StatefulWidget {
  const MusicArtistPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.playlistController,
  });
  final FavoriteController favoriteController;
  final AudioController audioController;
  final AllMusicsModel songModel;
  final PlaylistController playlistController;

  @override
  State<MusicArtistPage> createState() => MusicArtistPageState();
}

class MusicArtistPageState extends State<MusicArtistPage> {
  void refreshUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AllMusicController allMusicController = Get.put(AllMusicController());
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: allMusicController.artistMap,
          builder: (BuildContext context,
              Map<String, List<AllMusicsModel>> artist, Widget? _) {
            return ListView.builder(
              itemCount: artist.length,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              itemBuilder: (context, index) {
                log(artist.length.toString());
                log("Loading");
                String artistName = artist.keys.elementAt(index);
                // Getting artistSongs
                final List<AllMusicsModel> artistSongs = artist[artistName]!;
                return ContainerTileWidget(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArtistSongListPage(
                          instance: this,
                          playlistController: widget.playlistController,
                          allMusicController: allMusicController,
                          audioController: widget.audioController,
                          songModel: widget.audioController.currentPlayingSong
                                      .value !=
                                  null
                              ? widget.audioController.currentPlayingSong.value!
                              : widget.songModel,
                          favoriteController: widget.favoriteController,
                          artistName: artistName,
                          artistSongs: artistSongs,
                        ),
                      ),
                    );
                  },
                  pageType: PageTypeEnum.artistPage,
                  songLength: allMusicController.getSongsOfArtist(artistSongs, artistName).length,
                  title:
                      artistName == '<unknown>' ? "Unknown Artist" : artistName,
                );
              },
            );
          }),
    );
  }
}
