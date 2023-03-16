import 'package:dex_messenger/utils/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:overlay_support/overlay_support.dart';

class AppSettingsProvider extends ChangeNotifier {
  late bool isAppLockEnabled;
  late Box appSettingsBox;

  Future<void> init() async {
    appSettingsBox = await Hive.openBox('appSettings');
    isAppLockEnabled = appSettingsBox.get('isAppLockEnabled') ?? false;
  }

  Future<void> setAppLock({required bool enable}) async {
    if (await authenticate()) {
      appSettingsBox.put('isAppLockEnabled', enable);
      isAppLockEnabled = enable;
    } else {
      showSimpleNotification(const Text(
          'Your Device Doesnt Support App Lock.\nThis feature requires system screen lock to be enabeld.'));
    }
    notifyListeners();
  }
}
