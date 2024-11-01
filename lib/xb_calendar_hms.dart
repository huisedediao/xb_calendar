import 'package:flutter/material.dart';
import 'package:xb_calendar/xb_calendar.dart';
import 'package:xb_calendar/xb_calendar_hms_vm.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class XBCalendarHms extends XBCalendar {
  XBCalendarHms({
    required super.onDone,
    super.key,
    super.onWillDone,
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
  Widget hms(XBCalendarVM vm) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          xbLine(),
          Expanded(
              child: XBTitlePickerMulti(
            mulTitles: castVM(vm).hms,
            selecteds: castVM(vm).selectedHMS,
            onSelected: castVM(vm).onSelected,
          ))
        ],
      ),
    );
  }
}
