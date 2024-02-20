import 'package:get/get.dart';

class MusicPlayPageController extends GetxController{
  static MusicPlayPageController get to => Get.find();
  int id = 0;

  void setId(int songId){
    id = songId;
    update();
  }
}