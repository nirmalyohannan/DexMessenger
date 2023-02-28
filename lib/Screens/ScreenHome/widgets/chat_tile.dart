import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenChat/screen_chat.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/ScreenHome/get_chat_tile_notification_number.dart';
import 'package:dex_messenger/utils/ScreenHome/get_chat_tile_time.dart';
import 'package:dex_messenger/utils/ScreenHome/get_recipent_Info.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatTile extends StatelessWidget {
  const ChatTile(
      {super.key, required this.recipentUID, required this.lastMessage});
  final String recipentUID;
  final MessageModel lastMessage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRecipentInfo(recipentUID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              onTap: () => Navigator.push(
                  context,
                  dexRouteSlideFromLeft(
                      nextPage: ScreenChat(
                    recipentInfoModel: snapshot.data!,
                  ))),
              leading: ClipRRect(
                borderRadius: kradiusCircular,
                child: CachedNetworkImage(
                  imageUrl: snapshot.data!.recipentDpUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                snapshot.data!.recipentName,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                lastMessage.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorTextSecondary),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getChatTileTime(lastMessage)),
                  _NotificationBadgeChatTile(recipentUID: recipentUID)
                ],
              ),
            );
          } else {
            return SizedBox(
              width: 200.0,
              height: 100.0,
              child: Shimmer.fromColors(
                baseColor: colorPrimaryBG,
                highlightColor: colorTextPrimary,
                child: ListTile(
                  leading: const CircleAvatar(),
                  title: Container(
                    height: 10.0,
                    color: Colors.white,
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        height: 10.0,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}

class _NotificationBadgeChatTile extends StatelessWidget {
  const _NotificationBadgeChatTile({
    required this.recipentUID,
  });

  final String recipentUID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getChatTileNotificationNumber(recipentUID: recipentUID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 0) {
              // ignore: prefer_const_constructors
              return SizedBox();
            }
            return CircleAvatar(
              radius: 11,
              backgroundColor: colorPrimary,
              child: Text(
                snapshot.data!.toString(),
                style: TextStyle(
                    color: colorTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
