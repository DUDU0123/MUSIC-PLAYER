import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/favourite_model.dart';

class FavoriteController extends GetxController {
  RxList<FavoriteModel> favoriteSongs = <FavoriteModel>[].obs;
  int initialFavoriteSongsLength = 0;

  final Box<FavoriteModel> favoriteBox = Hive.box<FavoriteModel>('favorite');

  @override
  void onInit() {
    loadFavoriteSongs();
    super.onInit();
  }


  void loadFavoriteSongs() {
    print('Before load: ${favoriteBox.values}');
    favoriteSongs.assignAll(favoriteBox.values.cast<FavoriteModel>());
     final uniqueFavorites = favoriteSongs.toSet().toList();
     favoriteSongs.clear();
    favoriteSongs.assignAll(uniqueFavorites);
    print('After load: ${favoriteBox.values}');
  }


  void onTapFavorite(FavoriteModel song) {
    if (favoriteSongs.contains(song)) {
      favoriteSongs.remove(song);
      favoriteBox.delete(song.id);
    } else {
      if (!favoriteSongs.any((element) => element.id == song.id)) {
        favoriteSongs.add(song);
        favoriteBox.add(song);
      }
    }
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
