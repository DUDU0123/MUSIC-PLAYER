import 'dart:async';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';

class PlaylistController extends GetxController {
  RxList<Playlist> listOfPlaylist = <Playlist>[].obs;
  RxList<int> playlistSongLengths = <int>[].obs;
  RxList<AllMusicsModel> fullSongListToAddToPlaylist = <AllMusicsModel>[].obs;
  static PlaylistController get to => Get.find();
  Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
  RxList<Playlist> currentPlaylistSongList = <Playlist>[].obs;
  AudioController audioController = Get.put(AudioController());
  RxInt getPlaylistIDFromAddToPlaylist = RxInt(0);
  RxBool isMusicPlaylistPage = RxBool(false);

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
    } catch (e) {}
    try {
      // Playlist newPlaylist =
      //     Playlist(id: selectedPlaylist!.id, name: selectedPlaylist.name);
      if (selectedPlaylist != null) {
        for (var song in playlistSongs) {
          if (!selectedPlaylist.playlistSongs!.contains(song)) {
            selectedPlaylist.playlistSongs?.add(song);
            Get.snackbar(
              "Song Added",
              "Song added to playlist",
              backgroundColor: kTileColor,
              colorText: kWhite,
              duration: const Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              "Song Exist",
              "Song exist in playlist",
              backgroundColor: kTileColor,
              colorText: kWhite,
              duration: const Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
        playlistBox.put(playlistID, selectedPlaylist);
      }
    } catch (e) {}
    update();
  }

  bool isInPlaylist(int songId) {
    // Iterate through each playlist
    for (var playlist in listOfPlaylist) {
      // Check if the playlist has songs and if it contains the specified songId
      if (playlist.playlistSongs != null &&
          playlist.playlistSongs!.any((song) => song.id == songId)) {
        return true; // The song is in at least one playlist
      }
    }
    return false; // The song is not in any playlist
  }

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
    }
    update();
  }

//  playlist delete function
  void playlistDelete({required int index}) async {
    if (index >= 0 && index < listOfPlaylist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');

      listOfPlaylist.removeAt(index);
      await hiveBox.deleteAt(index);
    }
    update();
  }

  void removeSongsFromPlaylist(List<AllMusicsModel> songsToRemove) {
    if (currentPlaylistSongList.isNotEmpty) {
      for (var songToRemove in songsToRemove) {
        for (var playlist in currentPlaylistSongList) {
          if (playlist.playlistSongs!.contains(songToRemove)) {
            playlist.playlistSongs!.remove(songToRemove);
            playlistBox.put(playlist.id!, playlist);
          }
        }
      }
      update();
    }
    Get.back();
  }

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
    }
  }

  String getPlaylistName({required int index}) {
    if (index >= 0 && index < listOfPlaylist.length) {
      return listOfPlaylist[index].name;
    }
    return "";
  }

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
        for (var playlistSong in playlist.playlistSongs!) {
          if (!AllFiles.files.value.contains(playlistSong)) {
            playlist.playlistSongs!.remove(playlistSong);
          }
        }
        // updatePlaylistSongLengths();
        return playlist.playlistSongs;
      } else {
        // Return an empty list if the playlist or playlistSongs is null
        return [];
      }
    } else {
      // Handle the case where playListId is out of bounds
      return [];
    }
  }

  loadPlaylist(int playListId) async {
    List<AllMusicsModel> filteredSongs = [];
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    if (playListId >= 0 && playListId < listOfPlaylist.length) {
      Playlist? playlist = hiveBox.getAt(playListId);
      if (playlist != null && playlist.playlistSongs != null) {
        filteredSongs = playlist.playlistSongs!
            .where((song) =>
                AllFiles.files.value.any((file) => file.id == song.id))
            .toList();
      }
    }
    return filteredSongs;
  }

  onTapRemoveFromPlaylist(
      {required int songId, required int playlistId}) async {
    var playlistBox = await Hive.openBox<Playlist>('playlist');
    Playlist? selectedPlaylist = playlistBox.getAt(playlistId);
    if (selectedPlaylist != null && selectedPlaylist.playlistSongs != null) {
      // Find the song with the specified songId in the playlist
      int indexOfSong = selectedPlaylist.playlistSongs!.indexWhere((song) {
        return song.id == songId;
      });

      if (indexOfSong != -1) {
        selectedPlaylist.playlistSongs!.removeAt(indexOfSong);
        playlistBox.putAt(playlistId, selectedPlaylist);
        Get.back();
        Get.snackbar(
          "Song Removed",
          "Song removed from playlist",
          backgroundColor: kTileColor,
          colorText: kWhite,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        
      }
    } else {
      
    }
    update();
  }

  onTapRemovefromPlaylistAddToPlaylistPage(
      {required int songId, required int playlistId}) async {
    var playlistBox = await Hive.openBox<Playlist>('playlist');

    // Iterate through all playlists
    for (int i = 0; i < playlistBox.length; i++) {
      Playlist? currentPlaylist = playlistBox.getAt(i);

      if (currentPlaylist != null && currentPlaylist.playlistSongs != null) {
        // Check if the playlist contains the song
        int indexOfSong = currentPlaylist.playlistSongs!.indexWhere((song) {
          return song.id == songId;
        });

        if (indexOfSong != -1) {
          // Remove the song from the playlist
          currentPlaylist.playlistSongs!.removeAt(indexOfSong);
          playlistBox.putAt(i, currentPlaylist);

          Get.back();
          Get.snackbar(
            "Song Removed",
            "Song removed from playlist",
            backgroundColor: kTileColor,
            colorText: kWhite,
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
          );

          // Return after removing the song from the first playlist found
          return;
        }
      }
    }
    // If no playlist contains the song
    Get.snackbar(
      "Song Not Found",
      "Song not found in any playlist",
      backgroundColor: kTileColor,
      colorText: kWhite,
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
    );

    update();
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
    // updatePlaylistSongLengths();
  }

  // Retrieve all playlists from Hive
  Future<List<Playlist>> getPlaylists() async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    return playlistBox.values.toList();
  }
}
