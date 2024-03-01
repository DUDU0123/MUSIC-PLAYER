import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/settings/widgets/terms_and_policy_texts.dart';

class TermsAndPrivacyPolicyPage extends StatelessWidget {
  const TermsAndPrivacyPolicyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final kScreenWidth = MediaQuery.of(context).size.width;
    final kScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: kRed, size: 28.sp,)),
        automaticallyImplyLeading: false,
        title: TextWidgetCommon(
          text: "Terms And Privacy Policy",
          fontSize: 18.sp,
          color: kWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        decoration: BoxDecoration(
          color: kTileColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp)),
        ),
        width: kScreenWidth,
        height: kScreenHeight,
        child:const SingleChildScrollView(
          child: TermsAndPolicyTexts(),
        ),
      ),
    );
  }
}