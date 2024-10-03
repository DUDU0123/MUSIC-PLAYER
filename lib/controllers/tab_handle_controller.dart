import 'package:get/get.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class TabHandleController extends GetxController {
    static TabHandleController get to => Get.find();
  Rx<TabType> currentTabType = TabType.songs.obs;
}