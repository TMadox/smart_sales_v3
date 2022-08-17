import 'package:intl/intl.dart' as intl;

class CurrentDate {
  static String getCurrentDate() {
    var now = DateTime.now();
    var formatter = intl.DateFormat('dd-MM-yyyy', "en_US");
    String date = formatter.format(now).toString();
    return date;
  }

  static String getCurrentTime() =>
      intl.DateFormat.Hms("en_US").format(DateTime.now());
}
