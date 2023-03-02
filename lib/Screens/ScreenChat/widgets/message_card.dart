import 'dart:developer';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/ScreenChat/get_message_card_time.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/message_card_options.dart';
import 'package:dex_messenger/utils/ScreenChat/set_delivery_status_seen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    setDeliveryStatusSeen(messageModel,
        recipentUID); //To set deliveryStatus to seen for the recieved messages
    switch (messageModel.type) {
      case 'string':
        return _MessageCardString(
            messageModel: messageModel, recipentUID: recipentUID);
      case 'relation':
        String string;
        if (messageModel.content == 'friends') {
          string = '🤜🤛 Request Accepted 🤜🤛';
        } else if (messageModel.content == 'unfriend') {
          string = '👎 Friendship Canceled 👎';
        } else {
          string = '👋 Friendship Requested 👋';
        }
        return Center(
          child: Text(
            string,
            style: TextStyle(color: colorTextSecondary),
          ),
        );
      default:
        log('MEssageCard: Problem with Message Model type: Entered into default in switch case');
        log('Message Model Type: ${messageModel.type}');
        return _MessageCardString(
            messageModel: messageModel, recipentUID: recipentUID);
    }
  }
}

class _MessageCardString extends StatelessWidget {
  const _MessageCardString({
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
      child: InkWell(
        onLongPress: () {
          messageCardOptions(context,
              messageModel: messageModel, recipentUID: recipentUID);
        },
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
          child: Column(
            crossAxisAlignment: messageModel.fromUID == recipentUID
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(messageModel.content),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    getMessageCardTime(messageModel),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  kGapWidth10,
                  messageModel.fromUID == recipentUID
                      ? const SizedBox()
                      : _buildDeliveryStatusIcon(messageModel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

FaIcon _buildDeliveryStatusIcon(MessageModel messageModel) {
  FaIcon deliveryStatusIcon;
  switch (messageModel.deliveryStatus) {
    case 'send':
      deliveryStatusIcon = FaIcon(
        FontAwesomeIcons.check,
        size: 15,
        color: colorTextSecondary,
      );
      break;
    case 'recieved':
      deliveryStatusIcon = FaIcon(
        FontAwesomeIcons.checkDouble,
        size: 15,
        color: colorTextSecondary,
      );
      break;
    case 'seen':
      deliveryStatusIcon = FaIcon(
        FontAwesomeIcons.checkDouble,
        size: 15,
        color: colorPrimary,
      );
      break;
    default:
      deliveryStatusIcon = const FaIcon(
        FontAwesomeIcons.check,
        size: 15,
      );
  }
  return deliveryStatusIcon;
}
