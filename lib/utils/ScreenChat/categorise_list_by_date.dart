import 'package:dex_messenger/data/models/message_model.dart';

List<List<MessageModel>> categoriseListByDate(
    List<MessageModel> messageModelList) {
  //----------------------------
  List<List<MessageModel>> categorisedList = [];
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
