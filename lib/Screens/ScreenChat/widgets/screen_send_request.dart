import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';
import 'package:dex_messenger/utils/ScreenChat/send_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenSendRequest extends StatelessWidget {
  const ScreenSendRequest({super.key, required this.recipentInfoModel});

  final RecipentInfoModel recipentInfoModel;
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsProvider>(
      builder: (context, friendsProvider, _) {
        MessageModel? friendshipStatus =
            friendsProvider.getFriendShipStatus(recipentInfoModel.recipentUID);
        if (friendshipStatus == null) {
          log("ScreenSendRequest: FriendShipStatus Null recieved");
          return _sendRequestSection();
        }

        log('ScreenSendRequest: FriendshipStatus: ${friendshipStatus.content}');
        return friendshipStatus.content == 'requested'
            ? Card(
                color: colorSecondaryBG,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Friend Request succesfully send'),
                ))
            : _sendRequestSection();
      },
    );
  }

  Widget _sendRequestSection() {
    return DexButton(
      child: const Text('Send Friend Request'),
      onPressed: () async {
        log('Send Request Button Pressed');
        await sendRequest(recipentInfoModel.recipentUID);
      },
    );
  }
}
