import 'package:flutter/material.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/albums/music_album_page.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/home/music_home_page.dart';
import 'package:music_player/views/playlist/music_playlist_page.dart';

class TabViewList {
  static List<Widget> tabViews({
    required AllMusicController allMusicController,
    required FavoriteController favoriteController,
    required AudioController audioController,
    required PlaylistController playlistController,
    required AllMusicsModel currentSong,
  }) {
    return [
      MusicHomePage(
        allMusicController: allMusicController,
        favoriteController: favoriteController,
        audioController: audioController,
      ),
      MusicArtistPage(
        playlistController: playlistController,
        audioController: audioController,
        songModel: currentSong,
        favoriteController: favoriteController,
      ),
      MusicAlbumPage(
        playlistController: playlistController,
        audioController: audioController,
        songModel: currentSong,
        favoriteController: favoriteController,
      ),
      MusicPlaylistPage(
        playlistController: playlistController,
        audioController: audioController,
        songModel: currentSong,
        favoriteController: favoriteController,
      ),
    ];
  }
}
