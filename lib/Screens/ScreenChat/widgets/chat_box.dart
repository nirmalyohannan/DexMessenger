import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
    required this.recipentUID,
    required this.scrollController,
  });
  final String recipentUID;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: TextFormField(
                  controller: textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: colorDisabledBG),
                          borderRadius: kradiusMedium),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: colorPrimary),
                          borderRadius: kradiusMedium),
                      filled: true,
                      fillColor: colorChatBoxBG,
                      hintText: 'Type Message'),
                ),
              ),
            ),
            kGapWidth10,
            DexCircleButton(
              circleRadius: 25,
              child: const Icon(
                Icons.send_rounded,
                size: 30,
              ),
              onPressed: () async {
                log("Send Button clicked");

                if (textEditingController.text.isNotEmpty) {
                  //--------------------------------

                  //-------------------------------
                  var userUID = FirebaseAuth.instance.currentUser!.uid;
                  //-----------------
                  MessageModel messageModel = MessageModel(
                      type: 'string',
                      content: textEditingController.text,
                      fromUID: userUID,
                      toUID: recipentUID,
                      createdTime: DateTime.now().toString());
                  //---------------------
                  var chatsCollectionRef =
                      FirebaseFirestore.instance.collection('chats');
                  //---------------
                  log('UserUID: $userUID');
                  log('recipentUID: $recipentUID');

                  var userRecipentChatCollecRef =
                      chatsCollectionRef.doc(userUID).collection(recipentUID);
                  // var userRecipentChatDoc = await userRecipentChatCollecRef.get();
                  //------------
                  var recipentUserChatCollecRef =
                      chatsCollectionRef.doc(recipentUID).collection(userUID);
                  // var recipentUserChatDoc = await recipentUserChatCollecRef.get();
                  //--------------------------------------
                  //----Adding the Message to user's and recipent's message collection in Firestore Database
                  userRecipentChatCollecRef.add(messageModel.toJson());

                  recipentUserChatCollecRef.add(messageModel.toJson());

                  //---------------------------
                  textEditingController.clear();
                  // FocusScope.of(context).unfocus(); //To unfocus Keyboard

                  //----To move chat list view builder to bottom
                  scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn);
                  log("Send Button Execution Complete");
                }
              },
            )
          ],
        ),
      ),
    ]);
  }
}
