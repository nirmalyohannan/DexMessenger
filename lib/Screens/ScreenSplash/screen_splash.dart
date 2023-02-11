import 'dart:async';

import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/ScreenLogin/screen_login.dart';
import 'package:dex_messenger/Screens/ScreenOTP/screen_otp.dart';
import 'package:dex_messenger/core/assets.dart';

import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenLogin(),
          ));
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
