import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';


class FavoriteController extends GetxController {
  RxList<FavoriteModel> favoriteSongs = <FavoriteModel>[].obs;
  int initialFavoriteSongsLength = 0;
  AudioController audioController = Get.put(AudioController());
  final Box<FavoriteModel> favoriteBox = Hive.box<FavoriteModel>('favorite');
  final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');

  @override
  void onInit() {
    loadFavoriteSongs();
    super.onInit();
  }

  removeFromFavorite(List<AllMusicsModel> selectedSongs, BuildContext context) {
    for (var song in selectedSongs) {
      if (isFavorite(song.id)) {
        log("Removing from FAVORITE");
        // Song is a favorite, remove it
        favoriteSongs.removeWhere((favoriteSong) => favoriteSong.id == song.id);
        favoriteBox.delete(song.id);
        snackBarCommonWidget(context, contentText: "Removed from favorites");
      }
    }
    update();
    Get.back();
  }

  void loadFavoriteSongs() {
    log('Before load: ${favoriteBox.values}');
    favoriteSongs.assignAll(favoriteBox.values.cast<FavoriteModel>());
    final uniqueFavorites = favoriteSongs.toSet().toList();
    favoriteSongs.clear();
    favoriteSongs.assignAll(uniqueFavorites);
  //  print('After load: ${favoriteBox.values}');
  }

  void onTapFavorite(FavoriteModel song, BuildContext context) {
    if (isFavorite(song.id)) {
      // Song is already a favorite, remove it
      favoriteSongs.remove(song);
      favoriteBox.delete(song.id);
      snackBarCommonWidget(context, contentText: "Removed from favorites");
    } else {
      // Song is not a favorite, add it
      favoriteSongs.add(song);
      favoriteBox.put(song.id, song);
      snackBarCommonWidget(context, contentText: "Added to favorites");
    }
    update();
  }

  bool isFavorite(int songId) {
    FavoriteModel? favoriteSong = favoriteBox.get(songId);
    return favoriteSong != null;
  }

  @override
  void dispose() {
    favoriteSongs.clear();
    super.dispose();
  }
}
