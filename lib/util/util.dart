import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime getyMd({required DateTime dateTime}) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
  static int getMonth({required String dateTime}){
    return int.parse(DateFormat('MM').format(DateTime.parse(dateTime)));
  }

}
