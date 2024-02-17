import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/root_widget_page.dart';
import 'package:path_provider/path_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory =
      await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(AllMusicsModelAdapter());
  await Hive.openBox<AllMusicsModel>('musics');
  runApp(
    const RootWidgetPage(),
  );
}

