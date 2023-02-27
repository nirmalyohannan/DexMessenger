getStickyHeaderDate(String dateTimeString) {
  String chatStickyHeaderDate = '';
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
  List<String> dateList = dateTimeString.split(' ').first.split('-');
  DateTime currentDateTime = DateTime.now().toUtc();
  List<String> currentDateList =
      currentDateTime.toString().split(' ').first.split('-');

  if (dateList.first == currentDateList.first &&
      dateList[1] == currentDateList[1] &&
      dateList.last == currentDateList.last) {
    chatStickyHeaderDate = 'Today';
    return chatStickyHeaderDate;
  } else if (dateList.first == currentDateList.first &&
      dateList[1] == currentDateList[1] &&
      dateList.last == (int.parse(currentDateList.last) - 1).toString()) {
    chatStickyHeaderDate = 'Yesterday';
    return chatStickyHeaderDate;
  } else if (dateList.first == currentDateList.first) {
    String month = monthlList[int.parse(dateList[1]) - 1];
    chatStickyHeaderDate = '${dateList.last} $month';
    return chatStickyHeaderDate;
  } else {
    String month = monthlList[int.parse(dateList[1]) - 1];
    chatStickyHeaderDate = '${dateList.last} $month ${dateList.first}';
    return chatStickyHeaderDate;
  }
}
