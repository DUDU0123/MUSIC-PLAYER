import 'package:get/get.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';

class TabHandleController extends GetxController {
  Rx<TabType> currentTabType = TabType.songs.obs;
}