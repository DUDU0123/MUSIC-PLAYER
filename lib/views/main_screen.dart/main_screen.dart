import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/playlist/music_playlist_page.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AudioController audioController = Get.put(AudioController());
  FavoriteController favoriteController = Get.put(FavoriteController());
  bool isSongsLoaded = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isSongsLoaded = true;
      });
    },);
    audioController.requestPermissionAndFetchSongsAndInitializePlayer();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    //final kScreenWidth = MediaQuery.of(context).size.width;
    //final kScreenHeight = MediaQuery.of(context).size.height;

    TabController tabController = TabController(length: 4, vsync: this);

    if (!isSongsLoaded) {
      return Center(
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
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: 22.h,
              child: Image.asset(
                "assets/search_icon.png",
                color: kRed,
                // scale: 18.h,
              ),
            ),
          ),
          kWidth10,
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: kRed,
              size: 30,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 15.w),
            child: TabBar(
              labelPadding: const EdgeInsets.all(0),
              isScrollable: false,
              unselectedLabelStyle: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: kRed,
                fontSize: 16.sp,
              ),
              dividerColor: kTransparent,
              indicatorColor: kRed,
              controller: tabController,
              tabs: const [
                Tab(
                  text: "Songs",
                ),
                Tab(
                  text: "Artists",
                ),
                Tab(
                  text: "Albums",
                ),
                Tab(
                  text: "Playlists",
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          MusicHomePage(
            favoriteController: favoriteController,
            audioController: audioController,
          ),
           MusicArtistPage(
            favoriteController: favoriteController,
          ),
           MusicAlbumPage(
            favoriteController: favoriteController,
           ),
          MusicPlaylistPage(
            favoriteController: favoriteController,
          ),
        ],
      ),
    );
  }
}
