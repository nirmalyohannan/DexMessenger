import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenCreateRoom/screen_create_room.dart';
import 'package:dex_messenger/Screens/ScreenRooms/widgets/room_chat_tile.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenRooms extends StatelessWidget {
  const ScreenRooms({super.key});

  @override
  Widget build(BuildContext context) {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('roomChats')
              .where('membersUID', arrayContains: userUID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: colorTextPrimary,
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Align(
                    alignment: AlignmentDirectional.center,
                    child: Text('No Room Chats'));
              } else {
                List<RoomInfoModel> roomInfoList = [];
                for (var doc in snapshot.data!.docs) {
                  roomInfoList.add(RoomInfoModel.fromMap(doc.data()));
                }
                //---------Sorting Recent Room Messages-
                roomInfoList.sort(
                  (a, b) {
                    return b.lastMessage.createdTime
                        .compareTo(a.lastMessage.createdTime);
                  },
                );
                //----------------------
                return ListView.separated(
                  itemCount: roomInfoList.length,
                  itemBuilder: (context, index) {
                    RoomInfoModel roomInfoModel = roomInfoList[index];
                    return RoomChatTile(
                      roomInfoModel: roomInfoModel,
                    );
                  },
                  separatorBuilder: (context, index) => kGapWidth10,
                );
              }
            }
          },
        ),
        const ScreenRoomFloatingActionButton()
      ],
    );
  }
}

class ScreenRoomFloatingActionButton extends StatelessWidget {
  const ScreenRoomFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ScreenCreateRoom(),
          ));
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
