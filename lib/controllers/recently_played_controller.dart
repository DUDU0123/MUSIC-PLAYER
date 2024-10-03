// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:music_player/constants/colors.dart';
// import 'package:music_player/models/allmusics_model.dart';
// import 'package:music_player/models/recently_played_model.dart';

// class RecentlyPlayedController extends GetxController {
//   static RecentlyPlayedController get to => Get.find();
//   Box<RecentlyPlayedModel> recentlyPlayedBox =
//       Hive.box<RecentlyPlayedModel>('recent');

//   List<RecentlyPlayedModel> getAllRecentlyPlayedSongsList() {
//     final List<RecentlyPlayedModel> recentlyPlayedSongs =
//         recentlyPlayedBox.values.toList();

//     recentlyPlayedSongs.sort((a, b) => DateTime.parse(b.dateTimeAdded)
//         .compareTo(DateTime.parse(a.dateTimeAdded)));

//     return recentlyPlayedSongs;
//   }

//   void addToRecentlyPlayedList({required AllMusicsModel song}) async {
//     try {
//       final List<RecentlyPlayedModel> recentlyPlayedSongs =
//           recentlyPlayedBox.values.toList();
//       // Check if the song already exists in the list
//       final bool isSongAlreadyInList = recentlyPlayedSongs.any(
//         (recentSong) => recentSong.recentlyPlayedSong.musicPathInDevice == song.musicPathInDevice,
//       );
//       if (isSongAlreadyInList) {
//         recentlyPlayedBox
//             .delete(song.id); // Remove the existing song from the box
//       }
//       final RecentlyPlayedModel newRecentlyPlayed = RecentlyPlayedModel(
//           recentlyPlayedSong: song, dateTimeAdded: DateTime.now().toString());
//       if (!isSongAlreadyInList) {
//         recentlyPlayedBox.put(song.id, newRecentlyPlayed);
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error !!!!!",
//         "$e",
//         duration: const Duration(seconds: 1),
//         colorText: kWhite,
//       );
//     }
//     update(); // Update the UI or listeners
//   }

//   void removeAllRecentlyPlayedSongs() {
//     try {
//       final List<RecentlyPlayedModel> recentlyPlayedSongs =
//           recentlyPlayedBox.values.toList();
//       recentlyPlayedSongs.clear();
//     } catch (e) {
//       Get.snackbar(
//         "Error !!!!!",
//         "$e",
//         duration: const Duration(seconds: 1),
//         colorText: kWhite,
//       );
//     }
//     update();
//   }
// }
