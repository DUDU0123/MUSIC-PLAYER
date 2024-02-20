import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/root_widget_page.dart';
import 'package:path_provider/path_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory =
      await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(AllMusicsModelAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  Hive.registerAdapter(FavoriteModelAdapter());
  await Hive.deleteBoxFromDisk('musics');
  await Hive.deleteBoxFromDisk('playlist');
  await Hive.deleteBoxFromDisk('favorite');
  await Hive.openBox<AllMusicsModel>('musics');
  await Hive.openBox<Playlist>('playlist');
  await Hive.openBox<FavoriteModel>('favorite');
   // Initialize the PlaylistController and load playlists from Hive
  
  runApp(
    const RootWidgetPage(),
  );
}

