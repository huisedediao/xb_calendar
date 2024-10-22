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

    // 文本样式

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
      canvas.drawRect(rect, paint);

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
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 在每次需要重绘时返回 true
  }
}
