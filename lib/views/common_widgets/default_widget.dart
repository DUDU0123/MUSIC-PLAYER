import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';

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