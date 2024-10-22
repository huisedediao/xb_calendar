import 'package:flutter/material.dart';

class XBCalendarDisplay {
  final TextStyle? textStyleDoneBtn;
  final double? dDoneBtnRadius;
  final double? dDoneBtnHeight;
  final Color? bgColorDoneBtn;
  final Color? colorSelectedDateText;
  final Color? colorSelectedDateBg;
  final Color? colorTodayText;
  final Color? colorSelectedTodayText;
  final Color? colorInRangeDateText;
  final Color? colorInRangeDateBg;
  final double? dDayRowGap;
  final double? dDayHeight;
  XBCalendarDisplay({
    this.textStyleDoneBtn,
    this.dDoneBtnRadius,
    this.dDoneBtnHeight,
    this.bgColorDoneBtn,
    this.colorSelectedDateText,
    this.colorSelectedDateBg,
    this.colorTodayText,
    this.colorSelectedTodayText,
    this.colorInRangeDateText,
    this.colorInRangeDateBg,
    this.dDayRowGap,
    this.dDayHeight,
  });
}
