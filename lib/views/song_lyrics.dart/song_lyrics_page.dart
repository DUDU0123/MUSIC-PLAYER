import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class MusicLyricsPage extends StatefulWidget {
  const MusicLyricsPage({
    super.key,
    required this.songId,
    required this.songModel,
    required this.allMusicController,
  });
  final int songId;
  final AllMusicsModel songModel;
  final AllMusicController allMusicController;

  @override
  State<MusicLyricsPage> createState() => _MusicLyricsPageState();
}

class _MusicLyricsPageState extends State<MusicLyricsPage> {
  late TextEditingController lyricsTextController;

  @override
  void initState() {
    super.initState();
    lyricsTextController = TextEditingController(
        text: widget.allMusicController.getLyricsForSong(widget.songModel.id));
  }

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: kLyricsTextColor,
          ),
        ),
        title: Text(
          widget.songModel.musicName,
          style: TextStyle(color: kLyricsTextColor, fontSize: 18.sp),
        ),
        actions: [
          GetBuilder<AllMusicController>(
            init: widget.allMusicController,
            builder: (controller) {
              return GestureDetector(
                onTap: () async {
                  final String lyrics = lyricsTextController.text;
                  // Save lyrics to the database
                  await controller.saveLyrics(widget.songModel.id, lyrics);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.sp, bottom: 10.sp),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.sp, vertical: 5.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kTileColor,
                      border: Border.all(
                        color: kMenuBtmSheetColor,
                      )),
                  child: TextWidgetCommon(
                    text: "Save",
                    fontSize: 15.sp,
                    color: kRed,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: kScreenHeight,
        width: kScreenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
              colors: [kTileColor, kBlack]),
        ),
        child: GetBuilder<AllMusicController>(
            init: widget.allMusicController,
            builder: (controller) {
              return Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
                  decoration: BoxDecoration(
                      color: kTransparent,
                      border: Border.all(color: kWhite),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: null,
                    maxLength: null,
                    controller: lyricsTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: kTransparent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kTransparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kTransparent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kTransparent)),
                      hintText: "Enter lyrics of the song and save it",
                      hintStyle: TextStyle(
                        color: kLyricsTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ));
            }),
      ),
    );
  }
}
