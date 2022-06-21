import 'package:intl/intl.dart';

class TimeTemplate {
  Future<String> getDate() async {
    DateTime now = DateTime.now();
    return DateFormat.yMMMMd().format(now);
  }

  Future<String> getTime() async {
    DateTime now = DateTime.now();
    return DateFormat.jm().format(now);
  }
}
