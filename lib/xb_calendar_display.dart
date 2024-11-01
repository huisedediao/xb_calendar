import 'package:flutter/material.dart';

class XBCalendarDisplay {
  final TextStyle? textStyleTitle;
  final TextStyle? textStyleDoneBtn;
  final TextStyle? textStyleScrollDate;
  final double? dDoneBtnRadius;
  final double? dDoneBtnHeight;
  final Color? colorDoneBtnBg;
  final Color? colorSelectedDateText;
  final Color? colorSelectedDateBg;
  final Color? colorTodayText;
  final Color? colorSelectedTodayText;
  final Color? colorInRangeDateText;
  final Color? colorInRangeDateBg;
  final Color? colorMark;
  final Color? colorMarkSelected;
  final Color? colorMarkInRange;
  final Color? colorHMSUnit;
  final double? dMarkSize;
  final double? dDayRowGap;
  final double? dDayHeight;
  final double? dDayRadius;
  XBCalendarDisplay({
    this.textStyleTitle,
    this.textStyleDoneBtn,
    this.textStyleScrollDate,
    this.dDoneBtnRadius,
    this.dDoneBtnHeight,
    this.colorDoneBtnBg,
    this.colorSelectedDateText,
    this.colorSelectedDateBg,
    this.colorTodayText,
    this.colorSelectedTodayText,
    this.colorInRangeDateText,
    this.colorInRangeDateBg,
    this.colorMark,
    this.colorMarkSelected,
    this.colorMarkInRange,
    this.colorHMSUnit,
    this.dMarkSize,
    this.dDayRowGap,
    this.dDayHeight,
    this.dDayRadius,
  });
}
