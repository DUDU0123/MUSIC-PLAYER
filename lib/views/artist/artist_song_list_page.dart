import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class ArtistSongListPage extends StatelessWidget {
  const ArtistSongListPage({
    super.key,
    required this.artistName,
    required this.artistSongs,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.allMusicController,
  });
  final String artistName;
  final FavoriteController favoriteController;
  final List<AllMusicsModel> artistSongs;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final AllMusicController allMusicController;
  @override
  Widget build(BuildContext context) {
    // final musicBox = Hive.box<AllMusicsModel>('musics');
    // final List<AllMusicsModel> artistSongs = artistOrAlbumSongsListGetting(
    //   musicBox: musicBox,
    //   callback: (music) {
    //     return music.musicArtistName == artistName;
    //   },
    // );
    //  AllMusicController allMusicController = Get.put(AllMusicController());
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SideTitleAppBarCommon(
            onPressed: () {
              Navigator.pop(context);
            },
            appBarText:
                artistName == '<unknown>' ? "Unknown Artist" : artistName,
            actions: [
              TextButton(
                onPressed: () {
                  // need to send the song details list to the song edit page from here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SongEditPage(
                        audioController: audioController,
                        song: songModel,
                        favoriteController: favoriteController,
                        pageType: PageTypeEnum.songEditPage,
                        songList: artistSongs,
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
        body: artistSongs.isEmpty
            ? const DefaultCommonWidget(text: "No songs available")
            : ListView.builder(
                itemCount: artistSongs.length,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                itemBuilder: (context, index) {
                  return MusicTileWidget(
                    audioController: audioController,
                    songModel: artistSongs[index],
                    favoriteController: favoriteController,
                    musicUri: artistSongs[index].musicUri,
                    songId: artistSongs[index].id,
                    pageType: PageTypeEnum.artistSongListPage,
                    albumName: artistSongs[index].musicAlbumName,
                    artistName: artistSongs[index].musicArtistName,
                    songTitle: artistSongs[index].musicName,
                    songFormat: artistSongs[index].musicFormat,
                    songPathIndevice: artistSongs[index].musicPathInDevice,
                    songSize: AppUsingCommonFunctions.convertToMBorKB(
                        artistSongs[index].musicFileSize),
                  );
                },
              ));
  }
}
