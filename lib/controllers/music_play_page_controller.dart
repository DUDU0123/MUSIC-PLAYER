import 'package:get/get.dart';

class MusicPlayPageController extends GetxController{
  int id = 0;

  void setId(int songId){
    id = songId;
    update();
  }
}