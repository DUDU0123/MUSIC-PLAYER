import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabSetUp extends StatelessWidget {
  const TabSetUp({
    super.key,
    required this.text,
    required this.fontSize,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.color,
    this.fontWeight,
    this.onTap,
    required this.borderColor,
  });
  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final Color? color;
  final FontWeight? fontWeight;
  final Color borderColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border(bottom: BorderSide(color: borderColor, width: 2))),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          textAlign: textAlign,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
