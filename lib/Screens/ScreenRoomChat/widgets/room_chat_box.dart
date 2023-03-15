import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/room_emojis_bottomsheet.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';
import 'package:dex_messenger/utils/ScreenRoomChat/send_room_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RoomChatBox extends StatelessWidget {
  const RoomChatBox({
    super.key,
    required this.roomInfoModel,
    required this.scrollController,
  });
  final RoomInfoModel roomInfoModel;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end, //To bring ChatBox to bottom in the stack
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Builder(builder: (context) {
            String userUID = FirebaseAuth.instance.currentUser!.uid;
            if (roomInfoModel.isBroadcastRoom) {
              if (roomInfoModel.adminsUID.contains(userUID)) {
                return _ChatBoxSection(
                    roomID: roomInfoModel.roomID,
                    scrollController: scrollController,
                    textEditingController: textEditingController);
              } else {
                return const Text("Only admins can message in Broadcast Room");
              }
            } else {
              return _ChatBoxSection(
                  roomID: roomInfoModel.roomID,
                  scrollController: scrollController,
                  textEditingController: textEditingController);
            }
          }),
        ),
      ],
    );
  }
}

class _ChatBoxSection extends StatelessWidget {
  const _ChatBoxSection({
    required this.textEditingController,
    required this.roomID,
    required this.scrollController,
  });

  final TextEditingController textEditingController;
  final String roomID;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            log('Pressed on Chatbox Emoji Button');
            showModalBottomSheet(
              context: context,
              builder: (context) => RoomEmojisBottomSheet(
                roomID: roomID,
              ),
            );
          },
          icon: const FaIcon(
            FontAwesomeIcons.faceSmile,
            color: Colors.orangeAccent,
          ),
        ),
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
                  borderSide: BorderSide(width: 0, color: colorDisabledBG),
                  borderRadius: kradiusMedium,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: colorPrimary),
                  borderRadius: kradiusMedium,
                ),
                filled: true,
                fillColor: colorChatBoxBG,
                hintText: 'Type Message',
              ),
            ),
          ),
        ),
        kGapWidth10,
        _SendButton(
          textEditingController: textEditingController,
          roomID: roomID,
          scrollController: scrollController,
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.textEditingController,
    required this.roomID,
    required this.scrollController,
  });

  final TextEditingController textEditingController;
  final String roomID;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DexCircleButton(
      circleRadius: 25,
      child: const FaIcon(
        FontAwesomeIcons.paperPlane,
        size: 30,
      ),
      onPressed: () async {
        log("Send Button clicked");
        if (textEditingController.text.trim().isNotEmpty) {
          // sendRoomMessage(
          //     type: 'string',
          //     content: textEditingController.text.trim(),
          //     roomID: roomID); //To write in Background Service
          String userUID = FirebaseAuth.instance.currentUser!.uid;
          RoomInfoModel roomInfoModel =
              context.read<RecentRoomChatProvider>().roomInfoModelMap[roomID]!;

          RoomMessageModel roomMessageModel = RoomMessageModel(
              'string',
              textEditingController.text.trim(),
              userUID,
              roomID,
              DateTime.now().toUtc().toString(),
              roomInfoModel.membersUID, []);
          sendRoomMessage(roomMessageModel);

          textEditingController.clear();
          // FocusScope.of(context).unfocus(); //To unfocus Keyboard

          //----To move chat list view builder to bottom
          scrollController.animateTo(scrollController.position.minScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn);
          log("Send Button Execution Complete");
        } else {
          log("ChatBox TextformField Empty");
        }
      },
    );
  }
}
