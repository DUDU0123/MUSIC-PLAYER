import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';

class AllMusicController extends GetxController {
  AudioController audioController = Get.put(AudioController());
  @override
  void onInit() {
    getAlbumSongs();
    getArtistSongs();
    super.onInit();
  }

  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  final RxMap<String, List<AllMusicsModel>> artistMap =
      <String, List<AllMusicsModel>>{}.obs;
  final RxMap<String, List<AllMusicsModel>> albumsMap =
      <String, List<AllMusicsModel>>{}.obs;

  // getting artist with songs
  void getArtistSongs() {
    final List<AllMusicsModel> allMusics = musicBox.values.toList();
    allMusics.forEach((music) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.containsKey(artistName)) {
        artistMap[artistName] = [];
      }
      artistMap[artistName]!.add(music);
    });
  }

  // getting album with songs
  void getAlbumSongs() {
    final List<AllMusicsModel> allMusics = musicBox.values.toList();
    allMusics.forEach((music) {
      final albumName = capitalizeFirstLetter(music.musicAlbumName);
      if (!albumsMap.containsKey(albumName)) {
        albumsMap[albumName] = [];
      }
      albumsMap[albumName]!.add(music);
    });
  }

  // method for deleting a song permanently
  void deleteSelectedSongs(List<int> selectedSongIds) {
    final musicList = musicBox.values.toList();
    selectedSongIds.forEach((id) {
      final index = musicList.indexWhere((music) => music.id == id);
      if (index != -1) {
        musicBox.deleteAt(index);
      }
    });
    update();
    Get.back();
    audioController.getAllSongs();
  }
}
