import 'dart:developer';

import 'package:dex_messenger/core/credentials.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<bool> sendEmailOTP(String userEmail, int otp) async {
  final smtpServer = gmail(dexMailUsername, dexMailAppPassword);
  final message = Message()
    ..from = const Address(dexMailUsername, 'Dex Messenger')
    ..recipients.add(userEmail)
    ..subject = 'Dex Messenger Login OTP'
    ..html =
        '<h2>Please Enter this OTP in the App to login</h2><h1>$otp</h1><h2>Thank You</h2>';

  try {
    final sendReport = await send(message, smtpServer);
    log('Message sent: $sendReport');
    return true;
  } catch (e) {
    log('Message not sent. Reason: ${e.toString()}');

    return false;
  }
}
