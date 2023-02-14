import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: kradiusCircular,
        child: Image.network(
          "https://i.guim.co.uk/img/media/63de40b99577af9b867a9c57555a432632ba760b/0_266_5616_3370/master/5616.jpg?width=620&quality=45&dpr=2&s=none",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: const Text(
        "Name Here",
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        "This is the last message from user😍",
        style: TextStyle(color: colorTextSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("09:30 PM"),
          CircleAvatar(
            radius: 11,
            backgroundColor: colorPrimary,
            child: Text(
              '2',
              style: TextStyle(
                  color: colorTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
