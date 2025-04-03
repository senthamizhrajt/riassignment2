import 'package:flutter/foundation.dart';

class CalendarController {
  ValueNotifier<DateTime?> selectedDateNotifier;

  CalendarController({DateTime? initialDate}) : selectedDateNotifier = ValueNotifier<DateTime?>(initialDate);

  Future<void> moveToDate(DateTime date) async {
    selectedDateNotifier.value = date;
  }

  Future<void> onDateSelected(DateTime date) async {
    selectedDateNotifier.value = date;
  }

  void dispose() {
    selectedDateNotifier.dispose();
  }
}
