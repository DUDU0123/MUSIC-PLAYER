import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

void snackBarCommonWidget(BuildContext context,{required String contentText}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: kMenuBtmSheetColor,
      duration: const Duration(
        seconds: 2,
      ),
      content: TextWidgetCommon(
        text: contentText,
        fontSize: 15.sp,
      ),
    ),
  );
}
