import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';

class TextFieldCommonWidget extends StatelessWidget {
  const TextFieldCommonWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.errorText, this.onTap, this.hintStyle, this.onChanged, this.focusNode,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String labelText;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      cursorColor: kRed,
      style: TextStyle(
        fontSize: 16.sp,
        color: kWhite,
      ),
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: kRed,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: kRed,
          ),
        ),
      ),
    );
  }
}
