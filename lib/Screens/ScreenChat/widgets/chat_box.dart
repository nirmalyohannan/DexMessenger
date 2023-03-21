import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenChat/widgets/accept_request_section.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/emojis_bottomsheet.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/screen_send_request.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:dex_messenger/utils/NotificationService/notification_service.dart';
import 'package:dex_messenger/utils/send_message.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
    required this.recipentInfoModel,
    required this.scrollController,
  });
  final RecipentInfoModel recipentInfoModel;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end, //To bring ChatBox to bottom in the stack
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Consumer<FriendsProvider>(
            builder: (context, friendsProvider, _) {
              MessageModel? currentStatus = context
                  .read<FriendsProvider>()
                  .getFriendShipStatus(recipentInfoModel.recipentUID);

              if (currentStatus != null) {
                log('Current FriendShip Status: ${currentStatus.content} : by ${currentStatus.fromUID}');
                //--------------------------
                switch (currentStatus.content) {
                  case 'friends':
                    return _ChatBoxSection(
                        recipentInfoModel: recipentInfoModel,
                        scrollController: scrollController,
                        textEditingController: textEditingController);

                  case 'requested':
                    if (currentStatus.fromUID ==
                        recipentInfoModel.recipentUID) {
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
                    if (currentStatus.fromUID ==
                        recipentInfoModel.recipentUID) {
                      //SnackBar Cant Open this Chat: YOu are banned!!
                    } else {
                      //Navigate to unblockRecipentScreen
                    }

                    break;
                  case 'unfriend':
                    return ScreenSendRequest(
                        recipentInfoModel: recipentInfoModel);

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
              return _ChatBoxSection(
                  recipentInfoModel: recipentInfoModel,
                  scrollController: scrollController,
                  textEditingController: textEditingController);
            },
          ),
        ),
      ],
    );
  }
}

class _ChatBoxSection extends StatelessWidget {
  const _ChatBoxSection({
    required this.textEditingController,
    required this.recipentInfoModel,
    required this.scrollController,
  });

  final TextEditingController textEditingController;
  final RecipentInfoModel recipentInfoModel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            log('Pressed on Chatbox Emoji Button');
            showModalBottomSheet(
              context: context,
              builder: (context) => EmojisBottomSheet(
                recipentUID: recipentInfoModel.recipentUID,
              ),
            );
          },
          icon: const FaIcon(
            FontAwesomeIcons.faceSmile,
            color: Colors.orangeAccent,
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: TextFormField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: colorDisabledBG),
                  borderRadius: kradiusMedium,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: colorPrimary),
                  borderRadius: kradiusMedium,
                ),
                filled: true,
                fillColor: colorChatBoxBG,
                hintText: 'Type Message',
              ),
            ),
          ),
        ),
        kGapWidth10,
        _SendButton(
          textEditingController: textEditingController,
          recipentInfoModel: recipentInfoModel,
          scrollController: scrollController,
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.textEditingController,
    required this.recipentInfoModel,
    required this.scrollController,
  });

  final TextEditingController textEditingController;
  final RecipentInfoModel recipentInfoModel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DexCircleButton(
      circleRadius: 25,
      child: const FaIcon(
        FontAwesomeIcons.paperPlane,
        size: 30,
      ),
      onPressed: () async {
        log("Send Button clicked");
        if (textEditingController.text.trim().isNotEmpty) {
          sendMessage(
              type: 'string',
              content: textEditingController.text.trim(),
              recipentUID: recipentInfoModel
                  .recipentUID); //To write in Background Service

          if (recipentInfoModel.recipentFcmToken != null) {
            log('recipentFCM TOKEN is not null: Sending Push Notification');
            sendPushMessage(
                textEditingController.text.trim(),
                context.read<UserInfoProvider>().userName.toString(),
                recipentInfoModel.recipentFcmToken!);
          } else {
            log('recipentFCM TOKEN is  null: Cannot Send Push Notification');
          }

          textEditingController.clear();
          // FocusScope.of(context).unfocus(); //To unfocus Keyboard

          //----To move chat list view builder to bottom
          scrollController.animateTo(scrollController.position.minScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn);
          log("Send Button Execution Complete");
        } else {
          log("ChatBox TextformField Empty");
        }
      },
    );
  }
}
