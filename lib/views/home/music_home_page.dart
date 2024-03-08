import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

class MusicHomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {

    int unixTimestamp = 1709518353;
  
  // Convert Unix timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
  
  log("Unix Timestamp: $unixTimestamp");
  log("Formatted Date: ${dateTime.toLocal()}");

    log("REBUILDING");
    //  final kScreenWidth = MediaQuery.of(context).size.width;
    //  final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<List<AllMusicsModel>>(
          future: audioController.getAllSongs(),
          builder: (BuildContext context,
              AsyncSnapshot<List<AllMusicsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: CircularProgressIndicator(color: kRed,),
              );
            } else if (snapshot.hasError) {
              return const DefaultCommonWidget(text: "Error on loading songs");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const DefaultCommonWidget(
                text: "No songs available",
              );
            }
            return Obx(() {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                itemBuilder: (context, index) {
                  AllMusicsModel song = snapshot.data![index];
                  return MusicTileWidget(
                    audioController: audioController,
                    favoriteController: favoriteController,
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
                      audioController.isPlaying.value = true;
                      audioController.playSong(song);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return MusicPlayPage(
                            allMusicController: allMusicController,
                            favoriteController: favoriteController,
                            musicUri: song.musicUri,
                            audioController: audioController,
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
            });
          }),
    );
  }
}
