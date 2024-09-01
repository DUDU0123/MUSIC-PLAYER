
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class TermsAndPolicyCommonTextWidgetForHeading extends StatelessWidget {
  const TermsAndPolicyCommonTextWidgetForHeading(
      {super.key, required this.text, this.textAlign = TextAlign.start});
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return TextWidgetCommon(
      textAlign: textAlign,
      text: text,
      fontSize: 16.sp,
      color: kWhite,
      fontWeight: FontWeight.normal,
    );
  }
}
