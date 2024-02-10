import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/current_playlist/current_playlist.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicViewPage extends StatelessWidget {
  const MusicViewPage(
      {super.key,
      required this.songName,
      required this.artistName,
      required this.albumName,
      required this.songFormat,
      required this.songSize,
      required this.songPathIndevice});

  final String songName;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: kScreenWidth,
        height: kScreenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 5,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 1, color: kLightGrey),
                    top: BorderSide(width: 1, color: kLightGrey),
                  )),
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      width: 280.w,
                      height: 280.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(1, 1),
                            color: kWhite.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 2,
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: kMusicIconContainerColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.music_note,
                          size: 200.sp,
                          color: kMusicIconMusicColor,
                        ),
                      ),
                    ),
                  ),
                  kHeight15,
                  // Duration Slider
                  Slider(
                    activeColor: kRed,
                    thumbColor: kRed,
                    inactiveColor: const Color.fromARGB(255, 53, 53, 53),
                    value: 1,
                    onChanged: (value) {},
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgetCommon(
                          text: "00:00",
                          fontSize: 10.sp,
                          color: kGrey,
                        ),
                        TextWidgetCommon(
                          text: "04:00",
                          fontSize: 10.sp,
                          color: kGrey,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: kScreenWidth,
                height: kScreenHeight / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        // song name
                        SizedBox(
                          width: kScreenWidth / 1.6,
                          child: TextWidgetCommon(
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            text: songName,
                            fontSize: 23.sp,
                            color: kWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        kHeight5,
                        // song artist name
                        TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: artistName,
                          fontSize: 10.sp,
                          color: kGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    // control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // play back button
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/play_back.png',
                            color: kRed,
                            scale: 18.sp,
                          ),
                        ),
                        // play pause button
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 6.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kRed),
                            child: Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: kWhite,
                            ),
                          ),
                        ),
                        // play next button
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/play_next.png',
                            color: kRed,
                            scale: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    // song bottom settings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // song current playlist show icon
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CurrentPlayListPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.list,
                            size: 30,
                            color: kWhite,
                          ),
                        ),
                        // song favourite add icon
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border,
                            size: 30,
                            color: kWhite,
                          ),
                        ),
                        // song loop shuffle
                        Image.asset(
                          "assets/loop_all.png",
                          scale: 15.sp,
                          color: kWhite,
                        ),
                        // song settings icon
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: kMenuBtmSheetColor,
                              context: context,
                              builder: (context) {
                                return MenuBottomSheet(
                                  kScreenHeight: kScreenHeight,
                                  pageType: PageTypeEnum.musicViewPage,
                                  songName: songName,
                                  artistName: artistName,
                                  albumName: albumName,
                                  songFormat: songFormat,
                                  songSize: songSize,
                                  songPathIndevice: songPathIndevice,
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: kWhite,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
