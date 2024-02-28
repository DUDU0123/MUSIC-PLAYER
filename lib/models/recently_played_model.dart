import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';
part 'recently_played_model.g.dart';
@HiveType(typeId: 4)
class RecentlyPlayedModel {
  @HiveField(0)
  final List<AllMusicsModel> recentlyPlayedSongsList;
  RecentlyPlayedModel({
    required this.recentlyPlayedSongsList,
  });

  // Method to add a song to the recently played list
  void addRecentlyPlayedSong(AllMusicsModel song) {
    bool isSongAlreadyAdded = false;

    for (var addedSong in recentlyPlayedSongsList) {
      if (addedSong == song) {
        isSongAlreadyAdded = true;
        break;
      }
    }

    if (!isSongAlreadyAdded) {
      // Optionally, you can limit the size of the list to keep only the most recent songs
      // You can adjust this limit based on your requirements
      if (recentlyPlayedSongsList.length >= 10) {
        recentlyPlayedSongsList.removeAt(0);
      }

      recentlyPlayedSongsList.add(song);
    }
  }

  void removeRecentlyPlayedSong(AllMusicsModel song) {
    recentlyPlayedSongsList.removeWhere((recentlyPlayedSong) =>
        recentlyPlayedSong.id == song.id);
  }
  
}
