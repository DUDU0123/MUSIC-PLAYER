import 'package:flutter/material.dart';

class TextWidgetCommon extends StatelessWidget {
  const TextWidgetCommon({
    super.key,
    required this.text,
    required this.fontSize,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.color,
    this.fontWeight, this.fontFamily,
  });
  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
