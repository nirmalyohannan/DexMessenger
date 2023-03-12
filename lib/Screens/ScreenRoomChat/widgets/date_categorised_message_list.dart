import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/room_message_card.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class RoomDateCategorisedMessageList extends StatelessWidget {
  const RoomDateCategorisedMessageList(
      {super.key,
      required this.messageModelList,
      required this.roomID,
      required this.stickyHeaderDate,
      required this.isLastCategory});

  final List<RoomMessageModel> messageModelList;
  final String roomID;
  final String stickyHeaderDate;
  final bool isLastCategory;
  @override
  Widget build(BuildContext context) {
    return StickyHeader(
        overlapHeaders: false,
        header: Align(
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: colorSecondaryBG, borderRadius: kradiusMedium),
              // alignment: AlignmentDirectional.center,
              child: Text(
                stickyHeaderDate,
                style: TextStyle(color: colorTextSecondary),
              )),
        ),
        content: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: messageModelList.length,
          separatorBuilder: (context, index) => kGapHeight15,
          itemBuilder: (context, index) =>
              RoomMessageCardChatScreen(messageModel: messageModelList[index]),
        ));
  }
}
