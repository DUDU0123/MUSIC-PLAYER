import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';


class MusicTileWidget extends StatelessWidget {
  const MusicTileWidget({
    super.key,
    required this.kScreenWidth,
    required this.songTitle,
    this.artistName = "Unknown artist",
    this.albumName = "Unknown album",
    required this.pageType,
    this.onTap,
    required this.songFormat,
    required this.songSize,
    required this.songPathIndevice,
  });

  final double kScreenWidth;
  final String songTitle;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  final PageTypeEnum pageType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final kScreenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: kTileColor,
          borderRadius: BorderRadius.circular(13.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: kScreenWidth / 1.7,
                  child: TextWidgetCommon(
                    overflow: TextOverflow.ellipsis,
                    text: songTitle,
                    fontSize: 16.sp,
                    color: kWhite,
                  ),
                ),
                TextWidgetCommon(
                  text: "$artistName-$albumName",
                  fontSize: 10.sp,
                  color: kGrey,
                ),
              ],
            ),
            Row(
              children: [
                pageType != PageTypeEnum.currentPlayListPage
                    ? IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return MenuBottomSheet(
                                kScreenHeight: kScreenHeight,
                                pageType: PageTypeEnum.normalPage,
                                songName: songTitle,
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
                          Icons.more_vert,
                          size: 26.sp,
                          color: kGrey,
                        ),
                      )
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
