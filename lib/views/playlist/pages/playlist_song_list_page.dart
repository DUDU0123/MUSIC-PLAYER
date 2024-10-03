import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_play_page_open.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/playlist/pages/add_songs_in_playlist_from_selecting_songs.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class PlaylistSongListPage extends StatefulWidget {
  const PlaylistSongListPage({
    super.key,
    required this.songModel,
    required this.playlist,
  });
  final AllMusicsModel songModel;
  final Playlist playlist;
  @override
  State<PlaylistSongListPage> createState() => PlaylistSongListPageState();
}

class PlaylistSongListPageState extends State<PlaylistSongListPage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: widget.playlist.name,
          actions: [
            GetBuilder<PlaylistController>(
                init: PlaylistController.to,
                builder: (controller) {
                  return IconButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddSongInPlaylistFromSelectingSongs(
                            instance: this,
                            playlist: widget.playlist,
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
                if (widget.playlist.playlistSongs != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SongEditPage(
                        song: widget.songModel,
                        pageType: PageTypeEnum.playListPage,
                        songList: widget.playlist.playlistSongs!,
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
      body: widget.playlist.playlistSongs != null
          ? widget.playlist.playlistSongs!.isNotEmpty
              ? 
              // ValueListenableBuilder(
              //     valueListenable: AllFiles.files,
              //     builder: (BuildContext context, List<AllMusicsModel> songs,
              //         Widget? _) {
              //       return 
                    GetBuilder<PlaylistController>(
                        init: PlaylistController.to,
                        builder: (controller) {
                          return ListView.builder(
                            itemCount: widget.playlist.playlistSongs!.length,
                            itemBuilder: (context, index) {
                              if (index <
                                  widget.playlist.playlistSongs!.length) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: MusicTileWidget(
                                    onTap: () {
                                      AudioController.to.isPlaying.value = true;
                                      AudioController.to.playSong(widget
                                          .playlist.playlistSongs![index]);
                                      musicPlayPageOpenPage(
                                        context: context,
                                        song: widget
                                            .playlist.playlistSongs![index],
                                      );
                                    },
                                    playListID: widget.playlist.id,
                                    songModel:
                                        widget.playlist.playlistSongs![index],
                                    musicUri: widget.playlist
                                        .playlistSongs![index].musicUri,
                                    albumName: widget.playlist
                                        .playlistSongs![index].musicAlbumName,
                                    artistName: widget.playlist
                                        .playlistSongs![index].musicArtistName,
                                    songTitle: widget.playlist
                                        .playlistSongs![index].musicName,
                                    songFormat: widget.playlist
                                        .playlistSongs![index].musicFormat,
                                    songSize:
                                        AppUsingCommonFunctions.convertToMBorKB(
                                            widget
                                                .playlist
                                                .playlistSongs![index]
                                                .musicFileSize),
                                    songPathIndevice: widget
                                        .playlist
                                        .playlistSongs![index]
                                        .musicPathInDevice,
                                    pageType: PageTypeEnum.playListPage,
                                    songId: widget
                                        .playlist.playlistSongs![index].id,
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          );
                        })
                  // })
              : const DefaultCommonWidget(
                  text: "No songs available",
                )
          : const SizedBox(),
    );
  }
}
