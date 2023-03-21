import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenMain/screen_main.dart';
import 'package:dex_messenger/core/assets.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/app_settings_provider.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:dex_messenger/utils/local_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    initialise();
    super.initState();
  }

  void initialise() async {
    await Hive.initFlutter();
    log('Hive initialised');
    await Firebase.initializeApp();
    log("::::::FireaBase initialised");

    if (context.mounted) {
      context.read<LiveEmojisProvider>().initiate();
      await context.read<AppSettingsProvider>().init();

      bool isAppLockEnabled =
          context.read<AppSettingsProvider>().isAppLockEnabled;
      bool isAuthenticated = true;
      if (isAppLockEnabled) {
        isAuthenticated = await authenticate();
      }

      while (context.read<LiveEmojisProvider>().isInitialised == false) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted && isAuthenticated) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ScreenMain()),
            (route) => false);
      }

      //========================================
    } else {
      log('Splash Screen: context not mounted so didnt called Navigator to Screen Main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                assetDexLogo,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            kGapHeight30,
            FutureBuilder(
                future: Future.delayed(const Duration(
                    seconds:
                        2)), //Only shows loading progress after 2 seconds, THis avoid loading progress indicators in normal startups
                builder: (context, snapshot) {
                  return Consumer<LiveEmojisProvider>(
                      builder: (context, liveEmojisProvider, child) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LinearProgressIndicator(
                          color: colorPrimary,
                          backgroundColor: colorTextPrimary,
                          value: liveEmojisProvider.loadedEmojis /
                              liveEmojisProvider.totalEmojis),
                    );
                  });
                })
          ],
        ),
      ),
    );
  }
}
