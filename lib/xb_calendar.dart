import 'package:xb_calendar/xb_calendar_config.dart';
import 'package:xb_scaffold/xb_scaffold.dart';
import 'package:flutter/material.dart';
import 'xb_calendar_display.dart';
import 'xb_calendar_model.dart';
import 'xb_calendar_month_cell.dart';
import 'xb_calendar_vm.dart';

class XBCalendarStreamData {
  final List<DateTime>? markDates;
  XBCalendarStreamData({this.markDates});
}

class XBCalendar extends XBWidget<XBCalendarVM> {
  /// 选择完成回调
  final ValueChanged<List<DateTime>> onDone;

  /// 即将完成回调
  final XBValueGetter<bool, List<DateTime>>? onWillDone;

  /// 滚动导致月份改变回调
  final ValueChanged<DateTime>? onMonthChange;

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

  /// 有标记的日期
  final List<DateTime>? initMarkDates;

  /// 年的单位
  final String yearUnit;

  /// 月的单位
  final String monthUnit;

  /// weekday的显示
  final List<String>? weekDays;

  /// weekday的显示
  final XBCalendarDisplay? display;

  /// 单选
  final bool isSingle;

  /// 更新数据的流
  final Stream<XBCalendarStreamData>? dataStream;

  XBCalendar(
      {required this.onDone,
      this.onWillDone,
      this.onMonthChange,
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
      this.isSingle = false,
      this.initMarkDates,
      this.dataStream,
      super.key}) {
    xbCalendarDayH = display?.dDayHeight;
    xbCalendarDayRowGap = display?.dDayRowGap ?? 0;
  }

  @override
  generateVM(BuildContext context) {
    return XBCalendarVM(context: context);
  }

  double get _closeW => 25;

  Widget hms(XBCalendarVM vm) {
    return Container();
  }

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
                children: vm.weekDaysWidgets,
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
            hms(vm),
            xbSpaceHeight(donePaddingTop),
            Padding(
              padding: EdgeInsets.only(
                  left: spaces.gapDef,
                  right: spaces.gapDef,
                  bottom: safeAreaBottom + spaces.gapDef),
              child: XBButton(
                  onTap: vm.onDone,
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

  double get donePaddingTop => 10;

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
