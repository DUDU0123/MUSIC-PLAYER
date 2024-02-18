import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/playlist/music_playlist_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentPlayingSongIndex;
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  Future<List<SongModel>> requestPermission() async {
    try {
      var perm = await Permission.storage.request();
      if (perm.isGranted) {
        return audioQuery.querySongs(
          sortType: null,
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
        );
      } else {
        var reRequest = await Permission.storage.request();
        if (reRequest.isGranted) {
          return audioQuery.querySongs(
            sortType: null,
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
          );
        } else {
          print("Permission not granted.");
          return [];
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return audioQuery.querySongs(
      sortType: null,
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
  }

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
            
            requestPermission: requestPermission,
            audioQuery: audioQuery,
            audioPlayer: audioPlayer,
            isPlaying: isPlaying,
            //playSong: playSong,
          ),
          MusicArtistPage(),
          MusicAlbumPage(),
          MusicPlaylistPage(isPlaying: isPlaying),
        ],
      ),
    );
  }
}
