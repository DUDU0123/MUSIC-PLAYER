import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/playlist_model.dart';

class PlaylistController extends GetxController {
  RxList<Playlist> playlist = <Playlist>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaylistsFromHive();
  }

  Future<void> loadPlaylistsFromHive() async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    playlist.assignAll(hiveBox.values.toList());
  }

  void playlistCreation({required String playlistName}) async {
    var newPlaylist = Playlist(name: playlistName);
    playlist.add(newPlaylist);

    // Save to Hive box
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    hiveBox.add(newPlaylist);
  }

  void playlistDelete({required int index}) async {
    if (index >= 0 && index < playlist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      hiveBox.deleteAt(index);
      playlist.removeAt(index);
    }
  }

  void playlistUpdateName({
    required int index,
    required String newPlaylistName,
  }) async {
    if (index >= 0 && index < playlist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      var updatedPlaylist = Playlist(name: newPlaylistName);
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