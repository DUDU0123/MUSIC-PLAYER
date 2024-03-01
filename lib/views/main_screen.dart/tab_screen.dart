import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/common_widgets/sort_radio_title_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/main_screen.dart/tab_widgets/build_tab_menu.dart';
import 'package:music_player/views/music_view/music_play_page.dart';
import 'package:music_player/views/playlist/music_playlist_page.dart';
import 'package:music_player/views/search/search_page.dart';
import 'package:music_player/views/settings/settings_page.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class TabScreen extends StatefulWidget {
  TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  AudioController audioController = Get.put(AudioController());
  FavoriteController favoriteController = Get.put(FavoriteController());
  AllMusicController allMusicController = Get.put(AllMusicController());

  SortMethod sortMethod = SortMethod.alphabetically;
  TabType currentTabType = TabType.songs;
  TextEditingController controller = TextEditingController();
  PageController _pageController = PageController();
  PageTypeEnum pageTypeEnum = PageTypeEnum.homePage;
  bool isSongsLoaded = false;

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
        setState(() {
          isSongsLoaded = true;
        });
      },
    );
    audioController.requestPermissionAndFetchSongsAndInitializePlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool currentSongNotNull = audioController.currentPlayingSong.value != null;
    AllMusicsModel currentSong = currentSongNotNull
        ? audioController.currentPlayingSong.value!
        : songModel;
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
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
    return SafeArea(
      child: Scaffold(
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
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.sp),
                                  border:
                                      Border.all(color: kMenuBtmSheetColor)),
                              height: kScreenHeight / 2.8,
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
                                    onTap: () {
                                      audioController.updateSortMethod(
                                          SortMethod.alphabetically);
                                      Get.back();
                                    },
                                    text: "Display Alphabetically",
                                    sortMethod:
                                        audioController.currentSortMethod.value,
                                    value: SortMethod.alphabetically,
                                    onChanged: (selectedSortMethod) {
                                      setState(() {
                                        audioController.currentSortMethod
                                            .value = selectedSortMethod!;
                                      });
                                    },
                                  ),
                                  SortRadioTitleWidget(
                                    onTap: () {
                                      audioController.updateSortMethod(
                                          SortMethod.byTimeAdded);
                                      Get.back();
                                    },
                                    text: "Display by Time Added",
                                    sortMethod:
                                        audioController.currentSortMethod.value,
                                    value: SortMethod.byTimeAdded,
                                    onChanged: (selectedSortMethod) {
                                      setState(() {
                                        audioController.currentSortMethod
                                            .value = selectedSortMethod!;
                                      });
                                    },
                                  ),
                                  kHeight10,
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                      ),
                                      backgroundColor: kTileColor,
                                      side: BorderSide(
                                        color: kMenuBtmSheetColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: TextWidgetCommon(
                                      text: "Done",
                                      fontSize: 20.sp,
                                      color: kWhite,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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
                // BuildTabMenu.listPopUpMenuItem(
                //   audioController: audioController,
                //   favoriteController: favoriteController,
                //   currentSong: currentSong,
                //   pageTypeEnum: pageTypeEnum,
                //   currentTabType: currentTabType,
                // );
                final showAllOptions =
                    AppUsingCommonFunctions.shouldShowAllOptions(
                        pageTypeEnum, currentTabType);
                if (showAllOptions &&
                    audioController.allSongsListFromDevice.isNotEmpty) {
                  return [
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
                      onTap: () {
                        Get.to(() => SongEditPage(
                              audioController: audioController,
                              favoriteController: favoriteController,
                              pageType: PageTypeEnum.homePage,
                              songList: audioController.allSongsListFromDevice,
                              song: currentSong,
                            ));
                      },
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
                } else {
                  return [
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
                }
              },
            ),
          ],
          backgroundColor: kTransparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTab(TabType.songs, "Songs", currentTabType),
                      buildTab(TabType.artist, "Artists", currentTabType),
                      buildTab(TabType.album, "Albums", currentTabType),
                      buildTab(TabType.playlist, "Playlist", currentTabType),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentTabType = TabType.values[index];
            });
          },
          children: [
            MusicHomePage(
              allMusicController: allMusicController,
              favoriteController: favoriteController,
              audioController: audioController,
            ),
            MusicArtistPage(
              audioController: audioController,
              songModel: currentSong,
              favoriteController: favoriteController,
            ),
            MusicAlbumPage(
              audioController: audioController,
              songModel: currentSong,
              favoriteController: favoriteController,
            ),
            MusicPlaylistPage(
              audioController: audioController,
              songModel: currentSong,
              favoriteController: favoriteController,
            ),
          ],
        ),

        // buildBody(),
        floatingActionButton: audioController.allSongsListFromDevice.isNotEmpty
            ? FloatingActionButton(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200.sp)),
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
              )
            : const SizedBox(),
      ),
    );
  }

  Widget buildTab(TabType tabType, String text, TabType currentTabType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTabType = tabType;
          _pageController.animateToPage(
            tabType.index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          border: Border(
            bottom: BorderSide(
              color:
                  currentTabType == tabType ? kTileColor : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: currentTabType == tabType ? kRed : Colors.white,
          ),
        ),
      ),
    );
  }
}
