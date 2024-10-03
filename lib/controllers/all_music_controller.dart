import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';

class AllMusicController extends GetxController {
  static AllMusicController get to => Get.find();
  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  final ValueNotifier<Map<String, List<AllMusicsModel>>> artistMap =
      ValueNotifier({});
  final ValueNotifier<Map<String, List<AllMusicsModel>>> albumsMap =
      ValueNotifier({});

  Future<List<AllMusicsModel>> fetchAllAlbumMusicData() async {
    await getAlbumSongs();
    return AudioController.to.getAllSongs();
  }

  Future<List<AllMusicsModel>> fetchAllArtistMusicData() async {
    await getArtistSongs();
    return AudioController.to.getAllSongs();
  }

  // getting artist with songs
  getArtistSongs() async {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    for (var music in allMusics) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.value.containsKey(artistName)) {
        artistMap.value[artistName] = [];
      }

      // Check if the song is in AllFiles.files.value before adding it
      if (!artistMap.value[artistName]!.contains(music) &&
          AllFiles.files.value.contains(music)) {
        artistMap.value[artistName]!.add(music);
      }
    }
  }

  // getting album with songs
  getAlbumSongs() {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    for (var music in allMusics) {
      final albumName = capitalizeFirstLetter(music.musicAlbumName);
      if (!albumsMap.value.containsKey(albumName)) {
        albumsMap.value[albumName] = [];
      }

      if (!albumsMap.value[albumName]!.contains(music) &&
          AllFiles.files.value.contains(music)) {
        albumsMap.value[albumName]!.add(music);
      }
    }
  }


  // working
  List<AllMusicsModel> getSongsOfArtist(
      List<AllMusicsModel> songs, String targetArtist) {
    List<AllMusicsModel> artistSongs = [];
    for (var song in songs) {
      final artistName = capitalizeFirstLetter(song.musicArtistName);
      if (artistName == capitalizeFirstLetter(targetArtist)) {
        artistSongs.add(song);
      }
    }
    // Remove the artist from artistMap if there are no songs
    if (artistSongs.isEmpty) {
      final targetArtistKey = capitalizeFirstLetter(targetArtist);
      if (artistMap.value.containsKey(targetArtistKey)) {
        artistMap.value.remove(targetArtistKey);
      }
    }
    return artistSongs;
  }

  List<AllMusicsModel> getSongsOfAlbum(
      List<AllMusicsModel> songs, String targetAlbum) {
    List<AllMusicsModel> albumSongs = [];

    for (var song in songs) {
      final albumName = capitalizeFirstLetter(song.musicAlbumName);
      if (albumName == capitalizeFirstLetter(targetAlbum)) {
        albumSongs.add(song);
      }
    }

    // Remove the album from albumsMap if there are no songs
    if (albumSongs.isEmpty) {
      final targetAlbumKey = capitalizeFirstLetter(targetAlbum);
      if (albumsMap.value.containsKey(targetAlbumKey)) {
        albumsMap.value.remove(targetAlbumKey);
      }
    }

    return albumSongs;
  }



  Future<void> saveLyrics({required AllMusicsModel song}) async {
    log("Song id: ${song.id}");
    log("Song name: ${song.musicName}");
    log("Song lyrics: ${song.musicLyrics}");
    await musicBox.put(song.id, song);
    update();
    Get.snackbar(
      "Lyrics Saved",
      "Lyrics saved successfully",
      colorText: kWhite,
      backgroundColor: kTileColor,
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String getLyricsForSong(int songId) {
    final AllMusicsModel? songModel = musicBox.get(songId);
    return songModel?.musicLyrics ?? '';
  }
}
