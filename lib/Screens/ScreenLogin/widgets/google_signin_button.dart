import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: colorSecondaryBG,
      child: Container(
        padding: kPaddingButtonMedium,
        decoration: BoxDecoration(
            border: Border.all(color: colorSecondaryBG),
            borderRadius: kradiusMedium),
        child: const FaIcon(
          FontAwesomeIcons.google,
          size: 40,
          color: Colors.red,
        ),
      ),
      onTap: () {
        context.read<GoogleSignInProvider>().googleLogIn();

        // Navigator.push(
        //     context, dexRouteSlideFromLeft(nextPage: ScreenOTP(otp: 1234)));
      },
    );
  }
}
