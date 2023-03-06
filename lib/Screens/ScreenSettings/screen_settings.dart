import 'package:dex_messenger/Screens/ScreenMain/screen_main.dart';
import 'package:dex_messenger/Screens/ScreenUserInfo/screen_user_info.dart';
import 'package:dex_messenger/Screens/widgets/dex_alert_dialog.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:dex_messenger/utils/NotificationService/notification_service.dart';
import 'package:dex_messenger/utils/ScreenLogin/dex_google_login_in.dart';
import 'package:dex_messenger/utils/ScreenSettings/clear_full_chats.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DexButton(
            child: const Text("Edit User Info"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenUserInfo(),
                ),
              );
            },
          ),
          DexButton(
            child: const Text("Clear Full Chats"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => DexAlertDialog(
                        title: 'Clear full chats?',
                        content: const Text(
                            'Chats will not be recoverable after this!!'),
                        icon: const FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: Colors.red,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                await clearFullChats();
                              },
                              child: const Text('Yes')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No')),
                        ],
                      ));
            },
          ),
          DexButton(
            child: const Text("Log Out"),
            onPressed: () async {
              //----------------------
              showSimpleNotification(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('logging Out'),
                      CircularProgressIndicator(
                        color: colorPrimary,
                      )
                    ],
                  ),
                  background: colorSecondaryBG);
              //--------

              await DexGoogleSignIn.googleLogOut();
              if (context.mounted) {
                context.read<UserInfoProvider>().clear();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenMain(),
                    ),
                    (route) => false);
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                NotificationService.showNotification(
                    1, 'Sample Notification Title', 'Sample Notification Body');
              },
              child: const Text('Sample Notification Button'))
        ],
      )),
    );
  }
}
