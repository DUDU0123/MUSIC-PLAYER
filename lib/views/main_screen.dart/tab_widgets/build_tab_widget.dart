import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';

class BuildTabWidget extends StatelessWidget {
  BuildTabWidget({
    super.key,
    required this.tabType,
    required this.text,
    required this.currentTabType,
    required this.pageController,
  });
  final TabType tabType;
  final String text;
  TabType? currentTabType;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        currentTabType = tabType;
        pageController.animateToPage(
          tabType.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          border: Border(
            bottom: BorderSide(
              color:
                  currentTabType == tabType ? kTileColor : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: currentTabType == tabType ? kRed : Colors.white,
          ),
        ),
      ),
    );
  }
}
