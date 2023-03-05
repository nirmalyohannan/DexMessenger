import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/date_categorised_message_list.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/ScreenChat/categorise_list_by_date.dart';
import 'package:dex_messenger/utils/ScreenChat/get_sticky_header_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBodyListView extends StatelessWidget {
  const ChatBodyListView(
      {super.key,
      required this.recipentUID,
      required this.scrollController,
      required this.listViewTopPadding});

  final String recipentUID;
  final ScrollController scrollController;
  final double listViewTopPadding;
  @override
  Widget build(BuildContext context) {
    final String userID = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(userID)
            .collection(recipentUID)
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log('Chat Stream Builder Building');
            List<MessageModel> messageModelList = snapshot.data!.docs
                .map((e) => MessageModel.fromJson(e.data()))
                .toList();
            //----------------Setting Live Emoji FG and BG if Available-------------------------------
            // context
            //     .read<LiveEmojisProvider>()
            //     .setLiveEmojiBgFg(lastMessage: messageModelList.first);
            //----------------------------------------------------------------
            var dateCategorisedList = categoriseListByDate(messageModelList);
            return Padding(
              padding: EdgeInsets.only(top: listViewTopPadding / 1.5),
              child: ListView.separated(
                  // shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  reverse: true,
                  padding: const EdgeInsets.only(
                      top: 60, bottom: 80, left: 8, right: 8),
                  itemCount: dateCategorisedList.length,
                  separatorBuilder: (context, index) => kGapHeight10,
                  itemBuilder: (context, index) {
                    // return MessageCardChatScreen(
                    //     messageModel: messageModelList[index],
                    //     recipentUID: recipentUID);
                    // ---------------------
                    String date = getStickyHeaderDate(
                        dateCategorisedList[index].first.createdTime);
                    return DateCategorisedMessageList(
                        stickyHeaderDate: date,
                        messageModelList:
                            dateCategorisedList[index].reversed.toList(),
                        isLastCategory: index == dateCategorisedList.length - 1,
                        recipentUID: recipentUID);
                  }),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
