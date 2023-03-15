import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/utils/convert_timezone.dart';
import 'package:dex_messenger/utils/date_time_from_string.dart';

Stream<String> getOnlineStatusStream(String recipentUID) async* {
  while (true) {
    var docSnap = await FirebaseFirestore.instance
        .collection('lastSeen')
        .doc(recipentUID)
        .get();

    if (docSnap.exists) {
      String? timeString = docSnap.data()!['lastSeen'];
      if (timeString != null) {
        DateTime dateTime = dateTimeFromString(timeString);
        dateTime = convertTimeZoneToLocal(dateTime);

        if (DateTime.now()
            .subtract(const Duration(seconds: 10))
            .compareTo(dateTime)
            .isNegative) {
          yield 'online';
        } else {
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
          yield 'last seen: $hour:$minute $amPm';
        }
      }
    }

    Future.delayed(const Duration(seconds: 5));
  }

  //---------------------------
}
