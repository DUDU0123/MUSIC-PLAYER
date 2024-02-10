import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class CurrentPlayListPage extends StatelessWidget {
  const CurrentPlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: kRed,
            size: 30,
          ),
        ),
        title: TextWidgetCommon(
          text: "Current Playlist",
          color: kWhite,
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
        ),
        automaticallyImplyLeading: false,
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(
            onTap: () {},
            kScreenWidth: kScreenWidth,
            albumName: "Unkown album",
            artistName: "Unknown artist",
            songTitle: "Vaaranam Aayiram_Oh_Shanti",
            pageType: PageTypeEnum.currentPlayListPage,
            songFormat: "mp3",
            songPathIndevice: "",
            songSize: "3.80MB",
          );
        },
      ),
    );
  }
}
