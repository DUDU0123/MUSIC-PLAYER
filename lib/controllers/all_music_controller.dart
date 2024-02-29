import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/album_artist_functions_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class AllMusicController extends GetxController {
  AudioController audioController = Get.put(AudioController());
  
  @override
  void onInit() {
    getAlbumSongs();
    getArtistSongs();
    super.onInit();
  }

  // Future<void> fetchAllMusicData() async {
  //   await getAlbumSongs();
  //   await getArtistSongs();
  // }

  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  final RxMap<String, List<AllMusicsModel>> artistMap =
      <String, List<AllMusicsModel>>{}.obs;
  final RxMap<String, List<AllMusicsModel>> albumsMap =
      <String, List<AllMusicsModel>>{}.obs;

  // getting artist with songs
   getArtistSongs() {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    allMusics.value.forEach((music) {
      final artistName = capitalizeFirstLetter(music.musicArtistName);
      if (!artistMap.value.containsKey(artistName)) {
        artistMap.value[artistName] = [];
      }
      artistMap.value[artistName]!.add(music);
    });
    update();
  }

  // getting album with songs
   getAlbumSongs() {
    final RxList<AllMusicsModel> allMusics = musicBox.values.toList().obs;
    allMusics.value.forEach((music) {
      final albumName = capitalizeFirstLetter(music.musicAlbumName);
      if (!albumsMap.value.containsKey(albumName)) {
        albumsMap.value[albumName] = [];
      }
      albumsMap.value[albumName]!.add(music);
    });
    update();
  }


}
