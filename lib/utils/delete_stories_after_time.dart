import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/story_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

deleteStoriesAfterTime(
    Duration duration, List<StoryModel> storyModelList) async {
  for (var storyModel in storyModelList) {
    for (var singleStoryModel in storyModel.storiesList) {
      DateTime dateTime = DateTime.parse(singleStoryModel.createdTime);
      DateTime deadlineTime = dateTime.add(duration);

      int deadlineExceeded = DateTime.now().toUtc().compareTo(deadlineTime);
      //if the comparison int is negative that means time is not reached yet
      //if zero i.e time is equal to the other time.
      //else time is already crossed
      if (deadlineExceeded.isNegative) {
      } else {
        log('refFrom URL: ${singleStoryModel.url}');
        await FirebaseFirestore.instance
            .collection('stories')
            .doc(storyModel.uid)
            .update({
          'storiesList': FieldValue.arrayRemove([singleStoryModel.toMap()])
        });
        try {
          await FirebaseStorage.instance
              .refFromURL(singleStoryModel.url)
              .delete();
        } catch (e) {
          log('DeleteStoryAfterTime ${e.toString()}');
        }
      }
    }
  }
}
