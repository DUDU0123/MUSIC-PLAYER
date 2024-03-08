import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/settings/widgets/terms_privacy_common_text_widget.dart';

class TermsAndPolicyTexts extends StatelessWidget {
  const TermsAndPolicyTexts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        kHeight50,
        TextWidgetCommon(
          textAlign: TextAlign.center,
          text:
              "Welcome to Music Box!\n\nThese terms of service ('Terms') govern your use of the Music Box application and services",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
        kHeight20,
        const TermsAndPolicyCommonTextWidgetForHeading(
          textAlign: TextAlign.center,
          text:
              " By using the Music Box application, you agree to comply with and be bound by these Terms. If you do not agree with any part of these Terms, please do not use the Music Box application. The Music Box application allows you to access and listen to music.Users are solely responsible for the content they upload, share, or otherwise make available on the Music Box application. The Music Box application and its content are protected by copyright and other intellectual property laws. You may not reproduce, distribute, modify, or create derivative works from any part of the Music Box application without our prior written consent. We reserve the right to terminate or suspend your access to the Music Box application at any time without prior notice if you violate these Terms.",
        ),
        kHeight30,
        TextWidgetCommon(
          textAlign: TextAlign.center,
          text:
              "Your privacy is important to us. This Privacy Policy explains how Music Box collects, uses, and protects your personal information.",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.w500,
        ),
        kHeight25,
        const TermsAndPolicyCommonTextWidgetForHeading(
          textAlign: TextAlign.center,
          text:
              "We may collect personal information, such as your device information, to provide you with a personalized music experience. We use your information to enhance your experience, improve our services, and communicate with you about updates and features. We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as required by law. We implement security measures to protect your personal information from unauthorized access and disclosure. We may update our Privacy Policy from time to time. Please review this policy periodically for changes.",
        ),
        kHeight60,
        const TermsAndPolicyCommonTextWidgetForHeading(
          textAlign: TextAlign.center,
          text:
              "By using the Music Box application, you agree to the terms outlined in this Privacy Policy.",
        ),
        kHeight30,
        const TermsAndPolicyCommonTextWidgetForHeading(
          textAlign: TextAlign.center,
          text:
              "If you have any questions or concerns about our Terms of Service or Privacy Policy, please contact us at sdu200115@gmail.com.",
        ),
        kHeight25,
        TextWidgetCommon(
          text: "Thank you for using Music Box!",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.bold,
        ),
        kHeight20,
      ],
    );
  }
}