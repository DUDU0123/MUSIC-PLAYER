import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/album_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicAlbumPage extends StatefulWidget {
  const MusicAlbumPage({
    super.key,
    required this.songModel,
  });
  final AllMusicsModel songModel;

  @override
  State<MusicAlbumPage> createState() => MusicAlbumPageState();
}

class MusicAlbumPageState extends State<MusicAlbumPage> {
  @override
  void initState() {
    AllMusicController.to.fetchAllAlbumMusicData();
    // widget.audioController.requestPermissionAndFetchSongsAndInitializePlayer();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: AllMusicController.to.albumsMap,
        builder: (BuildContext context,
            Map<String, List<AllMusicsModel>> albums, Widget? _) {
          return ListView.builder(
            itemCount: albums.length,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            itemBuilder: (context, index) {
              String albumName = albums.keys.elementAt(index);
              // Getting albumSongs
              final List<AllMusicsModel> albumSongs = albums[albumName]!;
              return GetBuilder<AllMusicController>(
                  init: AllMusicController.to,
                  builder: (controller) {
                    return ContainerTileWidget(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AlbumSongListPage(
                              songModel: widget.songModel,
                              albumName: albumName,
                              albumSongs: albumSongs,
                            ),
                          ),
                        );
                      },
                      pageType: PageTypeEnum.albumPage,
                      songLength: controller
                          .getSongsOfAlbum(albumSongs, albumName)
                          .length,
                      title: albumName,
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
