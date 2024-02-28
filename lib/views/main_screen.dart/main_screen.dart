import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/common_widgets/sort_radio_title_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/playlist/music_playlist_page.dart';
import 'package:music_player/views/search/search_page.dart';
import 'package:music_player/views/settings/settings_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AudioController audioController = Get.put(AudioController());
  FavoriteController favoriteController = Get.put(FavoriteController());
  AllMusicController allMusicController = Get.put(AllMusicController());
  bool isSongsLoaded = false;
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          isSongsLoaded = true;
        });
      },
    );
    audioController.requestPermissionAndFetchSongsAndInitializePlayer();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;

    TabController tabController = TabController(length: 4, vsync: this);
    SortMethod sortMethod = SortMethod.alphabetically;

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
            onTap: () {
              Get.to(
                () => SearchPage(
                  audioController: audioController,
                  favoriteController: favoriteController,
                ),
              );
            },
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
          PopupMenuButton(
            color: kTileColor,
            surfaceTintColor: kTransparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp)),
            icon: Icon(
              Icons.more_vert,
              color: kRed,
              size: 28.sp,
            ),
            onSelected: (value) {
              log("$value");
              switch (value) {
                case TopMenuItemEnum.manageSong:
                  break;
                case TopMenuItemEnum.sortSong:
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.sp)),
                        surfaceTintColor: kTransparent,
                        backgroundColor: kTileColor,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.sp),
                              border: Border.all(color: kMenuBtmSheetColor)),
                          height: kScreenHeight / 2.9,
                          padding: REdgeInsets.only(top: 30.sp),
                          child: Column(
                            children: [
                              TextWidgetCommon(
                                text: "Select Sort Method",
                                fontSize: 18.sp,
                                color: kWhite,
                                fontWeight: FontWeight.w500,
                              ),
                              kHeight20,
                              SortRadioTitleWidget(
                                onTap: () {},
                                text: "Display Alphabetically",
                                sortMethod: sortMethod,
                                value: SortMethod.alphabetically,
                                onChanged: (selectedSortMethod) {
                                  setState(() {
                                    sortMethod = selectedSortMethod!;
                                  });
                                },
                              ),
                              SortRadioTitleWidget(
                                onTap: () {},
                                text: "Display by Time Added",
                                sortMethod: sortMethod,
                                value: SortMethod.byTimeAdded,
                                onChanged: (selectedSortMethod) {
                                  setState(() {
                                    sortMethod = selectedSortMethod!;
                                  });
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp),),
                                  backgroundColor: kTileColor,
                                  side: BorderSide(
                                    color: kMenuBtmSheetColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: TextWidgetCommon(
                                  text: "Cancel",
                                  fontSize: 20.sp,
                                  color: kWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  break;
                case TopMenuItemEnum.settings:
                  Get.to(() => const SettingsPage());
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return [
                //allMusicController.albumsMap.value.isEmpty
                //allMusicController.artistMap.value.isEmpty
                PopupMenuItem(
                  value: TopMenuItemEnum.sortSong,
                  child: TextWidgetCommon(
                    text: "Select Sort Method",
                    fontSize: 14.sp,
                    color: kWhite,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                PopupMenuItem(
                  value: TopMenuItemEnum.manageSong,
                  child: TextWidgetCommon(
                    text: "Manage Songs",
                    fontSize: 14.sp,
                    color: kWhite,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                PopupMenuItem(
                  value: TopMenuItemEnum.settings,
                  child: TextWidgetCommon(
                    text: "Settings",
                    fontSize: 14.sp,
                    color: kWhite,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ];
            },
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
            allMusicController: allMusicController,
            favoriteController: favoriteController,
            audioController: audioController,
          ),
          MusicArtistPage(
            songModel: songModel,
            favoriteController: favoriteController,
          ),
          MusicAlbumPage(
            songModel: songModel,
            favoriteController: favoriteController,
          ),
          MusicPlaylistPage(
            songModel: songModel,
            favoriteController: favoriteController,
          ),
        ],
      ),
    );
  }
}


