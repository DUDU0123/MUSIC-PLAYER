// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:music_player/constants/colors.dart';
// import 'package:music_player/controllers/all_music_controller.dart';
// import 'package:music_player/controllers/audio_controller.dart';
// import 'package:music_player/controllers/favourite_controller.dart';
// import 'package:music_player/controllers/functions_default.dart';
// import 'package:music_player/controllers/playlist_controller.dart';
// import 'package:music_player/models/allmusics_model.dart';
// import 'package:music_player/views/common_widgets/default_common_widget.dart';
// import 'package:music_player/views/common_widgets/music_tile_widget.dart';
// import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
// import 'package:music_player/views/common_widgets/text_widget_common.dart';
// import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
// import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

// class ArtistSongListPage extends StatefulWidget {
//   const ArtistSongListPage({
//     super.key,
//     required this.artistName,
//     required this.artistSongs,
//     required this.favoriteController,
//     required this.songModel,
//     required this.audioController,
//     required this.allMusicController,
//     required this.playlistController,
//   });
//   final String artistName;
//   final FavoriteController favoriteController;
//   final List<AllMusicsModel> artistSongs;
//   final AllMusicsModel songModel;
//   final AudioController audioController;
//   final AllMusicController allMusicController;
//   final PlaylistController playlistController;

//   @override
//   State<ArtistSongListPage> createState() => _ArtistSongListPageState();
// }

// class _ArtistSongListPageState extends State<ArtistSongListPage> {
//   @override
//   void initState() {
//     //widget.allMusicController.fetchAllArtistMusicData();
//     widget.audioController.getAllSongs();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: SideTitleAppBarCommon(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             appBarText: widget.artistName == '<unknown>'
//                 ? "Unknown Artist"
//                 : widget.artistName,
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   // need to send the song details list to the song edit page from here
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => SongEditPage(
//                         playlistController: widget.playlistController,
//                         audioController: widget.audioController,
//                         song: widget.songModel,
//                         favoriteController: widget.favoriteController,
//                         pageType: PageTypeEnum.songEditPage,
//                         songList: widget.artistSongs,
//                       ),
//                     ),
//                   );
//                 },
//                 child: TextWidgetCommon(
//                   text: "Edit",
//                   color: kRed,
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: widget.artistSongs.isEmpty
//             ? const DefaultCommonWidget(text: "No songs available")
//             : FutureBuilder(
//                 future: widget.allMusicController.fetchAllArtistMusicData(),
//                 builder: (context, snapshot) {
//                   return GetBuilder<AllMusicController>(
//                       init: widget.allMusicController,
//                       builder: (controller) {
//                         return ListView.builder(
//                           itemCount: widget.artistSongs.length,
//                           padding: EdgeInsets.symmetric(
//                               vertical: 15.h, horizontal: 10.w),
//                           itemBuilder: (context, index) {
//                             return MusicTileWidget(
//                               onTap: () {
//                                 widget.audioController
//                                     .playSong(widget.artistSongs[index]);
//                               },
//                               audioController: widget.audioController,
//                               songModel: widget.artistSongs[index],
//                               favoriteController: widget.favoriteController,
//                               musicUri: widget.artistSongs[index].musicUri,
//                               songId: widget.artistSongs[index].id,
//                               pageType: PageTypeEnum.artistSongListPage,
//                               albumName:
//                                   widget.artistSongs[index].musicAlbumName,
//                               artistName:
//                                   widget.artistSongs[index].musicArtistName,
//                               songTitle: widget.artistSongs[index].musicName,
//                               songFormat: widget.artistSongs[index].musicFormat,
//                               songPathIndevice:
//                                   widget.artistSongs[index].musicPathInDevice,
//                               songSize: AppUsingCommonFunctions.convertToMBorKB(
//                                   widget.artistSongs[index].musicFileSize),
//                             );
//                           },
//                         );
//                       });
//                 }));
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/details.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/artist/music_artist_page.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class ArtistSongListPage extends StatefulWidget {
  const ArtistSongListPage({
    super.key,
    required this.artistName,
    required this.artistSongs,
    required this.favoriteController,
    required this.songModel,
    required this.audioController,
    required this.allMusicController,
    required this.playlistController,
    required this.instance,
  });
  final String artistName;
  final FavoriteController favoriteController;
  final List<AllMusicsModel> artistSongs;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final AllMusicController allMusicController;
  final PlaylistController playlistController;
  final MusicArtistPageState instance;

  @override
  State<ArtistSongListPage> createState() => _ArtistSongListPageState();
}

class _ArtistSongListPageState extends State<ArtistSongListPage> {
  @override
  void initState() {
    widget.allMusicController.fetchAllArtistMusicData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SideTitleAppBarCommon(
            onPressed: () {
              // widget.instance.refreshUI();
              Navigator.pop(context);
            },
            appBarText: widget.artistName == '<unknown>'
                ? "Unknown Artist"
                : widget.artistName,
            actions: [
              TextButton(
                onPressed: () {
                  // need to send the song details list to the song edit page from here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SongEditPage(
                        playlistController: widget.playlistController,
                        audioController: widget.audioController,
                        song: widget.songModel,
                        favoriteController: widget.favoriteController,
                        pageType: PageTypeEnum.songEditPage,
                        songList: widget.allMusicController.getSongsOfArtist(
                            AllFiles.files.value, widget.artistName),
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
        body: widget.artistSongs.isEmpty
            ? const DefaultCommonWidget(text: "No songs available")
            : ValueListenableBuilder(
                valueListenable: AllFiles.files,
                builder: (BuildContext context, List<AllMusicsModel> songs,
                    Widget? _) {
                  final List<AllMusicsModel> artistSongs = widget
                      .allMusicController
                      .getSongsOfArtist(songs, widget.artistName);
                  return ListView.builder(
                    itemCount: artistSongs.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    itemBuilder: (context, index) {
                      //   String artistName = artist.keys.elementAt(index);
                      // Getting artistSongs

                      return MusicTileWidget(
                        onTap: () {
                          widget.audioController.playSong(artistSongs[index]);
                        },
                        audioController: widget.audioController,
                        songModel: artistSongs[index],
                        favoriteController: widget.favoriteController,
                        musicUri: artistSongs[index].musicUri,
                        songId: artistSongs[index].id,
                        pageType: PageTypeEnum.artistSongListPage,
                        albumName: artistSongs[index].musicAlbumName,
                        artistName: artistSongs[index].musicArtistName,
                        songTitle: artistSongs[index].musicName,
                        songFormat: artistSongs[index].musicFormat,
                        songPathIndevice: artistSongs[index].musicPathInDevice,
                        songSize: AppUsingCommonFunctions.convertToMBorKB(
                            artistSongs[index].musicFileSize),
                      );
                    },
                  );
                }));
  }
}
