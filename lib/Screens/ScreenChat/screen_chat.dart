import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/app_bar_section.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_body_list_view.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_box.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/models/live_emoji_model.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ScreenChat extends StatelessWidget {
  ScreenChat({super.key, required this.recipentInfoModel});

  final double imageSize = 90;
  final RecipentInfoModel recipentInfoModel;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    log('Chat Screen Opened: UID= ${recipentInfoModel.recipentUID}');
    return ColoredBox(
      color: colorPrimary,
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              //To Unfocus Keyboard when Tapped outSide Focus Area
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _ChatBgSection(recipentUID: recipentInfoModel.recipentUID),
                _ChatFgSection(recipentUID: recipentInfoModel.recipentUID),
                ChatBodyListView(
                  recipentUID: recipentInfoModel.recipentUID,
                  scrollController: scrollController,
                  listViewTopPadding: imageSize,
                ),
                AppBarSectionChatScreen(
                  imageSize: imageSize,
                  recipentInfoModel: recipentInfoModel,
                ),
                ChatBox(
                  recipentInfoModel: recipentInfoModel,
                  scrollController: scrollController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatFgSection extends StatelessWidget {
  const _ChatFgSection({required this.recipentUID});

  final String recipentUID;
  @override
  Widget build(BuildContext context) {
    // String activeForeground = liveEmojiProvider.activeForeground;
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc('recentChats')
          .collection(userUID)
          .doc(recipentUID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MessageModel messageModel =
              MessageModel.fromJson(snapshot.data!.data()!);
          if (messageModel.type == 'liveEmoji') {
            LiveEmojiModel activeEmoji = context
                .read<LiveEmojisProvider>()
                .findLiveEmoji(messageModel.content);
            if (activeEmoji.foreground == null) {
              log('ChatFgSection: No foreground to play');
              return const SizedBox();
            } else {
              log('ChatFgSection: Playing foreground');
              Uint8List? emojiForegroundFromMemory = context
                  .read<LiveEmojisProvider>()
                  .liveEmojisForegroundMemoryMap[activeEmoji.foreground];

              if (emojiForegroundFromMemory == null) {
                return LottieBuilder.network(
                  activeEmoji.foreground!,
                  repeat: activeEmoji.foregroundRepeat ?? false,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              } else {
                return LottieBuilder.memory(
                  emojiForegroundFromMemory,
                  repeat: activeEmoji.foregroundRepeat ?? false,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              }
            }
          }
          log('ChatFgSection: Last Message not LiveEmoji');
        }
        return const SizedBox();
      },
    );
  }
}

class _ChatBgSection extends StatelessWidget {
  const _ChatBgSection({required this.recipentUID});

  final String recipentUID;
  @override
  Widget build(BuildContext context) {
    // String activebackground = liveEmojiProvider.activebackground;
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc('recentChats')
          .collection(userUID)
          .doc(recipentUID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MessageModel messageModel =
              MessageModel.fromJson(snapshot.data!.data()!);

          if (messageModel.type == 'liveEmoji') {
            LiveEmojiModel activeEmoji = context
                .read<LiveEmojisProvider>()
                .findLiveEmoji(messageModel.content);

            if (activeEmoji.background == null) {
              log('ChatBGSection: No Background to Play');
              return const SizedBox();
            } else {
              log('ChatBGSection: Playing background');
              Uint8List? emojiBackgroundFromMemory = context
                  .read<LiveEmojisProvider>()
                  .liveEmojisBackgroundMemoryMap[activeEmoji.background];

              if (emojiBackgroundFromMemory == null) {
                return LottieBuilder.network(
                  activeEmoji.background!,
                  repeat: activeEmoji.backgroundRepeat ?? false,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              } else {
                return LottieBuilder.memory(
                  emojiBackgroundFromMemory,
                  repeat: activeEmoji.backgroundRepeat ?? false,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              }
            }
          }
          log('ChatBGSection: Last Message not LiveEmoji');
        }
        return const SizedBox();
      },
    );
  }
}
