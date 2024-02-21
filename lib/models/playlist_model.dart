import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';
part 'playlist_model.g.dart';
@HiveType(typeId: 2)
class Playlist {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<AllMusicsModel>? playlistSongs;
  Playlist({
     this.id,
    required this.name,
    this.playlistSongs = const <AllMusicsModel>[],
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Playlist && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode;
}
