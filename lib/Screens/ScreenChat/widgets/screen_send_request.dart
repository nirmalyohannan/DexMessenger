import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: kradiusCircular,
                child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 1.5,
                    fit: BoxFit.cover,
                    imageUrl: recipentInfoModel.recipentDpUrl),
              ),
              kGapHeight10,
              Text(
                recipentInfoModel.recipentName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              kGapHeight10,
              Consumer<FriendsProvider>(
                builder: (context, friendsProvider, _) {
                  Map<String, dynamic>? map = friendsProvider
                      .friendshipStatusMap[recipentInfoModel.recipentUID];
                  if (map == null) {
                    log("ScreenSendRequest: FriendShipStatus Null recieved");
                    return _sendRequestSection();
                  }
                  MessageModel friendshipStatus = MessageModel.fromJson(map);
                  log('ScreenSendRequest: FriendshipStatus: ${friendshipStatus.content}');
                  return friendshipStatus.content == 'requested'
                      ? const Text('Friend Request succesfully send')
                      : _sendRequestSection();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _sendRequestSection() {
    return Column(
      children: [
        Text(
            'You are not friend with ${recipentInfoModel.recipentName}.\n Send Friend Request to chat'),
        DexButton(
          child: const Text('Send Request'),
          onPressed: () async {
            log('Send Request Button Pressed');
            await sendRequest(recipentInfoModel.recipentUID);
          },
        ),
      ],
    );
  }
}
