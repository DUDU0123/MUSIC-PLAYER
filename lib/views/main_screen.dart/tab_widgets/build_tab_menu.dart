import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

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
