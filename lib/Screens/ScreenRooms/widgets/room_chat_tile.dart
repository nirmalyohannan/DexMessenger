import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenRoomChat/screen_room_chat.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/Screens/widgets/flight_shuttle_builder.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/utils/ScreenRooms/get_room_chat_tile_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomChatTile extends StatelessWidget {
  const RoomChatTile({super.key, required this.roomInfoModel});

  final RoomInfoModel roomInfoModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //--------------------------------------
      onTap: () {
        log('Room Chat Tile pressed');

        // authenticateToChatScreen(context,
        //     recipentInfoModel: snapshot.data!);
        String userUID = FirebaseAuth.instance.currentUser!.uid;
        bool isAdmin = roomInfoModel.adminsUID.contains(userUID);
        Navigator.push(
            context,
            dexRouteSlideFromLeft(
                nextPage: ScreenRoomChat(
              roomID: roomInfoModel.roomID,
              isAdmin: isAdmin,
            )));
      },
      //--------------------------------------
      leading: Hero(
        tag: roomInfoModel.roomID,
        flightShuttleBuilder: flightShuttleBuilder,
        child: ClipRRect(
          borderRadius: kradiusCircular,
          child: CachedNetworkImage(
            imageUrl: roomInfoModel.imageUrl,
            // imageUrl: snapshot.data!.recipentDpUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        // snapshot.data!.recipentName,
        roomInfoModel.name,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        // lastMessage.content,
        roomInfoModel.lastMessage.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: colorTextSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getRoomChatTileTime(roomInfoModel.lastMessage)),
          _NotificationBadgeRoomChatTile(
            roomID: roomInfoModel.roomID,
          )
        ],
      ),
    );
  }
} //=======================================

class _NotificationBadgeRoomChatTile extends StatelessWidget {
  const _NotificationBadgeRoomChatTile({required this.roomID});

  final String roomID;
  @override
  Widget build(BuildContext context) {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        // future: getChatTileNotificationNumber(recipentUID: recipentUID),
        stream: FirebaseFirestore.instance
            .collection('roomChats')
            .doc(roomID)
            .collection('messages')
            .where('notSeenUID', arrayContains: userUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const SizedBox();
            }
            return CircleAvatar(
              radius: 11,
              backgroundColor: colorPrimary,
              child: Text(
                snapshot.data!.docs.length.toString(),
                style: TextStyle(
                    color: colorTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
