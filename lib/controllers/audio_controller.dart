import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/permission_request_class.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/models/recently_played_model.dart';
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
  RxBool isRecentlyPlayed = false.obs;
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
  RxBool isSongDeleted = false.obs;
  RxBool isShuffleSongs = false.obs;
  Rx<PageTypeEnum> pageType = PageTypeEnum.homePage.obs;
  RecentlyPlayedModel recentlyPlayedModel =
      RecentlyPlayedModel(recentlyPlayedSongsList: []);

  // function for making slider move according to song position duration
  changeToSeconds(int seconds) {
    Rx<Duration> seekDurationSlider = Duration(seconds: seconds).obs;
    audioPlayer.seek(seekDurationSlider.value);
  }

  // for initializing audio player
  Future<void> intializeAudioPlayer(List<AllMusicsModel> songs) async {
    try {
      await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: songs.map((song) {
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
      currentPlayingSong.value = AllFiles.files.value[currentSongIndex.value];
    } catch (e) {
      
    }
    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed &&
          event.currentIndex != null) {
        if (currentSongIndex < AllFiles.files.value.length - 1) {
          currentPlayingSong.value = AllFiles.files.value[event.currentIndex!];
          playNextSong();
        } else {
          if (audioPlayer.loopMode == LoopMode.all &&
              currentPlayingSong.value != null) {
            currentPlayingSong.value =
                AllFiles.files.value[event.currentIndex!];
            //play song
            playSong(currentPlayingSong.value!);
          } else {
            //stop
            stopSong();
          }
        }
        // Update UI with the new song details
        currentPlayingSong.value = AllFiles.files.value[event.currentIndex!];
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
    var status = await PermissionRequestClass.permissionStorage();
    bool ispermanetelydenied = await Permission.storage.isPermanentlyDenied;
    if (status) {
      await fetchSongsFromDeviceStorage();
      await intializeAudioPlayer(AllFiles.files.value);
    } else if (ispermanetelydenied) {
      await openAppSettings();
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
    final songs = await onAudioQuery.querySongs(
      sortType: null,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
    );
    //allSongsListFromDevice.clear();
    AllFiles.files.value.clear();

    List<AllMusicsModel> allsongs =
        songs.map((song) => AllMusicsModel.fromSongModel(song)).toList();
    List<AllMusicsModel> songsList = <AllMusicsModel>[];

    for (var element in allsongs) {
      if (File(element.musicPathInDevice).existsSync()) {
        songsList.add(element);
      }
    }

    // allSongsListFromDevice.addAll(songsList);
    AllFiles.files.value = songsList;

    await addSongsToDB(AllFiles.files.value);
  }

  void clearRecentlyPlayedSongs() {
    recentlyPlayedBox.put(
      'recent',
      RecentlyPlayedModel(recentlyPlayedSongsList: []),
    );
    update();
  }

  // add  songs to hive db
  Future<void> addSongsToDB(List<AllMusicsModel> songs) async {
    final Box<AllMusicsModel> musicBox = Hive.box<AllMusicsModel>('musics');
    await musicBox.clear();
    final List<AllMusicsModel> songsCopy = List.from(songs);

    for (var song in songsCopy) {
      await musicBox.put(song.id, song);
    }
  }

  Future initializeRecentlyPlayedSongs() async {
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

  Future<void> playSong(AllMusicsModel song) async {
    int index = AllFiles.files.value.indexWhere((s) {
      return s.id == song.id;
    });
    if (AllFiles.files.value.isEmpty ||
        index < 0 ||
        index >= AllFiles.files.value.length) {
      Get.snackbar(
        "SOMETHING HAPPENED",
        "Song not exist",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kTileColor,
        colorText: kWhite,
        duration: const Duration(seconds: 1),
      );
      AllFiles.files.value.remove(song);
      return;
    }

    audioPlayer.playbackEventStream.listen((event) {
      if (event.currentIndex != null) {
        currentSongIndex.value = event.currentIndex!;
        currentPlayingSong.value = AllFiles.files.value[currentSongIndex.value];

        AllMusicsModel nextSong = AllFiles.files.value[event.currentIndex!];
        if (!isSongRecentlyPlayed(nextSong, musicBox.values.toList())) {
          RecentlyPlayedModel recentlyPlayedModel = recentlyPlayedBox.get(
                'recent',
                defaultValue: RecentlyPlayedModel(recentlyPlayedSongsList: []),
              ) ??
              RecentlyPlayedModel(recentlyPlayedSongsList: []);
          recentlyPlayedModel.removeRecentlyPlayedSong(nextSong);
          recentlyPlayedModel.addRecentlyPlayedSong(nextSong);
          recentlyPlayedBox.put('recent', recentlyPlayedModel);
          update();
        }
      }
    });
    await audioPlayer.seek(Duration.zero, index: index);
    await audioPlayer.play();
    isPlaying.value = true;
    if (currentPlayingSong.value != null) {
      isRecentlyPlayed.value = isSongRecentlyPlayed(
          currentPlayingSong.value!, musicBox.values.toList());
    }
    audioPlayer.durationStream.listen(
      (d) {
        duration.value = d ?? const Duration();
      },
    );
    audioPlayer.durationStream.listen((p) {
      position.value = p ?? const Duration();
    });
    // Update the current playing song
    update();
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
    if (currentSongIndex < AllFiles.files.value.length - 1) {
      currentSongIndex++;
      isPlaying.value = true;
      await playSong(AllFiles.files.value[currentSongIndex.value]);
    } else {
      Get.snackbar(
        "Play Back",
        "No songs to play next",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kTileColor,
        colorText: kWhite,
        duration: const Duration(seconds: 1),
      );
    }
  }

// function for play previous song
  Future<void> playPreviousSong() async {
    if (currentSongIndex > 0) {
      currentSongIndex--;
      isPlaying.value = true;
      await playSong(AllFiles.files.value[currentSongIndex.value]);
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
    return AllFiles.files.value;
  }

  // function for delete a song permanently
  Future<void> deleteSongsPermentaly(
      List<int> songIds, BuildContext context) async {
    var status = await PermissionRequestClass.permissionStorageToDelete();
    if (status) {
      await stopSong();
      try {
        for (var songId in songIds) {
          AllMusicsModel? songToDelete = AllFiles.files.value
              .firstWhereOrNull((song) => song.id == songId);
          if (songToDelete != null) {
            // allSongsListFromDevice.remove(songToDelete);
            AllFiles.files.value.remove(songToDelete);

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
            await musicBox.delete(songId);
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
          colorText: kWhite,
          backgroundColor: kTileColor,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          "Error !!!!!",
          "$e",
          duration: const Duration(seconds: 1),
          colorText: kWhite,
        );
      }
    } else {
      Get.snackbar(
        "Can't delete",
        "Permission Denied to delete a file",
        colorText: kWhite,
        backgroundColor: kTileColor,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    requestPermissionAndFetchSongsAndInitializePlayer();
    
    // fetchSongsFromDeviceStorage();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
