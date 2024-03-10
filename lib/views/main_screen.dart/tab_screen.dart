import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/details.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/controllers/tab_handle_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/main_screen.dart/tab_widgets/build_tab_menu.dart';
import 'package:music_player/views/main_screen.dart/tab_widgets/build_tab_widget.dart';
import 'package:music_player/views/main_screen.dart/tab_widgets/floating_button_on_bottom.dart';
import 'package:music_player/views/main_screen.dart/tab_widgets/sort_dialog_box.dart';
import 'package:music_player/views/main_screen.dart/tab_widgets/tab_views.dart';
import 'package:music_player/views/search/search_page.dart';
import 'package:music_player/views/settings/settings_page.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({
    super.key,
    required this.audioController,
    required this.favoriteController,
    required this.allMusicController,
    required this.playlistController,
    required this.tabHandleController,
    required this.sortMethod,
    required this.pageController,
    required this.pageTypeEnum,
  });
  final AudioController audioController;
  final FavoriteController favoriteController;
  final AllMusicController allMusicController;
  final PlaylistController playlistController;
  final TabHandleController tabHandleController;
  final SortMethod sortMethod;
  final PageController pageController;
  final PageTypeEnum pageTypeEnum;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  void refreshUI() {
    setState(() {});
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
    bool currentSongNotNull =
        widget.audioController.currentPlayingSong.value != null;
    AllMusicsModel currentSong = currentSongNotNull
        ? widget.audioController.currentPlayingSong.value!
        : songModel;
    // final kScreenWidth = MediaQuery.of(context).size.width;
    //final kScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => SearchPage(
                      audioController: widget.audioController,
                      favoriteController: widget.favoriteController,
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
                  switch (value) {
                    case TopMenuItemEnum.manageSong:
                      Get.to(() => SongEditPage(
                        allMusicController: widget.allMusicController,
                            playlistController: widget.playlistController,
                            audioController: widget.audioController,
                            favoriteController: widget.favoriteController,
                            pageType: PageTypeEnum.homePage,
                            songList: AllFiles.files.value,
                            song: currentSong,
                          ));
                      break;
                    case TopMenuItemEnum.settings:
                      Get.to(() => const SettingsPage());
                      break;
                    default:
                  }
                },
                itemBuilder: (context) {
                  // three dot menu options list
                  return BuildTabMenu.listPopUpMenuItem(
                    audioController: widget.audioController,
                    favoriteController: widget.favoriteController,
                    currentSong: currentSong,
                    pageTypeEnum: widget.pageTypeEnum,
                    currentTabType:
                        widget.tabHandleController.currentTabType.value,
                  );
                },
              ),
            ],
            backgroundColor: kTransparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Stack(
                children: [
                  Obx(() {
                    return Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BuildTabWidget(
                            tabType: TabType.songs,
                            text: "Songs",
                            currentTabType:
                                widget.tabHandleController.currentTabType.value,
                            pageController: widget.pageController,
                          ),
                          BuildTabWidget(
                            tabType: TabType.artist,
                            text: "Artists",
                            currentTabType:
                                widget.tabHandleController.currentTabType.value,
                            pageController: widget.pageController,
                          ),
                          BuildTabWidget(
                            tabType: TabType.album,
                            text: "Albums",
                            currentTabType:
                                widget.tabHandleController.currentTabType.value,
                            pageController: widget.pageController,
                          ),
                          BuildTabWidget(
                            tabType: TabType.playlist,
                            text: "Playlist",
                            currentTabType:
                                widget.tabHandleController.currentTabType.value,
                            pageController: widget.pageController,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          body: GetBuilder<TabHandleController>(
              init: widget.tabHandleController,
              builder: (controller) {
                return PageView(
                  controller: widget.pageController,
                  onPageChanged: (index) {
                    controller.currentTabType.value = TabType.values[index];
                  },
                  children: TabViewList.tabViews(
                    playlistController: widget.playlistController,
                    allMusicController: widget.allMusicController,
                    favoriteController: widget.favoriteController,
                    audioController: widget.audioController,
                    // here no currentsong, need to take
                    currentSong: currentSong,
                  ),
                );
              }),
          floatingActionButton:
              // AllFiles.files.value.isNotEmpty
              //     ?
              FloatingButtonOnBottom(
            allMusicController: widget.allMusicController,
            currentSong: currentSong,
            audioController: widget.audioController,
            favoriteController: widget.favoriteController,
          )
          // : const SizedBox(),
          ),
    );
  }
}
