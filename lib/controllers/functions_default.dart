import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';
import 'package:share_plus/share_plus.dart';

class AppUsingCommonFunctions {
  static bool shouldShowAllOptions(
      PageTypeEnum pageType, TabType currentTabType) {
    if (currentTabType == TabType.songs) {
      // Show all options for the MusicHomePage
      return true;
    } else {
      // Show only "Settings" for MusicArtistPage, MusicAlbumPage, and MusicPlaylistPage
      return pageType == PageTypeEnum.artistPage;
    }
  }

  static int parseSongSize(String songSize) {
    // Remove non-numeric characters and parse the remaining string as an integer
    return int.parse(songSize.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  // function for getting size of file in mb or kb
  static String convertToMBorKB(int bytes) {
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

  // its for favourite
  static int convertToMBorKBInt(int bytes) {
    const int kB = 1024;
    const int mB = kB * 1024;

    if (bytes >= mB) {
      return (bytes / mB).toInt(); // Return size in MB as an integer
    } else if (bytes >= kB) {
      return (bytes / kB).toInt(); // Return size in KB as an integer
    } else {
      return bytes; // Return size in Bytes
    }
  }

  // function to send more song
  static void sendMoreSong(List<AllMusicsModel> songs) async {
    for (var song in songs) {
      if (song.musicPathInDevice.isNotEmpty && songs.length < 10) {
        try {
          List<XFile> listOfSongs = [XFile(song.musicPathInDevice)];
          try {
            await Share.shareXFiles(listOfSongs);
          } catch (e) {
            Get.snackbar(
              "Error Occured",
              "$e",
              colorText: kWhite,
              backgroundColor: kTileColor,
              duration: const Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } catch (e) {
          Get.snackbar(
            "Error Occured",
            "An error occured on sending the song",
            colorText: kWhite,
            backgroundColor: kTileColor,
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    }
  }

  // function to send one song
  static void sendOneSong(AllMusicsModel song) async {
    if (song.musicPathInDevice.isNotEmpty) {
      try {
        List<XFile> listOfSongs = [XFile(song.musicPathInDevice)];
        try {
          await Share.shareXFiles(listOfSongs);
        } catch (e) {
          Get.snackbar(
            "Error Occured",
            "$e",
            colorText: kWhite,
            backgroundColor: kTileColor,
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error Occured",
          "An error occured on sending the song",
          colorText: kWhite,
          backgroundColor: kTileColor,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
