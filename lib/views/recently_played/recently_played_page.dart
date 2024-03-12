import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_play_page_open.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class RecentlyPlayedPage extends StatefulWidget {
  const RecentlyPlayedPage({
    super.key,
    required this.favoriteController,
    required this.songModel,
    required this.allMusicController,
  });
  final FavoriteController favoriteController;
  final AllMusicController allMusicController;
  final AllMusicsModel songModel;
  @override
  State<RecentlyPlayedPage> createState() => _RecentlyPlayedPageState();
}

class _RecentlyPlayedPageState extends State<RecentlyPlayedPage> {
  AudioController audioController = Get.put(AudioController());

  @override
  void initState() {
    super.initState();
    audioController.initializeRecentlyPlayedSongs();
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
            GetBuilder<AudioController>(builder: (controller) {
              return TextButton(
                onPressed: () {
                  // clear the list only
                  controller.clearRecentlyPlayedSongs();
                },
                child: TextWidgetCommon(
                  text: "Clear",
                  color: kRed,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              );
            }),
          ],
        ),
      ),
      body: audioController.recentlyPlayedSongList.isEmpty
          ? const DefaultCommonWidget(
              text: "No songs available",
            )
          : Obx(() {
              return ListView.builder(
                itemCount: audioController.recentlyPlayedSongList.length,
                itemBuilder: (BuildContext context, int index) {
                  RecentlyPlayedModel recentlyPlayedModel =
                      audioController.recentlyPlayedSongList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (AllMusicsModel music
                          in recentlyPlayedModel.recentlyPlayedSongsList)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: MusicTileWidget(
                            onTap: () {
                              audioController.isPlaying.value = true;
                              audioController.playSong(music);
                              musicPlayPageOpenPage(
                                context: context,
                                song: music,
                                allMusicController: widget.allMusicController,
                                favoriteController: widget.favoriteController,
                                audioController: audioController,
                              );
                            },
                            audioController: audioController,
                            songModel: music,
                            favoriteController: widget.favoriteController,
                            musicUri: music.musicUri,
                            albumName: music.musicAlbumName,
                            artistName: music.musicArtistName,
                            songTitle: music.musicName,
                            songFormat: music.musicFormat,
                            songSize: AppUsingCommonFunctions.convertToMBorKB(
                                music.musicFileSize),
                            songPathIndevice: music.musicPathInDevice,
                            pageType: PageTypeEnum.recentlyPlayedPage,
                            songId: music.id,
                          ),
                        ),
                    ],
                  );
                },
              );
            }),
    );
  }
}
