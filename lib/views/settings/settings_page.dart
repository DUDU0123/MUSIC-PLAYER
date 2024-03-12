import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/settings/pages/about_us_page.dart';
import 'package:music_player/views/settings/pages/privacy_policy_page.dart';
import 'package:music_player/views/settings/pages/terms_and_conditions_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: kRed,
            size: 28.sp,
          ),
        ),
        title: TextWidgetCommon(
          text: "Settings",
          fontSize: 18.sp,
          color: kRed,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          children: [
            ListTile(
              onTap: () {},
              title: TextWidgetCommon(
                text: "Version",
                fontSize: 17.sp,
                color: kWhite,
              ),
              subtitle: TextWidgetCommon(
                text: "1.0.0",
                fontSize: 12.sp,
                color: kGrey,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(()=> const TermsAndConditionsPage());
              },
              title: TextWidgetCommon(
                text: "Terms and Conditions",
                fontSize: 17.sp,
                color: kWhite,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(()=> const PrivacyPolicyPage());
              },
              title: TextWidgetCommon(
                text: "Privacy Policy",
                fontSize: 17.sp,
                color: kWhite,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(()=> const AboutUsPage());
              },
              title: TextWidgetCommon(
                text: "About Us",
                fontSize: 17.sp,
                color: kWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




