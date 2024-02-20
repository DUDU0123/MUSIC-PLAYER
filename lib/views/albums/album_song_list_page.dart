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

class AlbumSongListPage extends StatelessWidget {
  const AlbumSongListPage({super.key, required this.albumName, required this.albumSongs});
  final String albumName;
  final List<AllMusicsModel> albumSongs;

  

  @override
  Widget build(BuildContext context) {
    final musicBox = Hive.box<AllMusicsModel>('musics');
    // final List<AllMusicsModel> albumSongs = artistOrAlbumSongsListGetting(
    //   musicBox: musicBox,
    //   callback: (music) {
    //     return music.musicAlbumName == albumName;
    //   },
    // );

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
      body: ListView.builder(
        itemCount: albumSongs.length,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(
            songId: albumSongs[index].id,
            onTap: () {},
            pageType: PageTypeEnum.normalPage,
            albumName: albumSongs[index].musicAlbumName,
            artistName: albumSongs[index].musicArtistName,
            songTitle: albumSongs[index].musicName,
            songFormat: albumSongs[index].musicFormat,
            songPathIndevice: albumSongs[index].musicPathInDevice,
            songSize: "${albumSongs[index].musicFileSize}MB",
          );
        },
      ),
    );
  }
}
