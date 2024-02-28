import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
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

  RxList<RecentlyPlayedModel> recentlyPlayedSongList =
      <RecentlyPlayedModel>[].obs;
  Rx<LoopMode> loopMode = LoopMode.all.obs;
  RxBool isLoopOneSong = false.obs;
  RxBool isShuffleSongs = false.obs;
  // RxString musicName = ''.obs;
  // RxString musicAlbum = ''.obs;
  // RxString musicArtist = ''.obs;
  // RxInt musicFileSize = 0.obs;
  // RxString musicPathInDevice = ''.obs;
  // RxString musicUri = ''.obs;
  // RxString musicFormat = ''.obs;
  // RxInt musicId = 0.obs;

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
                album: song.musicAlbumName
              ),
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

  //request permission , if granted fetch songs and initialize audio player
  Future<void> requestPermissionAndFetchSongsAndInitializePlayer() async {
    var status = await requestPermission();
    if (status.isGranted) {
      log("Granted");
      await fetchSongsFromDeviceStorage();

      await intializeAudioPlayer(allSongsListFromDevice);
    } else {
      debugPrint("Permission Denied");
      await requestPermission();
    }
  }

  // requesting permission to access the storage
  Future<PermissionStatus> requestPermission() async {
    try {
      log("requesting");
      var status = await Permission.storage.request();
      log(status.toString());
      return status;
    } catch (e) {
      debugPrint(e.toString());
      return PermissionStatus.denied;
    }
  }

  // fetching songs from device storage
  Future<void> fetchSongsFromDeviceStorage() async {
    final OnAudioQuery onAudioQuery = OnAudioQuery();
    try {
      log("Fetching");
      final songs = await onAudioQuery.querySongs(
          sortType: null,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER);

      allSongsListFromDevice.clear();
      allSongsListFromDevice.addAll(
          songs.map((song) => AllMusicsModel.fromSongModel(song)).toList());
      await addSongsToDB(allSongsListFromDevice);
    } catch (e) {
      debugPrint(e.toString());
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
    if (isRecentlyPlayed != null && currentPlayingSong.value!=null) {
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
    }
  }

  // function for play previous song
  Future<void> playPreviousSong() async {
    if (currentSongIndex > 0) {
      currentSongIndex--;
      await playSong(currentSongIndex.value);
    }
  }

  Future<List<AllMusicsModel>> getAllSongs() async {
    await fetchSongsFromDeviceStorage();
    return allSongsListFromDevice;
  }

  //   Future<void> deleteSongPermanently(AllMusicsModel song, BuildContext context) async {
  //   try {
  //     // Stop the song if it's currently playing
  //     await stopSong();

  //     // Remove the song from the UI
  //     allSongsListFromDevice.remove(song);
  //     update();

  //     // Delete the song file from device storage
  //     await File(song.musicPathInDevice).delete();

  //     // Remove the song from Hive box
  //     musicBox.delete(song.id);

  //     // If the deleted song is the currently playing song, reset the current song index
  //     if (currentPlayingSong.value?.id == song.id) {
  //       currentSongIndex.value = -1;
  //       currentPlayingSong.value = null;
  //     }

  //     // Update the recently played list to remove the deleted song
  // Box<RecentlyPlayedModel> recentlyPlayedBox =
  //     Hive.box<RecentlyPlayedModel>('recent');
  // RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
  //         'recent',
  //         defaultValue:
  //             RecentlyPlayedModel(recentlyPlayedSongsList: [])) ??
  //     RecentlyPlayedModel(recentlyPlayedSongsList: []);
  // recentlyPlayedModel.removeRecentlyPlayedSong(song);
  // recentlyPlayedBox.put('recent', recentlyPlayedModel);

  //     snackBarCommonWidget(
  //       // You can customize the context and contentText as per your application
  //       context,
  //       contentText: "Song deleted permanently",
  //     );
  //   } catch (e) {
  //     print("Error deleting song: $e");
  //     snackBarCommonWidget(
  //       // You can customize the context and contentText as per your application
  //       context,
  //       contentText: "Error deleting song",
  //     );
  //   }
  // }

  // Future<void> deleteSongsPermentaly(
  //     List<int> songIds, BuildContext context) async {
  //   var status = await requestPermission();
  //   if (status.isGranted) {
  //     await stopSong();
  //     try {
  //       for (var songId in songIds) {
  //         AllMusicsModel? songToDelete = allSongsListFromDevice
  //             .firstWhereOrNull((song) => song.id == songId);
  //         if (songToDelete != null) {
  //           allSongsListFromDevice.remove(songToDelete);
  //           update();

  //           if (currentPlayingSong.value?.id == songId) {
  //             currentSongIndex.value = -1;
  //             currentPlayingSong.value = null;
  //           }

  //           await audioPlayer.pause();

  //           if (songToDelete.musicPathInDevice != null &&
  //               songToDelete.musicPathInDevice.isNotEmpty) {
  //             await File(songToDelete.musicPathInDevice).delete();
  //           }
  //           musicBox.delete(songId);
  //           Box<RecentlyPlayedModel> recentlyPlayedBox =
  //               Hive.box<RecentlyPlayedModel>('recent');
  //           RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
  //                   'recent',
  //                   defaultValue:
  //                       RecentlyPlayedModel(recentlyPlayedSongsList: [])) ??
  //               RecentlyPlayedModel(recentlyPlayedSongsList: []);
  //           recentlyPlayedModel.removeRecentlyPlayedSong(songToDelete);
  //           recentlyPlayedBox.put('recent', recentlyPlayedModel);
  //         }
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: TextWidgetCommon(text: "Error !!!!! $e", fontSize: 20.sp),
  //         duration: const Duration(minutes: 10),
  //       ));
  //     }
  //   }
  // }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
