import 'package:dex_messenger/Screens/ScreenHome/widgets/chat_result_tile.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class HomeSearchResultSection extends StatelessWidget {
  const HomeSearchResultSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kGapHeight10,
        Text("Search Result", style: Theme.of(context).textTheme.titleLarge!),
        kGapHeight10,
        ListView.separated(
          shrinkWrap: true,
          itemCount: 5,
          separatorBuilder: (context, index) => kGapHeight10,
          itemBuilder: (context, index) => const ChatResultTile(),
        ),
      ],
    );
  }
}
