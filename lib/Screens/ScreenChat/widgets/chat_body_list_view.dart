import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatBodyListView extends StatelessWidget {
  const ChatBodyListView(
      {super.key, required this.recipentUID, required this.scrollController});

  final String recipentUID;
  final ScrollController scrollController;
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
            return ListView.separated(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.only(
                    top: 120, bottom: 80, left: 8, right: 8),
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (context, index) => kGapHeight10,
                itemBuilder: (context, index) {
                  var messageData = snapshot.data!.docs[index];
                  MessageModel messageModel =
                      MessageModel.fromJson(messageData.data());
                  return UnconstrainedBox(
                    alignment: messageModel.fromUID == recipentUID
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.5,
                      ),
                      padding: kScreenPaddingAllLight,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                spreadRadius: -1.5,
                                blurRadius: 10,
                                color: Colors.black87)
                          ],
                          color: messageModel.fromUID == recipentUID
                              ? colorRecipentChatCard
                              : colorUserChatCard,
                          borderRadius: kradiusMedium),
                      child: Flexible(
                        child: Text(messageModel.content),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
