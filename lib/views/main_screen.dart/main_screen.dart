import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/current_playlist/current_playlist.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/music_view/music_view_page.dart';
import 'package:music_player/views/playlist/music_playlist_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    TabController tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              "assets/search_icon.png",
              color: kRed,
              scale: 18.h,
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
          MusicHomePage(),
          MusicArtistPage(),
          MusicAlbumPage(),
          MusicPlaylistPage(),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return const MusicViewPage(
                songName: "Nothing",
                artistName: 'Unknown artist',
                albumName: 'Unknown album',
                songFormat: 'mp3',
                songSize: '4.0MB',
                songPathIndevice: 'Phone/Vidmate/download/Vaaranam_Aayiram_-_Oh_Shanti_Shanti_Video_|_Suriya_|_Harris_Jayaraj(128k)',
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          height: kScreenHeight / 10,
          decoration: BoxDecoration(
            color: kMusicBottomBarColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.w),
              topRight: Radius.circular(18.w),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: kMusicNoteContainerColor,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.music_note,
                        color: kGrey,
                      ),
                    ),
                  ),
                  kWidth15,
                  SizedBox(
                    width: kScreenWidth / 2.5,
                    child: TextWidgetCommon(
                      overflow: TextOverflow.ellipsis,
                      text: "Vaaranam Aayiram_Oh_Shanti",
                      fontSize: 15.sp,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: kWhite,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CurrentPlayListPage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.list,
                      color: kWhite,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
