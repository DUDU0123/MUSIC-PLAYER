import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/playlist/add_songs_in_playlist_from_selecting_songs.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class PlaylistSongListPage extends StatefulWidget {
  PlaylistSongListPage({
    super.key,
    required this.playlistName,
    required this.playlistId, required this.favoriteController,
  });
  final String playlistName;
  final int playlistId;
  final FavoriteController favoriteController;

  @override
  State<PlaylistSongListPage> createState() => _PlaylistSongListPageState();
}

class _PlaylistSongListPageState extends State<PlaylistSongListPage> {
  List<AllMusicsModel>? playlistSongsList;

  List<Playlist>? playlistList;

  @override
  void initState() {
    getPlayList();
    super.initState();
  }

  void addPlaylist(Playlist playlist) async {
    final playlistBox = await Hive.openBox<Playlist>('playlist');
    playlistBox.add(playlist);
  }

  PlaylistController playlistController = Get.put(PlaylistController());

  Future<void> getPlayList() async {
    playlistList = await playlistController.getPlaylists();
    playlistSongsList =
        await playlistController.getPlayListSongs(widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    // retrieving data
    Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
    final List<Playlist> currentPlaylistSongList = playlistBox.values.toList();

    Future<void> addPlaylistSongs(List<AllMusicsModel> newSongs) async {
      final List<AllMusicsModel> existingSongs = currentPlaylistSongList
          .expand((playlist) => playlist.playlistSongs ?? <AllMusicsModel>[])
          .toList();

      // Check if a playlist with the same name already exists
      final existingPlaylist = currentPlaylistSongList.firstWhere(
        (playlist) => playlist.name == widget.playlistName,
        orElse: () => Playlist(name: ''),
      );

      if (existingPlaylist.name.isNotEmpty) {
        // Playlist with the same name exists, update it
        final List<AllMusicsModel> uniqueNewSongs = newSongs
            .where((newSong) => !existingSongs
                .any((existingSong) => existingSong.id == newSong.id))
            .toList();

        if (uniqueNewSongs.isNotEmpty) {
          existingPlaylist.playlistSongs?.addAll(uniqueNewSongs);
          await existingPlaylist.save(); // Save the updated playlist
        } else {
          snackBarCommonWidget(context,
              contentText: "Already available in this playlist");
        }
      } else {
        // Playlist with the same name doesn't exist, create a new playlist
        final playlist = Playlist(
            playlistSongs: newSongs,
            name: widget.playlistName,
            id: widget.playlistId);
        addPlaylist(playlist);
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: widget.playlistName,
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddSongInPlaylistFromSelectingSongs(
                      playListID: widget.playlistId,
                    ),
                  ),
                );
                // playlistSongsList =
                //     await Navigator.of(context).push<List<AllMusicsModel>>(
                //   MaterialPageRoute(
                //     builder: (context) => AddSongInPlaylistFromSelectingSongs(
                //       playListID: widget.playlistId,
                //     ),
                //   ),
                // );

                // // Add the playlist to Hive
                // if (playlistSongsList != null &&
                //     playlistSongsList!.isNotEmpty) {
                //   addPlaylistSongs(playlistSongsList!);
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PlaylistSongListPage(
                //         playlistId: widget.playlistId,
                //         playlistName: widget.playlistName,
                //       ),
                //     ),
                //   );
                // }
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
      body:
          // playlistList!=null?
          //  playlistList!.isEmpty
          //     ? DefaultWidget()
          //     : ListView.builder(
          //         itemCount: playlistList!.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           Playlist playlistModel = playlistList![index];
          //           return Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               if (playlistModel.playlistSongs != null)
          //                 for (AllMusicsModel music in playlistModel.playlistSongs!)
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15.w),
          //   child: MusicTileWidget(
          //     // audioPlayer: audioPlayer,
          //     // musicBox: musicBox,
          //     // isPlaying: isPlaying,
          //     albumName: music.musicAlbumName,
          //     artistName: music.musicArtistName,
          //     songTitle: music.musicName,
          //     songFormat: music.musicFormat,
          //     songSize: music.musicFileSize.toString(),
          //     songPathIndevice: music.musicPathInDevice,
          //     pageType: PageTypeEnum.playListPage,
          //     songId: music.id,
          //   ),
          // ),
          //             ],
          //           );
          //         },
          //       ):SizedBox(),
          playlistSongsList != null
              ? playlistSongsList!.isEmpty
                  ? DefaultCommonWidget(text: "No songs available",)
                  : ListView.builder(
                      itemCount: playlistSongsList!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: MusicTileWidget(
                            favoriteController: widget.favoriteController,
                            musicUri: playlistSongsList![index].musicUri,
                            // audioPlayer: audioPlayer,
                            // musicBox: musicBox,
                            // isPlaying: isPlaying,
                            albumName: playlistSongsList![index].musicAlbumName,
                            artistName:
                                playlistSongsList![index].musicArtistName,
                            songTitle: playlistSongsList![index].musicName,
                            songFormat: playlistSongsList![index].musicFormat,
                            songSize: playlistSongsList![index]
                                .musicFileSize
                                .toString(),
                            songPathIndevice:
                                playlistSongsList![index].musicPathInDevice,
                            pageType: PageTypeEnum.playListPage,
                            songId: playlistSongsList![index].id,
                          ),
                        );
                      },
                    )
              : SizedBox(),

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
