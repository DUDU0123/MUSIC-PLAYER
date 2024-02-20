import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/views/add_to_playlist/add_to_playlist_page.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

import 'package:music_player/views/song_edit_page.dart/widgets/icon_text_widget.dart';

class BottomSettingsWidget extends StatelessWidget {
  const BottomSettingsWidget({
    super.key,
    this.isSelected, required this.pageType,
  });
  final bool? isSelected;
  final PageTypeEnum pageType;
  // Here need to have a variable to access each song from the list  to do operation
  // final List;
  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
      width: kScreenWidth,
      padding: EdgeInsets.only(top: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kMenuBtmSheetColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         pageType!=PageTypeEnum.playListPage && pageType!=PageTypeEnum.favoritePage? IconTextWidget(
            isSongSelected: isSelected,
            onTap: () {
              // need to have the song song details to send the song
              // also need to check that that the count of song to send is less than or equal to 10
            },
            icon: Icons.share_outlined,
            iconName: "Send",
          ):IconTextWidget(
            isSongSelected: isSelected,
            onTap: () {
              // need to have the song song details to send the song
              // also need to check that that the count of song to send is less than or equal to 10
            },
            icon: Icons.logout_outlined,
            iconName: "Remove",
          ),
          pageType!=PageTypeEnum.playListPage?kWidth10:const SizedBox(width: 0,),
         pageType!=PageTypeEnum.favoritePage? IconTextWidget(
            isSongSelected: isSelected,
            icon: Icons.favorite_outline,
            iconName: "Favorite",
            onTap: () {
              // need to send song details to add to favourites
              isSelected! ? Navigator.pop(context) : null;
              isSelected!
                  ? snackBarCommonWidget(
                      context,
                      contentText: "Added To favorites",
                    )
                  : null;
            },
          ):SizedBox(),
          pageType!=PageTypeEnum.playListPage && pageType!=PageTypeEnum.favoritePage?IconTextWidget(
            isSongSelected: isSelected,
            onTap: () {
              // need to send song details to add song to a playlist
              isSelected!
                  ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddToPlaylistPage(),
                      ),
                    )
                  : null;
            },
            icon: Icons.playlist_add,
            iconName: "Add to Playlist",
          ): const SizedBox(height: 0,width: 0,),
          IconTextWidget(
            isSongSelected: isSelected,
            onTap: () {
              // need to send song details to delete the song permenantly
              isSelected!
                  ? showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteDialogBox(
                          contentText: "Do you want to delete the song?",
                          deleteAction: () {},
                        );
                      },
                    )
                  : const SizedBox();
            },
            icon: Icons.delete_outline_outlined,
            iconName: "Delete",
          ),
        ],
      ),
    );
  }
}
