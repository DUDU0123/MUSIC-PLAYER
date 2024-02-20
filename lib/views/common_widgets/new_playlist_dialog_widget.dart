import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/button_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/common_widgets/textfield_common_widget.dart';

class NewPlayListDialogBoxWidget extends StatefulWidget {
  const NewPlayListDialogBoxWidget({
    super.key,
    required this.playlsitNameGiverController,
    required this.onSavePlaylist,
  });
  final TextEditingController playlsitNameGiverController;
  final Function(String) onSavePlaylist;
  @override
  State<NewPlayListDialogBoxWidget> createState() =>
      _NewPlayListDialogBoxWidgetState();
}

class _NewPlayListDialogBoxWidgetState
    extends State<NewPlayListDialogBoxWidget> {
  @override
  void initState() {
    super.initState();
    widget.playlsitNameGiverController.text = "Playlist 1";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: kTransparent,
      backgroundColor: kMenuBtmSheetColor,
      title: Center(
        child: TextWidgetCommon(
          text: "New Playlist",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: SizedBox(
        width: 100,
        height: 50,
        child: TextFieldCommonWidget(
          controller: widget.playlsitNameGiverController,
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
              onPressed:() {
                 widget.onSavePlaylist(widget.playlsitNameGiverController.text);
              },
            ),
          ],
        ),
      ],
    );
  }
}
