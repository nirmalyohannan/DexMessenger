import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenLogin/screen_login.dart';
import 'package:dex_messenger/Screens/ScreenLogin/widgets/widget_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

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
              return const Text("Logged In\nDisplay User Details");
            } else if (snapshot.hasError) {
              log(":::::::::SomethingWrong");

              return Text("Something went wrong: ${snapshot.error.toString()}");
            } else {
              log(":::::::::SignInPage");

              return const WidgetLogin();
            }
          },
        ),
      ),
    );
  }
}



//---------------------------------



