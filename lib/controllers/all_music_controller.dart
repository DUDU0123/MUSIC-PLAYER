import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';

class AllMusicController extends GetxController {
  AudioController audioController = Get.put(AudioController());

  // @override
  // void onInit() {
  //   getAlbumSongs();
  //   getArtistSongs();
  //   super.onInit();
  // }

  Future<List<AllMusicsModel>> fetchAllAlbumMusicData() async {
    await getAlbumSongs();
    return audioController.allSongsListFromDevice;
  }

  Future<void> fetchAllArtistMusicData() async {
    await getArtistSongs();
  }

  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  final RxMap<String, List<AllMusicsModel>> artistMap =
      <String, List<AllMusicsModel>>{}.obs;
  final RxMap<String, List<AllMusicsModel>> albumsMap =
      <String, List<AllMusicsModel>>{}.obs;

  // getting artist with songs
  getArtistSongs() {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    for (var music in allMusics) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.containsKey(artistName)) {
        artistMap[artistName] = [];
      }
      if (!artistMap[artistName]!.contains(music)) {
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

      if (!albumsMap[albumName]!.contains(music)) {
        albumsMap[albumName]!.add(music);
      }
    }
    update();
  }
}
