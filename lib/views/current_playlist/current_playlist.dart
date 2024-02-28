import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';

class CurrentPlayListPage extends StatelessWidget {
  const CurrentPlayListPage({
    super.key,
    required this.songId,
    required this.songModel,
    // required this.currentPlayingsongs,
  });
  // final String songName;
  // final String artistName;
  // final String albumName;
  // final String songFormat;
  // final String songSize;
  // final String songPathIndevice;

  final int songId;
  final AllMusicsModel songModel;
  //final List<AllMusicsModel> currentPlayingsongs;

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
      // body: ListView.builder(
      //   padding: EdgeInsets.symmetric(horizontal: 10.w),
      //   itemBuilder: (context, index) {
      //     return MusicTileWidget(
      //       musicUri: ,
      //       // audioPlayer: audioPlayer,
      //       // index: indexfromhome,
      //       // musicBox: musicBox,
      //       songModel: songModel,
      //       // audioSource: audioSource,
      //       // currentPlayingSongIndex: currentPlayingSongIndex,
      //       // playSong: playSong,
      //       songId: songId,
      //     //  isPlaying: isPlaying,
      //       albumName: albumName,
      //       artistName: artistName,
      //       songTitle: songName,
      //       pageType: PageTypeEnum.currentPlayListPage,
      //       songFormat: songFormat,
      //       songPathIndevice: songPathIndevice,
      //       songSize: "${songSize}MB",
      //     );
      //   },
      // ),


      // FutureBuilder(
      //   future: audioController.getAllSongs(),
      //   builder: (context, snapshot) {
      //     return ListView.builder(
      //       itemCount: snapshot.data!.length,
      //       itemBuilder: (context, index) {
      //         var song = snapshot.data![index];
      //         return MusicTileWidget(
      //           songTitle: song.musicName,
      //           songFormat: song.musicFormat,
      //           songSize: song.musicFileSize.toString(),
      //           songPathIndevice: song.musicPathInDevice,
      //           pageType: PageTypeEnum.currentPlayListPage,
      //           songId: songId,
      //           songModel: songModel,
      //           musicUri: song.musicUri,
      //           favoriteController: favoriteController,
      //         );
      //       },
      //     );
      //   }
      // ),
    );
  }
}
