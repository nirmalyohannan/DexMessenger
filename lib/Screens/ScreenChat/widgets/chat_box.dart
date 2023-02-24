import 'dart:developer';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/utils/ScreenChat/send_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
    required this.recipentUID,
    required this.scrollController,
  });
  final String recipentUID;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: [
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
                          borderSide:
                              BorderSide(width: 0, color: colorDisabledBG),
                          borderRadius: kradiusMedium),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: colorPrimary),
                          borderRadius: kradiusMedium),
                      filled: true,
                      fillColor: colorChatBoxBG,
                      hintText: 'Type Message'),
                ),
              ),
            ),
            kGapWidth10,
            _SendButton(
                textEditingController: textEditingController,
                recipentUID: recipentUID,
                scrollController: scrollController)
          ],
        ),
      ),
    ]);
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.textEditingController,
    required this.recipentUID,
    required this.scrollController,
  });

  final TextEditingController textEditingController;
  final String recipentUID;
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

        if (textEditingController.text.isNotEmpty) {
          sendMessage(
              content: textEditingController.text, recipentUID: recipentUID);

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
