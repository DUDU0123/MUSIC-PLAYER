import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/constants/colors.dart';

class TextFieldCommonWidget extends StatelessWidget {
  const TextFieldCommonWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.errorText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String labelText;
  final String? Function(String?)? validator;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
