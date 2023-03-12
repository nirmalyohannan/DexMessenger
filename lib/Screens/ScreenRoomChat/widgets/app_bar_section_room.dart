import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenRoomChat/widgets/room_menu_button.dart';
import 'package:dex_messenger/Screens/widgets/flight_shuttle_builder.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:flutter/material.dart';

class AppBarSectionRoomChatScreen extends StatelessWidget {
  const AppBarSectionRoomChatScreen(
      {super.key, required this.imageSize, required this.roomInfoModel});

  final double imageSize;
  final RoomInfoModel roomInfoModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Container(
          color: colorPrimary,
          height: imageSize / 1.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: imageSize,
              ),
              Flexible(
                child: AutoSizeText(
                  roomInfoModel.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              RoomMenuButtonChatScreen(roomID: roomInfoModel.roomID)
              // MenuButtonChatScreen(
              //   recipentUID: recipentInfoModel.recipentUID,
              // )
            ],
          ),
        ),
        Hero(
            tag: roomInfoModel.roomID,
            flightShuttleBuilder: flightShuttleBuilder,
            child: _DpChatScreen(
                roomDpUrl: roomInfoModel.imageUrl, imageSize: imageSize)),
      ],
    );
  }
}

class _DpChatScreen extends StatelessWidget {
  const _DpChatScreen({
    required this.roomDpUrl,
    required this.imageSize,
  });

  final String roomDpUrl;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, 10),
      child: Material(
        elevation: 20,
        borderRadius: kradiusCircular,
        child: CircleAvatar(
          radius: imageSize / 1.9,
          backgroundColor: colorPrimary,
          child: ClipRRect(
            borderRadius: kradiusCircular,
            child: CachedNetworkImage(
              imageUrl: roomDpUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
