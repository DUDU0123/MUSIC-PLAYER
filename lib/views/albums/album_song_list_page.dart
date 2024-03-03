import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class AlbumSongListPage extends StatelessWidget {
  const AlbumSongListPage({
    super.key,
    required this.albumName,
    required this.albumSongs,
    required this.favoriteController,
    required this.songModel,
    required this.audioController, required this.allMusicController, required this.playlistController,
  });
  final String albumName;
  final List<AllMusicsModel> albumSongs;
  final FavoriteController favoriteController;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final AllMusicController allMusicController;
  final PlaylistController playlistController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: albumName,
          actions: [
            TextButton(
              onPressed: () {
                // need to send the song details list to song edit page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SongEditPage(
                      playlistController: playlistController,
                      audioController: audioController,
                      song: songModel,
                      favoriteController: favoriteController,
                      pageType: PageTypeEnum.albumPage,
                      songList: albumSongs,
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
      body: albumSongs.isEmpty
          ? const DefaultCommonWidget(text: "No songs available")
          : FutureBuilder(
            future: allMusicController.fetchAllAlbumMusicData(),
            builder: (context, snapshot) {
              return GetBuilder<AllMusicController>(
                init: allMusicController,
                builder: (controller) {
                  return ListView.builder(
                      itemCount: albumSongs.length,
                      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                      itemBuilder: (context, index) {
                        return MusicTileWidget(
                          audioController: audioController,
                          songModel: albumSongs[index],
                          favoriteController: favoriteController,
                          musicUri: albumSongs[index].musicUri,
                          songId: albumSongs[index].id,
                          pageType: PageTypeEnum.albumSongListPage,
                          albumName: albumSongs[index].musicAlbumName,
                          artistName: albumSongs[index].musicArtistName,
                          songTitle: albumSongs[index].musicName,
                          songFormat: albumSongs[index].musicFormat,
                          songPathIndevice: albumSongs[index].musicPathInDevice,
                          songSize: AppUsingCommonFunctions.convertToMBorKB(
                              albumSongs[index].musicFileSize),
                        );
                      },
                    );
                }
              );
            }
          ),
    );
  }
}
