import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';

Future<RecipentInfoModel> getRecipentInfo(String recipentUID) async {
  var usersCollectionRef = FirebaseFirestore.instance.collection('users');
  var recipentDocSnapshot = await usersCollectionRef.doc(recipentUID).get();

  return RecipentInfoModel.fromJson(recipentDocSnapshot.data()!);
}
