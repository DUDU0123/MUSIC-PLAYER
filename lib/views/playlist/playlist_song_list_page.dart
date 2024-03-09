import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/details.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
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
    this.playlistSongsList,
    required this.audioController,
    required this.playlistController,
  });
  final String playlistName;
  final int playlistId;
  final FavoriteController favoriteController;
  final AllMusicsModel songModel;
  final List<AllMusicsModel>? playlistSongsList;
  final AudioController audioController;
  final PlaylistController playlistController;

  @override
  State<PlaylistSongListPage> createState() => PlaylistSongListPageState();
}

class PlaylistSongListPageState extends State<PlaylistSongListPage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var hiveBox = Hive.box<Playlist>('playlist');
    Playlist? selectedPlaylist = hiveBox.get(widget.playlistId);
    log(name: 'PLAYLIST ID FROM LIST PAGE', '${widget.playlistId}');
    log(name: 'PLAYLIST NAME', widget.playlistName);
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
                init: widget.playlistController,
                builder: (controller) {
                  return IconButton(
                    onPressed: () async {
                      log(
                          name: 'NAVIGATING TO ADD PAGE',
                          '${widget.playlistId}');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddSongInPlaylistFromSelectingSongs(
                            instance: this,
                            playlistController: widget.playlistController,
                            audioController: widget.audioController,
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
                        playlistController: widget.playlistController,
                        audioController: widget.audioController,
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
              ? ValueListenableBuilder(
                valueListenable: AllFiles.files,
                builder: (BuildContext context, List<AllMusicsModel> songs, Widget?_) {
                  return GetBuilder<PlaylistController>(
                      init: widget.playlistController,
                      builder: (controller) {
                        return ListView.builder(
                          itemCount: widget.playlistSongsList!.length,
                          itemBuilder: (context, index) {
                            if (index < widget.playlistSongsList!.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: MusicTileWidget(
                                  onTap: () {
                                    widget.audioController
                                        .playSong(widget.playlistSongsList![index]);
                                  },
                                  audioController: widget.audioController,
                                  playListID: widget.playlistId,
                                  songModel: widget.playlistSongsList![index],
                                  favoriteController: widget.favoriteController,
                                  musicUri:
                                      widget.playlistSongsList![index].musicUri,
                                  albumName: widget
                                      .playlistSongsList![index].musicAlbumName,
                                  artistName: widget
                                      .playlistSongsList![index].musicArtistName,
                                  songTitle:
                                      widget.playlistSongsList![index].musicName,
                                  songFormat:
                                      widget.playlistSongsList![index].musicFormat,
                                  songSize: AppUsingCommonFunctions.convertToMBorKB(
                                      widget
                                          .playlistSongsList![index].musicFileSize),
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
                        );
                      });
                }
              )
              : const DefaultCommonWidget(
                  text: "No songs available",
                )
          : const SizedBox(),
    );
  }
}
