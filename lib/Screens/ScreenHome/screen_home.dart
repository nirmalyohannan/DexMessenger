import 'package:auto_size_text/auto_size_text.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_screen_search_section.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_screen_tabbar_section.dart';
import 'package:dex_messenger/Screens/ScreenSettings/screen_settings.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:dex_messenger/utils/listen_update_user_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    listenUpdateUserInfo(context); //To write in Background Service

    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: kScreenPaddingAllLight,
        child: Column(
          children: [
            Consumer<UserInfoProvider>(
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
                      value.userName ?? "No Name",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const _SettingsButton(),
                  ],
                );
              },
            ),
            kGapHeight10,
            const HomeSearchSection(),

            const HomeScreenTabBarSection(),

            //-------------------------------------------------------------
            // kGapHeight30,

            // const Text(
            //     "You Have been Succefully Loggedin\nThe App is under Development and will be functional very soon."),
            // LottieBuilder.network(
            //     "https://assets9.lottiefiles.com/private_files/lf30_y9czxcb9.json"),
          ],
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
