import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class FavouriteMusicListPage extends StatelessWidget {
  FavouriteMusicListPage({
    super.key,
    required this.songModel,
    required this.audioController,
    // required this.favouriteController,
  });
  // final FavoriteController favouriteController;
  final FavoriteController favouriteController = Get.put(FavoriteController());
  final AllMusicsModel songModel;
  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    favouriteController.loadFavoriteSongs();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: 'Favorites',
          actions: [
            TextButton(
              onPressed: () {
                // need to send the song details list to song edit page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SongEditPage(
                      song: songModel,
                      favoriteController: favouriteController,
                      pageType: PageTypeEnum.favoritePage,
                      songList:
                          favouriteController.favoriteSongs.value.map((e) {
                        return AllMusicsModel(
                          id: e.id,
                          musicName: e.musicName,
                          musicAlbumName: e.musicAlbumName,
                          musicArtistName: e.musicArtistName,
                          musicPathInDevice: e.musicPathInDevice,
                          musicFormat: e.musicFormat,
                          musicUri: e.musicUri,
                          musicFileSize: int.parse(audioController.convertToMBorKB(e.musicFileSize)),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              child: TextWidgetCommon(
                text: "Edit",
                color: kRed,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        return favouriteController.favoriteSongs.isEmpty
            ? const DefaultCommonWidget(text: "No songs available")
            : ListView.builder(
                itemCount: favouriteController.favoriteSongs.length,
                itemBuilder: (context, index) {
                  favouriteController.favoriteSongs.toList().toSet();
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: MusicTileWidget(
                      songModel: songModel,
                      favoriteController: favouriteController,
                      musicUri:
                          favouriteController.favoriteSongs[index].musicUri,
                      // audioPlayer: audioPlayer,
                      // musicBox: musicBox,
                      albumName: favouriteController
                          .favoriteSongs[index].musicAlbumName,
                      artistName: favouriteController
                          .favoriteSongs[index].musicArtistName,
                      // isPlaying: false,
                      songTitle:
                          favouriteController.favoriteSongs[index].musicName,
                      songFormat:
                          favouriteController.favoriteSongs[index].musicFormat,
                      songSize: audioController.convertToMBorKB(
                          favouriteController
                              .favoriteSongs[index].musicFileSize),
                      songPathIndevice: favouriteController
                          .favoriteSongs[index].musicPathInDevice,
                      pageType: PageTypeEnum.favoritePage,
                      songId: favouriteController.favoriteSongs[index].id,
                    ),
                  );
                },
              );
      }),
    );
  }
}
