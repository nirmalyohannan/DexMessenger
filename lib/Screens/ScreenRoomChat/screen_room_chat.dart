import 'dart:developer';
import 'dart:typed_data';

import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/app_bar_section_room.dart';
import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/room_chat_body_list_view.dart';
import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/room_chat_box.dart';
import 'package:dex_messenger/Screens/ScreenRoomDetails/screen_room_details.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/models/live_emoji_model.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ScreenRoomChat extends StatelessWidget {
  ScreenRoomChat({super.key, required this.roomID, required this.isAdmin});

  final double imageSize = 90;
  final String roomID;
  final ScrollController scrollController = ScrollController();
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    log('Chat Screen Opened: roomID= $roomID');
    return ColoredBox(
      color: colorPrimary,
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              //To Unfocus Keyboard when Tapped outSide Focus Area
              FocusScope.of(context).unfocus();
            },
            child: Consumer<RecentRoomChatProvider>(
                builder: (context, recentRoomChat, _) {
              RoomInfoModel roomInfoModel =
                  recentRoomChat.roomInfoModelMap[roomID]!;
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  _ChatBgSection(lastMessage: roomInfoModel.lastMessage),
                  _ChatFgSection(lastMessage: roomInfoModel.lastMessage),
                  RoomChatBodyListView(
                    roomID: roomID,
                    scrollController: scrollController,
                    listViewTopPadding: imageSize,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        dexRouteSlideFromTop(
                            duration: const Duration(milliseconds: 300),
                            nextPage: ScreenRoomDetails(
                              roomID: roomInfoModel.roomID,
                              isAdmin: isAdmin,
                            )),
                      );
                    },
                    child: AppBarSectionRoomChatScreen(
                      imageSize: imageSize,
                      roomInfoModel: roomInfoModel,
                    ),
                  ),
                  RoomChatBox(
                    roomInfoModel: roomInfoModel,
                    scrollController: scrollController,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

//=================================================
class _ChatFgSection extends StatelessWidget {
  const _ChatFgSection({required this.lastMessage});

  final RoomMessageModel lastMessage;
  @override
  Widget build(BuildContext context) {
    if (lastMessage.type == 'liveEmoji') {
      LiveEmojiModel activeEmoji =
          context.read<LiveEmojisProvider>().findLiveEmoji(lastMessage.content);
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
    return const SizedBox();
  }
}

class _ChatBgSection extends StatelessWidget {
  const _ChatBgSection({required this.lastMessage});

  final RoomMessageModel lastMessage;
  @override
  Widget build(BuildContext context) {
    if (lastMessage.type == 'liveEmoji') {
      LiveEmojiModel activeEmoji =
          context.read<LiveEmojisProvider>().findLiveEmoji(lastMessage.content);

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

    return const SizedBox();
  }
}
