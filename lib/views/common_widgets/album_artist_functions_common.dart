import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';

// Artist or album song list getting function
List<AllMusicsModel> artistOrAlbumSongsListGetting({
  required Box<AllMusicsModel> musicBox,
  required bool Function(AllMusicsModel) callback,
}) {
  final List<AllMusicsModel> artistOrAlbumSongs =
      musicBox.values.where(callback).toList();
  return artistOrAlbumSongs;
}

// Making first letter capital of a string value
String capitalizeFirstLetter(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
