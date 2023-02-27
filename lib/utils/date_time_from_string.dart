DateTime dateTimeFromString(String stringDateTime) {
  String stringDate = stringDateTime.split(' ').first;
  String stringTime = stringDateTime.split(' ').last;
  //---------------
  String stringYear = stringDate.split('-').first;
  String stringMonth = stringDate.split('-')[1];
  String stringDay = stringDate.split('-').last;
  //---------------
  String stringHour = stringTime.split(':').first;
  String stringMinute = stringTime.split(':')[1];
  String stringSecond = stringTime.split(':').last.split('.').first;

  DateTime dateTime = DateTime(
    int.parse(stringYear),
    int.parse(stringMonth),
    int.parse(stringDay),
    int.parse(stringHour),
    int.parse(stringMinute),
    int.parse(stringSecond),
  );
  return dateTime;
}
