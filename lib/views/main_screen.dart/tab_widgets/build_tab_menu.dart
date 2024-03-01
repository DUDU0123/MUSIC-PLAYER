//   import 'package:flutter/material.dart';
// import 'package:music_player/constants/colors.dart';
// import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

// Widget buildTab(TabType tabType, String text, TabType currentTabType) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           currentTabType = tabType;
//           _pageController.animateToPage(
//             tabType.index,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.linear,
//           );
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.sp),
//           border: Border(
//             bottom: BorderSide(
//               color:
//                   currentTabType == tabType ? kTileColor : Colors.transparent,
//               width: 2.0,
//             ),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//             color: currentTabType == tabType ? kRed : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/song_edit_page.dart';

class BuildTabMenu {
 static List<PopupMenuItem<TopMenuItemEnum>> listPopUpMenuItem({
    required AudioController audioController,
    required FavoriteController favoriteController,
    required AllMusicsModel currentSong,
    required PageTypeEnum pageTypeEnum,
    required TabType currentTabType,
  }) {
    final showAllOptions = AppUsingCommonFunctions.shouldShowAllOptions(
        pageTypeEnum, currentTabType);

    if (showAllOptions && audioController.allSongsListFromDevice.isNotEmpty) {
      return [
        PopupMenuItem(
          value: TopMenuItemEnum.sortSong,
          child: TextWidgetCommon(
            text: "Select Sort Method",
            fontSize: 14.sp,
            color: kWhite,
            fontWeight: FontWeight.normal,
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Get.to(() => SongEditPage(
                  audioController: audioController,
                  favoriteController: favoriteController,
                  pageType: PageTypeEnum.homePage,
                  songList: audioController.allSongsListFromDevice,
                  song: currentSong,
                ));
          },
          value: TopMenuItemEnum.manageSong,
          child: TextWidgetCommon(
            text: "Manage Songs",
            fontSize: 14.sp,
            color: kWhite,
            fontWeight: FontWeight.normal,
          ),
        ),
        PopupMenuItem(
          value: TopMenuItemEnum.settings,
          child: TextWidgetCommon(
            text: "Settings",
            fontSize: 14.sp,
            color: kWhite,
            fontWeight: FontWeight.normal,
          ),
        ),
      ];
    } else {
      return [
        PopupMenuItem(
          value: TopMenuItemEnum.settings,
          child: TextWidgetCommon(
            text: "Settings",
            fontSize: 14.sp,
            color: kWhite,
            fontWeight: FontWeight.normal,
          ),
        ),
      ];
    }
  }
}
