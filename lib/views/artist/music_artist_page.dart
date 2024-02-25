import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/artist/artist_song_list_page.dart';
import 'package:music_player/views/common_widgets/container_tile_widget.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicArtistPage extends StatelessWidget {
  const MusicArtistPage({
    super.key, required this.favoriteController,
  });
   final FavoriteController favoriteController;

  @override
  Widget build(BuildContext context) {
    AllMusicController allMusicController = Get.put(AllMusicController());
    return Obx(() {
      print('Artist Map Length: ${allMusicController.artistMap.value.length}');
      return Scaffold(
        body: allMusicController.artistMap.value.isEmpty
            ? DefaultCommonWidget(text: "No artists available")
            : ListView.builder(
                itemCount: allMusicController.artistMap.value.length,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                itemBuilder: (context, index) {
                  String artistName =
                      allMusicController.artistMap.value.keys.elementAt(index);
                  // Getting artistSongs
                  final List<AllMusicsModel> artistSongs =
                      allMusicController.artistMap.value[artistName]!;
                  return ContainerTileWidget(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ArtistSongListPage(
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
              ),
      );
    });
  }
}
