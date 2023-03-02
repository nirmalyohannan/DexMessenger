getStickyHeaderDate(String dateTimeString) {
  String chatStickyHeaderDate = '';
  DateTime messageDateTime = DateTime.parse(dateTimeString);
  DateTime currentDateTime = DateTime.now().toUtc();
  DateTime yesterdayDateTime = currentDateTime.add(const Duration(days: -1));
  List<String> monthlList = [
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

  // List<String> dateList = dateTimeString.split(' ').first.split('-');

  // List<String> currentDateList =
  //     currentDateTime.toString().split(' ').first.split('-');

  if (messageDateTime.year == currentDateTime.year &&
      messageDateTime.month == currentDateTime.month &&
      messageDateTime.day == currentDateTime.day) {
    chatStickyHeaderDate = 'Today';
    return chatStickyHeaderDate;
  } else if (messageDateTime.year == yesterdayDateTime.year &&
      messageDateTime.month == yesterdayDateTime.month &&
      messageDateTime.day == yesterdayDateTime.day) {
    chatStickyHeaderDate = 'Yesterday';
    return chatStickyHeaderDate;
  } else if (messageDateTime.year == currentDateTime.year) {
    String month = monthlList[messageDateTime.month - 1];
    chatStickyHeaderDate = '${messageDateTime.day} $month';
    return chatStickyHeaderDate;
  } else {
    String month = monthlList[messageDateTime.month - 1];
    chatStickyHeaderDate =
        '${messageDateTime.day} $month ${messageDateTime.year}';
    return chatStickyHeaderDate;
  }

  // if (dateList.first == currentDateList.first &&
  //     dateList[1] == currentDateList[1] &&
  //     dateList.last == currentDateList.last) {
  //   chatStickyHeaderDate = 'Today';
  //   return chatStickyHeaderDate;
  // } else if (dateList.first == currentDateList.first &&
  //     dateList[1] == currentDateList[1] &&
  //     dateList.last == (int.parse(currentDateList.last) - 1).toString()) {
  //   chatStickyHeaderDate = 'Yesterday';
  //   return chatStickyHeaderDate;
  // } else if (dateList.first == currentDateList.first) {
  //   String month = monthlList[int.parse(dateList[1]) - 1];
  //   chatStickyHeaderDate = '${dateList.last} $month';
  //   return chatStickyHeaderDate;
  // } else {
  //   String month = monthlList[int.parse(dateList[1]) - 1];
  //   chatStickyHeaderDate = '${dateList.last} $month ${dateList.first}';
  //   return chatStickyHeaderDate;
  // }
}
