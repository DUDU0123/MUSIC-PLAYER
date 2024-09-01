import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/constants/height_width.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class PlayListSingleTileWidget extends StatelessWidget {
  const PlayListSingleTileWidget({
    super.key,
    required this.title,
    required this.iconName,
    required this.iconColor, this.onTap,
  });
  final String title;
  final IconData iconName;
  final Color iconColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 15.w, bottom: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  iconName,
                  color: iconColor,
                  size: 28.sp,
                ),
                kWidth15,
                TextWidgetCommon(
                  text: title,
                  fontSize: 17.sp,
                  color: kWhite,
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