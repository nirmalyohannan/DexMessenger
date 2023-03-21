import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenViewStory/screen_view_story.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/story_model.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';
import 'package:dex_messenger/utils/ScreenHome/get_recipent_Info.dart';
import 'package:dex_messenger/utils/delete_stories_after_time.dart';
import 'package:dex_messenger/utils/upload_story.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class WidgetStories extends StatelessWidget {
  const WidgetStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('stories').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<StoryModel> storyModelList = [];

              for (var doc in snapshot.data!.docs) {
                if (context
                    .read<FriendsProvider>()
                    .getFriendsUidList()
                    .contains(doc.id)) {
                  StoryModel storyModel = StoryModel.fromMap(doc.data());
                  if (storyModel.storiesList.isNotEmpty) {
                    storyModelList.add(storyModel);
                  }
                }
              }
              return FutureBuilder(
                  future: deleteStoriesAfterTime(
                      const Duration(hours: 24), storyModelList),
                  builder: (context, _) {
                    if (storyModelList.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(
                              'assets/storyScreen/noStoriesLottie.json'),
                          const Text(
                            'No Stories to View!',
                            style: TextStyle(
                                fontSize: 30, color: Colors.purpleAccent),
                          ),
                        ],
                      ));
                    }
                    return ListView.builder(
                      itemCount: storyModelList.length,
                      itemBuilder: (context, index) => FutureBuilder(
                          future: getRecipentInfo(storyModelList[index].uid),
                          builder: (context, snapshot) => !snapshot.hasData
                              ? const SizedBox()
                              : ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        dexRouteSlideFromLeft(
                                            nextPage: ScreenViewStory(
                                          storyModel: storyModelList[index],
                                          recipentInfoModel: snapshot.data!,
                                        )));
                                  },
                                  leading: ClipRRect(
                                    borderRadius: kradiusCircular,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.recipentDpUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(snapshot.data!.recipentName),
                                )),
                    );
                  });
            }),
        const WidgetStoriesFloatingActionButton(),
      ],
    );
  }
}

class WidgetStoriesFloatingActionButton extends StatelessWidget {
  const WidgetStoriesFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: GestureDetector(
        onTap: () async {
          var xfile =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (xfile == null) return;
          //---------
          showSimpleNotification(const Text('Uploading Story'),
              trailing: CircularProgressIndicator(
                color: colorPrimary,
              ),
              autoDismiss: true);
          //----------------------
          File file = File(xfile.path);
          uploadStory(file);
        },
        child: Container(
          decoration:
              BoxDecoration(color: colorPrimary, borderRadius: kradiusMedium),
          child: Icon(
            Icons.add,
            size: 60,
            color: colorTextPrimary,
          ),
        ),
      ),
    );
  }
}
