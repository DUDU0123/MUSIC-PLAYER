import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/constants/height_width.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
class AboutUsPageTexts extends StatelessWidget {
  const AboutUsPageTexts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        kHeight40,
         TextWidgetCommon(
          textAlign: TextAlign.center,
          text:
              "Welcome to Music Box!",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.bold,
        ),
        kHeight20,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "About the App",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
        kHeight5,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "MusicBox is a sleek and intuitive music player designed to deliver a seamless listening experience. With powerful features and a user-friendly interface, MusicBox makes it easy for you to enjoy your favorite tunes anytime, anywhere.",
          fontSize: 16.sp,
          color: kWhite,
          fontWeight: FontWeight.w400,
        ),
        kHeight20,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "Our Mission",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
        kHeight5,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "At MusicBox, our mission is to provide music enthusiasts with a delightful and immersive listening experience. We believe in the power of music to inspire, motivate, and bring joy to people's lives.",
          fontSize: 16.sp,
          color: kWhite,
          fontWeight: FontWeight.w400,
        ),

        kHeight20,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "Developer",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
         kHeight5,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "Sandra Mathew\n[Lead Developer , UI/UX Designer, Backend Developer]",
          fontSize: 16.sp,
          color: kWhite,
          fontWeight: FontWeight.w400,
        ),
        kHeight20,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "Acknowledgments",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
        kHeight5,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "We would like to express our gratitude to the open-source community for their valuable contributions.",
          fontSize: 16.sp,
          color: kWhite,
          fontWeight: FontWeight.w400,
        ),
        kHeight20,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "Contact Us",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
        kHeight5,
        TextWidgetCommon(
          textAlign: TextAlign.start,
          text:
              "Have questions or feedback? Reach out to us at sdu200115@gmail.com.",
          fontSize: 16.sp,
          color: kWhite,
          fontWeight: FontWeight.w400,
        ),
        kHeight30,
        TextWidgetCommon(
          textAlign: TextAlign.center,
          text:
              "Thank you for choosing MusicBox for your music journey!",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.bold,
        ),
        kHeight40,
      ],
    );
  }
}