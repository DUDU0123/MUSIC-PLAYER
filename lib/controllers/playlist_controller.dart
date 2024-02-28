import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';

class PlaylistController extends GetxController {
  RxList<Playlist> listOfPlaylist = <Playlist>[].obs;
  RxList<int> playlistSongLengths = <int>[].obs;
  RxList<AllMusicsModel> fullSongListToAddToPlaylist = <AllMusicsModel>[].obs;
  static PlaylistController get to => Get.find();
  // Add a StreamController to notify PlaylistSongListPage
  final _songAddedToPlaylistController = StreamController<Playlist>.broadcast();
  Stream<Playlist> get onSongAddedToPlaylist =>
      _songAddedToPlaylistController.stream;
  RxInt selectedPlaylistId = RxInt(-1);
  set setSelectedPlaylistId(int value) => selectedPlaylistId.value = value;
  int get getSelectedPlaylistId => selectedPlaylistId.value;

  @override
  void onInit() {
    super.onInit();
    loadPlaylistsFromHive();
    addingAllSongsToList();
  }

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

  // addSongsToPlaylist
  // addSongsToPlaylist(List<AllMusicsModel> songs, int playlistId) async {
  //   var hiveBox = await Hive.openBox<Playlist>('playlist');
  //    final List<Playlist> currentPlaylistSongList = hiveBox.values.toList();
  //   currentPlaylistSongList.map((onePlaylist) => onePlaylist.id == playlistId).toList();
  //   // check if song already available in playlist
  //   // check if playlist already available
  //   // if playlist not available create one
  //   // if selected songs not available in that particular playlist , then add the songs to the playlist
  // }

  // addToPlaylist(List<AllMusicsModel> songs) {
  //   var songList = [];
  //   listOfPlaylist.map((playlist) {
  //     return playlist.playlistSongs!.map((e) {
  //       return songs;
  //     }).toList();
  //   });
  // }

  // addSongListToPlaylist(List<AllMusicsModel> songs, int playlistId) {
  //   final correctSongs = listOfPlaylist.value
  //       .where((playlist) => playlist.id == playlistId)
  //       .map((playlist) => songs)
  //       .toList();
  // }

  // addSongsToPlaylist
  addSongsToPlaylist(List<AllMusicsModel> songs, int playlistId) async {
    var hiveBox = await Hive.openBox<Playlist>('playlist');
    final List<Playlist> currentPlaylistSongList = hiveBox.values.toList();

    // Find the playlist with the specified playlistId
    Playlist? selectedPlaylist = currentPlaylistSongList.firstWhere(
      (playlist) => playlist.id == playlistId,
      orElse: () => Playlist(name: '', id: 0),
    );

    if (selectedPlaylist != null) {
      // Check if the songs are not already in the playlist
      for (var song in songs) {
        if (!selectedPlaylist.playlistSongs!.contains(song)) {
          log("Song Added: ${song.musicName}");
          selectedPlaylist.playlistSongs?.add(song);
        }
      }

      // Update the playlist in Hive
      hiveBox.put(playlistId, selectedPlaylist);
    } else {
      // If the playlist with the specified id does not exist, you can handle it accordingly.
      print("Playlist with id $playlistId not found");
    }
  }

  // retrive all songs in a particular playlist
  // Future<List<AllMusicsModel>?> getPlayListSongs(int playListId) async {
  //   var hiveBox = await Hive.openBox<Playlist>('playlist');
  //   Playlist? playlist = hiveBox.getAt(playListId);
  //   return playlist?.playlistSongs;
    
  // }

  Future<List<AllMusicsModel>?> getPlayListSongs(int playListId) async {
  var hiveBox = await Hive.openBox<Playlist>('playlist');
  Playlist? playlist = hiveBox.getAt(playListId);

  // Check if the playlist is not null and playlistSongs is not null
  if (playlist != null && playlist.playlistSongs != null) {
    return playlist.playlistSongs;
  } else {
    // Return an empty list if the playlist or playlistSongs is null
    return [];
  }
}

  // Retrieve all playlists from Hive
  Future<List<Playlist>> getPlaylists() async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    return playlistBox.values.toList();
  }

  void playlistCreation(
      {required String playlistName, required int index}) async {
    bool isPlaylistAlreadyAdded = false;
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

  // getter for get all playlist
  List<Playlist> get allPlaylists => listOfPlaylist;

  @override
  void onClose() {
    super.onClose();
    _songAddedToPlaylistController.close();
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
        // Print statement for debugging
        log("Playlist after update: ${selectedPlaylist.playlistSongs}");
        // Show a snackbar or perform any other action to notify the user
        snackBarCommonWidget(context, contentText: "Song added to playlist");
      } else {
        // Show a snackbar or perform any other action to notify the user
        snackBarCommonWidget(context, contentText: "Song already in playlist");
      }
    } else {
      log("Playlist with id $playlistId not found");
    }
  }

// playlist delete function
  void playlistDelete({required int index}) async {
    print("Deleting playlist at index: $index");
    if (index >= 0 && index < listOfPlaylist.length) {
      var hiveBox = await Hive.openBox<Playlist>('playlist');
      print("Before deletion: ${hiveBox.values}");
      listOfPlaylist.removeAt(index);
      await hiveBox.deleteAt(index);
      print("After deletion: ${listOfPlaylist.toList()}");
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
      print(updatedPlaylistWithName.name);
      print(updatedPlaylistWithName.id);
    }
  }

  String getPlaylistName({required int index}) {
    if (index >= 0 && index < listOfPlaylist.length) {
      return listOfPlaylist[index].name;
    }
    return "";
  }
}
