import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/favourite_controller.dart';
import 'package:music_player/controllers/music_play_page_controller.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/favourite_model.dart';
import 'package:music_player/views/common_widgets/menu_bottom_sheet.dart';
import 'package:music_player/views/common_widgets/snackbar_common_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/current_playlist/current_playlist.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayPage extends StatefulWidget {
  MusicPlayPage({
    super.key,
    required this.isPlaying,
    required this.audioPlayer,
    required this.songModel,
    required this.audioSource,
    required this.initialIndex, this.currentPlayingSongIndex,required this.playSong, required this.musicBox,
  });

  final AllMusicsModel songModel;
  final AudioPlayer audioPlayer;
  final ConcatenatingAudioSource? audioSource;
  int? currentPlayingSongIndex;
  final void Function({String? url, int? index, bool? isRecentlyPlayed})
      playSong;
      final Box<AllMusicsModel> musicBox;

  final int initialIndex;
  bool isPlaying;
  Duration totalDuration = Duration();
  Duration currentPosition = Duration();
  

  @override
  State<MusicPlayPage> createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
 // final musicBox = Hive.box<AllMusicsModel>('musics');
  late AllMusicsModel currentPlayingSong;
  bool _isMounted = false;
  bool isLoopingAllSongs = false;
  bool isShufflingSongs = false;
  bool isFavorite = false;
  final FavoriteController favoriteController = Get.put(FavoriteController());
  // index of song getting for details
  AllMusicsModel getSongDetailsByIndex(int index) {
    try {
      return widget.musicBox.getAt(index) ??
          AllMusicsModel(
            id: currentPlayingSong
                .id, // Replace with default values for named parameters
            musicName: currentPlayingSong.musicName,
            musicAlbumName: currentPlayingSong.musicAlbumName,
            musicArtistName: currentPlayingSong.musicArtistName,
            musicPathInDevice: currentPlayingSong.musicPathInDevice,
            musicFormat: currentPlayingSong.musicFormat,
            musicUri: currentPlayingSong.musicUri,
            musicFileSize: currentPlayingSong.musicFileSize,
            musicSelected: false,
          );
    } catch (e) {
      print("Error getting song details: $e");
      return AllMusicsModel(
        id: widget
            .songModel.id, // Replace with default values for named parameters
        musicName: currentPlayingSong.musicName,
        musicAlbumName: currentPlayingSong.musicAlbumName,
        musicArtistName: currentPlayingSong.musicArtistName,
        musicPathInDevice: currentPlayingSong.musicPathInDevice,
        musicFormat: currentPlayingSong.musicFormat,
        musicUri: currentPlayingSong.musicUri,
        musicFileSize: currentPlayingSong.musicFileSize,
        musicSelected: false,
      );
    }
  }

  // play song method
  void playSong([int? index]) {
    try {
      if (widget.audioSource != null) {
        widget.audioPlayer.setAudioSource(
          widget.audioSource!,
          initialIndex: index,
        );
      }
      setState(() {
       widget.currentPlayingSongIndex = index;
      if(widget.currentPlayingSongIndex!=null)
        currentPlayingSong =
            getSongDetailsByIndex(widget.currentPlayingSongIndex!);
        MusicPlayPageController.to.setId(currentPlayingSong.id);
        checkIsFavorite();
      });
      widget.audioPlayer.play();
    } on Exception {
      print("Can't Play Song PlaySong Not Working Properly Let's fix it");
    }
    setState(() {
      widget.isPlaying = true;
    });
    // listening to duration
    widget.audioPlayer.durationStream.listen((totalDurationOfSong) {
      setState(() {
        if (totalDurationOfSong != null) {
          widget.totalDuration = totalDurationOfSong;
        }
      });
    });
    // listening to positing
    widget.audioPlayer.positionStream.listen((currentPositionOfSong) {
      setState(() {
        widget.currentPosition = currentPositionOfSong;
      });
    });
  }

  // initializer at first
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    currentPlayingSong = widget.songModel;
    playSong(widget.initialIndex);
    MusicPlayPageController.to.setId(currentPlayingSong.id);
    // checkIsFavorite();
    favoriteController.loadFavoriteSongs();
  }

  @override
  void dispose() {
    _isMounted = false;
    favoriteController.favoriteBox.putAll(Map.fromIterable(
        favoriteController.favoriteSongs,
        key: (song) => song.id));
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (_isMounted) {
      setState(fn);
    }
  }

  // to seconds changer
  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  // To next song
  void goToNextSong() {
    if (widget.currentPlayingSongIndex != null && widget.audioSource != null) {
      if (widget.currentPlayingSongIndex! < widget.audioSource!.length &&
          widget.currentPlayingSongIndex != null) {
        widget.audioPlayer.seekToNext();
        // Update the currentPlayingSongIndex
        safeSetState(() {
          widget.currentPlayingSongIndex =
              widget.audioPlayer.currentIndex ?? widget.currentPlayingSongIndex;
          currentPlayingSong =
              getSongDetailsByIndex(widget.currentPlayingSongIndex!);
        });
      }
    }
  }

  // To previous song
  void goToPreviousSong() {
    if (widget.currentPlayingSongIndex != 0) {
      widget.audioPlayer.seekToPrevious();
      // Update the currentPlayingSongIndex
      safeSetState(() {
 widget.currentPlayingSongIndex =
  widget.audioPlayer.currentIndex ?? widget.currentPlayingSongIndex;
        currentPlayingSong =
            getSongDetailsByIndex(widget.currentPlayingSongIndex!);
      });
    }
  }

  void songLoopModesControlling() {
    setState(() {
      isLoopingAllSongs = !isLoopingAllSongs;
      if (isLoopingAllSongs) {
        // Toggle shuffle state when looping all songs
        isShufflingSongs = !isShufflingSongs;
        widget.audioPlayer.setLoopMode(
          isShufflingSongs ? LoopMode.off : LoopMode.all,
        );
      } else {
        // Toggle between loop one and shuffle modes when looping one song
        isShufflingSongs
            ? widget.audioPlayer.setLoopMode(LoopMode.one)
            : widget.audioPlayer.shuffleModeEnabled;
      }
    });
  }

  FavoriteModel getFavoriteModelFromAllMusicModel(AllMusicsModel allMusic) {
    return FavoriteModel(
      id: allMusic.id,
      musicName: allMusic.musicName,
      musicArtistName: allMusic.musicArtistName,
      musicAlbumName: allMusic.musicAlbumName,
      musicFileSize: allMusic.musicFileSize,
      musicFormat: allMusic.musicFormat,
      musicPathInDevice: allMusic.musicPathInDevice,
      musicUri: allMusic.musicUri,
    );
  }

  void checkIsFavorite() {
    isFavorite = favoriteController.isFavorite(currentPlayingSong.id);
  }

  @override
  Widget build(BuildContext context) {
    print(currentPlayingSong.id);
    print(currentPlayingSong.musicName);
    print(currentPlayingSong.musicArtistName);
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: kScreenWidth,
        height: kScreenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1, color: kLightGrey),
                      top: BorderSide(width: 1, color: kLightGrey),
                    )),
                  ),
                ),
                kHeight30,
                Column(
                  children: [
                    Center(
                      child: Container(
                        width: 280.w,
                        height: 280.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              color: kWhite.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 2,
                            )
                          ],
                          borderRadius: BorderRadius.circular(60),
                          color: kMusicIconContainerColor,
                        ),
                        child: const ArtWorkWidgetMusicPlayingPage(),
                      ),
                    ),
                    kHeight15,
                    // Duration Slider
                    Slider(
                      activeColor: kRed,
                      thumbColor: kRed,
                      inactiveColor: const Color.fromARGB(255, 53, 53, 53),
                      min: const Duration(microseconds: 0).inSeconds.toDouble(),
                      max: widget.totalDuration.inSeconds.toDouble(),
                      value: (widget.currentPosition != null &&
                              widget.currentPosition.inSeconds >= 0 &&
                              widget.currentPosition.inSeconds <=
                                  (widget.totalDuration != null
                                      ? widget.totalDuration.inSeconds
                                      : 1.0))
                          ? widget.currentPosition.inSeconds.toDouble()
                          : 0.0,
                      onChanged: (value) {
                        setState(() {
                          changeToSeconds(value.toInt());
                          value = value;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidgetCommon(
                            text:
                                widget.currentPosition.toString().split(".")[0],
                            fontSize: 10.sp,
                            color: kGrey,
                          ),
                          TextWidgetCommon(
                            text: widget.totalDuration.toString().split(".")[0],
                            fontSize: 10.sp,
                            color: kGrey,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: kScreenWidth,
                  height: kScreenHeight / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          // song name
                          SizedBox(
                            width: kScreenWidth / 1.6,
                            child: TextWidgetCommon(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: currentPlayingSong.musicName,
                              fontSize: 23.sp,
                              color: kWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          kHeight5,
                          // song artist name
                          TextWidgetCommon(
                            overflow: TextOverflow.ellipsis,
                            text: currentPlayingSong.musicArtistName ==
                                    '<unknown>'
                                ? 'Unknown Artist'
                                : currentPlayingSong.musicArtistName,
                            fontSize: 10.sp,
                            color: kGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      // control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // play back button
                          GestureDetector(
                            onTap: () {
                              print("to back");
                              goToPreviousSong();
                            },
                            child: Image.asset(
                              'assets/play_back.png',
                              color: kRed,
                              scale: 18.sp,
                            ),
                          ),
                          // play and pause button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (widget.isPlaying) {
                                  widget.audioPlayer.pause();
                                } else {
                                  widget.audioPlayer.play();
                                }
                                widget.isPlaying = !widget.isPlaying;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kRed),
                              child: Icon(
                                widget.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                                color: kWhite,
                              ),
                            ),
                          ),
                          // play next button
                          GestureDetector(
                            onTap: () {
                              print("to next");
                              goToNextSong();
                            },
                            child: Image.asset(
                              'assets/play_next.png',
                              color: kRed,
                              scale: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      // song bottom settings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // song current playlist show icon
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CurrentPlayListPage(
                                    audioPlayer: widget.audioPlayer,
                      indexfromhome: widget.initialIndex,
                      musicBox: widget.musicBox,
                      songModel: widget.songModel,
                      audioSource: widget.audioSource,
                      currentPlayingSongIndex: widget.currentPlayingSongIndex,
                      playSong: widget.playSong,
                                    songId: widget.songModel.id,
                                    isPlaying: widget.isPlaying,
                                    songName: widget.songModel.musicName,
                                    artistName:
                                        widget.songModel.musicArtistName,
                                    albumName: widget.songModel.musicAlbumName,
                                    songFormat: widget.songModel.musicFormat,
                                    songSize: widget.songModel.musicFileSize
                                        .toString(),
                                    songPathIndevice:
                                        widget.songModel.musicPathInDevice,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.list,
                              size: 30,
                              color: kWhite,
                            ),
                          ),
                          // song favourite add icon
                          IconButton(
                            onPressed: () {
                              AllMusicsModel music = getSongDetailsByIndex(
                                  widget.currentPlayingSongIndex!);
                              FavoriteModel favoriteMusic =
                                  getFavoriteModelFromAllMusicModel(music);
                              favoriteController.onTapFavorite(favoriteMusic);
                              checkIsFavorite();
                              snackBarCommonWidget(
                                context,
                                contentText: !isFavorite
                                    ? "Added to favorites"
                                    : "Removed from favorites",
                              );
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 30,
                              color: isFavorite ? kRed : kWhite,
                            ),
                          ),
                          // song loop shuffle

                          GestureDetector(
                            onTap: songLoopModesControlling,
                            child: isLoopingAllSongs
                                ? isShufflingSongs
                                    ? Image.asset(
                                        "assets/shuffle.png",
                                        scale: 18.sp,
                                        color: kWhite,
                                      )
                                    : Image.asset(
                                        "assets/loop_all.png",
                                        scale: 15.sp,
                                        color: kWhite,
                                      )
                                : Image.asset(
                                    "assets/loop_one.png",
                                    scale: 15.sp,
                                    color: kWhite,
                                  ),
                          ),

                          // song settings icon
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: kMenuBtmSheetColor,
                                context: context,
                                builder: (context) {
                                  return MenuBottomSheet(
                                    kScreenHeight: kScreenHeight,
                                    pageType: PageTypeEnum.musicViewPage,
                                    songName: widget.songModel.musicName,
                                    artistName:
                                        widget.songModel.musicArtistName,
                                    albumName: widget.songModel.musicAlbumName,
                                    songFormat: widget.songModel.musicFormat,
                                    songSize: widget.songModel.musicFileSize
                                        .toString(),
                                    songPathIndevice:
                                        widget.songModel.musicPathInDevice,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              size: 30,
                              color: kWhite,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArtWorkWidgetMusicPlayingPage extends StatelessWidget {
  const ArtWorkWidgetMusicPlayingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MusicPlayPageController>(
        init: MusicPlayPageController(),
        builder: (controller) {
          return QueryArtworkWidget(
            id: controller.id,
            type: ArtworkType.AUDIO,
            artworkFit: BoxFit.cover,
            nullArtworkWidget: Center(
              child: Icon(
                Icons.music_note,
                size: 200,
                color: kGrey,
              ),
            ),
          );
        });
  }
}
