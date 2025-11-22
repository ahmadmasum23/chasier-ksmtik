import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy', 'id_ID');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }

  static DateTime parseDate(String dateString) {
    try {
      final parser = DateFormat('yyyy-MM-dd', 'id_ID');
      return parser.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }
}