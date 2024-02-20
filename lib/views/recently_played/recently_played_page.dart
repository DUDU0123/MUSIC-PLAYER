import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
import 'package:music_player/views/common_widgets/default_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class RecentlyPlayedPage extends StatefulWidget {
  RecentlyPlayedPage({
    super.key,
    required this.audioPlayer,
    this.isPlaying,
    required this.musicBox,
  });

  final bool? isPlaying;
  final AudioPlayer audioPlayer;
  final Box<AllMusicsModel> musicBox;
  @override
  State<RecentlyPlayedPage> createState() => _RecentlyPlayedPageState();
}

class _RecentlyPlayedPageState extends State<RecentlyPlayedPage> {
  late Box<RecentlyPlayedModel> recentlyPlayedBox;
  late List<RecentlyPlayedModel> recentlyPlayedSongList;

  @override
  void initState() {
    super.initState();
    recentlyPlayedBox = Hive.box<RecentlyPlayedModel>('recent');
    recentlyPlayedSongList = recentlyPlayedBox.values.toList();
    if (recentlyPlayedBox.isEmpty) {
      // If the box is empty, initialize it with a default RecentlyPlayedModel
      recentlyPlayedBox.put(
          'recent', RecentlyPlayedModel(recentlyPlayedSongsList: []));
    }
    // Listen to changes in the recently played list
    recentlyPlayedBox.watch().listen((event) {
      setState(() {
        recentlyPlayedSongList = recentlyPlayedBox.values.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          appBarText: "Recently Played",
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [
            TextButton(
              onPressed: () {
                // clear the list only
                // don't delete
                recentlyPlayedBox.put(
                    'recent', RecentlyPlayedModel(recentlyPlayedSongsList: []));
              },
              child: TextWidgetCommon(
                text: "Clear",
                color: kRed,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
      body: recentlyPlayedSongList.isEmpty
          ? DefaultWidget()
          : ListView.builder(
              itemCount: recentlyPlayedSongList.length,
              itemBuilder: (BuildContext context, int index) {
                RecentlyPlayedModel recentlyPlayedModel =
                    recentlyPlayedSongList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (AllMusicsModel music
                        in recentlyPlayedModel.recentlyPlayedSongsList)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: MusicTileWidget(
                          audioPlayer: widget.audioPlayer,
                          musicBox: widget.musicBox,
                          isPlaying: widget.isPlaying,
                          albumName: music.musicAlbumName,
                          artistName: music.musicArtistName,
                          songTitle: music.musicName,
                          songFormat: music.musicFormat,
                          songSize: music.musicFileSize.toString(),
                          songPathIndevice: music.musicPathInDevice,
                          pageType: PageTypeEnum.recentlyPlayedPage,
                          songId: music.id,
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
