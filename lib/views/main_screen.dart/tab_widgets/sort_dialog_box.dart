import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/height_width.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/views/common_widgets/sort_radio_title_widget.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class SortDialogBox extends StatelessWidget {
  const SortDialogBox(
      {super.key,
      required this.audioController,
      required this.kScreenHeight,
      this.alphetOrderMethod,
      this.timeAddedOrderMethod});
  final AudioController audioController;
  final double kScreenHeight;
  final void Function(SortMethod?)? alphetOrderMethod;
  final void Function(SortMethod?)? timeAddedOrderMethod;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      surfaceTintColor: kTransparent,
      backgroundColor: kTileColor,
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              border: Border.all(color: kMenuBtmSheetColor)),
          height: kScreenHeight / 2.8,
          padding: EdgeInsets.only(top: 30.sp),
          child: Column(
            children: [
              TextWidgetCommon(
                text: "Select Sort Method",
                fontSize: 18.sp,
                color: kWhite,
                fontWeight: FontWeight.w500,
              ),
              kHeight20,
              SortRadioTitleWidget(
                onTap: () {
                  audioController.updateSortMethod(SortMethod.alphabetically);
                },
                text: "Display Alphabetically",
                sortMethod: audioController.currentSortMethod.value,
                value: SortMethod.alphabetically,
                onChanged: alphetOrderMethod,
              ),
              SortRadioTitleWidget(
                onTap: () {
                  audioController.updateSortMethod(SortMethod.byTimeAdded);
                },
                text: "Display by Time Added",
                sortMethod: audioController.currentSortMethod.value,
                value: SortMethod.byTimeAdded,
                onChanged: timeAddedOrderMethod,
              ),
              kHeight10,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  backgroundColor: kTileColor,
                  side: BorderSide(
                    color: kMenuBtmSheetColor,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: TextWidgetCommon(
                  text: "Done",
                  fontSize: 20.sp,
                  color: kWhite,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
