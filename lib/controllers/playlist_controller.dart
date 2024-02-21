import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/playlist_model.dart';

class PlaylistController extends GetxController {
  RxList<Playlist> playlist = <Playlist>[].obs;
  RxList<int> playlistSongLengths = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaylistsFromHive();
  }

  Future<void> loadPlaylistsFromHive() async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    playlist.assignAll(hiveBox.values.toList());

    // Initialize playlistSongLengths with default lengths
    playlistSongLengths.assignAll(List<int>.filled(playlist.length, 0));
  }

  void playlistCreation({required String playlistName, required int index}) async {
    bool isPlaylistAlreadyAdded = false;
    for (var playlistList in playlist) {
      if (playlistList.name == playlistName || playlistList.name == '' || playlistList.id == index) {
        isPlaylistAlreadyAdded = true;
        break;
      }
    }
    if (!isPlaylistAlreadyAdded) {
      var newPlaylist = Playlist(name: playlistName, id: index);
      playlist.add(newPlaylist);

      // Save to Hive box
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      hiveBox.add(newPlaylist);
    }
  }

  void playlistDelete({required int index}) async {
    print("Deleting playlist at index: $index");
    if (index >= 0 && index < playlist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      print("Before deletion: ${hiveBox.values}");
      playlist.removeAt(index);
      await hiveBox.deleteAt(index);
      print("After deletion: ${playlist.toList()}");
    }
  }

  void playlistUpdateName({
    required int index,
    required String newPlaylistName,
  }) async {
    if (index >= 0 && index < playlist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      var updatedPlaylist = Playlist(name: newPlaylistName, id: index);
      hiveBox.putAt(index, updatedPlaylist);
      playlist[index] = updatedPlaylist;
    }
  }

  String getPlaylistName({required int index}) {
    if (index >= 0 && index < playlist.length) {
      return playlist[index].name;
    }
    return "";
  }
}
