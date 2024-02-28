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
    this.fontWeight,
  });
  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final Color? color;
  final FontWeight? fontWeight;


  @override
  Widget build(BuildContext context) {
    return Text(
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
    );
  }
}
