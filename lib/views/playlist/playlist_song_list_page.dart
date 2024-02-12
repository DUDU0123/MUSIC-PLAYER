import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class PlaylistSongListPage extends StatelessWidget {
  const PlaylistSongListPage({super.key});
  // final String songTitle;
  // final String artistName;
  // final String albumName;
  // final String songFormat;
  // final String songSize;
  // final String songPathIndevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          appBarText: "Playlist 1",
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: kRed,
                size: 30.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                // need to send the list of song in the playlist
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  SongEditPage(pageType: PageTypeEnum.playListPage),),);
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
        itemCount: 5,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(
            onTap: () {},
            pageType: PageTypeEnum.playListPage,
            albumName: "Unknown album",
            artistName: "Unknown artist",
            songTitle: "Vaaranam Aayiram_Oh_Shanti",
            songFormat: "mp3",
            songPathIndevice:
                "Phone/Vidmate/download/Vaaranam_Aayiram_-_Oh_Shanti_Shanti_Video_|_Suriya_|_Harris_Jayaraj(128k)",
            songSize: "3.80MB",
          );
        },
      ),
    );
  }
}
