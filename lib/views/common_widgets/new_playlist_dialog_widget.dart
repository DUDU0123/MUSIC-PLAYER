import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/button_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/common_widgets/textfield_common_widget.dart';

class NewPlayListDialogBoxWidget extends StatelessWidget {
  const NewPlayListDialogBoxWidget({
    super.key,
    required this.playlsitNameGiverController, required this.editOrNew, required this.onPressed,
  });
  final TextEditingController playlsitNameGiverController;
  final void Function() onPressed;
  final String editOrNew;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: kTransparent,
      backgroundColor: kTileColor,
      title: Center(
        child: TextWidgetCommon(
          
          text: editOrNew,
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: SizedBox(
        width: 100,
        height: 50,
        child: TextFieldCommonWidget(
          controller: playlsitNameGiverController,
          hintText: "",
          labelText: "",
        ),
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
              buttonText: "Save",
              onPressed:onPressed,
            ),
          ],
        ),
      ],
    );
  }
}
