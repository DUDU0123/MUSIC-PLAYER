import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/artist/artist_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicArtistPage extends StatefulWidget {
  const MusicArtistPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.playlistController, required this.allMusicController,
  });
  final FavoriteController favoriteController;
  final AudioController audioController;
  final AllMusicsModel songModel;
  final PlaylistController playlistController;
  final AllMusicController allMusicController;

  @override
  State<MusicArtistPage> createState() => MusicArtistPageState();
}

class MusicArtistPageState extends State<MusicArtistPage> {

  @override
  void initState() {
    widget.allMusicController.fetchAllArtistMusicData();
    //widget.audioController.requestPermissionAndFetchSongsAndInitializePlayer();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: widget.allMusicController.artistMap,
          builder: (BuildContext context,
              Map<String, List<AllMusicsModel>> artist, Widget? _) {
            return ListView.builder(
              itemCount: artist.length,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              itemBuilder: (context, index) {
                String artistName = artist.keys.elementAt(index);
                // Getting artistSongs
                final List<AllMusicsModel> artistSongs = artist[artistName]!;
                return GetBuilder<AllMusicController>(
                  init: widget.allMusicController,
                  builder: (controller) {
                    return ContainerTileWidget(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ArtistSongListPage(
                              playlistController: widget.playlistController,
                              allMusicController: widget.allMusicController,
                              audioController: widget.audioController,
                              songModel:  widget.songModel,
                              favoriteController: widget.favoriteController,
                              artistName: artistName,
                              artistSongs: artistSongs,
                            ),
                          ),
                        );
                      },
                      pageType: PageTypeEnum.artistPage,
                      songLength: controller.getSongsOfArtist(artistSongs, artistName).length,
                      title:
                          artistName == '<unknown>' ? "Unknown Artist" : artistName,
                    );
                  }
                );
              },
            );
          }),
    );
  }
}
