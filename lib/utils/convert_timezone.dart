DateTime convertTimeZoneToLocal(DateTime dateTime) {
  // log('Converting DateTime to timezone: ${DateTime.now().timeZoneName}');
  return dateTime.add(DateTime.now().timeZoneOffset);
}
