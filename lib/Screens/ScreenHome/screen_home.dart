import 'package:auto_size_text/auto_size_text.dart';
import 'package:dex_messenger/Screens/ScreenLogin/screen_login.dart';
import 'package:dex_messenger/Screens/ScreenSettings/screen_settings.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:dex_messenger/data/states/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: kScreenPaddingAllLight,
        child: Center(
          child: Column(
            children: [
              Consumer<UserDataProvider>(
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: kradiusCircular,
                        child: Image.network(
                          value.user!.photoURL ??
                              "https://cdn.statusqueen.com/dpimages/thumbnail/No_Dp_-1507.jpg",
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                      ),
                      AutoSizeText(
                        "${value.user!.displayName}",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const _SettingsButton()
                    ],
                  );
                },
              ),
              kGapHeight10,
              const HomeSearchSection(),

              //-------------------------------------------------------------
              kGapHeight30,
              const Text(
                  "You Have been Succefully Loggedin\nThe App is under Development and will be functional very soon."),
              LottieBuilder.network(
                  "https://assets9.lottiefiles.com/private_files/lf30_y9czxcb9.json"),
            ],
          ),
        ),
      )),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScreenSettings(),
            ));
      },
      child: FaIcon(
        FontAwesomeIcons.gear,
        color: colorIcon1,
        size: 35,
      ),
    );
  }
}

class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Flexible(
          child: TextFormField(
            style: Theme.of(context).textTheme.titleMedium,
            decoration: InputDecoration(
              suffixIcon: SizedBox(
                width: 50,
                child: DexButton(
                  onPressed: () {},
                  child: const Icon(Icons.search),
                ),
              ),
              hintText: "Search",
              hintStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: colorTextSecondary),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: colorDisabledBG),
                  borderRadius: kradiusMedium),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: colorPrimary),
                  borderRadius: kradiusMedium),
              fillColor: colorSecondaryBG,
              filled: true,
            ),
          ),
        ),
        kGapWidth10,
        // ElevatedButton(
        //   onPressed: () {},
        //   child: const Icon(Icons.search),
        // )
      ],
    );
  }
}
