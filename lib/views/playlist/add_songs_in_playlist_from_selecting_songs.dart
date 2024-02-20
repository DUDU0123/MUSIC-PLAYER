import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/center_title_appbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/playlist/playlist_song_list_page.dart';

class AddSongInPlaylistFromSelectingSongs extends StatefulWidget {
  const AddSongInPlaylistFromSelectingSongs({super.key});

  @override
  State<AddSongInPlaylistFromSelectingSongs> createState() =>
      _AddSongInPlaylistFromSelectingSongsState();
}

class _AddSongInPlaylistFromSelectingSongsState
    extends State<AddSongInPlaylistFromSelectingSongs> {
  bool isSelected = false;
  bool isAllSelected = false;
  final musicBox = Hive.box<AllMusicsModel>('musics');
  List<AllMusicsModel> notAddedMusicList = [];
  @override
  void initState() {
    notAddedMusicList = musicBox.values.map((music) {
      return AllMusicsModel(
        musicSelected: music.musicSelected,
        id: music.id,
        musicAlbumName: music.musicAlbumName,
        musicArtistName: music.musicArtistName,
        musicFileSize: music.musicFileSize,
        musicFormat: music.musicFormat,
        musicName: music.musicName,
        musicPathInDevice: music.musicPathInDevice,
        musicUri: music.musicUri,
      );
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
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
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
            itemCount: notAddedMusicList.length,
            itemBuilder: (context, index) {
              AllMusicsModel musicList = notAddedMusicList[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                        "${musicList.musicArtistName}-${musicList.musicAlbumName}",
                    fontSize: 10.sp,
                    color: kGrey,
                  ),
                  value: musicList.musicSelected ?? false,
                  onChanged: (value) {
                    setState(() {
                      musicList.musicSelected = value ?? false;
                      isSelected = notAddedMusicList
                          .any((checkbox) => checkbox.musicSelected == true);
                    });
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 20.h,
            left: kScreenWidth / 2 - 50,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(
                    context,
                    notAddedMusicList
                        .where((music) => music.musicSelected == true)
                        .toList());
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
            ),
          ),
        ],
      ),
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
    for (var element in notAddedMusicList) {
      setState(() {
        element.musicSelected = true;
        isSelected = true;
        isAllSelected = true;
      });
    }
  }

  deselectAllSongs() {
    for (var element in notAddedMusicList) {
      setState(() {
        element.musicSelected = false;
        isSelected = false;
        isAllSelected = false;
      });
    }
  }
}
