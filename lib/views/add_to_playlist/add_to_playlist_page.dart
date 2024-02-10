import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class AddToPlaylistPage extends StatelessWidget {
  const AddToPlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: kRed,
              size: 28.sp,
            )),
        automaticallyImplyLeading: false,
        title: TextWidgetCommon(
          text: "Add to Playlist",
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: kWhite,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextWidgetCommon(
              text: "Cancel",
              fontSize: 15.sp,
              color: kRed,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 10+2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              onTap: () {},
              title: TextWidgetCommon(
                text: "Favorites",
                fontSize: 16.sp,
                color: kWhite,
              ),
            );
          } else if (index == 1) {
            return ListTile(
              onTap: () {},
              title: TextWidgetCommon(
                text: "New Playlist",
                fontSize: 16.sp,
                color: kWhite,
              ),
            );
          }
          return ListTile(
            onTap: () {},
            title: TextWidgetCommon(
              text: "Playlist ${index-1}",
              fontSize: 16.sp,
              color: kWhite,
            ),
          );
        },
      ),
    );
  }
}
