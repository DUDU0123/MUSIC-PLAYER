import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/artist/artist_song_list_page.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicArtistPage extends StatelessWidget {
  const MusicArtistPage({super.key});

 

  @override
  Widget build(BuildContext context) {
    final musicBox = Hive.box<AllMusicsModel>('musics');
    // getting a list of artistSongList song according to artist
    // getting a list of album song according to album
    final List<AllMusicsModel> allMusics = musicBox.values.toList();
    // Grouping songs by album name
    final Map<String, List<AllMusicsModel>> artistMap = {};
    allMusics.forEach((music) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.containsKey(artistName)) {
        artistMap[artistName] = [];
      }
      artistMap[artistName]!.add(music);
    });

    return Scaffold(
      body: ListView.builder(
        itemCount: artistMap.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        itemBuilder: (context, index) {
          String artistName = artistMap.keys.elementAt(index);
          // Getting artistSongs
         final List<AllMusicsModel> albumSongs = artistMap[artistName]!;
          return ContainerTileWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ArtistSongListPage(artistName: artistName),
                ),
              );
            },
            pageType: PageTypeEnum.artistPage,
            songLength: albumSongs.length,
            title: artistName == '<unknown>' ? "Unknown Artist" : artistName,
          );
        },
      ),
    );
  }
}
