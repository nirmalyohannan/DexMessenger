import 'package:dex_messenger/Screens/widgets/dex_alert_dialog.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/ScreenChat/delete_for_everyone.dart';
import 'package:dex_messenger/utils/ScreenChat/delete_for_me.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popover/popover.dart';

void messageCardOptions(
  BuildContext context, {
  required MessageModel messageModel,
  required String recipentUID,
}) {
  showPopover(
    backgroundColor: colorPrimaryBG,
    context: context,
    bodyBuilder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DeleteButton(
          messageModel: messageModel,
          recipentUID: recipentUID,
        ),
        IconButton(
          onPressed: () {},
          icon: const FaIcon(FontAwesomeIcons.reply),
        ),
      ],
    ),
  );
}

//-------------------Delete Button-------------------------------------------------
class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    required this.messageModel,
    required this.recipentUID,
  });
  final MessageModel messageModel;
  final String recipentUID;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => DexAlertDialog(
            title: 'Delete Message?',
            icon: const FaIcon(
              FontAwesomeIcons.solidTrashCan,
              color: Colors.red,
            ),
            actions: [
              TextButton(
                  //Delete For Me
                  onPressed: () {
                    Navigator.pop(context);
                    deleteForMe(messageModel, recipentUID);
                  },
                  child: const Text('Delete for me')),
              messageModel.fromUID != recipentUID
                  ? TextButton(
                      //Delete for Everyone (Only if sender is user)
                      onPressed: () async {
                        Navigator.pop(context);
                        await deleteForEveryone(messageModel, recipentUID);
                      },
                      child: const Text('Delete for Everyone'),
                    )
                  : const SizedBox(),
              TextButton(
                  //Cancel Deletion
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          ),
        );
      },
      icon: const FaIcon(FontAwesomeIcons.solidTrashCan),
    );
  }
}
//----------------------------------------------------------