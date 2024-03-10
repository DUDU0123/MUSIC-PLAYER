import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/models/recently_played_model.dart';
import 'package:music_player/root_widget_page.dart';
import 'package:path_provider/path_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(AllMusicsModelAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  Hive.registerAdapter(FavoriteModelAdapter());
  Hive.registerAdapter(RecentlyPlayedModelAdapter());
  await Hive.openBox<AllMusicsModel>('musics');
  await Hive.openBox<Playlist>('playlist');
  await Hive.openBox<FavoriteModel>('favorite');
  await Hive.openBox<RecentlyPlayedModel>('recent');
  runApp(
    const RootWidgetPage(),
  );
}
