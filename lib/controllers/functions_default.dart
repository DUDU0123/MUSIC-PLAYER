import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

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
}
