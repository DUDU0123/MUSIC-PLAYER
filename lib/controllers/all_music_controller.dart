import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/details.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';

class AllMusicController extends GetxController {
  AudioController audioController = Get.put(AudioController());
  // we need to check if the allsongs list not containing the song , then only add music to artist and artist songs
  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  final ValueNotifier<Map<String, List<AllMusicsModel>>> artistMap =
      ValueNotifier({});
  final ValueNotifier<Map<String, List<AllMusicsModel>>> albumsMap =
      ValueNotifier({});

  Future<List<AllMusicsModel>> fetchAllAlbumMusicData() async {
    await getAlbumSongs();
    return audioController.getAllSongs();
  }

  Future<List<AllMusicsModel>> fetchAllArtistMusicData() async {
    await getArtistSongs();
    return audioController.getAllSongs();
  }


  // getting artist with songs
  getArtistSongs() async {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    for (var music in allMusics) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.value.containsKey(artistName)) {
        artistMap.value[artistName] = [];
      }

      // Check if the song is in allsongslistfromdevice before adding it
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
 
  String getArtistName(List<AllMusicsModel> songs){
    String artistName = '';
    for (var song in songs) {
      artistName = capitalizeFirstLetter(song.musicArtistName);
    }
    return artistName;
  }


  List<String> getUniqueArtists(List<AllMusicsModel> songs) {
  Set<String> uniqueArtists = <String>{};
  for (var song in songs) {
    final artistName = capitalizeFirstLetter(song.musicArtistName);
    uniqueArtists.add(artistName);
  }
  return uniqueArtists.toList();
}

// working
  List<AllMusicsModel> getSongsOfArtist(List<AllMusicsModel> songs, String targetArtist) {
    List<AllMusicsModel> artistSongs = [];
    for (var song in songs) {
      final artistName = capitalizeFirstLetter(song.musicArtistName);
      if (artistName == capitalizeFirstLetter(targetArtist)) {
        artistSongs.add(song);
      }
    }
    return artistSongs;
  }

  List<AllMusicsModel> getSongsOfAlbum(List<AllMusicsModel> songs, String targetAlbum) {
    List<AllMusicsModel> albumSongs = [];
    for (var song in songs) {
      final albumName = capitalizeFirstLetter(song.musicAlbumName);
      if (albumName == capitalizeFirstLetter(targetAlbum)) {
        albumSongs.add(song);
      }
    }
    return albumSongs;
  }

  

  Future<void> saveLyrics(int songId, String lyrics) async {
    // Load the Hive box
    final box = await Hive.openBox<AllMusicsModel>('musics');
    final AllMusicsModel? songModel = box.get(songId);
    songModel?.musicLyrics = lyrics;
    log(name: "SAVING LYRICS ", "${songModel?.musicLyrics}");
    log(name: 'SAVING SONG ID', "$songId");
    await box.put(
      songId,
      songModel ??
          AllMusicsModel(
            id: 0,
            musicName: "musicName",
            musicAlbumName: "musicAlbumName",
            musicArtistName: "musicArtistName",
            musicPathInDevice: "musicPathInDevice",
            musicFormat: "musicFormat",
            musicUri: "musicUri",
            musicFileSize: 0,
          ),
    );
    log(name: "SAVED LYRICS ", "${songModel?.musicLyrics}");
    update();
    Get.snackbar(
      "Lyrics Saved",
      "Lyrics saved successfully",
      colorText: kWhite,
      backgroundColor: kBlack,
    );
  }

  String getLyricsForSong(int songId) {
    log(name: 'GETTING SONG ID', "$songId");
    final box = Hive.box<AllMusicsModel>('musics');
    final AllMusicsModel? songModel = box.get(songId);
    log(name: "GET SAVING LYRICS", "${songModel?.musicLyrics}");
    log(name: "GET SAVING SONG NAME", "${songModel?.musicName}");
    return songModel?.musicLyrics ?? '';
  }
}
