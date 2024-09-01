import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class SideTitleAppBarCommon extends StatelessWidget {
  const SideTitleAppBarCommon({super.key, required this.appBarText, this.actions,required this.onPressed});
  final String appBarText;
  final List<Widget>? actions;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.arrow_back,
          size: 30.sp,
          color: kRed,
        ),
      ),
      title: TextWidgetCommon(
        color: kWhite,
        text: appBarText,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      actions: actions,
    );
  }
}
