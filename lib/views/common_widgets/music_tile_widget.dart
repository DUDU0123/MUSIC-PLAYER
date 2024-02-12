import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class MusicTileWidget extends StatefulWidget {
  const MusicTileWidget({
    super.key,
    required this.songTitle,
    this.artistName = "Unknown artist",
    this.albumName = "Unknown album",
    required this.songFormat,
    required this.songSize,
    required this.songPathIndevice,
    required this.pageType,
    this.onTap,
  });

  final String songTitle;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  final PageTypeEnum pageType;
  final void Function()? onTap;

  @override
  State<MusicTileWidget> createState() => _MusicTileWidgetState();
}

class _MusicTileWidgetState extends State<MusicTileWidget> {
  bool? isSongSelected = false;
  @override
  Widget build(BuildContext context) {
    final kScreenHeight = MediaQuery.of(context).size.height;
    final kScreenWidth = MediaQuery.of(context).size.width;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Padding(padding: EdgeInsets.symmetric(vertical: value*7.h), child: child,),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, ),
          padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 10.h),
          decoration: BoxDecoration(
            color: kTileColor,
            borderRadius: BorderRadius.circular(13.sp),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: kScreenWidth / 1.7,
                    child: TextWidgetCommon(
                      overflow: TextOverflow.ellipsis,
                      text: widget.songTitle,
                      fontSize: 16.sp,
                      color: kWhite,
                    ),
                  ),
                  TextWidgetCommon(
                    text: "${widget.artistName}-${widget.albumName}",
                    fontSize: 10.sp,
                    color: kGrey,
                  ),
                ],
              ),
              Row(
                children: [
                  widget.pageType != PageTypeEnum.currentPlayListPage
                      ? IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              barrierColor: kTransparent,
                              backgroundColor: kTransparent,
                              context: context,
                              builder: (context) {
                                return MenuBottomSheet(
                                  kScreenHeight: kScreenHeight,
                                  pageType: widget.pageType,
                                  songName: widget.songTitle,
                                  artistName: widget.artistName,
                                  albumName: widget.albumName,
                                  songFormat: widget.songFormat,
                                  songSize: widget.songSize,
                                  songPathIndevice: widget.songPathIndevice,
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.more_vert,
                            size: 26.sp,
                            color: kGrey,
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
