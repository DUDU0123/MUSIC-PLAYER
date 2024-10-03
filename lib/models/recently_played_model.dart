import 'package:hive_flutter/hive_flutter.dart';

import 'package:music_player/models/allmusics_model.dart';

part 'recently_played_model.g.dart';

@HiveType(typeId: 4)
class RecentlyPlayedModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final List<AllMusicsModel> recentlyPlayedSongsList;
  @HiveField(2)
  final String? dateTimeAdded;

  RecentlyPlayedModel({
    this.id,
    required this.recentlyPlayedSongsList,this.dateTimeAdded,
  });
  RecentlyPlayedModel copyWith({
    int? id,
    List<AllMusicsModel>? recentlyPlayedSongsList,String? dateTimeAdded,
  }) {
    return RecentlyPlayedModel(
      dateTimeAdded: dateTimeAdded ?? this.dateTimeAdded,
      id: id ?? this.id,
      recentlyPlayedSongsList: recentlyPlayedSongsList ?? this.recentlyPlayedSongsList,
    );
  }



  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RecentlyPlayedModel &&
      other.id == id &&
      other.recentlyPlayedSongsList == recentlyPlayedSongsList&&other.dateTimeAdded==dateTimeAdded;
      
  }

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
      // can adjust this limit based on your requirements
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

  @override
  int get hashCode => id.hashCode ^ recentlyPlayedSongsList.hashCode;
}
