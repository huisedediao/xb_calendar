import 'package:flutter/material.dart';
import 'package:xb_calendar/xb_calendar_config.dart';
import 'xb_calendar_display.dart';
import 'xb_calendar_model.dart'; // 假设这个是你的模型文件

class XBCalendarPainter extends CustomPainter {
  final XBCalendarMonth month; // 传入一个月的数据
  final Size daySize; // 每天的方块大小
  final XBCalendarDisplay? display;

  XBCalendarPainter({required this.month, required this.daySize, this.display});

  @override
  void paint(Canvas canvas, Size size) {
    // 获取画笔
    final paint = Paint();

    // 定义圆角半径
    const radius = Radius.circular(10);

    // 行列布局，每行7天
    for (int i = 0; i < month.days.length; i++) {
      final day = month.days[i];
      final x = ((i + month.firstDayWeekDayIndex) % 7) * daySize.width;
      final y = ((i + month.firstDayWeekDayIndex) ~/ 7) *
          (daySize.height + xbCalendarDayRowGap);

      Color textColor;

      if (day.isSelected) {
        paint.color = display?.colorSelectedDateBg ?? Colors.blue; // 选中的日期
        textColor = display?.colorSelectedDateText ?? Colors.white;
        if (day.isToday) {
          textColor = display?.colorSelectedTodayText ?? Colors.limeAccent;
        }
      } else {
        if (day.isInRange) {
          paint.color = display?.colorInRangeDateBg ??
              (display?.colorSelectedDateBg ?? Colors.blue)
                  .withAlpha(100); // 在范围内的日期
          textColor = display?.colorInRangeDateText ?? Colors.black;
        } else {
          paint.color = Colors.transparent; // 普通日期
          textColor = Colors.black;
        }
        if (day.isToday) {
          textColor = display?.colorTodayText ?? Colors.green;
        }
      }

      final textStyle = TextStyle(
        color: textColor.withAlpha(day.isEnable ? 255 : 50),
        fontSize: 14,
      );

      // 绘制日期方块
      final rect = Rect.fromLTWH(x, y, daySize.width, daySize.height);

      // 圆角处理，根据开始日期和结束日期的状态判断
      if (day.isSelectedStart && day.isSelectedEnd) {
        // 如果开始日期和结束日期是同一天，则四个角都切圆角
        final rrect = RRect.fromRectAndCorners(rect,
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius);
        canvas.drawRRect(rrect, paint);
      } else if (day.isSelectedStart) {
        // 如果是开始日期，则只切左上和左下角
        final rrect =
            RRect.fromRectAndCorners(rect, topLeft: radius, bottomLeft: radius);
        canvas.drawRRect(rrect, paint);
      } else if (day.isSelectedEnd) {
        // 如果是结束日期，则只切右上和右下角
        final rrect = RRect.fromRectAndCorners(rect,
            topRight: radius, bottomRight: radius);
        canvas.drawRRect(rrect, paint);
      } else {
        // 如果不是开始或结束日期，则绘制普通的矩形
        canvas.drawRect(rect, paint);
      }

      // 绘制日期文字
      final textPainter = TextPainter(
        text: TextSpan(text: day.dateTime.day.toString(), style: textStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: daySize.width);
      textPainter.paint(
        canvas,
        Offset(x + (daySize.width - textPainter.width) / 2,
            y + (daySize.height - textPainter.height) / 2),
      );

      // 绘制标记
      if (day.isMark) {
        Color markColor;
        if (day.isSelectedStart || day.isSelectedEnd) {
          markColor = display?.colorMarkSelected ?? Colors.red;
        } else if (day.isInRange) {
          markColor = display?.colorMarkInRange ?? Colors.red;
        } else {
          markColor = display?.colorMark ?? Colors.red;
        }
        final markPainter = TextPainter(
          text: TextSpan(
              text: "●",
              style: TextStyle(
                  color: markColor, fontSize: display?.dMarkSize ?? 12)),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        markPainter.layout(minWidth: 0, maxWidth: daySize.width);
        markPainter.paint(
          canvas,
          Offset(
              x + (daySize.width - markPainter.width) / 2,
              y +
                  (daySize.height - markPainter.height) / 2 +
                  (textStyle.fontSize ?? 0).toDouble() -
                  2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 在每次需要重绘时返回 true
  }
}
