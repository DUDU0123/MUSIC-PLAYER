import 'dart:async';

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
  RxInt currentSongIndex = RxInt(-1);
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = const Duration().obs;
  Rx<Duration> position = const Duration().obs;
  Rx<AllMusicsModel?> currentPlayingSong = Rx<AllMusicsModel?>(null);
  Box<RecentlyPlayedModel> recentlyPlayedBox =
      Hive.box<RecentlyPlayedModel>('recent');
  Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');

  RxList<RecentlyPlayedModel> recentlyPlayedSongList =
      <RecentlyPlayedModel>[].obs;

// function for making slider move according to song position duration
  changeToSeconds(int seconds) {
    Rx<Duration> seekDurationSlider = Duration(seconds: seconds).obs;
    audioPlayer.seek(seekDurationSlider.value);
  }

  // for initializing audio player
  Future<void> intializeAudioPlayer(List<AllMusicsModel> songs) async {
    print("Initializing");
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: songs.map((song) {
          return AudioSource.uri(
            Uri.parse(song.musicUri),
            tag: MediaItem(
              id: song.id.toString(),
              title: song.musicName,
            ),
          );
        }).toList(),
      ),
      initialIndex: currentSongIndex.value,
      // initialPosition: audioPlayer.position,
      preload: false,
    );

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
      print("Granted");
      await fetchSongsFromDeviceStorage();

      intializeAudioPlayer(allSongsListFromDevice);
    } else {
      debugPrint("Permission Denied");
      await requestPermission();
    }
  }

  // requesting permission to access the storage
  Future<PermissionStatus> requestPermission() async {
    try {
      print("requesting");
      var status = await Permission.storage.request();
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
      print("Fetching");
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
    print("Debug: Initializing Recently Played Songs");
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
  Future<void> playSong(int index, {bool? isRecentlyPlayed = false}) async {
    if (allSongsListFromDevice.isEmpty) {
      return;
    }
    currentSongIndex.value = index;
    await audioPlayer.seek(Duration.zero, index: index);
    await audioPlayer.play();
    isPlaying.value = true;
    audioPlayer.durationStream.listen(
      (d) {
        duration.value = d ?? Duration();
      },
    );

    audioPlayer.durationStream.listen((p) {
      position.value = p ?? Duration();
    });

    currentPlayingSong.value = allSongsListFromDevice[currentSongIndex.value];
    print(
        "${currentPlayingSong.value!.id} ${currentPlayingSong.value!.musicName} ${currentPlayingSong.value!.musicAlbumName}");
    if (isRecentlyPlayed != null) {
      if (!isRecentlyPlayed && index != null) {
        // Update the recently played list
        Box<RecentlyPlayedModel> recentlyPlayedBox =
            Hive.box<RecentlyPlayedModel>('recent');
        RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
                'recent',
                defaultValue:
                    RecentlyPlayedModel(recentlyPlayedSongsList: [])) ??
            RecentlyPlayedModel(recentlyPlayedSongsList: []);
        recentlyPlayedModel.addRecentlyPlayedSong(currentPlayingSong.value!);
        recentlyPlayedBox.put('recent', recentlyPlayedModel);
        update();
      }
    }
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

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
