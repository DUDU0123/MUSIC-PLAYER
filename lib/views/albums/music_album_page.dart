import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/album_song_list_page.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicAlbumPage extends StatelessWidget {
  const MusicAlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicBox = Hive.box<AllMusicsModel>('musics');
    // getting a list of album song according to album
    final List<AllMusicsModel> allMusics = musicBox.values.toList();
    // Grouping songs by album name
    final Map<String, List<AllMusicsModel>> albumsMap = {};
    allMusics.forEach((music) {
      final albumName = capitalizeFirstLetter(music.musicAlbumName);
      if (!albumsMap.containsKey(albumName)) {
        albumsMap[albumName] = [];
      }
      albumsMap[albumName]!.add(music);
    });
    
    return Scaffold(
      body: ListView.builder(
        itemCount: albumsMap.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        itemBuilder: (context, index) {
          String albumName = albumsMap.keys.elementAt(index);
          // Getting albumSongs
          final List<AllMusicsModel> albumSongs = albumsMap[albumName]!;
          print('AlbumsSONG : ${albumSongs.length}');
          return ContainerTileWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AlbumSongListPage(
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
  }
}
