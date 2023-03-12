import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenRoomDetails/widgets/widget_add_members.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            name: 'Add Friend',
            onpressed: () async {
              await Future.delayed(const Duration(seconds: 0));
              if (context.mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScreenAddMembers(roomID: roomID),
                ));
              }
            }),
      ],
    );
  }
}
//-----------------------------------------------------------

PopupMenuItem<dynamic> _buildMenuButtonItem({
  required String name,
  required Function() onpressed,
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
            color: colorTextPrimary,
          ),
          Text(
            name,
            style: TextStyle(color: colorTextPrimary),
          )
        ],
      ));
}
