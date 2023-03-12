import 'package:dex_messenger/data/models/room_message_model.dart';

List<List<RoomMessageModel>> roomCategoriseListByDate(
    List<RoomMessageModel> messageModelList) {
  //----------------------------
  List<List<RoomMessageModel>> categorisedList = [];
  String previousDate = '';

  for (var element in messageModelList) {
    String date = element.createdTime.split(' ').first;
    if (date == previousDate) {
      categorisedList.last.add(element);
    } else {
      previousDate = date;
      categorisedList.add([]);
      categorisedList.last.add(element);
    }
  }
  return categorisedList;
}
