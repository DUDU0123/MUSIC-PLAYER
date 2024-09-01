import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/core/enums/page_and_menu_type_enum.dart';

class SortRadioTitleWidget extends StatelessWidget {
  const SortRadioTitleWidget({
    super.key,
    required this.sortMethod,
    required this.value,
    this.onChanged,
    required this.text,
    this.onTap,
  });

  final SortMethod sortMethod;
  final SortMethod value;
  final void Function(SortMethod?)? onChanged;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: TextWidgetCommon(
        text: text,
        fontSize: 15.sp,
        color: kWhite,
        fontWeight: FontWeight.w500,
      ),
      trailing: Radio(
        activeColor: kRed,
        value: value,
        groupValue: sortMethod,
        onChanged: (value) {
          if (value != null) {
            onChanged!(value);
          }
        },
      ),
    );
  }
}
