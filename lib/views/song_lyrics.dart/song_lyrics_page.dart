import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';

class MusicLyricsPage extends StatelessWidget {
  const MusicLyricsPage({
    super.key,
    required this.songId,
    required this.songModel,
    // required this.currentPlayingsongs,
  });
  // final String songName;
  // final String artistName;
  // final String albumName;
  // final String songFormat;
  // final String songSize;
  // final String songPathIndevice;

  final int songId;
  final AllMusicsModel songModel;
  //final List<AllMusicsModel> currentPlayingsongs;

  @override
  Widget build(BuildContext context) {
    //final kScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 169, 169, 169),
          ),
        ),
        title: Text(
          songModel.musicName,
          style: GoogleFonts.averiaGruesaLibre().copyWith(
              color: const Color.fromARGB(255, 169, 169, 169), fontSize: 20.sp),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topCenter,
                colors: [kTileColor, kBlack])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Parayathe ariyathe ni poyathalle",
              style: GoogleFonts.averiaGruesaLibre().copyWith(
                  color: const Color.fromARGB(255, 188, 130, 128),
                  fontSize: 20.sp),
            )
          ],
        ),
      ),
    );
  }
}
