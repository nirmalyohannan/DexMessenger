import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:overlay_support/overlay_support.dart';

Future<bool> authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();
  bool didAuthenticate = false;

  try {
    didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to Enter App');
    // ···
  } catch (e) {
    log('localAuth Error: ${e.toString()}');
    showSimpleNotification(Text(e.toString()));
  }

  return didAuthenticate;
}
