import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class CenterTitleAppBarCommonWidget extends StatelessWidget {
  const CenterTitleAppBarCommonWidget(
      {super.key, required this.appBarText, this.actions});
  final String appBarText;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_outlined,
          color: kRed,
          size: 30.sp,
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
