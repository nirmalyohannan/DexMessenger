import 'package:dex_messenger/utils/convert_timezone.dart';
import 'package:dex_messenger/utils/date_time_from_string.dart';

String getStoryViewTime(String timeString) {
  DateTime dateTime = dateTimeFromString(timeString);
  dateTime = convertTimeZoneToLocal(dateTime);
  String hour;
  String minute = dateTime.minute.toString();
  String amPm;
  if (dateTime.hour > 12) {
    hour = (dateTime.hour - 12).toString();
    amPm = 'PM';
  } else {
    hour = dateTime.hour.toString();
    amPm = 'AM';
  }

  //--------------------
  if (hour.length == 1) {
    hour = '0$hour';
  }
  if (minute.length == 1) {
    minute = '0$minute';
  }

  // log('${messageModel.createdTime}---------$hour:$minute $amPm');
  return '$hour:$minute $amPm';
}
