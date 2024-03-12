import 'package:flutter/material.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

Future<dynamic> musicPlayPageOpenPage({
  required BuildContext context,
  required AllMusicsModel song,
  required AllMusicController allMusicController,
  required FavoriteController favoriteController,
  required AudioController audioController,
}) {
  return showModalBottomSheet(
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
        songSize: AppUsingCommonFunctions.convertToMBorKB(song.musicFileSize),
        songTitle: song.musicName,
        songId: song.id,
        songModel: song,
      );
    },
  );
}
