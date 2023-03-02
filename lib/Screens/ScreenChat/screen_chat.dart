import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenChat/widgets/app_bar_section.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_body_list_view.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_box.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/accept_request_section.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/screen_send_request.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';

import 'package:flutter/material.dart';
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
