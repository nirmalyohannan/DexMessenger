import 'dart:async';
import 'dart:developer';
import 'package:dex_messenger/Screens/ScreenLogin/screen_login.dart';
import 'package:dex_messenger/Screens/ScreenLogin/widgets/widget_login.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/Screens/widgets/flight_shuttle_builder.dart';
import 'package:dex_messenger/core/assets.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () async {
      await Firebase.initializeApp();
      log("::::::FireaBase initialised");
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenLogin()),
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
