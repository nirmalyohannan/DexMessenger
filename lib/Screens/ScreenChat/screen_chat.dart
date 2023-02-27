import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenChat/widgets/app_bar_section_chat_screen.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_body_list_view.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_box.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenChat extends StatelessWidget {
  ScreenChat(
      {super.key,
      required this.recipentUID,
      required this.recipentName,
      required this.recipentDpUrl});

  final double imageSize = 90;
  final String recipentUID;
  final String recipentName;
  final String recipentDpUrl;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    log('Chat Screen Opened: UID= $recipentUID');
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
                ChatBodyListView(
                  recipentUID: recipentUID,
                  scrollController: scrollController,
                  listViewTopPadding: imageSize,
                ),
                AppBarSectionChatScreen(
                    imageSize: imageSize,
                    recipentName: recipentName,
                    recipentDpUrl: recipentDpUrl),
                ChatBox(
                  recipentUID: recipentUID,
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
