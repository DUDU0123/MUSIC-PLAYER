import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class PlaylistDeleteErrorDialogBox extends StatelessWidget {
  const PlaylistDeleteErrorDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidgetCommon(
        text: "Info",
        fontSize: 19.sp,
        fontWeight: FontWeight.bold,
        color: kWhite,
      ),
      backgroundColor: kTileColor,
      surfaceTintColor: kTransparent,
      content: TextWidgetCommon(
        text:
            "You can delete playlist from last. You are not allowed to delete the playlist from first and in between!!\nIf you don't want to delete playlist from last, you have the option to edit the name of the playlist and You can go to the playlist you want to delete,  and remove the songs from that playlist and can add new songs.",
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: kWhite,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kTileColor,
              side: BorderSide(
                color: kMenuBtmSheetColor,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp)),
            ),
            onPressed: () {
              Get.back();
            },
            child: TextWidgetCommon(
              text: "Okay",
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
        ),
      ],
    );
  }
}
