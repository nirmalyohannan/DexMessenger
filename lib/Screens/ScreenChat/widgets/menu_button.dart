import 'dart:developer';

import 'package:dex_messenger/Screens/widgets/dex_alert_dialog.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/utils/ScreenChat/clear_chat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuButtonChatScreen extends StatelessWidget {
  const MenuButtonChatScreen({
    super.key,
    required this.recipentUID,
  });
  final String recipentUID;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: colorPrimaryBG,
      icon: Icon(
        Icons.more_vert,
        size: 30,
        color: colorTextPrimary,
      ),
      itemBuilder: (context) => [_clearChatButton(context)],
    );
  }

//----------------------Clear Chat Button-----------------------------
  PopupMenuItem<dynamic> _clearChatButton(BuildContext context) {
    return PopupMenuItem(
        onTap: () async {
          log('Clear Chat Pressed');
          await Future.delayed(const Duration(seconds: 0));
          // ignore: use_build_context_synchronously
          await showDialog(
            context: context,
            builder: (context) => DexAlertDialog(
              title: 'Clear Chat',
              actions: [
                TextButton(
                    onPressed: () {
                      log("Clear Chat Confirmed!");
                      clearChat(recipentUID);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'))
              ],
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                color: colorTextPrimary,
              ),
            ),
          );
        },
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.trashCan,
              color: colorTextPrimary,
            ),
            Text(
              "Clear Chat",
              style: TextStyle(color: colorTextPrimary),
            )
          ],
        ));
  }
}
//-----------------------------------------------------------