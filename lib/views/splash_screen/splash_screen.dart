import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/controllers/tab_handle_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/main_screen.dart/tab_screen.dart';

import '../../controllers/all_music_controller.dart';

class MusicBoxSplashScreen extends StatefulWidget {
  const MusicBoxSplashScreen({super.key});

  @override
  State<MusicBoxSplashScreen> createState() => _MusicBoxSplashScreenState();
}

class _MusicBoxSplashScreenState extends State<MusicBoxSplashScreen> {
  AudioController audioController = Get.put(AudioController());
  FavoriteController favoriteController = Get.put(FavoriteController());
  AllMusicController allMusicController = Get.put(AllMusicController());
  TabHandleController tabHandleController = Get.put(TabHandleController());
  PlaylistController playlistController = Get.put(PlaylistController());
  SortMethod sortMethod = SortMethod.alphabetically;
  TextEditingController controller = TextEditingController();
  PageController pageController = PageController();
  PageTypeEnum pageTypeEnum = PageTypeEnum.homePage;

  AllMusicsModel songModel = AllMusicsModel(
    id: 0,
    musicName: "musicName",
    musicAlbumName: "musicAlbumName",
    musicArtistName: "musicArtistName",
    musicPathInDevice: "musicPathInDevice",
    musicFormat: "musicFormat",
    musicUri: "musicUri",
    musicFileSize: 0,
  );
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TabScreen(
                
                audioController: audioController,
                favoriteController: favoriteController,
                allMusicController: allMusicController,
                playlistController: playlistController,
                tabHandleController: tabHandleController,
                sortMethod: sortMethod,
                pageController: pageController,
                pageTypeEnum: pageTypeEnum,
              ),
            ),
            (route) => false);
      },
    );
    audioController.requestPermissionAndFetchSongsAndInitializePlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage(
                  "assets/music_player_logo.png",
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(20.sp),
          ),
        ),
      ),
    );
  }
}
