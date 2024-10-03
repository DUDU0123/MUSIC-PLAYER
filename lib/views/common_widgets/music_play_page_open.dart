import 'package:flutter/material.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/music_view/music_play_page.dart';

Future<dynamic> musicPlayPageOpenPage({
  required BuildContext context,
  required AllMusicsModel song,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return MusicPlayPage(
        songModel: song,
      );
    },
  );
}
