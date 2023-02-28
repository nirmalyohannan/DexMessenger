import 'dart:async';
import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenMain/screen_main.dart';
import 'package:dex_messenger/core/assets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 300), () async {
      await Firebase.initializeApp();

      log("::::::FireaBase initialised");

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenMain()),
          (route) => false);
    });
    super.initState();
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
