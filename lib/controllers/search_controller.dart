import 'package:get/get.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';

class SearchFilterController extends GetxController {
  
  RxString searchName = ''.obs;
  RxList<AllMusicsModel> filteredSongs = <AllMusicsModel>[].obs;
  final AudioController audioController = Get.put(AudioController());



  void filterSongs(String query) {
    filteredSongs.value = audioController.allSongsListFromDevice.value
        .where((song) =>
            _cleanString(song.musicName).toLowerCase().contains(_cleanString(query.toLowerCase())) ||
            _cleanString(song.musicAlbumName).toLowerCase().contains(_cleanString(query.toLowerCase())) ||
            _cleanString(song.musicArtistName).toLowerCase().contains(_cleanString(query.toLowerCase())))
        .toList();
        update();
  }

  String _cleanString(String input) {
    // Remove hyphens, commas, and other symbols as needed
    return input.replaceAll('-', '').replaceAll(',', '').toLowerCase().replaceAll('.', '').toLowerCase().replaceAll('|', '').toLowerCase();
  }
}
