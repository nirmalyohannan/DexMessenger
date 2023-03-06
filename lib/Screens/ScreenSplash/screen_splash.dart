import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenMain/screen_main.dart';
import 'package:dex_messenger/core/assets.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
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

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenMain()),
          (route) => false);
    } else {
      log('Splash Screen: context not mounted so didnt called Navigator to Screen Main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset(
            assetDexLogo,
            width: MediaQuery.of(context).size.width / 2,
          ),
        ),
      ),
    );
  }
}
