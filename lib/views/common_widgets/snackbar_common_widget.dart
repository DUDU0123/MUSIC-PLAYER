import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

void snackBarCommonWidget(BuildContext context,{required String contentText}) {
  ScaffoldMessenger.of(context).showSnackBar(
    
    SnackBar(
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      backgroundColor: kMenuBtmSheetColor,
      duration: const Duration(
        seconds: 1,
      ),
      content: TextWidgetCommon(
        text: contentText,
        fontSize: 15.sp,
      ),
    ),
  );
}
