import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/global_variables.dart';
import 'package:dex_messenger/utils/ScreenLogin/dex_google_login_in.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        child: SvgPicture.asset("assets/googleLogo.svg"),
      ),
      onTap: () {
        isLoggedInNow = true;
        DexGoogleSignIn.googleLogIn();
      },
    );
  }
}
