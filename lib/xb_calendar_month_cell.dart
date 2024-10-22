import 'package:flutter/material.dart';
import 'package:xb_scaffold/xb_scaffold.dart';
import 'xb_calendar_config.dart';
import 'xb_calendar_display.dart';
import 'xb_calendar_model.dart';
import 'xb_calendar_painter.dart';

class XBCalendarMonthCell extends XBWidget<XBCalendarMonthCellVM> {
  final XBCalendarMonth month;
  final ValueChanged<DateTime> onSelectDate;
  final XBCalendarDisplay? display;
  final String yearUnit;
  final String monthUnit;

  const XBCalendarMonthCell(
      {required this.month,
      required this.onSelectDate,
      this.display,
      this.yearUnit = "年",
      this.monthUnit = "月",
      super.key});

  @override
  generateVM(BuildContext context) {
    return XBCalendarMonthCellVM(context: context);
  }

  @override
  Widget buildWidget(XBCalendarMonthCellVM vm, BuildContext context) {
    return SizedBox(
      height: month.height,
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "${month.month}",
                style:
                    TextStyle(fontSize: 100, color: Colors.black.withAlpha(10)),
              ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: xbCalendarMonthH,
                  alignment: Alignment.center,
                  child: Text(
                      "${month.year} $yearUnit ${month.month} $monthUnit"))),
          Positioned(
              top: 50,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTapDown: (details) {
                  vm.position = details.localPosition;
                },
                onTap: vm.onTap,
                child: CustomPaint(
                  size: Size(screenW, month.height - xbCalendarMonthH),
                  painter: XBCalendarPainter(
                      month: month,
                      daySize: Size(
                          xbCalendarDayW, xbCalendarDayH ?? xbCalendarDayW),
                      display: display),
                ),
              ))
        ],
      ),
    );
  }
}

class XBCalendarMonthCellVM extends XBVM<XBCalendarMonthCell> {
  XBCalendarMonthCellVM({required super.context});

  @override
  void didUpdateWidget(covariant XBCalendarMonthCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    notify();
  }

  Offset? position;

  onTap() {
    if (position == null) return;
    int row = position!.dy ~/
        ((xbCalendarDayH ?? xbCalendarDayW) + xbCalendarDayRowGap);
    int col = position!.dx ~/ xbCalendarDayW;
    int index = row * 7 + col - widget.month.firstDayWeekDayIndex;
    final day = widget.month.days[index];
    if (day.isEnable == false) return;
    widget.onSelectDate(day.dateTime);
  }
}
