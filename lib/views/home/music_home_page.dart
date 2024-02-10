import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicHomePage extends StatelessWidget {
  const MusicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
   // final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(

            onTap: () {
              
            },
            pageType: PageTypeEnum.normalPage,
            kScreenWidth: kScreenWidth,
            albumName: "Unknown album",
            artistName: "Unknown artist",
            songTitle: "Vaaranam Aayiram_Oh_Shanti",
            songFormat: "mp3",
            songPathIndevice: "Phone/Vidmate/download/Vaaranam_Aayiram_-_Oh_Shanti_Shanti_Video_|_Suriya_|_Harris_Jayaraj(128k)",
            songSize: "3.80MB",
          );
        },
      ),
    );
  }
}
