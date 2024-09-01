import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/utils/allsongslist.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/music_play_page_open.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({
    super.key,
    required this.audioController,
    required this.favoriteController,
    required this.allMusicController,
  });

  final AudioController audioController;
  final FavoriteController favoriteController;
  final AllMusicController allMusicController;

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<AllMusicsModel>>(
          valueListenable: AllFiles.files,
          builder:
              (BuildContext context, List<AllMusicsModel> songs, Widget? _) {
            return ListView.builder(
              itemCount: songs.length,
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              itemBuilder: (context, index) {
                AllMusicsModel song = songs[index];
                return MusicTileWidget(
                  audioController: widget.audioController,
                  favoriteController: widget.favoriteController,
                  musicUri: song.musicUri,
                  songId: song.id,
                  songModel: song,
                  pageType: PageTypeEnum.homePage,
                  albumName: song.musicAlbumName,
                  artistName: song.musicArtistName,
                  songTitle: song.musicName,
                  songFormat: song.musicFormat,
                  songPathIndevice: song.musicPathInDevice,
                  songSize: AppUsingCommonFunctions.convertToMBorKB(
                      song.musicFileSize),
                  onTap: () async {
                    widget.audioController.isPlaying.value = true;
                    widget.audioController.playSong(song);
                    musicPlayPageOpenPage(
                      context: context,
                      song: song,
                      allMusicController: widget.allMusicController,
                      favoriteController: widget.favoriteController,
                      audioController: widget.audioController,
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
