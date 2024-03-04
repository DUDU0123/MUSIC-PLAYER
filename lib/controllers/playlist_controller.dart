import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:uuid/uuid.dart';

class PlaylistController extends GetxController {
  RxList<Playlist> listOfPlaylist = <Playlist>[].obs;
  RxList<int> playlistSongLengths = <int>[].obs;
  RxList<AllMusicsModel> fullSongListToAddToPlaylist = <AllMusicsModel>[].obs;
  static PlaylistController get to => Get.find();
  // Add a StreamController to notify PlaylistSongListPage
  // final _songAddedToPlaylistController = StreamController<Playlist>.broadcast();
  // Stream<Playlist> get onSongAddedToPlaylist =>
  //     _songAddedToPlaylistController.stream;
  // RxInt selectedPlaylistId = RxInt(0);
  // set setSelectedPlaylistId(int value) => selectedPlaylistId.value = value;
  // int get getSelectedPlaylistId => selectedPlaylistId.value;
  Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
  RxList<Playlist> currentPlaylistSongList = <Playlist>[].obs;
  AudioController audioController = Get.put(AudioController());

  @override
  void onInit() {
    super.onInit();
    loadPlaylistsFromHive();
    addingAllSongsToList();
  }

  addSongsToDBPlaylist(List<AllMusicsModel> playlistSongs, int playlistID) {
    currentPlaylistSongList.value = playlistBox.values.toList();

    Playlist? selectedPlaylist;
    try {
      selectedPlaylist = currentPlaylistSongList
          .firstWhere((playlist) => playlist.id == playlistID);
    } catch (e) {
      log("Playlist with id $playlistID not found");
    }
    try {
      // Playlist newPlaylist =
      //     Playlist(id: selectedPlaylist!.id, name: selectedPlaylist.name);
      if (selectedPlaylist != null) {
        for (var song in playlistSongs) {
          if (!selectedPlaylist.playlistSongs!.contains(song)) {
            log("Song name: ${song.musicName}");
            selectedPlaylist.playlistSongs?.add(song);
          }
        }
        playlistBox.put(playlistID, selectedPlaylist);
      }
    } catch (e) {
      log("ERROR ON ADDING SONGS: $e");
    }
    update();
    updatePlaylistSongLengths();
  }

//   void playlistCreation({required String playlistName}) async {
//   bool isPlaylistAlreadyAdded = false;
//   var uuid = const Uuid();
//   var newPlaylistId = uuid.v4(); // Generate a random UUID

//   while (listOfPlaylist.any((playlist) => playlist.id == newPlaylistId)) {
//     newPlaylistId = uuid.v4(); // Regenerate if the UUID is already in use
//   }

//   for (var playlistList in listOfPlaylist) {
//     if (playlistList.name == playlistName || playlistList.name == '') {
//       isPlaylistAlreadyAdded = true;
//       break;
//     }
//   }

//   if (!isPlaylistAlreadyAdded && playlistName.isNotEmpty && playlistName != '') {
//     var newPlaylist = Playlist(name: playlistName, id: newPlaylistId, playlistSongs: []);
//     listOfPlaylist.add(newPlaylist);

//     // Save to Hive box
//     var hiveBox = await Hive.openBox<Playlist>('playlist');
//     hiveBox.add(newPlaylist);

//     log(newPlaylist.name);
//     log(newPlaylist.id!);
//     log(newPlaylist.playlistSongs.toString());
//   }
//   update();
// }

  void playlistCreation(
      {required String playlistName, required int index}) async {
    bool isPlaylistAlreadyAdded = false;
    while (listOfPlaylist.any((playlist) => playlist.id == index)) {
      index++;
    }
    for (var playlistList in listOfPlaylist) {
      if (playlistList.name == playlistName || playlistList.name == '') {
        isPlaylistAlreadyAdded = true;
        break;
      }
    }

    if (!isPlaylistAlreadyAdded &&
        playlistName.isNotEmpty &&
        playlistName != '') {
      var newPlaylist =
          Playlist(name: playlistName, id: index, playlistSongs: []);
      listOfPlaylist.add(newPlaylist);
      // Save to Hive box
      var hiveBox = await Hive.openBox<Playlist>('playlist');

      hiveBox.add(newPlaylist);
      log(newPlaylist.name);
      log(newPlaylist.id!.toString());
      log(newPlaylist.playlistSongs.toString());
    }
    update();
    updatePlaylistSongLengths();
  }

  //playlist delete function
  void playlistDelete({required int index}) async {
    log("Deleting playlist at index: $index");
    if (index >= 0 && index < listOfPlaylist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      log("Before deletion: ${hiveBox.values}");
      listOfPlaylist.removeAt(index);
      await hiveBox.deleteAt(index);
      log("After deletion: ${listOfPlaylist.toList()}");
    }
    update();
    updatePlaylistSongLengths();
  }

// just dummy I created
  // removeSongsFromPlaylist(List<AllMusicsModel> songs) {
  //   for (var selectedSong in songs) {
  //     currentPlaylistSongList
  //         .removeWhere((playlistsong) => playlistsong.id == selectedSong.id);
  //     playlistBox.delete(selectedSong.id);
  //     Get.snackbar(
  //       "Removed",
  //       "Removed drom favorites",
  //       colorText: kWhite,
  //       backgroundColor: kBlack,
  //       duration: const Duration(seconds: 1),
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  //   update();
  // }

  void removeSongsFromPlaylist(List<AllMusicsModel> songsToRemove) {
    if (currentPlaylistSongList.isNotEmpty) {
      for (var songToRemove in songsToRemove) {
        currentPlaylistSongList.forEach((playlist) {
          if (playlist.playlistSongs!.contains(songToRemove)) {
            playlist.playlistSongs!.remove(songToRemove);
            playlistBox.put(playlist.id!, playlist);
          }
        });
      }
      update();
      updatePlaylistSongLengths();
    }
    Get.back();
  }

  //  void playlistUpdateName({
  //   required String playlistID,
  //   required String newPlaylistName,
  // }) async {
  //   var index = listOfPlaylist.indexWhere((playlist) => playlist.id == playlistID);
  //   if (
  //       newPlaylistName.isNotEmpty &&
  //       newPlaylistName != '') {
  //     var hiveBox = await Hive.openBox<Playlist>('playlist');
  //     var updatedPlaylist = listOfPlaylist[index];
  //     var updatedPlaylistWithName = Playlist(
  //       name: newPlaylistName,
  //       id: playlistID,
  //       playlistSongs: updatedPlaylist.playlistSongs,
  //     );

  //     hiveBox.putAt(index, updatedPlaylistWithName);
  //     listOfPlaylist[index] = updatedPlaylistWithName;
  //     log(updatedPlaylistWithName.name);
  //     log(updatedPlaylistWithName.id.toString());
  //   }
  // }

  void playlistUpdateName({
    required int index,
    required String newPlaylistName,
  }) async {
    if (index >= 0 &&
        index < listOfPlaylist.length &&
        newPlaylistName.isNotEmpty &&
        newPlaylistName != '') {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      var updatedPlaylist = listOfPlaylist[index];
      var updatedPlaylistWithName = Playlist(
        name: newPlaylistName,
        id: index,
        playlistSongs: updatedPlaylist.playlistSongs,
      );

      hiveBox.putAt(index, updatedPlaylistWithName);
      listOfPlaylist[index] = updatedPlaylistWithName;
      log(updatedPlaylistWithName.name);
      log(updatedPlaylistWithName.id.toString());
    }
    updatePlaylistSongLengths();
  }

  String getPlaylistName({required int index}) {
    if (index >= 0 && index < listOfPlaylist.length) {
      return listOfPlaylist[index].name;
    }
    return "";
  }
//   String getPlaylistID({required int index}) {
//   if (index >= 0 && index < listOfPlaylist.length) {
//     return listOfPlaylist[index].id ?? '';
//   }
//   return '';
// }

  int getPlaylistID({required int index}) {
    if (index >= 0 && index < listOfPlaylist.length) {
      return listOfPlaylist[index].id != null ? listOfPlaylist[index].id! : 0;
    }
    return 0;
  }

  Future<List<AllMusicsModel>?> getPlayListSongs(int playListId) async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');

    if (playListId >= 0 && playListId < listOfPlaylist.length) {
      Playlist? playlist = hiveBox.getAt(playListId);

      // Check if the playlist is not null and playlistSongs is not null
      if (playlist != null && playlist.playlistSongs != null) {
        return playlist.playlistSongs;
      } else {
        // Return an empty list if the playlist or playlistSongs is null
        return [];
      }
    } else {
      // Handle the case where playListId is out of bounds
      log("Invalid playlist ID: $playListId");
      return [];
    }
  }

//   Future<List<AllMusicsModel>?> getPlayListSongs(int playListId) async {
//   var hiveBox = await Hive.openBox<Playlist>('playlist');

//   if (playListId >= 0 && playListId < listOfPlaylist.length) {
//     Playlist? playlist = hiveBox.getAt(playListId);

//     // Check if the playlist is not null and playlistSongs is not null
//     if (playlist != null && playlist.playlistSongs != null) {
//       // Filter out songs that are not in audioController.allsongslistfromdevice
//       List<AllMusicsModel> filteredSongs = playlist.playlistSongs!
//           .where((song) => audioController.allSongsListFromDevice
//               .contains(song)) // Assuming AllMusicsModel has proper equality comparison
//           .toList();

//       // Update the playlistSongs with the filtered list
//       Playlist updatedPlaylist = Playlist(
//         name: playlist.name,
//         playlistSongs: filteredSongs,
//         id: playListId
//       );

//       // Save the updated playlist back to Hive
//       hiveBox.putAt(playListId, playlist);

//       return filteredSongs;
//     } else {
//       // Return an empty list if the playlist or playlistSongs is null
//       return [];
//     }
//   } else {
//     // Handle the case where playListId is out of bounds
//     log("Invalid playlist ID: $playListId");
//     return [];
//   }
// }

  // method to get paylist song length
  void updatePlaylistSongLengths() {
    playlistSongLengths.clear();
    for (int i = 0; i < listOfPlaylist.length; i++) {
      var playlistSongs = listOfPlaylist[i].playlistSongs;
      int songLength = playlistSongs != null ? playlistSongs.length : 0;
      playlistSongLengths.add(songLength);
    }
  }

  onTapRemoveFromPlaylist(
      {required int songId, required int playlistId}) async {
    log("Removing..");
    var playlistBox = await Hive.openBox<Playlist>('playlist');
    Playlist? selectedPlaylist = playlistBox.getAt(playlistId);
    if (selectedPlaylist != null && selectedPlaylist.playlistSongs != null) {
      // Find the song with the specified songId in the playlist
      int indexOfSong = selectedPlaylist.playlistSongs!.indexWhere(
        (song) => song.id == songId,
      );

      if (indexOfSong != -1) {
        selectedPlaylist.playlistSongs!.removeAt(indexOfSong);
        playlistBox.putAt(playlistId, selectedPlaylist);
        Get.snackbar(
          "Song Removed",
          "Song removed from playlist",
          backgroundColor: kBlack,
          colorText: kWhite,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        log("Song with id $songId not found in the playlist.");
      }
    } else {
      log("Playlist not found or doesn't have songs.");
    }
    update();
    updatePlaylistSongLengths();
  }

  // Get all playlist
  List<Playlist> get allPlaylists => listOfPlaylist;

  void addingAllSongsToList() async {
    Box<AllMusicsModel> hiveBox = await Hive.openBox<AllMusicsModel>('musics');
    fullSongListToAddToPlaylist.value = hiveBox.values.map((music) {
      return AllMusicsModel(
        id: music.id,
        musicName: music.musicName,
        musicAlbumName: music.musicAlbumName,
        musicArtistName: music.musicArtistName,
        musicPathInDevice: music.musicPathInDevice,
        musicFormat: music.musicFormat,
        musicUri: music.musicUri,
        musicFileSize: music.musicFileSize,
      );
    }).toList();
    update();
  }

  Future<void> loadPlaylistsFromHive() async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    listOfPlaylist.assignAll(hiveBox.values.toList());
    // Initialize playlistSongLengths with default lengths
    playlistSongLengths.assignAll(List<int>.filled(listOfPlaylist.length, 0));
    updatePlaylistSongLengths();
  }

  // Retrieve all playlists from Hive
  Future<List<Playlist>> getPlaylists() async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    return playlistBox.values.toList();
  }
}
