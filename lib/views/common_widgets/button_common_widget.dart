import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class ButtonCommonWidget extends StatelessWidget {
  const ButtonCommonWidget({
    super.key, this.onPressed, required this.buttonText,
  });

  final void Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        surfaceTintColor: kTransparent,
        backgroundColor:
            kTileColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: kLightGrey,
          ),
          borderRadius: BorderRadius.circular(10.sp),
        ),
      ),
      onPressed: onPressed,
      child: TextWidgetCommon(
        color: kWhite,
        fontWeight: FontWeight.w500,
        text: buttonText,
        fontSize: 16.sp,
      ),
    );
  }
}