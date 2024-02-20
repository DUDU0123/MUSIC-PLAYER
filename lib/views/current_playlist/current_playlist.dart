import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class CurrentPlayListPage extends StatelessWidget {
  const CurrentPlayListPage({super.key, required this.songName, required this.artistName, required this.albumName, required this.songFormat, required this.songSize, required this.songPathIndevice, required this.isPlaying, required this.songId});
  final String songName;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  final bool isPlaying;
  final int songId;

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: "Current Playlist",
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: TextWidgetCommon(
                text: "Done",
                color: kRed,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(
            songId: songId,
            isPlaying: isPlaying,
            onTap: () {},
            albumName: albumName,
            artistName: artistName,
            songTitle: songName,
            pageType: PageTypeEnum.currentPlayListPage,
            songFormat: songFormat,
            songPathIndevice: songPathIndevice,
            songSize: "${songSize}MB",
          );
        },
      ),
    );
  }
}
