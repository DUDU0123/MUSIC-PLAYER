import 'package:flutter/material.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/delete_dialog_box.dart';
import 'package:music_player/views/common_widgets/ontap_text_widget.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/add_to_playlist/add_to_playlist_page.dart';
import 'package:music_player/views/view_details_page.dart/view_details_page.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({
    super.key,
    required this.kScreenHeight,
    required this.pageType,
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.songFormat,
    required this.songSize,
    required this.songPathIndevice,
  });

  final double kScreenHeight;
  final PageTypeEnum pageType;
  final String songName;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;


  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20),),
        color: kMenuBtmSheetColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.5,
            spreadRadius: 0.5,
            color: kGrey,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: pageType==PageTypeEnum.playListPage?kScreenHeight/2.2: kScreenHeight / 2.5,
      child: Column(
        children: [
          OnTapTextWidget(
            text: "Add to Playlist",
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddToPlaylistPage(),
                ),
              );
            },
          ),
          OnTapTextWidget(
            text: "Send Song",
            onTap: () {},
          ),
          OnTapTextWidget(
            text: "View Details",
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewDetailsPage(
                    songName: songName,
                    artistName: artistName,
                    albumName: albumName,
                    songFormat: songFormat,
                    songSize: songSize,
                    songPathIndevice: songPathIndevice,
                  ),
                ),
              );
            },
          ),
          pageType == PageTypeEnum.playListPage
              ? OnTapTextWidget(
                  text: "Remove From Playlist",
                  onTap: () {
                    
                  },
                )
              : const SizedBox(),
          OnTapTextWidget(
            text: "Delete Song",
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return DeleteDialogBox(
                    contentText: "Do you want to delete the song?",
                    deleteAction: () {},
                  );
                },
              );
            },
          ),
          Divider(
            thickness: 1,
            color: kGrey,
          ),
          OnTapTextWidget(
            text: "Cancel",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
