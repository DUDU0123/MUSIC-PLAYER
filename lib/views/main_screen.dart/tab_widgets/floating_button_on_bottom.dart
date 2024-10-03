import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

class FloatingButtonOnBottom extends StatelessWidget {
  const FloatingButtonOnBottom({
    super.key,
    required this.currentSong,
  });

  final AllMusicsModel currentSong;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kRed,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.sp)),
      child: Icon(
        Icons.play_arrow,
        color: kTileColor,
        size: 30.sp,
      ),
      onPressed: () {
       AllFiles.files.value.isNotEmpty? showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return MusicPlayPage(
              songModel: currentSong,
            );
          },
        ):null;
      },
    );
  }
}