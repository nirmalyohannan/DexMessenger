import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadDP(File imageFile) async {
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  var storageRef = FirebaseStorage.instance.ref().child('dp/$userUID.jpeg');
  log("Going to Upload Dp File");
  var uploadTask = await storageRef.putFile(imageFile);
  log("Upload Dp File Completed");
  return await uploadTask.ref.getDownloadURL();
}
