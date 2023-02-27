import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/convert_timezone.dart';
import 'package:dex_messenger/utils/date_time_from_string.dart';

String getChatTileTime(MessageModel messageModel) {
  List<String> monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  DateTime dateTime = convertTimeZoneToLocal(
    dateTimeFromString(messageModel.createdTime),
  );
  DateTime dateTimeToday = DateTime.now();
  if (dateTime.year == dateTimeToday.year &&
      dateTime.month == dateTimeToday.month &&
      dateTime.day == dateTimeToday.day) {
    if (dateTime.hour > 12) {
      return '${dateTime.hour - 12}:${dateTime.minute} PM';
    } else {
      return '${dateTime.hour}:${dateTime.minute} PM';
    }
  } else if (dateTime.year == dateTimeToday.year &&
      dateTime.month == dateTimeToday.month &&
      dateTime.day == dateTimeToday.day - 1) {
    return 'yesterday';
  } else if (dateTime.year == dateTimeToday.year) {
    String month = monthList[dateTime.month - 1];
    return '${dateTime.year}-$month';
  } else {
    String month = monthList[dateTime.month - 1];
    return '${dateTime.year}-$month-${dateTime.year}';
  }
}
