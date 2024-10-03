import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/controllers/search_controller.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_play_page_open.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/common_widgets/textfield_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    // Call filterSongs with an empty query to display all songs initially
    SearchFilterController searchFilterController =
        Get.put(SearchFilterController());
    searchFilterController.filterSongs('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
    super.initState();
  }

  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
                hintText: "Search",
                labelText: "",
              );
            }),
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
            return searchFilterController.filteredSongs.isEmpty
                ? const DefaultCommonWidget(text: "Song does not exist")
                : ListView.builder(
                    itemCount:
                        searchFilterController.filteredSongs.value.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    itemBuilder: (context, index) {
                      var searchSong =
                          searchFilterController.filteredSongs.value;
                      return MusicTileWidget(
                        onTap: () {
                          AudioController.to.isPlaying.value = true;
                          AudioController.to.playSong(
                              searchFilterController.filteredSongs[index]);
                          musicPlayPageOpenPage(
                            context: context,
                            song: searchFilterController.filteredSongs[index],
                          );
                        },
                        songTitle: searchSong[index].musicName,
                        songFormat: searchSong[index].musicFormat,
                        songSize: AppUsingCommonFunctions.convertToMBorKB(
                            searchSong[index].musicFileSize),
                        songPathIndevice: searchSong[index].musicPathInDevice,
                        pageType: PageTypeEnum.searchPage,
                        songId: searchSong[index].id,
                        songModel: searchSong[index],
                        musicUri: searchSong[index].musicUri,
                        albumName: searchSong[index].musicAlbumName,
                        artistName: searchSong[index].musicArtistName,
                      );
                    },
                  );
          }),
    );
  }
}
