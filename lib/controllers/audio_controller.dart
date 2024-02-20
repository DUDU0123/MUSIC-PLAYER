import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxInt currentSongIndex = RxInt(-1);
  RxList<AllMusicsModel> allSongs = <AllMusicsModel>[].obs;

  Future<void> initializeAudioPlayer(List<AllMusicsModel> songs) async {
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: songs.map((song) => AudioSource.uri(Uri.parse(song.musicUri))).toList(),
      ),
      initialIndex: currentSongIndex.value,
      preload: false,
    );

    // Listen to audio player events
    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        if (currentSongIndex < allSongs.length - 1) {
          // Play the next song if available
          playNext();
        } else {
          // Handle the end of the playlist (looping)
          if (audioPlayer.loopMode == LoopMode.all) {
            playSong(0);
          } else {
            stop();
          }
        }
      }
    });
  }

  Future<void> requestPermissionAndFetchSongs() async {
    var status = await requestPermission();
    if (status.isGranted) {
      await fetchSongsFromDevice();
      initializeAudioPlayer(allSongs);
    } else {
      // Handle permission denied
      print('Permission denied');
    }
  }

  Future<PermissionStatus> requestPermission() async {
    try {
      var status = await Permission.storage.request();
      return status;
    } catch (e) {
      print('Error requesting permission: $e');
      return PermissionStatus.denied;
    }
  }

  Future<void> fetchSongsFromDevice() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    try {
      final songs = await audioQuery.querySongs(
        sortType: null,
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      allSongs.clear();
      allSongs.addAll(songs.map((song) => AllMusicsModel.fromSongModel(song)).toList());
    } catch (e) {
      print('Error fetching songs: $e');
      // Handle error fetching songs
    }
  }

  Future<void> playSong(int index) async {
    if (allSongs.isEmpty) {
      return;
    }

    currentSongIndex.value = index;
    await audioPlayer.seek(Duration.zero, index: index);
    await audioPlayer.play();
    isPlaying.value = true;
  }

  Future<void> pause() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    isPlaying.value = false;
  }

  Future<void> playNext() async {
    if (currentSongIndex < allSongs.length - 1) {
      currentSongIndex++;
      await playSong(currentSongIndex.value);
    }
  }

  Future<void> playPrevious() async {
    if (currentSongIndex > 0) {
      currentSongIndex--;
      await playSong(currentSongIndex.value);
    }
  }

  Future<void> toggleLoopMode() async {
    switch (audioPlayer.loopMode) {
      case LoopMode.off:
        audioPlayer.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        audioPlayer.setLoopMode(LoopMode.off);
        break;
    }
  }

  Future<List<AllMusicsModel>> getAllSongs() async {
    await fetchSongsFromDevice();
    return allSongs;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
