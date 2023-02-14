import 'package:dex_messenger/Screens/ScreenLogin/Screen_login.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: DexButton(
        child: const Text("Log Out"),
        onPressed: () async {
          await context.read<GoogleSignInProvider>().googleLogOut();
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenLogin(),
              ),
              (route) => false);
        },
      )),
    );
  }
}
