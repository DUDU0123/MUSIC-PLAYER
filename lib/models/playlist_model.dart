import 'package:hive_flutter/hive_flutter.dart';

import 'package:music_player/models/allmusics_model.dart';

part 'playlist_model.g.dart';
@HiveType(typeId: 2)
class Playlist {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<AllMusicsModel>? playlistSongs;
  Playlist({
    required this.name,
    this.playlistSongs,
  });
}
