import 'package:flutter/material.dart';
import 'package:xb_calendar/xb_calendar.dart';
import 'package:xb_calendar/xb_calendar_hms_vm.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class XBCalendarHms extends XBCalendar {
  XBCalendarHms({
    required super.onDone,
    super.key,
    super.onWillDone,
    super.onMonthChange,
    super.onCancel,
    super.title,
    super.doneBtnText,
    super.minDateTime,
    super.maxDateTime,
    super.minEnableDateTime,
    super.maxEnableDateTime,
    super.selectedDates,
    super.yearUnit = "年",
    super.monthUnit = "月",
    super.weekDays,
    super.display,
    super.markDates,
  }) : assert(selectedDates == null || selectedDates.length < 2,
            "selectedDates.length must be less than 2");

  @override
  XBCalendarHmsVM generateVM(BuildContext context) {
    return XBCalendarHmsVM(context: context);
  }

  XBCalendarHmsVM castVM(XBCalendarVM vm) {
    return vm as XBCalendarHmsVM;
  }

  @override
  double get donePaddingTop => 0;

  TextStyle get selectedStyle =>
      TextStyle(color: display?.colorHMSUnit ?? Colors.blue);

  @override
  Widget hms(XBCalendarVM vm) {
    return SizedBox(
      height: 140,
      child: Column(
        children: [
          xbLine(),
          Expanded(
              child: Stack(
            children: [
              XBTitlePickerMulti(
                mulTitles: castVM(vm).hms,
                selecteds: castVM(vm).selectedHMS,
                onSelected: castVM(vm).onSelected,
                selectedBG: Container(),
                selectedStyle: selectedStyle,
              ),
              Positioned.fill(
                  child: Row(
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(
                              "h",
                              style: selectedStyle,
                            ),
                          ))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(
                              "m",
                              style: selectedStyle,
                            ),
                          ))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(
                              "s",
                              style: selectedStyle,
                            ),
                          ))),
                ],
              ))
            ],
          ))
        ],
      ),
    );
  }
}
