import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/constants/height_width.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/view_details_page.dart/widgets/details_row_widget.dart';

class ViewDetailsPage extends StatelessWidget {
  const ViewDetailsPage({super.key, required this.songName, required this.artistName, required this.albumName, required this.songFormat, required this.songSize, required this.songPathIndevice});
  final String songName;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextWidgetCommon(
          color: kWhite,
          text: "Details",
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            size: 28.sp,
            color: kRed,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextWidgetCommon(
              color: kRed,
              text: "Done",
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
        child: Column(
          children: [
            DetailsRowWidget(
              fieldName: "Name",
              fieldValue: songName,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Artist",
              fieldValue: artistName=='<unknown>'?"Unknown Artist":artistName,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Album",
              fieldValue: albumName,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Format",
              fieldValue: songFormat,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Size",
              fieldValue: songSize,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Path",
              fieldValue:
                  songPathIndevice,
            )
          ],
        ),
      ),
    );
  }
}


