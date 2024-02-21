import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/default_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/playlist/add_songs_in_playlist_from_selecting_songs.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class PlaylistSongListPage extends StatelessWidget {
  PlaylistSongListPage({
    super.key,
    required this.isPlaying,
    required this.audioPlayer,
    required this.musicBox,
  });
  List<AllMusicsModel>? playlistSongsList;
  final bool isPlaying;
  final AudioPlayer audioPlayer;
  final Box<AllMusicsModel> musicBox;

  void addPlaylist(Playlist playlist) async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    playlistBox.add(playlist);
  }

  // Retrieve all playlists from Hive
  Future<List<Playlist>> getPlaylists() async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    return playlistBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    // retrieving data
    Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
    final List<Playlist> currentPlaylistSongList = playlistBox.values.toList();
    Future<void> addPlaylistSongs(List<AllMusicsModel> newSongs) async {
      final List<AllMusicsModel> existingSongs = currentPlaylistSongList
          .expand((playlist) =>
              playlist.playlistSongs ??
              <AllMusicsModel>[]) // Specify the type explicitly
          .toList();
      // Filter out the songs that are already in the playlist
      final List<AllMusicsModel> uniqueNewSongs = newSongs
          .where((newSong) => !existingSongs
              .any((existingSong) => existingSong.id == newSong.id))
          .toList();
      if (uniqueNewSongs.isNotEmpty) {
        final playlist = Playlist(playlistSongs: uniqueNewSongs, name: "");
        addPlaylist(playlist);
      }else{
        snackBarCommonWidget(context, contentText: "Already available in this playlist");
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: "Playlist 1",
          actions: [
            IconButton(
              onPressed: () async {
                playlistSongsList =
                    await Navigator.of(context).push<List<AllMusicsModel>>(
                  MaterialPageRoute(
                    builder: (context) => AddSongInPlaylistFromSelectingSongs(),
                  ),
                );

                // Add the playlist to Hive
                if (playlistSongsList != null &&
                    playlistSongsList!.isNotEmpty) {
                  
                  await addPlaylistSongs(playlistSongsList!);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistSongListPage(
                        audioPlayer: audioPlayer,
                        musicBox: musicBox,
                        isPlaying: isPlaying,
                      ),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.add,
                color: kRed,
                size: 30.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                // need to send the list of song in the playlist
                // if(playlistSongsList!=null){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SongEditPage(
                      pageType: PageTypeEnum.playListPage,
                      songList: [],
                    ),
                  ),
                );
              },
              child: TextWidgetCommon(
                text: "Edit",
                color: kRed,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
      body: currentPlaylistSongList.isEmpty
          ? DefaultWidget()
          : ListView.builder(
              itemCount: currentPlaylistSongList.length,
              itemBuilder: (BuildContext context, int index) {
                Playlist playlistModel = currentPlaylistSongList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (playlistModel.playlistSongs != null)
                      for (AllMusicsModel music in playlistModel.playlistSongs!)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: MusicTileWidget(
                            audioPlayer: audioPlayer,
                            musicBox: musicBox,
                            isPlaying: isPlaying,
                            albumName: music.musicAlbumName,
                            artistName: music.musicArtistName,
                            songTitle: music.musicName,
                            songFormat: music.musicFormat,
                            songSize: music.musicFileSize.toString(),
                            songPathIndevice: music.musicPathInDevice,
                            pageType: PageTypeEnum.playListPage,
                            songId: music.id,
                          ),
                        ),
                  ],
                );
              },
            ),

      // Column(
      //   children: [
      //     ListView.builder(
      //       shrinkWrap: true,
      //       itemCount: currentPlaylistSongList[0].playlistSongs != null
      //           ? currentPlaylistSongList[0].playlistSongs!.length
      //           : 0,
      //       padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      //       itemBuilder: (context, index) {
      //         final playlistsss =
      //             currentPlaylistSongList[index].playlistSongs!.map((e) {
      //           return AllMusicsModel(
      //             id: e.id,
      //             musicName: e.musicName,
      //             musicAlbumName: e.musicAlbumName,
      //             musicArtistName: e.musicArtistName,
      //             musicPathInDevice: e.musicPathInDevice,
      //             musicFormat: e.musicFormat,
      //             musicUri: e.musicUri,
      //             musicFileSize: e.musicFileSize,
      //           );
      //         }).toList();
      //         final currentSongs = currentPlaylistSongList[index].playlistSongs;
      //         return currentSongs != null && currentSongs.isNotEmpty
      //             ? MusicTileWidget(

      //                 audioPlayer: audioPlayer,

      //                 musicBox: musicBox,

      //                 songId: currentSongs[index].id,
      //                 isPlaying: isPlaying,
      //                 pageType: PageTypeEnum.playListPage,
      //                 albumName: currentSongs[index].musicAlbumName,
      //                 artistName: currentSongs[index].musicArtistName,
      //                 songTitle: currentSongs[index].musicName,
      //                 songFormat: currentSongs[index].musicFormat,
      //                 songPathIndevice: currentSongs[index].musicPathInDevice,
      //                 songSize: currentSongs[index].musicFileSize.toString(),
      //               )
      //             : null;
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
