import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/live_emoji_model.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';
import 'package:dex_messenger/utils/ScreenRoomChat/set_room_message_seen.dart';
import 'package:dex_messenger/utils/get_message_card_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RoomMessageCardChatScreen extends StatelessWidget {
  const RoomMessageCardChatScreen({
    super.key,
    required this.messageModel,
  });

  final RoomMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    setRoomMessageSeen(messageModel);

    // setDeliveryStatusSeen(messageModel,
    //     recipentUID); //To set deliveryStatus to seen for the recieved messages
    switch (messageModel.type) {
      case 'string':
        return _MessageCardString(messageModel: messageModel);
      case 'roomActivity':
        return _MessageRoomActivity(messageModel: messageModel);
      case 'liveEmoji':
        return _MessageCardLiveEmoji(
          messageModel: messageModel,
        );
      default:
        log('MEssageCard: Problem with Message Model type: Entered into default in switch case');
        log('Message Model Type: ${messageModel.type}');
        return _MessageCardString(messageModel: messageModel);
    }
  }
}
//----------------LiveEmoji-----------------------

class _MessageCardLiveEmoji extends StatelessWidget {
  const _MessageCardLiveEmoji({required this.messageModel});

  final RoomMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    final String userUID = FirebaseAuth.instance.currentUser!.uid;
    LiveEmojiModel liveEmojiModel =
        context.read<LiveEmojisProvider>().findLiveEmoji(messageModel.content);
    //----------------------------------
    Uint8List? liveEmojiFromMemory = context
        .read<LiveEmojisProvider>()
        .liveEmojisMemoryMap[liveEmojiModel.name];
    if (liveEmojiFromMemory == null) {
      log('MessageCard: Live Emoji Loaded from memory is Null: will load from network');
    }

    //----------------------------------

    bool isLastMessage =
        context.read<RecentRoomChatProvider>().isLastMessage(messageModel);
    return Container(
      alignment: messageModel.fromUID == userUID
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              liveEmojiFromMemory == null
                  ? LottieBuilder.network(
                      liveEmojiModel.emoji,
                      repeat: isLastMessage,
                      width: MediaQuery.of(context).size.width / 2,
                    )
                  : LottieBuilder.memory(
                      liveEmojiFromMemory,
                      repeat: isLastMessage,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
              Visibility(
                  visible: messageModel.fromUID != userUID,
                  child: ShowSenderBadge(messageModel: messageModel)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getMessageCardTime(messageModel),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              kGapWidth10,
              messageModel.fromUID != userUID
                  ? const SizedBox()
                  : FaIcon(
                      FontAwesomeIcons.check,
                      size: 15,
                      color: colorTextSecondary,
                    ),
            ],
          )
        ],
      ),
    );
  }
}

//----------------Relation--------------------

class _MessageRoomActivity extends StatelessWidget {
  const _MessageRoomActivity({
    required this.messageModel,
  });

  final RoomMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: kradiusMedium,
        color: colorSecondaryBG,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Divider(),
          ShowSenderBadge(messageModel: messageModel),
          Center(
            child: Text(
              messageModel.content,
              style: TextStyle(color: colorTextSecondary),
            ),
          ),
          // const Divider(),
        ],
      ),
    );
  }
}

//------------StringMessages-------------------

class _MessageCardString extends StatelessWidget {
  const _MessageCardString({
    required this.messageModel,
  });

  final RoomMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return UnconstrainedBox(
      alignment: messageModel.fromUID != userUID
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: InkWell(
        onLongPress: () {
          // messageCardOptions(context,
          //     messageModel: messageModel, recipentUID: recipentUID);
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.5,
          ),
          padding: kScreenPaddingAllLight,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    spreadRadius: -1, blurRadius: 6, color: Colors.black87)
              ],
              color: messageModel.fromUID != userUID
                  ? colorRecipentChatCard
                  : colorUserChatCard,
              borderRadius: kradiusMedium),
          child: Column(
            crossAxisAlignment: messageModel.fromUID != userUID
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              messageModel.fromUID != userUID
                  ? ShowSenderBadge(messageModel: messageModel)
                  : const SizedBox(),
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
                  messageModel.fromUID != userUID
                      ? const SizedBox()
                      : FaIcon(
                          FontAwesomeIcons.check,
                          size: 15,
                          color: colorTextSecondary,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowSenderBadge extends StatelessWidget {
  const ShowSenderBadge({
    super.key,
    required this.messageModel,
  });

  final RoomMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(messageModel.fromUID)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        RecipentInfoModel recipentInfoModel =
            RecipentInfoModel.fromJson(snapshot.data!.data()!);
        return Container(
          decoration: BoxDecoration(
              color: colorRecipentChatCard.withBlue(150),
              borderRadius: kradiusMedium),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: kradiusCircular,
                child: CachedNetworkImage(
                  imageUrl: recipentInfoModel.recipentDpUrl,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              kGapWidth5,
              Text(
                recipentInfoModel.recipentName,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: colorTextPrimary),
              ),
            ],
          ),
        );
      },
    );
  }
}
