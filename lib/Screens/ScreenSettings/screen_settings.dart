import 'package:dex_messenger/Screens/ScreenMain/screen_main.dart';
import 'package:dex_messenger/Screens/ScreenUserInfo/screen_user_info.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/utils/ScreenLogin/dex_google_login_in.dart';
import 'package:flutter/material.dart';

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
            child: const Text("Log Out"),
            onPressed: () async {
              await DexGoogleSignIn.googleLogOut();
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenMain(),
                  ),
                  (route) => false);
            },
          ),
        ],
      )),
    );
  }
}
