import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;

  Future googleLogIn() async {
    final tempGoogleUser = await googleSignIn.signIn();
    if (tempGoogleUser == null) {
      return;
    } else {
      user = tempGoogleUser;

      try {
        final userAuth = await user!.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: userAuth.accessToken, idToken: userAuth.idToken);

        await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (e) {
        log(e.toString());
      }

      notifyListeners();
    }
  }

  Future googleLogOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
