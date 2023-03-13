import 'dart:developer';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/states/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RoomMenuButtonChatScreen extends StatelessWidget {
  const RoomMenuButtonChatScreen({
    super.key,
    required this.roomID,
  });
  final String roomID;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: colorPrimaryBG,
      icon: Icon(
        Icons.more_vert,
        size: 30,
        color: colorTextPrimary,
      ),
      itemBuilder: (context) => [
        _buildMenuButtonItem(
            name: 'Exit Room',
            color: Colors.red,
            onpressed: () async {
              await context.read<RoomProvider>().exitFromRoom(roomID);
              if (context.mounted) Navigator.pop(context);
            }),
      ],
    );
  }
}
//-----------------------------------------------------------

PopupMenuItem<dynamic> _buildMenuButtonItem({
  required String name,
  required Function() onpressed,
  Color? color,
}) {
  return PopupMenuItem(
      onTap: () async {
        log('Menu Button Pressed: $name');
        onpressed();
      },
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.userGroup,
            color: color ?? colorTextPrimary,
          ),
          Text(
            name,
            style: TextStyle(color: color ?? colorTextPrimary),
          )
        ],
      ));
}
