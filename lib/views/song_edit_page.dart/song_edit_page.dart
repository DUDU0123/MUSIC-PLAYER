import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/center_title_appbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/widgets/bottom_settings_widget.dart';

class SongEditPage extends StatefulWidget {
  const SongEditPage({
    super.key,
    required this.pageType,
    required this.songList,
    required this.favoriteController,
    required this.song,
  });
  final PageTypeEnum pageType;
  final List<AllMusicsModel> songList;
  final FavoriteController favoriteController;
  final AllMusicsModel song;

  @override
  State<SongEditPage> createState() => _SongEditPageState();
}

class _SongEditPageState extends State<SongEditPage> {
  // function to remove song

  bool? isSelected = false;
  bool isAllSelected = false;
  int songID = 0;
  String songName = '';
  @override
  Widget build(BuildContext context) {
    // final kScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CenterTitleAppBarCommonWidget(
          appBarText: "Select Songs",
          actions: [
            TextButton(
              onPressed: toggleSelection,
              child: TextWidgetCommon(
                text: isAllSelected || isSelected! ? "Undo" : "Select All",
                fontSize: 16.sp,
                color: kRed,
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<FavoriteController>(
          init: FavoriteController(),
          builder: (context) {
            return ListView.builder(
              itemCount: widget.songList.length,
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              itemBuilder: (context, index) {
                songID = widget.songList[index].id;
                songName = widget.songList[index].musicName;
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: CheckboxListTile(
                    checkColor: kWhite,
                    activeColor: kRed,
                    tileColor: kTileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: TextWidgetCommon(
                      text: widget.songList[index].musicName,
                      fontSize: 17.sp,
                      color: kWhite,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: TextWidgetCommon(
                      overflow: TextOverflow.ellipsis,
                      text:
                          "${widget.songList[index].musicArtistName == '<unknown>' ? 'Unknown Artist' : widget.songList[index].musicArtistName}-${widget.songList[index].musicAlbumName}",
                      fontSize: 10.sp,
                      color: kGrey,
                    ),
                    value: widget.songList[index].musicSelected ?? false,
                    onChanged: (value) {
                      setState(() {
                        widget.songList[index].musicSelected = value ?? false;
                        isSelected = widget.songList
                            .any((checkbox) => checkbox.musicSelected == true);
                      });
                    },
                  ),
                );
              },
            );
          }),
      bottomNavigationBar: BottomSettingsWidget(
        song: widget.song,
        favoriteController: widget.favoriteController,
        // removeSongFromFavourites: removeSongFromFavourites,
        songList: widget.songList
            .where((song) => song.musicSelected == true)
            .toList(),
        isSelected: isSelected,
        pageType: widget.pageType,
      ),
    );
  }

  toggleSelection() {
    setState(() {
      if (isAllSelected || isSelected!) {
        deselectAllSongs();
      } else {
        selectAllSongs();
      }
    });
  }

  selectAllSongs() {
    for (var element in widget.songList) {
      setState(() {
        element.musicSelected = true;
        isSelected = true;
        isAllSelected = true;
      });
    }
  }

  deselectAllSongs() {
    for (var element in widget.songList) {
      setState(() {
        element.musicSelected = false;
        isSelected = false;
        isAllSelected = false;
      });
    }
  }
}
