import 'package:dex_messenger/Screens/ScreenChat/widgets/message_card_chat_screen.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class DateCategorisedMessageList extends StatelessWidget {
  const DateCategorisedMessageList(
      {super.key,
      required this.messageModelList,
      required this.recipentUID,
      required this.stickyHeaderDate});

  final List<MessageModel> messageModelList;
  final String recipentUID;
  final String stickyHeaderDate;
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
      content: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(
              messageModelList.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: MessageCardChatScreen(
                        messageModel: messageModelList[index],
                        recipentUID: recipentUID),
                  ))),
    );
  }
}
