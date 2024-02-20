import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class CurrentPlayListPage extends StatelessWidget {
  const CurrentPlayListPage(
      {super.key,
      required this.songName,
      required this.artistName,
      required this.albumName,
      required this.songFormat,
      required this.songSize,
      required this.songPathIndevice,
      required this.isPlaying,
      required this.songId,
      required this.indexfromhome,
      this.audioSource,
      required this.songModel,
      required this.audioPlayer,
      this.currentPlayingSongIndex,
      required this.musicBox,
      required this.playSong});
  final String songName;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;

  final int songId;
  final int indexfromhome;
  final AllMusicsModel songModel;
  final bool isPlaying;
  final ConcatenatingAudioSource? audioSource;
  final AudioPlayer audioPlayer;
  final int? currentPlayingSongIndex;
  final Box<AllMusicsModel> musicBox;
  final void Function({String? url, int? index, bool? isRecentlyPlayed})
      playSong;

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: "Current Playlist",
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: TextWidgetCommon(
                text: "Done",
                color: kRed,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemBuilder: (context, index) {
          return MusicTileWidget(
            audioPlayer: audioPlayer,
            index: indexfromhome,
            musicBox: musicBox,
            songModel: songModel,
            audioSource: audioSource,
            currentPlayingSongIndex: currentPlayingSongIndex,
            playSong: playSong,
            songId: songId,
            isPlaying: isPlaying,
            albumName: albumName,
            artistName: artistName,
            songTitle: songName,
            pageType: PageTypeEnum.currentPlayListPage,
            songFormat: songFormat,
            songPathIndevice: songPathIndevice,
            songSize: "${songSize}MB",
          );
        },
      ),
    );
  }
}
