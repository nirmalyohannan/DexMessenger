import 'dart:developer';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/live_emoji_model.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';
import 'package:dex_messenger/utils/ScreenRoomChat/send_room_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RoomEmojisBottomSheet extends StatelessWidget {
  const RoomEmojisBottomSheet({super.key, required this.roomID});

  final String roomID;
  @override
  Widget build(BuildContext context) {
    log('Building Emojis BottomSheet');
    return Container(
      decoration: BoxDecoration(
          color: colorSecondaryBG,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
          minHeight: 200, maxHeight: MediaQuery.of(context).size.height / 2),
      child: Column(
        children: [
          kGapHeight10,
          Text(
            'Live Emojis',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          kGapHeight5,
          Consumer<LiveEmojisProvider>(
            builder: (context, liveEmojisProvider, _) {
              List<LiveEmojiModel> liveEmojis =
                  liveEmojisProvider.liveEmojisList;
              return Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                      children: List.generate(liveEmojis.length, (index) {
                    // log('loaded Emoji: ${liveEmojis[index].emoji}');
                    return _Emoji(
                      liveEmoji: liveEmojis[index],
                      roomID: roomID,
                    );
                  })),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji({
    required this.liveEmoji,
    required this.roomID,
  });

  final LiveEmojiModel liveEmoji;
  final String roomID;

  @override
  Widget build(BuildContext context) {
    Uint8List? liveEmojiFromMemory =
        context.read<LiveEmojisProvider>().liveEmojisMemoryMap[liveEmoji.name];
    return GestureDetector(
      onTap: () {
        // sendMessage(
        //     type: 'liveEmoji',
        //     content: liveEmoji.name,
        //     recipentUID: recipentUID);
        String userUID = FirebaseAuth.instance.currentUser!.uid;
        RoomInfoModel roomInfoModel =
            context.read<RecentRoomChatProvider>().roomInfoModelMap[roomID]!;
        RoomMessageModel roomMessageModel = RoomMessageModel(
            'liveEmoji',
            liveEmoji.name,
            userUID,
            roomID,
            DateTime.now().toUtc().toString(),
            roomInfoModel.membersUID, []);
        sendRoomMessage(roomMessageModel);
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          liveEmojiFromMemory == null
              ? LottieBuilder.network(
                  liveEmoji.emoji,
                  width: 100,
                  height: 100,
                )
              : LottieBuilder.memory(
                  liveEmojiFromMemory,
                  width: 100,
                  height: 100,
                ),
          (liveEmoji.background != null) || (liveEmoji.foreground != null)
              ? const Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Hot'),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
