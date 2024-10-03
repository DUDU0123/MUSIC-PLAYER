import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/playlist_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/views/common_widgets/center_title_appbar_common_widget.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/playlist/pages/playlist_song_list_page.dart';

class AddSongInPlaylistFromSelectingSongs extends StatefulWidget {
  const AddSongInPlaylistFromSelectingSongs({
    super.key,
    required this.playlist,
    this.instance,
  });
  final Playlist playlist;
  final PlaylistSongListPageState? instance;
  @override
  State<AddSongInPlaylistFromSelectingSongs> createState() =>
      _AddSongInPlaylistFromSelectingSongsState();
}

class _AddSongInPlaylistFromSelectingSongsState
    extends State<AddSongInPlaylistFromSelectingSongs> {
  @override
  void initState() {
    PlaylistController.to.addingAllSongsToList();
    super.initState();
  }

  bool isSelected = false;
  bool isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CenterTitleAppBarCommonWidget(
          appBarText: "Select Songs",
          actions: [
            TextButton(
              onPressed: toggleSelection,
              child: TextWidgetCommon(
                text: (isAllSelected || isSelected) ? "Undo" : "Select All",
                fontSize: 16.sp,
                color: kRed,
              ),
            ),
          ],
        ),
      ),
      body: AllFiles.files.value.isNotEmpty
          ? Stack(
              children: [
                GetBuilder<PlaylistController>(
                    init: PlaylistController.to,
                    builder: (controller) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 10.w),
                        itemCount:
                            controller.fullSongListToAddToPlaylist.value.length,
                        itemBuilder: (context, index) {
                          AllMusicsModel musicList = controller
                              .fullSongListToAddToPlaylist.value[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            child: CheckboxListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              checkColor: kWhite,
                              activeColor: kRed,
                              tileColor: kTileColor,
                              title: TextWidgetCommon(
                                overflow: TextOverflow.ellipsis,
                                text: musicList.musicName,
                                fontSize: 16.sp,
                                color: kWhite,
                              ),
                              subtitle: TextWidgetCommon(
                                overflow: TextOverflow.ellipsis,
                                text:
                                    "${musicList.musicArtistName == "<unknown>" ? "Unknown Artisit" : musicList.musicArtistName}-${musicList.musicAlbumName == "<unknown>" ? "Unknown Album" : musicList.musicAlbumName}",
                                fontSize: 10.sp,
                                color: kGrey,
                              ),
                              value: musicList.musicSelected ?? false,
                              onChanged: (value) {
                                setState(() {
                                  musicList.musicSelected = value ?? false;
                                  isSelected = controller
                                      .fullSongListToAddToPlaylist.value
                                      .any((checkbox) =>
                                          checkbox.musicSelected == true);
                                });
                              },
                            ),
                          );
                        },
                      );
                    }),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: GetBuilder<PlaylistController>(
                      init: PlaylistController.to,
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () {
                            List<AllMusicsModel> selectedSongList = controller
                                .fullSongListToAddToPlaylist.value
                                .where((music) => music.musicSelected == true)
                                .toList();

                            PlaylistController.to.addSongsToDBPlaylist(
                              playlist: widget.playlist,
                              playlistNewSongsToAdd: selectedSongList,
                            );
                            widget.instance?.refresh();
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kMenuBtmSheetColor,
                            ),
                            height: 50,
                            width: 100,
                            child: Center(
                              child: TextWidgetCommon(
                                text: "Add",
                                fontSize: 16.sp,
                                color: isSelected ? kWhite : kGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )
          : const DefaultCommonWidget(text: "No songs available"),
    );
  }

  toggleSelection() {
    setState(() {
      if (isAllSelected || isSelected) {
        deselectAllSongs();
      } else {
        selectAllSongs();
      }
    });
  }

  selectAllSongs() {
    for (var element
        in PlaylistController.to.fullSongListToAddToPlaylist.value) {
      setState(() {
        element.musicSelected = true;
        isSelected = true;
        isAllSelected = true;
      });
    }
  }

  deselectAllSongs() {
    for (var element
        in PlaylistController.to.fullSongListToAddToPlaylist.value) {
      setState(() {
        element.musicSelected = false;
        isSelected = false;
        isAllSelected = false;
      });
    }
  }
}
