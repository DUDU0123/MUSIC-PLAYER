import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/playlist/add_songs_in_playlist_from_selecting_songs.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class PlaylistSongListPage extends StatefulWidget {
  const PlaylistSongListPage({
    super.key,
    required this.playlistName,
    required this.playlistId,
    required this.favoriteController,
    required this.songModel,
    this.playlistSongsList, required this.audioController,
  });
  final String playlistName;
  final int playlistId;
  final FavoriteController favoriteController;
  final AllMusicsModel songModel;
  final List<AllMusicsModel>? playlistSongsList;
  final AudioController audioController;

  @override
  State<PlaylistSongListPage> createState() => _PlaylistSongListPageState();
}

class _PlaylistSongListPageState extends State<PlaylistSongListPage> {
  PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    log("ID OF PLAYLIST: ${widget.playlistId} and PLAYLIST NAME: ${widget.playlistName}");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: widget.playlistName,
          actions: [
            GetBuilder<PlaylistController>(
                init: playlistController,
                builder: (controller) {
                  return IconButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddSongInPlaylistFromSelectingSongs(
                            playListID: widget.playlistId,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      color: kRed,
                      size: 30.sp,
                    ),
                  );
                }),
            TextButton(
              onPressed: () {
                // need to send the list of song in the playlist
                if (widget.playlistSongsList != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SongEditPage(
                        song: widget.songModel,
                        favoriteController: widget.favoriteController,
                        pageType: PageTypeEnum.playListPage,
                        songList: widget.playlistSongsList!,
                      ),
                    ),
                  );
                }
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
      body: widget.playlistSongsList != null
          ? widget.playlistSongsList!.isNotEmpty
              ? ListView.builder(
                  itemCount: widget.playlistSongsList!.length,
                  //widget.playlistSongsList!.length,
                  itemBuilder: (context, index) {
                    //log(playlistList!.length.toString());
                    if (index < widget.playlistSongsList!.length) {
                      // log(playlistList!.length.toString());
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: MusicTileWidget(
                          songModel: widget.songModel,
                          favoriteController: widget.favoriteController,
                          musicUri: widget.playlistSongsList![index].musicUri,
                          // audioPlayer: audioPlayer,
                          // musicBox: musicBox,
                          // isPlaying: isPlaying,
                          albumName:
                              widget.playlistSongsList![index].musicAlbumName,
                          artistName:
                              widget.playlistSongsList![index].musicArtistName,
                          songTitle: widget.playlistSongsList![index].musicName,
                          songFormat:
                              widget.playlistSongsList![index].musicFormat,
                          songSize: widget.audioController.convertToMBorKB(widget.playlistSongsList![index].musicFileSize)
                             ,
                          songPathIndevice: widget
                              .playlistSongsList![index].musicPathInDevice,
                          pageType: PageTypeEnum.playListPage,
                          songId: widget.playlistSongsList![index].id,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              : const DefaultCommonWidget(
                  text: "No songs available",
                )
          : const SizedBox(),
    );
  }
}
