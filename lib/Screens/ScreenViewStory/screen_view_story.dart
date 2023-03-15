import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/models/story_model.dart';
import 'package:dex_messenger/utils/delete_story.dart';
import 'package:dex_messenger/utils/get_story_view_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenViewStory extends StatelessWidget {
  const ScreenViewStory(
      {super.key, required this.storyModel, required this.recipentInfoModel});
  final StoryModel storyModel;
  final RecipentInfoModel recipentInfoModel;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final ValueNotifier<int> currentStoryIndexNotifier = ValueNotifier(0);
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (value) {
              currentStoryIndexNotifier.value = value;
              currentStoryIndexNotifier.notifyListeners();
            },
            controller: pageController,
            children: List.generate(
                storyModel.storiesList.length,
                (index) => Stack(
                      children: [
                        _StoryContentSection(
                            imageUrl: storyModel.storiesList[index].url),
                        _StoryListTileSection(
                            recipentInfoModel: recipentInfoModel,
                            singleStoryModel: storyModel.storiesList[index],
                            userUID: userUID)
                      ],
                    )),
          ),
          _PageViewIndicator(
            storyModel: storyModel,
            indexNotifier: currentStoryIndexNotifier,
            pageController: pageController,
          )
        ],
      )),
    );
  }
}

class _StoryContentSection extends StatelessWidget {
  const _StoryContentSection({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            color: colorTextPrimary,
            value: progress.totalSize != null
                ? progress.downloaded / progress.totalSize!
                : null,
          ),
        ),
      ),
    );
  }
}

class _StoryListTileSection extends StatelessWidget {
  const _StoryListTileSection(
      {super.key,
      required this.recipentInfoModel,
      required this.userUID,
      required this.singleStoryModel});

  final RecipentInfoModel recipentInfoModel;
  final SingleStoryModel singleStoryModel;
  final String userUID;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      title: Text(recipentInfoModel.recipentName),
      subtitle: Text(getStoryViewTime(singleStoryModel.createdTime)),
      leading: ClipRRect(
          borderRadius: kradiusCircular,
          child: CachedNetworkImage(
            imageUrl: recipentInfoModel.recipentDpUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )),
      trailing: Visibility(
        visible: userUID == recipentInfoModel.recipentUID,
        child: IconButton(
          onPressed: () {
            deleteStory(context, singleStoryModel);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PageViewIndicator extends StatelessWidget {
  const _PageViewIndicator(
      {required this.storyModel,
      required this.indexNotifier,
      required this.pageController});

  final StoryModel storyModel;
  final ValueNotifier<int> indexNotifier;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: indexNotifier,
        builder: (context, currentIndex, child) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
                storyModel.storiesList.length,
                (index) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: index == currentIndex
                                ? colorPrimary
                                : Colors.grey,
                          ),
                          index == currentIndex
                              ? SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CountDownProgressIndicator(
                                    strokeWidth: 4,
                                    duration: 5,
                                    backgroundColor: Colors.black,
                                    valueColor: Colors.white,
                                    onComplete: () {
                                      if (pageController.page ==
                                          storyModel.storiesList.length - 1) {
                                        Navigator.pop(context);
                                      }
                                      pageController.nextPage(
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.decelerate);
                                    },
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    )),
          );
        });
  }
}
