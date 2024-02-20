import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/music_play_page_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:music_player/views/music_view/music_play_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
    this.isPlaying,
    required this.songId,
    this.playSong,
     this.index =0,
    this.audioSource,
    this.songModel,
    required this.audioPlayer,
    this.currentPlayingSongIndex,
    required this.musicBox,
  });

  final String songTitle;
  final String artistName;
  final String albumName;
  final String songFormat;
  final String songSize;
  final String songPathIndevice;
  final PageTypeEnum pageType;
  final bool? isPlaying;
  final int songId;
  final void Function({String? url, int? index, bool? isRecentlyPlayed})?
      playSong;
  final int index;
  final ConcatenatingAudioSource? audioSource;
  final AllMusicsModel? songModel;
  final AudioPlayer audioPlayer;
  final int? currentPlayingSongIndex;
  final Box<AllMusicsModel> musicBox;

  @override
  State<MusicTileWidget> createState() => _MusicTileWidgetState();
}

class _MusicTileWidgetState extends State<MusicTileWidget> {
  MusicPlayPageController controller = Get.put(MusicPlayPageController());
  bool isSongRecentlyPlayed(
      AllMusicsModel song, List<AllMusicsModel> recentlyPlayedSongs) {
    // Assuming each song has a unique identifier like an ID
    String songIdentifier = song.id.toString();

    return recentlyPlayedSongs.any((recentlyPlayedSong) {
      // Check if the song is present in the recently played list based on the identifier
      return recentlyPlayedSong.id == songIdentifier;
    });
  }

  @override
  Widget build(BuildContext context) {
    final kScreenHeight = MediaQuery.of(context).size.height;
    final kScreenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.find<MusicPlayPageController>().id = widget.songId;
        // Check if the song is recently played

        if (widget.songModel!=null) {
          bool isRecentlyPlayed = isSongRecentlyPlayed(
            widget.songModel!,
            widget.musicBox.values.toList());
            widget.playSong!(
                url: widget.songModel!.musicUri,
                index: widget.musicBox.keyAt(widget.musicBox.values.toList().indexOf(widget.songModel!)),
                isRecentlyPlayed: isRecentlyPlayed);
        }
         
        
        
        
        
        //  playSong(song.musicUri, index);
        widget.pageType == PageTypeEnum.normalPage
            ? showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  
                  return widget.songModel!=null? MusicPlayPage(
                    musicBox: widget.musicBox,
                    playSong: widget.playSong!,
                    currentPlayingSongIndex: widget.currentPlayingSongIndex,
                    initialIndex: widget.index,
                    audioSource: widget.audioSource,
                    songModel: widget.songModel!,
                    audioPlayer: widget.audioPlayer,
                    isPlaying: widget.currentPlayingSongIndex == widget.index &&
                            widget.isPlaying != null
                        ? widget.isPlaying!
                        : false,
                  ):SizedBox();
                },
              )
            : null;
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 10.h),
              decoration: BoxDecoration(
                color: kTileColor,
                borderRadius: BorderRadius.circular(13.sp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QueryArtworkWidget(
                    id: widget.songId,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: Container(
                        height: 50.h,
                        width: 50.w,
                        // padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kMenuBtmSheetColor,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: kGrey,
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: kScreenWidth / 2.2,
                        // widget.pageType != PageTypeEnum.currentPlayListPage
                        //     ? kScreenWidth / 1.9
                        //     : kScreenWidth / 1.6,
                        child: TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: widget.songTitle,
                          fontSize: 16.sp,
                          color: widget.isPlaying != null
                              ? widget.isPlaying!
                                  ? kRed
                                  : kWhite
                              : kWhite,
                        ),
                      ),
                      SizedBox(
                        width: kScreenWidth / 2,
                        // widget.pageType != PageTypeEnum.currentPlayListPage
                        //     ? kScreenWidth / 1.9
                        //     : kScreenWidth / 1.9,
                        child: TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text:
                              "${widget.artistName == "<unknown>" ? "Unknown Artisit" : widget.artistName}-${widget.albumName}",
                          fontSize: 10.sp,
                          color: widget.isPlaying != null
                              ? widget.isPlaying!
                                  ? kRed
                                  : kGrey
                              : kGrey,
                        ),
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
                                color: widget.isPlaying != null
                                    ? widget.isPlaying!
                                        ? kRed
                                        : kGrey
                                    : kWhite,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ),
          widget.isPlaying != null
              ? widget.isPlaying!
                  ? Positioned(
                      right: 45.w,
                      top: 30.h,
                      child: Icon(
                        Icons.multitrack_audio_rounded,
                        color: kRed,
                        size: 26.sp,
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
        ],
      ),
    );
  }
}
