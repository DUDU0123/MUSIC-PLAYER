import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class ArtistSongListPage extends StatelessWidget {
  const ArtistSongListPage({super.key, required this.artistName, required this.artistSongs});
  final String artistName;
  final List<AllMusicsModel> artistSongs;

  @override
  Widget build(BuildContext context) {
    final musicBox = Hive.box<AllMusicsModel>('musics');
    // final List<AllMusicsModel> artistSongs = artistOrAlbumSongsListGetting(
    //   musicBox: musicBox,
    //   callback: (music) {
    //     return music.musicArtistName == artistName;
    //   },
    // );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          appBarText: artistName == '<unknown>' ? "Unknown Artist" : artistName,
          actions: [
            TextButton(
              onPressed: () {
                // need to send the song details list to the song edit page from here
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SongEditPage(
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
      body: ListView.builder(
        itemCount: artistSongs.length,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(
            songId: artistSongs[index].id,
            onTap: () {},
            pageType: PageTypeEnum.normalPage,
            albumName: artistSongs[index].musicAlbumName,
            artistName: artistSongs[index].musicArtistName,
            songTitle: artistSongs[index].musicName,
            songFormat: artistSongs[index].musicFormat,
            songPathIndevice: artistSongs[index].musicPathInDevice,
            songSize: "${artistSongs[index].musicFileSize}MB",
          );
        },
      ),
    );
  }
}
