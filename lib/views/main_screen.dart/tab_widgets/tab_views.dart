import 'package:flutter/material.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/playlist/pages/music_playlist_page.dart';

class TabViewList {
  static List<Widget> tabViews({

    required AllMusicsModel currentSong,
  }) {
    return [
      MusicHomePage(

      ),
      MusicArtistPage(
        songModel: currentSong,
      ),
      MusicAlbumPage(
        songModel: currentSong,
      ),
      MusicPlaylistPage(
        songModel: currentSong,
      ),
    ];
  }
}
