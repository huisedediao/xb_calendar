import 'package:xb_calendar/xb_calendar_config.dart';
import 'package:xb_scaffold/xb_scaffold.dart';
import 'package:flutter/material.dart';
import 'xb_calendar_display.dart';
import 'xb_calendar_model.dart';
import 'xb_calendar_month_cell.dart';

class XBCalendar extends XBWidget<XBCalendarVM> {
  /// 选择完成回调
  final ValueChanged<List<DateTime>> onDone;

  /// 即将完成回调
  final XBValueGetter<bool, List<DateTime>>? onWillDone;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 顶部标题
  final String? title;

  /// 确定按钮的文字
  final String? doneBtnText;

  /// 展示的日期范围：最小的日期，有效部分只到月份
  final DateTime? minDateTime;

  /// 展示的日期范围：最大的日期，有效部分只到月份
  final DateTime? maxDateTime;

  /// 可以选择的最小日期
  final DateTime? minEnableDateTime;

  /// 可以选择的最大日期
  final DateTime? maxEnableDateTime;

  /// 选择的日期
  final List<DateTime>? selectedDates;

  /// 年的单位
  final String yearUnit;

  /// 月的单位
  final String monthUnit;

  /// weekday的显示
  final List<String>? weekDays;

  /// weekday的显示
  final XBCalendarDisplay? display;

  XBCalendar(
      {required this.onDone,
      this.onWillDone,
      this.onCancel,
      this.title,
      this.doneBtnText,
      this.minDateTime,
      this.maxDateTime,
      this.minEnableDateTime,
      this.maxEnableDateTime,
      this.selectedDates,
      this.yearUnit = "年",
      this.monthUnit = "月",
      this.weekDays,
      this.display,
      super.key}) {
    xbCalendarDayH = display?.dDayHeight;
    xbCalendarDayRowGap = display?.dDayRowGap ?? 0;
  }

  @override
  generateVM(BuildContext context) {
    tempContext ??= context;
    return XBCalendarVM(context: context);
  }

  double get _closeW => 25;

  @override
  Widget buildWidget(XBCalendarVM vm, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Container(
        height: screenH * 0.85,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  XBButton(
                    onTap: vm.goCurrentDay,
                    coverTransparentWhileOpacity: true,
                    child: Container(
                      width: _closeW + spaces.gapLess * 2,
                      height: 50,
                      alignment: Alignment.center,
                      child: XBImage(
                        "packages/xb_calendar/assets/images/icon_current_day.png",
                        width: _closeW,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            title ?? "日期选择",
                            style: display?.textStyleTitle,
                          ))),
                  XBButton(
                    onTap: () {
                      pop();
                      onCancel?.call();
                    },
                    coverTransparentWhileOpacity: true,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: spaces.gapLess,
                          right: spaces.gapLess,
                          top: 10,
                          bottom: 10),
                      child: XBImage(
                        "packages/xb_calendar/assets/images/icon_close.png",
                        width: _closeW,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: chooseBtn(
                        text: vm.scrollYear,
                        onPrevious: vm.previousYear,
                        onNext: vm.nextYear,
                        mainAxisAlignment: MainAxisAlignment.start),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          vm.scrollDate,
                          style: display?.textStyleScrollDate,
                        )),
                  ),
                  Expanded(
                    child: chooseBtn(
                        text: vm.scrollMonth,
                        onPrevious: vm.previousMonth,
                        onNext: vm.nextMonth,
                        mainAxisAlignment: MainAxisAlignment.end),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: List.generate(vm.weekDays.length, (index) {
                  return Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(vm.weekDays[index])));
                }),
              ),
            ),
            Container(
              height: 10,
              color: Colors.grey.withAlpha(30),
            ),
            Expanded(
                child: ScrollConfiguration(
              behavior: const ScrollBehavior()
                  .copyWith(overscroll: false, scrollbars: false), // 禁用滚动条
              child: ListView.builder(
                controller: vm.controller,
                itemCount: vm.monthCount,
                itemBuilder: (context, index) {
                  XBCalendarMonth month = vm.monthForIndex(index);
                  return XBCalendarMonthCell(
                    month: month,
                    onSelectDate: vm.onSelectDate,
                    display: display,
                    yearUnit: yearUnit,
                    monthUnit: monthUnit,
                  );
                },
              ),
            )),
            xbSpaceHeight(10),
            Padding(
              padding: EdgeInsets.only(
                  left: spaces.gapDef,
                  right: spaces.gapDef,
                  bottom: safeAreaBottom + spaces.gapDef),
              child: XBButton(
                  onTap: () async {
                    bool pass = onWillDone?.call(vm.selectedDates) ?? true;
                    if (pass) {
                      pop();
                      onDone.call(vm.selectedDates);
                    }
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(display?.dDoneBtnRadius ?? 6),
                    child: Container(
                        alignment: Alignment.center,
                        height: display?.dDoneBtnHeight ?? 50,
                        color: display?.colorDoneBtnBg ?? Colors.blue,
                        child: Text(
                          doneBtnText ?? "确定",
                          style: display?.textStyleDoneBtn ??
                              const TextStyle(color: Colors.white),
                        )),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget chooseBtn(
      {required String text,
      required VoidCallback onPrevious,
      required VoidCallback onNext,
      MainAxisAlignment? mainAxisAlignment}) {
    double gap = spaces.gapLess * 0.5;
    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            XBButton(
              coverTransparentWhileOpacity: true,
              onTap: onPrevious,
              child: Padding(
                padding: EdgeInsets.only(
                    left: spaces.gapLess, right: gap, top: 5, bottom: 5),
                child: const XBImage(
                  "packages/xb_calendar/assets/images/icon_previous.png",
                  width: 18,
                ),
              ),
            ),
            Text(text),
            XBButton(
              coverTransparentWhileOpacity: true,
              onTap: onNext,
              child: Padding(
                padding: EdgeInsets.only(
                    left: gap, right: spaces.gapLess, top: 5, bottom: 5),
                child: const XBImage(
                  "packages/xb_calendar/assets/images/icon_next.png",
                  width: 18,
                ),
              ),
            ),
          ],
        ));
  }
}

class XBCalendarVM extends XBVM<XBCalendar> {
  late ScrollController controller;
  late DateTime createDateTime;
  int get createYear => createDateTime.year;
  int get createMonth => createDateTime.month;

  late DateTime minDateTime;
  late DateTime maxDateTime;

  @override
  widgetSizeDidChanged() {
    xbCalendarMaxW = widgetSize.width;
  }

  XBCalendarVM({required super.context}) {
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
          maxEnableDateTime: widget.maxEnableDateTime);
    }
    selectedDates = widget.selectedDates ?? [];
    selectedDates.sort();
    updateYears();
    controller = ScrollController(initialScrollOffset: initOffset);
    controller.addListener(offsetListener);
  }

  @override
  void dispose() {
    controller.removeListener(offsetListener);
    tempContext = null;
    super.dispose();
  }

  offsetListener() {
    notify();
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

  XBCalendarMonth monthForIndex(int index) {
    int i = 0;
    for (var year in years.values) {
      for (var month in year.months) {
        if (i == index) {
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
    if (selectedDates.length == 2) {
      selectedDates.clear();
    }
    selectedDates.add(dateTime);
    selectedDates.sort();
    updateYears();
    notify();
  }

  updateYears() {
    for (var year in years.values) {
      year.updateSelectState(selectedDates);
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

  XBCalendarYear? yearModelForYear(int year) {
    for (var element in years.values) {
      if (element.year == year) {
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

  String get scrollMonth => '$scrollMonthInt';

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
    controller.animateTo(offsetForDateTime(DateTime(year, month)),
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
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
    controller.animateTo(offsetForDateTime(DateTime(year, month)),
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }
}
