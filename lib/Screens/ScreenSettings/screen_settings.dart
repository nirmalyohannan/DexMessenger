import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenMain/screen_main.dart';
import 'package:dex_messenger/Screens/ScreenUserInfo/screen_user_info.dart';
import 'package:dex_messenger/Screens/widgets/dex_alert_dialog.dart';
import 'package:dex_messenger/Screens/widgets/dex_text_icon_button.dart';
import 'package:dex_messenger/Screens/widgets/flight_shuttle_builder.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
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
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _UserDpSection(),
            kGapHeight10,
            Hero(
              tag: 'userName',
              flightShuttleBuilder: flightShuttleBuilder,
              child: AutoSizeText(
                context.watch<UserInfoProvider>().userName!,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            kGapHeight30,
            const Divider(
              indent: 30,
              endIndent: 30,
            ),
            const _SettingsTitleSection(),
            //-----------------------
            kGapHeight15,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(),
                const _EditUserInfoSection(),
                //------------------------------------------------
                const _ClearFullChatsSection(),
                //---------------------------------------------
                const _LogOutSection(),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class _SettingsTitleSection extends StatelessWidget {
  const _SettingsTitleSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          FontAwesomeIcons.gear,
          size: 35,
          color: colorDisabledBG,
        ),
        kGapWidth10,
        AutoSizeText(
          'Settings',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: colorDisabledBG),
        ),
      ],
    );
  }
}

class _UserDpSection extends StatelessWidget {
  const _UserDpSection();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'userDp',
      child: ClipRRect(
        borderRadius: kradiusCircular,
        child: CachedNetworkImage(
          imageUrl: context.read<UserInfoProvider>().userDpUrl!,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 1.5,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _EditUserInfoSection extends StatelessWidget {
  const _EditUserInfoSection();

  @override
  Widget build(BuildContext context) {
    return DexTextIconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenUserInfo(),
          ),
        );
      },
      icon: const Icon(
        Icons.edit,
        color: Colors.grey,
      ),
      text: Text(
        "Edit User Info",
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.grey),
      ),
    );
  }
}

class _ClearFullChatsSection extends StatelessWidget {
  const _ClearFullChatsSection();

  @override
  Widget build(BuildContext context) {
    return DexTextIconButton(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.grey,
      ),
      text: Text(
        "Clear Full Chats",
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.grey),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => DexAlertDialog(
            title: 'Clear full chats?',
            content: const Text('Chats will not be recoverable after this!!'),
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
          ),
        );
      },
    );
  }
}

class _LogOutSection extends StatelessWidget {
  const _LogOutSection();

  @override
  Widget build(BuildContext context) {
    return DexTextIconButton(
      onPressed: () async {
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
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
      text: Text(
        "Logout",
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.red),
      ),
    );
  }
}
