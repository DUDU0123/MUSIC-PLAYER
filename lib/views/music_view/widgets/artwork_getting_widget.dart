import 'package:flutter/material.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtWorkWidgetMusicPlayingPage extends StatelessWidget {
  const ArtWorkWidgetMusicPlayingPage({
    super.key,
    required this.songId,
  });
  final int songId;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      type: ArtworkType.AUDIO,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Center(
        child: Icon(
          Icons.music_note,
          size: 200,
          color: kGrey,
        ),
      ),
    );
  }
}