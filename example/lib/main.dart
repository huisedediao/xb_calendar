import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xb_calendar/xb_calendar.dart';
import 'package:xb_calendar/xb_calendar_display.dart';
import 'package:xb_calendar/xb_calendar_hms.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DateTime> selectedDates = [];
  StreamController<XBCalendarStreamData> dataStreamController =
      StreamController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: XBButton(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              enableDrag: false,
              builder: (BuildContext context) {
                return XBCalendarHms(
                  minDateTime: DateTime(2021, 11),
                  maxDateTime: DateTime(2025, 10),
                  minEnableDateTime: DateTime(2021, 11, 5),
                  maxEnableDateTime: DateTime(2024, 11, 25),
                  selectedDates: selectedDates,
                  initMarkDates: [DateTime(2024, 11, 1), DateTime(2024, 11, 2)],
                  // isSingle: true,
                  display: XBCalendarDisplay(
                    dMarkSize: 5,
                    colorMark: Colors.orange,
                    colorMarkInRange: Colors.black,
                    colorMarkSelected: Colors.blueGrey,
                    dDayHeight: 50,
                    dDayRowGap: 3,
                    dDayRadius: 25,
                    textStyleTitle: TextStyle(
                        fontSize: 18, fontWeight: fontWeights.semiBold),
                    textStyleScrollDate: TextStyle(
                        fontSize: 16, fontWeight: fontWeights.semiBold),
                    // dDoneBtnRadius: 20, dDoneBtnHeight: 40,
                    // bgColorDoneBtn: Colors.red,
                    // textStyleDoneBtn:
                    //     const TextStyle(color: Colors.yellow, fontSize: 20),
                    // colorSelectedDateBg: Colors.red,
                    // colorSelectedDateText: Colors.orange,
                    // colorTodayText: Colors.purple,
                    // colorSelectedTodayText: Colors.tealAccent,
                    // colorInRangeDateText:
                    //     const Color.fromARGB(255, 188, 58, 11),
                    colorInRangeDateBg: Colors.blue.withAlpha(30),
                  ),
                  onDone: (value) {
                    selectedDates = value;
                  },
                  onMonthChange: (value) {
                    xbError(value);
                    if (value.month == 10) {
                      dataStreamController.add(XBCalendarStreamData(markDates: [
                        DateTime(2024, 10, 30),
                        DateTime(2024, 10, 31)
                      ]));
                    } else if (value.month == 11) {
                      dataStreamController.add(XBCalendarStreamData(markDates: [
                        DateTime(2024, 11, 1),
                        DateTime(2024, 11, 2)
                      ]));
                    } else if (value.month == 12) {
                      dataStreamController.add(XBCalendarStreamData(markDates: [
                        DateTime(2024, 12, 10),
                        DateTime(2024, 12, 11)
                      ]));
                    }
                  },
                  dataStream: dataStreamController.stream,
                );
              },
            );
          },
          child: const Text("展示日历")),
    );
  }

  @override
  void dispose() {
    dataStreamController.close();
    super.dispose();
  }
}
