import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/chat_tile.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WidgetDirectChat extends StatelessWidget {
  const WidgetDirectChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc('recentChats')
            .collection(userUID)
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            log("Chat Tiles are connecting");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            log("Chat Tiles are loaded");
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => kGapHeight10,
              itemBuilder: (context, index) {
                String recipentUID = snapshot
                    .data!.docs[index].id; //getting UIDs from chatcollections
                MessageModel lastMessage = MessageModel.fromJson(snapshot
                    .data!.docs[index]
                    .data()); //Getting the last message from recentChats Stream
                return ChatTile(
                  recipentUID: recipentUID,
                  lastMessage: lastMessage,
                );
              },
            );
          } else {
            log("Chat Tiles coudnt load");
            return const Center(
              child: Text("Error Loading"),
            );
          }
        });
  }
}
