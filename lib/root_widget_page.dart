import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/splash_screen/splash_screen.dart';
class RootWidgetPage extends StatelessWidget {
  const RootWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? _) {
        return GetMaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: kBlack,
              appBarTheme: AppBarTheme(
                backgroundColor: kBlack,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: const MusicBoxSplashScreen()
            );
      },
    );
  }
}
