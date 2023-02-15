import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DexGoogleSignIn {
  static final googleSignIn = GoogleSignIn();
  static GoogleSignInAccount? user;

  static Future googleLogIn() async {
    final tempGoogleUser = await googleSignIn.signIn();
    if (tempGoogleUser == null) {
      log("Null in google Sign In function");
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
    }
  }

  static Future googleLogOut() async {
    log("Logging out........");
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    log("Logged out");
  }
}
