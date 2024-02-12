import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/center_title_appbar_common_widget.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/widgets/bottom_settings_widget.dart';
import 'package:music_player/views/song_edit_page.dart/widgets/icon_text_widget.dart';

class CheckBoxModel {
  final String title;
  final String subtitle;
  bool? selected;
  CheckBoxModel({
    required this.title,
    required this.subtitle,
    required this.selected,
  });
}

class SongEditPage extends StatefulWidget {
  const SongEditPage({
    super.key,
    required this.pageType,
  });

  // final String songName;
  // final String artistName;
  // final String albumName;
  // final String songFormat;
  // final String songSize;
  // final String songPathIndevice;
  final PageTypeEnum pageType;

  @override
  State<SongEditPage> createState() => _SongEditPageState();
}

class _SongEditPageState extends State<SongEditPage> {
  //Here need to have the song list
  List<CheckBoxModel> list = [];
  @override
  void initState() {
    list.addAll({
      CheckBoxModel(
          title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
      CheckBoxModel(
          title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
      CheckBoxModel(
          title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
      CheckBoxModel(
          title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
      CheckBoxModel(
          title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
    });
    super.initState();
  }

  bool? isSelected = false;
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
              onPressed: () {},
              child: TextWidgetCommon(
                text: "Select All",
                fontSize: 16.sp,
                color: kRed,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: CheckboxListTile(
              checkColor: kWhite,
              activeColor: kRed,
              tileColor: kTileColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: TextWidgetCommon(
                text: list[index].title,
                fontSize: 17.sp,
                color: kWhite,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: TextWidgetCommon(
                text: list[index].subtitle,
                fontSize: 10.sp,
                color: kGrey,
              ),
              value: list[index].selected,
              onChanged: (value) {
                setState(() {
                  list[index].selected = value;
                  isSelected =
                      list.any((checkbox) => checkbox.selected == true);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomSettingsWidget(
        isSelected: isSelected,
        pageType: widget.pageType,
      ),
    );
  }
}