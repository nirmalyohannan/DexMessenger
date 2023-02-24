import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/ScreenLogin/Screen_login.dart';
import 'package:dex_messenger/Screens/ScreenUserInfo/screen_user_info.dart';
import 'package:dex_messenger/data/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              log(":::::::::Loading");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              log(":::::::::Logged In");
              return isLoggedInNow ? ScreenUserInfo() : const ScreenHome();
            } else if (snapshot.hasError) {
              log(":::::::::SomethingWrong");

              return Text("Something went wrong: ${snapshot.error.toString()}");
            } else {
              log(":::::::::SignInPage");

              return ScreenLogin();
            }
          },
        ),
      ),
    );
  }
}

//---------------------------------


