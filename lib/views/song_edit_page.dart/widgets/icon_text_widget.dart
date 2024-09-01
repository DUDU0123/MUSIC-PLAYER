import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    super.key,
    required this.icon,
    required this.iconName,
    this.onTap, required this.isSongSelected,
  });

  final IconData icon;
  final String iconName;
  final void Function()? onTap;
  final bool? isSongSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSongSelected!?kWhite:kGrey,
            size: 28.sp,
          ),
          TextWidgetCommon(
            text: iconName,
            fontSize: 12.sp,
            color: isSongSelected!?kWhite:kGrey,
          )
        ],
      ),
    );
  }
}