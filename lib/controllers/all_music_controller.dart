import 'dart:developer';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';

class AllMusicController extends GetxController {
  AudioController audioController = Get.put(AudioController());

  Future<List<AllMusicsModel>> fetchAllAlbumMusicData() async {
    await getAlbumSongs();
    update();
    return audioController.getAllSongs();
  }

  Future<List<AllMusicsModel>> fetchAllArtistMusicData() async {
    await getArtistSongs();
    update();
    return audioController.getAllSongs();
  }

  // we need to check if the allsongs list not containing the song , then only add music to artist and artist songs
  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  final RxMap<String, List<AllMusicsModel>> artistMap =
      <String, List<AllMusicsModel>>{}.obs;
  final RxMap<String, List<AllMusicsModel>> albumsMap =
      <String, List<AllMusicsModel>>{}.obs;

  // getting artist with songs
  getArtistSongs() async {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    for (var music in allMusics) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.containsKey(artistName)) {
        artistMap[artistName] = [];
      }

      //   if (audioController.allSongsListFromDevice.contains(music)) {
      //   // Check if the song is not already in the artist map
      //   if (!artistMap[artistName]!.contains(music)) {
      //     artistMap[artistName]!.add(music);
      //   }
      // }

      // Check if the song is in allsongslistfromdevice before adding it
      if (!artistMap[artistName]!.contains(music) &&
          audioController.allSongsListFromDevice.contains(music)) {
        artistMap[artistName]!.add(music);
      }
    }
    update();
  }

  // getting album with songs
  getAlbumSongs() {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    for (var music in allMusics) {
      final albumName = capitalizeFirstLetter(music.musicAlbumName);
      if (!albumsMap.containsKey(albumName)) {
        albumsMap[albumName] = [];
      }

      if (!albumsMap[albumName]!.contains(music) &&
          audioController.allSongsListFromDevice.contains(music)) {
        albumsMap[albumName]!.add(music);
      }
    }
    update();
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
