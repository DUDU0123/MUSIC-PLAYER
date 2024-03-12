import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_play_page_open.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

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
  });
  final String artistName;
  final FavoriteController favoriteController;
  final List<AllMusicsModel> artistSongs;
  final AllMusicsModel songModel;
  final AudioController audioController;
  final AllMusicController allMusicController;
  final PlaylistController playlistController;

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
                Get.back();
              },
              child: TextWidgetCommon(
                text: "Done",
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
                    return MusicTileWidget(
                      onTap: () {
                        widget.audioController.isPlaying.value = true;
                        widget.audioController.playSong(artistSongs[index]);
                        musicPlayPageOpenPage(
                          context: context,
                          song: artistSongs[index],
                          allMusicController: widget.allMusicController,
                          favoriteController: widget.favoriteController,
                          audioController: widget.audioController,
                        );
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
              }),
    );
  }
}
