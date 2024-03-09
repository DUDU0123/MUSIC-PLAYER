import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/details.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

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

    log("REBUILDING");
    //  final kScreenWidth = MediaQuery.of(context).size.width;
    //  final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ValueListenableBuilder<List<AllMusicsModel>>(
        valueListenable: AllFiles.files,
          //future: audioController.getAllSongs(),
          builder: (BuildContext context, List<AllMusicsModel> songs, Widget?_) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return  Center(
            //     child: CircularProgressIndicator(color: kRed,),
            //   );
            // } else if (snapshot.hasError) {
            //   return const DefaultCommonWidget(text: "Error on loading songs");
            // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return const DefaultCommonWidget(
            //     text: "No songs available",
            //   );
            // }
            return  ListView.builder(
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
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return MusicPlayPage(
                            allMusicController: widget.allMusicController,
                            favoriteController: widget.favoriteController,
                            musicUri: song.musicUri,
                            audioController: widget.audioController,
                            albumName: song.musicAlbumName,
                            artistName: song.musicArtistName,
                            songFormat: song.musicFormat,
                            songPathIndevice: song.musicPathInDevice,
                            songSize: AppUsingCommonFunctions.convertToMBorKB(
                                song.musicFileSize),
                            songTitle: song.musicName,
                            songId: song.id,
                            songModel: song,
                          );
                        },
                      );
                    },
                  );
                },
              );
            
          }),
    );
  }
}
