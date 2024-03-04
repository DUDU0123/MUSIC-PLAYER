import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

class FloatingButtonOnBottom extends StatelessWidget {
  const FloatingButtonOnBottom({
    super.key,
    required this.currentSong,
    required this.audioController,
    required this.favoriteController, required this.allMusicController,
  });

  final AllMusicsModel currentSong;
  final AudioController audioController;
  final AllMusicController allMusicController;
  final FavoriteController favoriteController;

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
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return MusicPlayPage(
              allMusicController: allMusicController,
              songModel: currentSong,
              songId: currentSong.id,
              songTitle: currentSong.musicName,
              artistName: currentSong.musicArtistName,
              albumName: currentSong.musicAlbumName,
              songFormat: currentSong.musicFormat,
              songSize: AppUsingCommonFunctions.convertToMBorKB(
                  currentSong.musicFileSize),
              songPathIndevice: currentSong.musicPathInDevice,
              audioController: audioController,
              musicUri: currentSong.musicUri,
              favoriteController: favoriteController,
            );
          },
        );
      },
    );
  }
}