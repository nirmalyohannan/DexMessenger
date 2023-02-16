import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class ChatResultTile extends StatelessWidget {
  const ChatResultTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: kradiusCircular,
        child: Image.network(
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbwZ2QmjlShNNeUuEVF-RNFZrwJo3Y9k-LRw&usqp=CAU",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: const Text(
        "Name Here",
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}
