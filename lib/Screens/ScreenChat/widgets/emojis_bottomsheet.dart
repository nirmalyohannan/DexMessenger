import 'dart:developer';

import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/live_emoji_model.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:dex_messenger/utils/send_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class EmojisBottomSheet extends StatelessWidget {
  const EmojisBottomSheet({super.key, required this.recipentUID});

  final String recipentUID;
  @override
  Widget build(BuildContext context) {
    log('Building Emojis BottomSheet');
    return Container(
      decoration: BoxDecoration(
          color: colorSecondaryBG,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
          minHeight: 200, maxHeight: MediaQuery.of(context).size.height / 2),
      child: Column(
        children: [
          kGapHeight10,
          Text(
            'Live Emojis',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          kGapHeight5,
          Consumer<LiveEmojisProvider>(
            builder: (context, liveEmojisProvider, _) {
              List<LiveEmojiModel> liveEmojis =
                  liveEmojisProvider.liveEmojisList;
              return Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                      children: List.generate(liveEmojis.length, (index) {
                    // log('loaded Emoji: ${liveEmojis[index].emoji}');
                    return _Emoji(
                      liveEmoji: liveEmojis[index],
                      recipentUID: recipentUID,
                    );
                  })),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji({
    required this.liveEmoji,
    required this.recipentUID,
  });

  final LiveEmojiModel liveEmoji;
  final String recipentUID;

  @override
  Widget build(BuildContext context) {
    Uint8List? liveEmojiFromMemory =
        context.read<LiveEmojisProvider>().liveEmojisMemoryMap[liveEmoji.name];
    return GestureDetector(
      onTap: () {
        sendMessage(
            type: 'liveEmoji',
            content: liveEmoji.name,
            recipentUID: recipentUID);
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          liveEmojiFromMemory == null
              ? LottieBuilder.network(
                  liveEmoji.emoji,
                  width: 100,
                  height: 100,
                )
              : LottieBuilder.memory(
                  liveEmojiFromMemory,
                  width: 100,
                  height: 100,
                ),
          (liveEmoji.background != null) || (liveEmoji.foreground != null)
              ? const Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Hot'),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
