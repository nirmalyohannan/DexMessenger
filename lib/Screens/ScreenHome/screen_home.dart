import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: kScreenPaddingAllMedium,
        child: const Center(
          child: Text(
              // AppLocalizations.of(context)!.welcome,
              "User You Have been Succefully Loggedin\nThe App is under Development and will be functional very soon."),
        ),
      )),
    );
  }
}
