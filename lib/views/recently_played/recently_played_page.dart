import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class RecentlyPlayedPage extends StatelessWidget {
  RecentlyPlayedPage({super.key});
  // need to integrate
  List<AllMusicsModel> recentlyPlayedSongList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          appBarText: "Recently Played",
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [
            TextButton(
              onPressed: () {},
              child: TextWidgetCommon(
                text: "Clear",
                color: kRed,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: recentlyPlayedSongList.length,
        itemBuilder: (context, index) {
          return MusicTileWidget(
            songTitle: recentlyPlayedSongList[index].musicName,
            songFormat: recentlyPlayedSongList[index].musicFormat,
            songSize: recentlyPlayedSongList[index].musicFileSize.toString(),
            songPathIndevice: recentlyPlayedSongList[index].musicPathInDevice,
            pageType: PageTypeEnum.recentlyPlayedPage,
            songId: recentlyPlayedSongList[index].id,
          );
        },
      ),
    );
  }
}
