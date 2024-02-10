import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/button_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class DeleteDialogBox extends StatelessWidget {
  const DeleteDialogBox({super.key, required this.contentText, required this.deleteAction});
  final String contentText;
  final void Function() deleteAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kMenuBtmSheetColor,
      surfaceTintColor: kTransparent,
      title: TextWidgetCommon(
        text: "Delete",
        fontSize: 20.sp,
        color: kWhite,
        fontWeight: FontWeight.w500,
      ),
      content: TextWidgetCommon(
        text: contentText,
        fontSize: 18.sp,
        color: kWhite,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonCommonWidget(
              buttonText: "Cancel",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ButtonCommonWidget(
          buttonText: "Delete",
          onPressed: deleteAction,
        ),
          ],
        ),
        
      ],
    );
  }
}
