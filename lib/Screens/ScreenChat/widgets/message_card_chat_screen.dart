import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageCardChatScreen extends StatelessWidget {
  const MessageCardChatScreen({
    super.key,
    required this.messageModel,
    required this.recipentUID,
  });

  final MessageModel messageModel;
  final String recipentUID;

  @override
  Widget build(BuildContext context) {
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
                  spreadRadius: -1.5, blurRadius: 10, color: Colors.black87)
            ],
            color: messageModel.fromUID == recipentUID
                ? colorRecipentChatCard
                : colorUserChatCard,
            borderRadius: kradiusMedium),
        child: Text(messageModel.content),
      ),
    );
  }
}
