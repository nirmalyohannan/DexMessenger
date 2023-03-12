import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/date_categorised_message_list.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:dex_messenger/utils/ScreenChat/get_sticky_header_date.dart';
import 'package:dex_messenger/utils/ScreenRooms/room_categorise_list_by_date.dart';
import 'package:flutter/material.dart';

class RoomChatBodyListView extends StatelessWidget {
  const RoomChatBodyListView(
      {super.key,
      required this.roomID,
      required this.scrollController,
      required this.listViewTopPadding});

  final String roomID;
  final ScrollController scrollController;
  final double listViewTopPadding;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('roomChats')
            .doc(roomID)
            .collection('messages')
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log('Chat Stream Builder Building');
            List<RoomMessageModel> messageModelList = snapshot.data!.docs
                .map((e) => RoomMessageModel.fromMap(e.data()))
                .toList();
            //----------------Setting Live Emoji FG and BG if Available-------------------------------
            // context
            //     .read<LiveEmojisProvider>()
            //     .setLiveEmojiBgFg(lastMessage: messageModelList.first);
            //----------------------------------------------------------------
            var dateCategorisedList =
                roomCategoriseListByDate(messageModelList);
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
                    return RoomDateCategorisedMessageList(
                        stickyHeaderDate: date,
                        messageModelList:
                            dateCategorisedList[index].reversed.toList(),
                        isLastCategory: index == dateCategorisedList.length - 1,
                        roomID: roomID);
                  }),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
