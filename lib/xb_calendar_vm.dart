import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xb_calendar/xb_calendar_config.dart';
import 'package:xb_calendar/xb_calendar_model.dart';
import 'package:xb_scaffold/xb_scaffold.dart';
import 'xb_calendar.dart';

class XBCalendarVM extends XBVM<XBCalendar> {
  late ScrollController controller;
  late DateTime createDateTime;
  int get createYear => createDateTime.year;
  int get createMonth => createDateTime.month;

  late DateTime minDateTime;
  late DateTime maxDateTime;

  late bool isSingle;

  late List<Widget> weekDaysWidgets;

  DateTime? _scrollMonth;

  StreamSubscription? _dataStreamSubscription;

  /// 有标记的日期
  List<DateTime>? markDates;

  onDone() async {
    bool pass = widget.onWillDone?.call(selectedDates) ?? true;
    if (pass) {
      pop();
      widget.onDone.call(selectedDates);
    }
  }

  @override
  widgetSizeDidChanged() {
    xbCalendarMaxW = widgetSize.width;
  }

  XBCalendarVM({required super.context}) {
    markDates = widget.initMarkDates;
    _dataStreamSubscription = widget.dataStream?.listen((event) {
      markDates = event.markDates;
      if (markDates == null) return;
      for (var element in years.values) {
        element.updateMark(markDates);
      }
      notify();
    });
    isSingle = widget.isSingle;
    tempContext ??= context;
    createDateTime = DateTime.now();
    minDateTime = widget.minDateTime ?? DateTime(createYear - 25, 1);
    maxDateTime = widget.maxDateTime ?? DateTime(createYear + 25, 1);
    for (int i = minDateTime.year; i <= maxDateTime.year; i++) {
      if (i < minDateTime.year || i > maxDateTime.year) continue;
      years[i] = XBCalendarYear(
          year: i,
          minDateTime: minDateTime,
          maxDateTime: maxDateTime,
          minEnableDateTime: widget.minEnableDateTime,
          maxEnableDateTime: widget.maxEnableDateTime,
          markDates: markDates);
    }
    selectedDates = widget.selectedDates ?? [];
    selectedDates.sort();
    updateYears();
    controller = ScrollController(initialScrollOffset: initOffset);
    controller.addListener(offsetListener);
    weekDaysWidgets = weekDays
        .map((day) => Expanded(child: Center(child: Text(day))))
        .toList();
  }

  @override
  void dispose() {
    _dataStreamSubscription?.cancel();
    controller.removeListener(offsetListener);
    tempContext = null;
    super.dispose();
  }

  double _lastOffset = 0;
  offsetListener() {
    if ((controller.offset - _lastOffset).abs() > 10) {
      _lastOffset = controller.offset;
      notify();
    }
  }

  goCurrentDay() {
    controller.jumpTo(offsetForDateTime(createDateTime));
  }

  int? _monthCount;
  int get monthCount {
    if (_monthCount == null) {
      int i = 0;
      for (var year in years.values) {
        for (var _ in year.months) {
          i++;
        }
      }
      _monthCount = i;
    }
    return _monthCount!;
  }

  final Map<int, XBCalendarMonth> _monthForIndexMap = {};
  XBCalendarMonth monthForIndex(int index) {
    if (_monthForIndexMap[index] != null) {
      return _monthForIndexMap[index]!;
    }
    int i = 0;
    for (var year in years.values) {
      for (var month in year.months) {
        if (i == index) {
          _monthForIndexMap[index] = month;
          return month;
        }
        i++;
      }
    }
    throw Exception("传入的序号不对");
  }

  final Map<String, double> _offsetForYearMonthMap = {};
  double offsetForDateTime(DateTime dateTime) {
    String key = "${dateTime.year}_${dateTime.month}";
    if (_offsetForYearMonthMap[key] != null) {
      return _offsetForYearMonthMap[key]!;
    }
    double ret = 0;
    for (var element in years.values) {
      if (element.year < dateTime.year) {
        ret += element.height;
      } else if (element.year == dateTime.year) {
        ret += element.offset(dateTime.month);
        break;
      } else {
        break;
      }
    }
    _offsetForYearMonthMap[key] = ret;
    return ret;
  }

  double get initOffset {
    if (selectedDates.isEmpty) {
      return offsetForDateTime(createDateTime);
    } else {
      return offsetForDateTime(widget.selectedDates!.first);
    }
  }

  Map<int, XBCalendarYear> years = {};

  onSelectDate(DateTime dateTime) {
    if (selectedDates.length == 2 || isSingle) {
      selectedDates.clear();
    }
    selectedDates.add(dateTime);
    selectedDates.sort();
    updateYears();
    notify();
  }

  updateYears() {
    if (selectedDates.isEmpty) return;
    for (var year in years.values) {
      if (selectedDates.first.year <= year.year &&
          year.year <= selectedDates.last.year) {
        year.updateSelectState(selectedDates);
      }
    }
  }

  List<DateTime> selectedDates = [];

  int get scrollYearInt {
    try {
      double offset = 0;
      XBCalendarYear? year;
      for (var element in years.values) {
        offset += element.height;
        if (offset > controller.offset) {
          year = element;
          break;
        }
      }
      return year!.year;
    } catch (e) {
      if (widget.selectedDates == null || widget.selectedDates!.isEmpty) {
        return createYear;
      } else {
        return widget.selectedDates!.first.year;
      }
    }
  }

  String get scrollYear => '$scrollYearInt';

  String get scrollDate =>
      "$scrollYear${widget.yearUnit}$scrollMonth${widget.monthUnit}";

  final Map<int, XBCalendarYear> _yearModelForYearMap = {};
  XBCalendarYear? yearModelForYear(int year) {
    if (_yearModelForYearMap[year] != null) {
      return _yearModelForYearMap[year]!;
    }
    for (var element in years.values) {
      if (element.year == year) {
        _yearModelForYearMap[year] = element;
        return element;
      }
    }
    return null;
  }

  int get scrollMonthInt {
    try {
      XBCalendarYear year = yearModelForYear(scrollYearInt)!;
      double offset = offsetForDateTime(DateTime(year.year, 1));
      XBCalendarMonth? month;
      for (var element in year.months) {
        if (offset + year.offset(element.month + 1) > controller.offset) {
          month = element;
          break;
        }
      }
      return month!.month;
    } catch (e) {
      if (widget.selectedDates == null || widget.selectedDates!.isEmpty) {
        return createMonth;
      } else {
        return widget.selectedDates!.first.month;
      }
    }
  }

  String get scrollMonth {
    DateTime newDate = DateTime(scrollYearInt, scrollMonthInt);
    if (newDate.month != _scrollMonth?.month) {
      _scrollMonth = newDate;
      widget.onMonthChange?.call(_scrollMonth!);
    }
    return '$scrollMonthInt';
  }

  List<String> get weekDays =>
      widget.weekDays ?? ["日", "一", "二", "三", "四", "五", "六"];

  previousYear() {
    int year = scrollYearInt;
    year -= 1;
    if (year < minDateTime.year) return;
    int month = scrollMonthInt;
    if (year == minDateTime.year && month < minDateTime.month) {
      month = minDateTime.month;
    }
    controller.jumpTo(offsetForDateTime(DateTime(year, month)));
  }

  nextYear() {
    int year = scrollYearInt;
    year += 1;
    if (year > maxDateTime.year) return;
    int month = scrollMonthInt;
    if (year == maxDateTime.year && month > maxDateTime.month) {
      month = maxDateTime.month;
    }
    controller.jumpTo(offsetForDateTime(DateTime(year, month)));
  }

  previousMonth() {
    int year = scrollYearInt;
    int month = scrollMonthInt;
    if (month == 1) {
      year -= 1;
      month = 12;
    } else {
      month -= 1;
    }
    if (year < minDateTime.year ||
        (year == minDateTime.year && month < minDateTime.month)) return;
    controller
        .animateTo(offsetForDateTime(DateTime(year, month)),
            duration: const Duration(milliseconds: 500), curve: Curves.linear)
        .then((value) => notify());
  }

  nextMonth() {
    int year = scrollYearInt;
    int month = scrollMonthInt;
    if (month == 12) {
      year += 1;
      month = 1;
    } else {
      month += 1;
    }
    if (year > maxDateTime.year ||
        (year == maxDateTime.year && month > maxDateTime.month)) return;
    controller
        .animateTo(offsetForDateTime(DateTime(year, month)),
            duration: const Duration(milliseconds: 500), curve: Curves.linear)
        .then((value) => notify());
  }
}
