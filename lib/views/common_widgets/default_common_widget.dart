import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class DefaultCommonWidget extends StatelessWidget {
  const DefaultCommonWidget({
    super.key, required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DefaultWidget(),
        Center(
          child: TextWidgetCommon(
            text: text,
            fontSize: 20.sp,
            color: kTileColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Center(
          child: Icon(
            Icons.music_note_rounded,
            color: kTileColor,
            size: 80.sp,
          ),
        ),
      );
  }
}