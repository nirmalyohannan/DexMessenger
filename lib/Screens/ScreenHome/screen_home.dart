import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:dex_messenger/data/states/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: kScreenPaddingAllMedium,
        child: Center(
          child: Column(
            children: [
              const Text(
                  // AppLocalizations.of(context)!.welcome,
                  "User You Have been Succefully Loggedin\nThe App is under Development and will be functional very soon."),
              Consumer<UserDataProvider>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      Image.network(value.user!.photoURL ??
                          "https://cdn.statusqueen.com/dpimages/thumbnail/No_Dp_-1507.jpg"),
                      Text("Name: ${value.user!.displayName}"),
                      DexButton(
                        child: const Text("Log Out"),
                        onPressed: () {
                          context.read<GoogleSignInProvider>().googleLogOut();
                        },
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
