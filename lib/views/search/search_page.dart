import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/search_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/common_widgets/textfield_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class SearchPage extends StatelessWidget {
  SearchPage(
      {super.key,
      required this.favoriteController,
      required this.audioController});

  final FavoriteController favoriteController;
  final AudioController audioController;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  

  @override
  Widget build(BuildContext context) {
    log("isPlaying: ${audioController.isPlaying.value}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTileColor,
        automaticallyImplyLeading: false,
        title: GetBuilder<SearchFilterController>(
          init: SearchFilterController(),
          builder: (searchFilterController) {
            return TextFieldCommonWidget(
              focusNode: searchFocusNode,
              onChanged: (value) {
                searchFilterController.filterSongs(value);
              },
              hintStyle: TextStyle(
                  color: kLightGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.sp),
              keyboardType: TextInputType.text,
              controller: searchController,
              hintText: "Search",
              labelText: "",
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: TextWidgetCommon(
              text: "Cancel",
              fontSize: 16.sp,
              color: kRed,
            ),
          ),
        ],
      ),
      body: GetBuilder<SearchFilterController>(
          init: SearchFilterController(),
          builder: (searchFilterController) {
            return ListView.builder(
              itemCount: searchFilterController.filteredSongs.value.length,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              itemBuilder: (context, index) {
                var searchSong = searchFilterController.filteredSongs.value;
                return MusicTileWidget(
                  songTitle: searchSong[index].musicName,
                  songFormat: searchSong[index].musicFormat,
                  songSize: searchSong[index].musicFileSize.toString(),
                  songPathIndevice: searchSong[index].musicPathInDevice,
                  pageType: PageTypeEnum.searchPage,
                  songId: searchSong[index].id,
                  songModel: searchSong[index],
                  musicUri: searchSong[index].musicUri,
                  albumName: searchSong[index].musicAlbumName,
                  artistName: searchSong[index].musicArtistName,
                  audioController: audioController,
                  favoriteController: favoriteController,
                );
              },
            );
          }),
    );
  }
}
