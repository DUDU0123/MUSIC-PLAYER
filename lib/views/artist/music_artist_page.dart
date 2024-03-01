import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/artist/artist_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicArtistPage extends StatelessWidget {
  const MusicArtistPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
  });
  final FavoriteController favoriteController;
  final AudioController audioController;
  final AllMusicsModel songModel;

  @override
  Widget build(BuildContext context) {
    AllMusicController allMusicController = Get.put(AllMusicController());
    return Scaffold(
      body: FutureBuilder(
              future: allMusicController.fetchAllArtistMusicData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Obx(() {
                  return ListView.builder(
                    itemCount: allMusicController.artistMap.length,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    itemBuilder: (context, index) {
                      log("Loading");
                      String artistName =
                          allMusicController.artistMap.keys.elementAt(index);
                      // Getting artistSongs
                      final List<AllMusicsModel> artistSongs =
                          allMusicController.artistMap[artistName]!;
                      return ContainerTileWidget(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ArtistSongListPage(
                                allMusicController: allMusicController,
                                audioController: audioController,
                                songModel: audioController
                                            .currentPlayingSong.value !=
                                        null
                                    ? audioController.currentPlayingSong.value!
                                    : songModel,
                                favoriteController: favoriteController,
                                artistName: artistName,
                                artistSongs: artistSongs,
                              ),
                            ),
                          );
                        },
                        pageType: PageTypeEnum.artistPage,
                        songLength: artistSongs.length,
                        title: artistName == '<unknown>'
                            ? "Unknown Artist"
                            : artistName,
                      );
                    },
                  );
                });
                }
                return const DefaultCommonWidget(text: "No artists available");
              })
    );
  }
}
