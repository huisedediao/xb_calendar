import 'xb_calendar_config.dart';

class XBCalendarYear {
  final int year;
  final List<XBCalendarMonth> _months = [];
  List<XBCalendarMonth> get months => _months;
  XBCalendarYear(
      {required this.year,
      required DateTime minDateTime,
      required DateTime maxDateTime,
      required DateTime? minEnableDateTime,
      required DateTime? maxEnableDateTime}) {
    for (int i = 1; i <= 12; i++) {
      if ((year == minDateTime.year && i < minDateTime.month) ||
          (year == maxDateTime.year && i > maxDateTime.month)) continue;
      _months.add(XBCalendarMonth(
          year: year,
          month: i,
          minEnableDateTime: minEnableDateTime,
          maxEnableDateTime: maxEnableDateTime));
    }
  }

  @override
  String toString() {
    String ret = "\n$year年\n";
    for (var month in _months) {
      ret += "${month.month}月, 行数：${month.lineCount} ,";
      for (var day in month.days) {
        ret += "$day ";
      }
      ret += "\n";
    }
    return ret;
  }

  double? _height;
  double get height {
    if (_height != null) return _height!;
    if (months.isEmpty) return 0;
    _height = offset(months.last.month + 1);
    return _height!;
  }

  /// 月份的起始偏移
  double offset(int month) {
    if (months.isEmpty) return 0;
    double ret = 0;
    for (int i = months.first.month; i < month; i++) {
      ret += months[i - months.first.month].height;
    }
    return ret;
  }

  updateSelectState(List<DateTime> selectedDates) {
    for (var month in months) {
      month.updateSelectState(selectedDates);
    }
  }
}

class XBCalendarMonth {
  final int year;
  final int month;
  final List<XBCalendarDay> _days = [];
  List<XBCalendarDay> get days => _days;
  XBCalendarMonth(
      {required this.year,
      required this.month,
      required DateTime? minEnableDateTime,
      required DateTime? maxEnableDateTime}) {
    /// 根据年份月份，生成日期，需要考虑闰年
    final DateTime lastDay = DateTime(year, month + 1, 0);
    final now = DateTime.now();
    for (int i = 1; i <= lastDay.day; i++) {
      final dateTime = DateTime(year, month, i);
      bool isEnable = (minEnableDateTime == null ||
              (dateTime.isAfter(minEnableDateTime) ||
                  (dateTime.year == minEnableDateTime.year &&
                      dateTime.month == minEnableDateTime.month &&
                      dateTime.day == minEnableDateTime.day))) &&
          (maxEnableDateTime == null ||
              dateTime.isBefore(maxEnableDateTime) ||
              (dateTime.year == maxEnableDateTime.year &&
                  dateTime.month == maxEnableDateTime.month &&
                  dateTime.day == maxEnableDateTime.day));
      _days.add(XBCalendarDay(
          dateTime: dateTime,
          isEnable: isEnable,
          isToday: year == now.year && month == now.month && i == now.day));
    }
  }

  /// 本月有多少行
  int? _lineCount;
  int get lineCount {
    if (_lineCount == null) {
      int residue = (days.length + firstDayWeekDayIndex) % 7;
      _lineCount =
          (days.length + firstDayWeekDayIndex) ~/ 7 + (residue != 0 ? 1 : 0);
    }
    return _lineCount!;
  }

  /// 本月第一天，是周几（从周日开始算，周日为0）
  int get firstDayWeekDayIndex {
    int ret = DateTime(year, month, 1).weekday;
    if (ret == 7) {
      return 0;
    }
    return ret;
  }

  /// 本月所占用的高度
  double get height {
    return ((xbCalendarDayH ?? xbCalendarDayW) + xbCalendarDayRowGap) *
            lineCount +
        xbCalendarMonthH;
  }

  updateSelectState(List<DateTime> selectedDates) {
    if (selectedDates.length == 1) {
      for (var day in days) {
        if (selectedDates.first.year == day.dateTime.year &&
            selectedDates.first.month == day.dateTime.month &&
            selectedDates.first.day == day.dateTime.day) {
          day.isSelected = true;
          day.isInRange = false;
          day.isSelectedStart = true;
          day.isSelectedEnd = true;
        } else {
          day.isSelected = false;
          day.isInRange = false;
          day.isSelectedStart = false;
          day.isSelectedEnd = false;
        }
      }
    } else if (selectedDates.length == 2) {
      for (var day in days) {
        bool isStart = selectedDates.first.year == day.dateTime.year &&
            selectedDates.first.month == day.dateTime.month &&
            selectedDates.first.day == day.dateTime.day;
        bool isEnd = selectedDates.last.year == day.dateTime.year &&
            selectedDates.last.month == day.dateTime.month &&
            selectedDates.last.day == day.dateTime.day;
        if (isStart || isEnd) {
          day.isSelected = true;
          day.isInRange = false;
          day.isSelectedStart = isStart;
          day.isSelectedEnd = isEnd;
        } else if (day.dateTime.isAfter(selectedDates.first) &&
            day.dateTime.isBefore(selectedDates.last)) {
          day.isSelected = false;
          day.isInRange = true;
          day.isSelectedStart = false;
          day.isSelectedEnd = false;
        } else {
          day.isSelected = false;
          day.isInRange = false;
          day.isSelectedStart = false;
          day.isSelectedEnd = false;
        }
      }
    }
  }
}

class XBCalendarDay {
  final DateTime dateTime;
  final bool isEnable;
  bool isSelected = false;
  bool isInRange = false;
  bool isToday;
  bool isSelectedStart = false;
  bool isSelectedEnd = false;
  XBCalendarDay(
      {required this.dateTime, required this.isEnable, required this.isToday});
  @override
  String toString() {
    return dateTime.day.toString();
  }
}
