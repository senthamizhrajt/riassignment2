import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatIsoDate(String isoDate) {
    final DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat("d MMM, yyyy").format(dateTime);
  }
}
