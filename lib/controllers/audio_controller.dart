import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  RxList<AllMusicsModel> allSongsListFromDevice = <AllMusicsModel>[].obs;
  RxInt currentSongIndex = RxInt(0);
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = const Duration().obs;
  Rx<Duration> position = const Duration().obs;
  Rx<AllMusicsModel?> currentPlayingSong = Rx<AllMusicsModel?>(null);
  Box<RecentlyPlayedModel> recentlyPlayedBox =
      Hive.box<RecentlyPlayedModel>('recent');
  Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
  Rx<SortMethod> currentSortMethod = SortMethod.alphabetically.obs;
  RxList<RecentlyPlayedModel> recentlyPlayedSongList =
      <RecentlyPlayedModel>[].obs;
  Rx<LoopMode> loopMode = LoopMode.all.obs;
  RxBool isLoopOneSong = false.obs;
  RxBool isShuffleSongs = false.obs;
  Rx<PageTypeEnum> pageType = PageTypeEnum.homePage.obs;

  PageTypeEnum setPageType(PageTypeEnum pageTypeEnum) {
    pageType.value = pageTypeEnum;
    return pageType.value;
  }

  String convertToMBorKB(int bytes) {
    const int kB = 1024;
    const int mB = kB * 1024;

    if (bytes >= mB) {
      return '${(bytes / mB).toStringAsFixed(2)} MB';
    } else if (bytes >= kB) {
      return '${(bytes / kB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes Bytes';
    }
  }

  // function for making slider move according to song position duration

  changeToSeconds(int seconds) {
    Rx<Duration> seekDurationSlider = Duration(seconds: seconds).obs;
    audioPlayer.seek(seekDurationSlider.value);
  }

  // for initializing audio player
  Future<void> intializeAudioPlayer(List<AllMusicsModel> songs) async {
    log("Initializing");
    try {
      await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: songs.map((song) {
            log(song.musicUri);
            log(song.musicPathInDevice);
            return AudioSource.uri(
              Uri.parse(song.musicUri),
              tag: MediaItem(
                  id: song.id.toString(),
                  title: song.musicName,
                  album: song.musicAlbumName),
            );
          }).toList(),
        ),
        initialIndex: currentSongIndex.value,
        // initialPosition: audioPlayer.position,
        preload: false,
      );
    } catch (e) {
      log("Error on play intialize: $e");
    }

    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        if (currentSongIndex < allSongsListFromDevice.length - 1) {
          playNextSong();
        } else {
          if (audioPlayer.loopMode == LoopMode.all) {
            //play song
            playSong(0);
          } else {
            //stop
            stopSong();
          }
        }
      }
    });
    audioPlayer.durationStream.listen(
      (d) {
        duration.value = d ?? const Duration(); // Set a default value if null
      },
    );

    audioPlayer.positionStream.listen((p) {
      position.value = p;
    });
  }
  Future<bool> permissionStorage() async {

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var k = await deviceInfoPlugin.androidInfo;
    PermissionStatus permissionStatus;
    if (int.parse(k.version.release) < 13) {
      //if it is android version below 13 then asking for storage permission
      permissionStatus = await Permission.storage.request();
    } else {
      //if it is android 13 or above asking video permission
      permissionStatus = await Permission.audio.request();
    }
    return permissionStatus.isGranted;
  }
  //request permission , if granted fetch songs and initialize audio player
  Future<void> requestPermissionAndFetchSongsAndInitializePlayer() async {
    var status = await permissionStorage();
    if (status) {
      log("Granted");
      await fetchSongsFromDeviceStorage();

      await intializeAudioPlayer(allSongsListFromDevice);
    } else {
      debugPrint("Permission Denied");
      await permissionStorage();
    }
  }

  // requesting permission to access the storage
  Future<PermissionStatus> requestPermission() async {
    try {
      log("requesting");
      var status = await Permission.manageExternalStorage.request();
      await Permission.audio.request();
      log(status.toString());
      return status;
    } catch (e) {
      debugPrint(e.toString());
      return PermissionStatus.denied;
    }
  }

  void updateSortMethod(SortMethod method) {
    currentSortMethod.value = method;
    fetchSongsFromDeviceStorage();
  }

  // fetching songs from device storage
  Future<void> fetchSongsFromDeviceStorage() async {
    final OnAudioQuery onAudioQuery = OnAudioQuery();
    try {
      log("Fetching");
      final songs = await onAudioQuery.querySongs(
          sortType: currentSortMethod.value == SortMethod.alphabetically
              ? SongSortType.DISPLAY_NAME
              : SongSortType.DATE_ADDED,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER);

      // for (var element in songs) {
      //   if (File(element.)) {

      //   }
      // }

      // allSongsListFromDevice.clear();

      // allSongsListFromDevice.addAll(
      //     songs.map((song) => AllMusicsModel.fromSongModel(song)).toList());

      allSongsListFromDevice.clear();

      List<AllMusicsModel> allsongs =
          songs.map((song) => AllMusicsModel.fromSongModel(song)).toList();
      final k = <AllMusicsModel>[];

      for (var element in allsongs) {
        if (File(element.musicPathInDevice).existsSync()) {
          k.add(element);
        }
      }
      allSongsListFromDevice.addAll(k);

      await addSongsToDB(allSongsListFromDevice);
    } catch (e) {
      print(e.toString());
    }
  }

  void clearRecentlyPlayedSongs() {
    recentlyPlayedBox.put(
        'recent', RecentlyPlayedModel(recentlyPlayedSongsList: []));
    update();
  }

  // add  songs to hive db
  Future<void> addSongsToDB(List<AllMusicsModel> songs) async {
    final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
    await musicBox.clear();

    for (var song in songs) {
      await musicBox.put(song.id, song);
    }
  }

  void initializeRecentlyPlayedSongs() {
    log("Debug: Initializing Recently Played Songs");
    recentlyPlayedBox = Hive.box<RecentlyPlayedModel>('recent');
    recentlyPlayedSongList.value = recentlyPlayedBox.values.toList();
    if (recentlyPlayedBox.isEmpty) {
      // If the box is empty, initialize it with a default RecentlyPlayedModel
      recentlyPlayedBox.put(
          'recent', RecentlyPlayedModel(recentlyPlayedSongsList: []));
    }
    // Listen to changes in the recently played list
    recentlyPlayedBox.watch().listen((event) {
      recentlyPlayedSongList.value = recentlyPlayedBox.values.toList();
      update();
    });
  }

  bool isSongRecentlyPlayed(
      AllMusicsModel song, List<AllMusicsModel> recentlyPlayedSongs) {
    String songIdentifier = song.id.toString();

    return recentlyPlayedSongs.any((recentlyPlayedSong) {
      // Check if the song is present in the recently played list based on the identifier
      return recentlyPlayedSong.id == songIdentifier;
    });
  }

  // play a song
  Future<void> playSong(int index,
      {bool? isRecentlyPlayed = false, Duration? lastPlayedPosition}) async {
    if (allSongsListFromDevice.isEmpty ||
        index < 0 ||
        index >= allSongsListFromDevice.length) {
      log("SOMETHING HAPPENED");
      return;
    }

    currentSongIndex.value = index;
    await audioPlayer.seek(Duration.zero, index: index);
    if (lastPlayedPosition != null) {
      await audioPlayer.seek(lastPlayedPosition, index: index);
    } else {
      await audioPlayer.seek(Duration.zero, index: index);
    }
    await audioPlayer.play();
    isPlaying.value = true;
    audioPlayer.durationStream.listen(
      (d) {
        duration.value = d ?? const Duration();
        log(duration.value.toString());
      },
    );

    audioPlayer.durationStream.listen((p) {
      position.value = p ?? const Duration();
      log(position.value.toString());
    });
    log("Current");
    currentPlayingSong.value = allSongsListFromDevice[currentSongIndex.value];

    log("After current");
    log("${currentPlayingSong.value!.id} ${currentPlayingSong.value!.musicName} ${currentPlayingSong.value!.musicAlbumName}");
    if (isRecentlyPlayed != null && currentPlayingSong.value != null) {
      if (!isRecentlyPlayed && index != null) {
        // Update the recently played list
        Box<RecentlyPlayedModel> recentlyPlayedBox =
            Hive.box<RecentlyPlayedModel>('recent');
        RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
                'recent',
                defaultValue:
                    RecentlyPlayedModel(recentlyPlayedSongsList: [])) ??
            RecentlyPlayedModel(recentlyPlayedSongsList: []);
        recentlyPlayedModel.removeRecentlyPlayedSong(currentPlayingSong.value!);
        recentlyPlayedModel.addRecentlyPlayedSong(currentPlayingSong.value!);
        recentlyPlayedBox.put('recent', recentlyPlayedModel);
        update();
      }
    }
    // Update the current playing song
    currentPlayingSong.value = allSongsListFromDevice[currentSongIndex.value];
  }

  songLoopModesControlling() {
    if (isLoopOneSong.value) {
      // If loop one song is enabled, switch to loop all
      isLoopOneSong.value = false;
      isShuffleSongs.value = false;
      loopMode.value = LoopMode.all;
    } else if (isShuffleSongs.value) {
      // If shuffle is enabled, switch to loop one song
      isShuffleSongs.value = false;
      isLoopOneSong.value = true;
      loopMode.value = LoopMode.one;
    } else {
      // If loop all is enabled, switch to shuffle
      isShuffleSongs.value = true;
      loopMode.value = LoopMode.all;
    }

    // Set the loop mode on the audioPlayer
    audioPlayer.setLoopMode(loopMode.value);
    // update();
  }

  // songStop function
  Future<void> stopSong() async {
    await audioPlayer.stop();
    isPlaying.value = false;
  }

  // songPause Function
  Future<void> pauseSong() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  // function for play next song
  Future<void> playNextSong() async {
    if (currentSongIndex < allSongsListFromDevice.length - 1) {
      currentSongIndex++;
      await playSong(currentSongIndex.value);
    } else {
      Get.snackbar("Play Back", "No songs to play next",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kTileColor,
          colorText: kWhite,
          duration: const Duration(seconds: 1));
    }
  }

  // function for play previous song
  Future<void> playPreviousSong() async {
    if (currentSongIndex > 0) {
      currentSongIndex--;
      await playSong(currentSongIndex.value);
    } else {
      Get.snackbar("Play Next", "No songs to play previous",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kTileColor,
          colorText: kWhite,
          duration: const Duration(seconds: 1));
    }
  }

  Future<List<AllMusicsModel>> getAllSongs() async {
    await fetchSongsFromDeviceStorage();
    return allSongsListFromDevice;
  }


  Future<void> deleteSongsPermentaly(
      List<int> songIds, BuildContext context) async {
    var status = await requestPermission();
    if (status.isGranted) {
      await stopSong();
      try {
        for (var songId in songIds) {
          AllMusicsModel? songToDelete = allSongsListFromDevice
              .firstWhereOrNull((song) => song.id == songId);
          if (songToDelete != null) {
            allSongsListFromDevice.remove(songToDelete);
            update();

            if (currentPlayingSong.value?.id == songId) {
              currentSongIndex.value = -1;
              currentPlayingSong.value = null;
            }

            await audioPlayer.pause();

            if (songToDelete.musicPathInDevice != null &&
                songToDelete.musicPathInDevice.isNotEmpty) {
              await File(songToDelete.musicPathInDevice).delete();
            }
            musicBox.delete(songId);
            Box<RecentlyPlayedModel> recentlyPlayedBox =
                Hive.box<RecentlyPlayedModel>('recent');
            RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
                    'recent',
                    defaultValue:
                        RecentlyPlayedModel(recentlyPlayedSongsList: [])) ??
                RecentlyPlayedModel(recentlyPlayedSongsList: []);
            recentlyPlayedModel.removeRecentlyPlayedSong(songToDelete);
            recentlyPlayedBox.put('recent', recentlyPlayedModel);
          }
        }
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: TextWidgetCommon(text: "Error !!!!! $e", fontSize: 20.sp),
          duration: const Duration(minutes: 10),
        ));
      }
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}

// class MyPermissionStorage {

  
//   static 
// }