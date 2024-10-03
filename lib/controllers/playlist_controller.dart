import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';

class PlaylistController extends GetxController {
  RxList<AllMusicsModel> fullSongListToAddToPlaylist = <AllMusicsModel>[].obs;
  static PlaylistController get to => Get.find();
  Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
  RxList<Playlist> currentPlaylistSongList = <Playlist>[].obs;
  RxInt getPlaylistIDFromAddToPlaylist = RxInt(0);
  RxBool isMusicPlaylistPage = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadPlaylistsFromHive();
    addingAllSongsToList();
  }

  void addSongsToDBPlaylist({
    required Playlist playlist,
    required List<AllMusicsModel> playlistNewSongsToAdd,
  }) {
    try {
      log(playlistNewSongsToAdd.toString());
      if (playlist != null) {
        log("inside not null");
        final List<AllMusicsModel> modifiablePlaylistSongs =
            List<AllMusicsModel>.from(playlist.playlistSongs ?? []);
        for (var song in playlistNewSongsToAdd) {
          if (!modifiablePlaylistSongs.contains(song)) {
            modifiablePlaylistSongs.add(song);
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
        playlist.playlistSongs = modifiablePlaylistSongs;
        playlistBox.put(playlist.id, playlist);
      }
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  bool isInPlaylist(int songId) {
    // Iterate through each playlist
    for (var playlist in getAllPlaylist()) {
      // Check if the playlist has songs and if it contains the specified songId
      if (playlist.playlistSongs != null &&
          playlist.playlistSongs!.any((song) => song.id == songId)) {
        return true; // The song is in at least one playlist
      }
    }
    return false; // The song is not in any playlist
  }

// create playlist
  void playlistCreation({
    required String playlistName,
  }) async {
    final playlistList = playlistBox.values.toList();
    bool isPlaylistAlreadyAdded = false;
    if (playlistList.any((playlist) => playlist.name == playlistName)) {
      isPlaylistAlreadyAdded = true;
    }
    if (!isPlaylistAlreadyAdded) {
      final Playlist newPlaylist = Playlist(name: playlistName);
      final int playlistID = await playlistBox.add(newPlaylist);
      final Playlist updatedPlaylist = newPlaylist.copyWith(
        id: playlistID,
      );
      await playlistBox.put(playlistID, updatedPlaylist);
    } else {
      Get.snackbar(
        "Playlist found",
        "Playlist with this name already available.",
        backgroundColor: kTileColor,
        colorText: kWhite,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    update();
  }

  // get all playlists from db
  List<Playlist> getAllPlaylist() {
    return playlistBox.values.toList();
  }

// playlist update name
  void playlistUpdateName({
    required Playlist updatedPlaylist,
  }) async {
    try {
      await playlistBox.put(updatedPlaylist.id, updatedPlaylist);
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occured",
        backgroundColor: kTileColor,
        colorText: kWhite,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

//  playlist delete function
  void playlistDelete({required int? playlistId}) async {
    final playlists = playlistBox.values.toList();
    if (playlists.any((playlist) => playlist.id == playlistId)) {
      playlistBox.delete(playlistId);
      Get.snackbar(
        "Deleted",
        "Playlist deleted successfully",
        backgroundColor: kTileColor,
        colorText: kWhite,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Failed",
        "Unable to delete playlist",
        backgroundColor: kTileColor,
        colorText: kWhite,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      );
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

  Future<List<AllMusicsModel>?> getPlayListSongs(int playListId) async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');

    if (playListId >= 0 && playListId < getAllPlaylist().length) {
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
      } else {}
    } else {}
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

  void addingAllSongsToList() async {
    Box<AllMusicsModel> hiveBox = await Hive.box<AllMusicsModel>('musics');
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
    getAllPlaylist();
  }
}
