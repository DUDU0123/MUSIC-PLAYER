import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/controllers/permission_request_class.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  RxList<AllMusicsModel> allSongsListFromDevice = <AllMusicsModel>[].obs;
  RxInt currentSongIndex = RxInt(0);
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = const Duration().obs;
  Rx<Duration> position = const Duration().obs;
  Rx<AllMusicsModel?> currentPlayingSong = Rx<AllMusicsModel?>(null);
  Rx<AllMusicsModel>? songNow;
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

  // function for making slider move according to song position duration
  changeToSeconds(int seconds) {
    Rx<Duration> seekDurationSlider = Duration(seconds: seconds).obs;
    audioPlayer.seek(seekDurationSlider.value);
  }

  setSong(AllMusicsModel song){
    if (songNow!=null) {
      songNow!.value = song;
    }
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
                album: song.musicAlbumName,
              ),
            );
          }).toList(),
        ),
        initialIndex: currentSongIndex.value,
        initialPosition: audioPlayer.position,
        preload: false,
      );
      if (audioPlayer.position > Duration.zero) {
      // Seek to the last played position
      await audioPlayer.seek(audioPlayer.position);
    }
     currentPlayingSong.value = allSongsListFromDevice[currentSongIndex.value];
   
    } catch (e) {
      log("Error on play intialize: $e");
    }
    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        if (currentSongIndex < allSongsListFromDevice.length - 1) {
          currentPlayingSong.value =
              allSongsListFromDevice[currentSongIndex.value];
          playNextSong();
        } else {
          if (audioPlayer.loopMode == LoopMode.all) {
            currentPlayingSong.value =
              allSongsListFromDevice[currentSongIndex.value];
            //play song
            playSong(0);
          } else {
            //stop
            stopSong();
          }
        }
        // Update UI with the new song details
        currentPlayingSong.value =
            allSongsListFromDevice[currentSongIndex.value];
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

  //request permission , if granted fetch songs and initialize audio player
  Future<void> requestPermissionAndFetchSongsAndInitializePlayer() async {
    log("CALLING REQUESTFETCHINITIALIZE AGAIN");
    var status = await PermissionRequestClass.permissionStorage();
    if (status) {
      log("Granted");
      await fetchSongsFromDeviceStorage();

      await intializeAudioPlayer(allSongsListFromDevice);
    } else {
      debugPrint("Permission Denied");
      await PermissionRequestClass.permissionStorage();
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
      List<AllMusicsModel> songsList = <AllMusicsModel>[];

      for (var element in allsongs) {
        if (File(element.musicPathInDevice).existsSync()) {
          songsList.add(element);
        }
      }
      allSongsListFromDevice.addAll(songsList);

      await addSongsToDB(allSongsListFromDevice);
    } catch (e) {
      log(e.toString());
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

  Future initializeRecentlyPlayedSongs() async{
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
    currentPlayingSong.value = allSongsListFromDevice[currentSongIndex.value];
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
    log("CALLING GET ALL SONGS");
    await fetchSongsFromDeviceStorage();
    return allSongsListFromDevice;
  }

  // function for delete a song permanently
  Future<void> deleteSongsPermentaly(
      List<int> songIds, BuildContext context) async {
    var status = await PermissionRequestClass.permissionStorageToDelete();
    if (status) {
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
        Get.snackbar(
          "Deleted",
          "Deleted successfully!",
          duration: const Duration(seconds: 1),
          colorText: kWhite,
        );
      } catch (e) {
        log(e.toString());
        Get.snackbar(
          "Error !!!!!",
          "$e",
          duration: const Duration(seconds: 1),
          colorText: kWhite,
        );
      }
    } else {
      log("Permission Denied to delete a file");
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
