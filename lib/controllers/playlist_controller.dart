import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';

class PlaylistController extends GetxController {
  RxList<Playlist> listOfPlaylist = <Playlist>[].obs;
  RxList<int> playlistSongLengths = <int>[].obs;
  RxList<AllMusicsModel> fullSongListToAddToPlaylist = <AllMusicsModel>[].obs;
  static PlaylistController get to => Get.find();
  // Add a StreamController to notify PlaylistSongListPage
  final _songAddedToPlaylistController = StreamController<Playlist>.broadcast();
  Stream<Playlist> get onSongAddedToPlaylist =>
      _songAddedToPlaylistController.stream;
  RxInt selectedPlaylistId = RxInt(0);
  set setSelectedPlaylistId(int value) => selectedPlaylistId.value = value;
  int get getSelectedPlaylistId => selectedPlaylistId.value;
  Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
  RxList<Playlist> currentPlaylistSongList = <Playlist>[].obs;

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
      // for (var song in playlistSongs) {
      //   if (!selectedPlaylist!.playlistSongs!.contains(song)) {
      //     log("Song name: ${song.musicName}");
      //     selectedPlaylist.playlistSongs?.add(song);
      //   }
      // }
      // playlistBox.put(playlistID, selectedPlaylist!);
    } catch (e) {
      log("ERROR ON ADDING SONGS: $e");
    }
    update();
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
      log(newPlaylist.name);
      log(newPlaylist.id!.toString());
      log(newPlaylist.playlistSongs.toString());
    }
    update();
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
      log(updatedPlaylistWithName.name);
      log(updatedPlaylistWithName.id.toString());
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

  onTapRemoveFromPlaylist(
      {required AllMusicsModel song, required int playlistId}) async {
    var playlistBox = await Hive.openBox<Playlist>('playlist');
    Playlist? selectedPlaylist = playlistBox.getAt(playlistId);

    if (selectedPlaylist!.playlistSongs!.contains(song)) {
      selectedPlaylist.playlistSongs!.remove(song);
      playlistBox.delete(song.id);
    }
  }

  // on tapping on the playlist add the song to the playlist
  void onTapAddToPlaylist({
    required AllMusicsModel selectedSong,
    required int playlistId,
    required BuildContext context,
  }) async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    Playlist? selectedPlaylist = hiveBox.getAt(playlistId);
    log("ONTAP FUNCTION TAPPED");
    if (selectedPlaylist != null) {
      log("ONTAP FUNCTION INSIDE");
      // Check if the song is not already in the playlist
      if (!selectedPlaylist.playlistSongs!.contains(selectedSong)) {
        log("ONTAP FUNCTION INSIDE INSIDE");
        // Add the song to the playlist
        selectedPlaylist.playlistSongs?.add(selectedSong);
        // Update the playlist in Hive
        hiveBox.put(playlistId, selectedPlaylist);
        // Print statements for debugging
        log("Song added to playlist: ${selectedSong.musicName}");
        log("Playlist before update: ${selectedPlaylist.playlistSongs}");
        // Notify the stream with the updated playlist
        setSelectedPlaylistId = playlistId;
        // Notify the stream with the updated playlist
        _songAddedToPlaylistController.add(selectedPlaylist);
        log("Playlist after update: ${selectedPlaylist.playlistSongs}");
        Get.snackbar(
          "Song Added",
          "Song added to playlist",
          colorText: kWhite,
          backgroundColor: kBlack,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Song Added",
          "Song already in playlist",
          colorText: kWhite,
          backgroundColor: kBlack,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      log("Playlist with id $playlistId not found");
    }
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
  }

  Future<void> loadPlaylistsFromHive() async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    listOfPlaylist.assignAll(hiveBox.values.toList());
    // Initialize playlistSongLengths with default lengths
    playlistSongLengths.assignAll(List<int>.filled(listOfPlaylist.length, 0));
  }

  // retrive all songs in a particular playlist
  // Future<List<AllMusicsModel>?> getPlayListSongs(int playListId) async {
  //   var hiveBox = await Hive.openBox<Playlist>('playlist');
  //   Playlist? playlist = hiveBox.getAt(playListId);
  //   return playlist?.playlistSongs;

  // }

  // Retrieve all playlists from Hive
  Future<List<Playlist>> getPlaylists() async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    return playlistBox.values.toList();
  }

  @override
  void onClose() {
    super.onClose();
    _songAddedToPlaylistController.close();
  }
}
