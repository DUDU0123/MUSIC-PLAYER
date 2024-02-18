import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/center_title_appbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/song_edit_page.dart/widgets/bottom_settings_widget.dart';


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
    required this.pageType, required this.songList,
  });
  final PageTypeEnum pageType;
  final List<AllMusicsModel> songList;

  @override
  State<SongEditPage> createState() => _SongEditPageState();
}

class _SongEditPageState extends State<SongEditPage> {
  //Here need to have the song list
  // List<CheckBoxModel> albumSongList = [];
  // @override
  // void initState() {
  //   albumSongList.addAll({
  //     CheckBoxModel(
  //         title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
  //     CheckBoxModel(
  //         title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
  //     CheckBoxModel(
  //         title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
  //     CheckBoxModel(
  //         title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
  //     CheckBoxModel(
  //         title: "VaarnamAayiram", subtitle: "Unknown Artist-Unknown Album", selected: false),
  //   });
  //   super.initState();
  // }

  bool? isSelected = false;
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
        itemCount: widget.songList.length,
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
                text: widget.songList[index].musicName,
                fontSize: 17.sp,
                color: kWhite,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: TextWidgetCommon(
                text:"${widget.songList[index].musicArtistName}-${widget.songList[index].musicAlbumName}",
                fontSize: 10.sp,
                color: kGrey,
              ),
              value: widget.songList[index].musicSelected!=null?widget.songList[index].musicSelected:false,
              onChanged: (value) {
                setState(() {
                  widget.songList[index].musicSelected = value;
                  isSelected =
                      widget.songList.any((checkbox) => checkbox.musicSelected == true);
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
