import 'package:xb_scaffold/xb_scaffold.dart';
import 'xb_calendar_vm.dart';

class XBCalendarHmsVM extends XBCalendarVM {
  XBCalendarHmsVM({required super.context}) {
    isSingle = true;
    if (widget.selectedDates != null && widget.selectedDates!.isNotEmpty) {
      selectedHMS = [
        widget.selectedDates!.first.hour,
        widget.selectedDates!.first.minute,
        widget.selectedDates!.first.second
      ];
    }
  }

  List<List<String>> get hms => [
        List.generate(24, (index) => "$index"),
        List.generate(60, (index) => "$index"),
        List.generate(60, (index) => "$index"),
      ];

  List<int> selectedHMS = [0, 0, 0];

  onSelected(XBTitlePickerIndex index) {
    selectedHMS[index.column] = index.index;
  }

  @override
  onDone() async {
    bool pass = widget.onWillDone?.call(selectedDates) ?? true;
    if (pass) {
      pop();
      final date = selectedDates.firstOrNull;
      if (date != null) {
        selectedDates = [
          DateTime(date.year, date.month, date.day, selectedHMS[0],
              selectedHMS[1], selectedHMS[2])
        ];
      }
      widget.onDone.call(selectedDates);
    }
  }
}
