import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/constants/height_width.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget({
    super.key,
    required this.fieldName,
    required this.fieldValue,
  });
  final String fieldName;
  final String fieldValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidgetCommon(
          color: kWhite,
          text: "$fieldName:",
          fontSize: 16.sp,
        ),
        kWidth10,
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextWidgetCommon(
            color: kWhite,
            text: fieldValue,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}