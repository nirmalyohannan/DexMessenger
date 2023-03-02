import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenChat/widgets/app_bar_section.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_body_list_view.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/chat_box.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/screen_accept_request.dart';
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
    return Consumer<FriendsProvider>(
      builder: (context, friendsProvider, _) {
        var currentStatusMap = context
            .read<FriendsProvider>()
            .friendshipStatusMap[recipentInfoModel.recipentUID];

        if (currentStatusMap != null) {
          MessageModel currentStatus = MessageModel.fromJson(currentStatusMap);
          log('Current FriendShip Status: ${currentStatus.content} : by ${currentStatus.fromUID}');
          //--------------------------
          switch (currentStatus.content) {
            case 'friends':
              return ChatSection(
                  recipentInfoModel: recipentInfoModel,
                  scrollController: scrollController,
                  imageSize: imageSize);

            case 'requested':
              if (currentStatus.fromUID == recipentInfoModel.recipentUID) {
                //Navigate to AcceptRequestScreen
                return ScreenAcceptRequest(
                  recipentInfoModel: recipentInfoModel,
                );
              } else {
                //Navigate to SendRequestScreen
                return ScreenSendRequest(
                  recipentInfoModel: recipentInfoModel,
                );
              }

            case 'blocked':
              if (currentStatus.fromUID == recipentInfoModel.recipentUID) {
                //SnackBar Cant Open this Chat: YOu are banned!!
              } else {
                //Navigate to unblockRecipentScreen
              }

              break;
            case 'unfriend':
              return ScreenSendRequest(recipentInfoModel: recipentInfoModel);

            default:
              log('There is some problem with authenticateToChatscreen method!!');
              log('Friendship Status Recieved: ${currentStatus.content}');
          }
        } else {
          //No relation Found between user and recipent i.e they are not friends!!
          //Therefore need to send friend request!!

          log('Current frnship Status Between user and recipent is null\n Therefore they are not friends');
          return ScreenSendRequest(
            recipentInfoModel: recipentInfoModel,
          );
        }
        return ChatSection(
            recipentInfoModel: recipentInfoModel,
            scrollController: scrollController,
            imageSize: imageSize);
      },
    );
  }
}

//------------------------------------------------
class ChatSection extends StatelessWidget {
  const ChatSection({
    super.key,
    required this.recipentInfoModel,
    required this.scrollController,
    required this.imageSize,
  });

  final RecipentInfoModel recipentInfoModel;
  final ScrollController scrollController;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
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
                  recipentUID: recipentInfoModel.recipentUID,
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
