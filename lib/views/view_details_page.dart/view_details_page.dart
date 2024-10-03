import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/view_details_page.dart/widgets/details_row_widget.dart';

class ViewDetailsPage extends StatelessWidget {
  const ViewDetailsPage({super.key,required this.currentSong,});

  final AllMusicsModel currentSong;

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
              fieldValue: currentSong.musicName,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Artist",
              fieldValue: currentSong.musicArtistName=='<unknown>'?"Unknown Artist":currentSong.musicArtistName,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Album",
              fieldValue: currentSong.musicAlbumName,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Format",
              fieldValue: currentSong.musicFormat,
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Size",
              fieldValue: AppUsingCommonFunctions.convertToMBorKB(currentSong.musicFileSize),
            ),
            kHeight20,
            DetailsRowWidget(
              fieldName: "Path",
              fieldValue:
                  currentSong.musicPathInDevice,
            )
          ],
        ),
      ),
    );
  }
}


