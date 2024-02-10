import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class ContainerTileWidget extends StatelessWidget {
  const ContainerTileWidget({
    super.key,
    required this.title,
    required this.songLength,
    required this.pageType, this.onTap,
  });
  final String title;
  final int songLength;
  final PageTypeEnum pageType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: kTileColor,
        ),
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 15.w, right: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
               pageType!= PageTypeEnum.artistPage? Container(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 7.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                    color: kLightGrey,
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: kWhite,
                    size: 24.sp,
                  ),
                ): const SizedBox(),
                kWidth10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidgetCommon(
                      text: title,
                      fontSize: 16.sp,
                      color: kWhite,
                    ),
                    TextWidgetCommon(
                      text: songLength > 1
                          ? '$songLength songs'
                          : '$songLength song',
                      fontSize: 10.sp,
                      color: kGrey,
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}