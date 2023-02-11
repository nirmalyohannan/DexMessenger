import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenOTP/screen_otp.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/Screens/widgets/dex_snackbar.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/credentials.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/utils/ScreenLogin/generate_otp.dart';
import 'package:dex_messenger/utils/ScreenLogin/send_email_otp.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController controllerEmail = TextEditingController();

  final emailFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 7,
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Login",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Form(
                key: emailFormKey,
                child: TextFormField(
                    validator: (value) {
                      if (value != null) {
                        if (value == '') {
                          return "Enter your Email id";
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return "Enter a valid Email";
                        } else {
                          return null;
                        }
                      } else {
                        return "Enter your Email id";
                      }
                    },
                    controller: controllerEmail,
                    cursorColor: colorPrimary,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: colorTextSecondary),
                        hintText: "Enter your mail",
                        filled: true,
                        fillColor: colorSecondaryBG,
                        border: OutlineInputBorder(
                            borderRadius: kradiusMedium,
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)))),
              ),
              DexButton(
                height: 45,
                minWidth: 150,
                child: Text(
                  "Login",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onPressed: () {
                  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                  // if (emailFormKey.currentState!.validate()) {
                  //   int otp = generateOTP();

                  //   ///--------
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) => Scaffold(
                  //       backgroundColor: colorPrimaryBG.withAlpha(50),
                  //       body: Center(
                  //         child: SizedBox(
                  //           width: MediaQuery.of(context).size.width / 4,
                  //           height: MediaQuery.of(context).size.width / 4,
                  //           child: CircularProgressIndicator(
                  //             color: colorPrimary,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     //------------------------------
                  //   );
                  //   sendEmailOTP(controllerEmail.text, otp).then((value) {
                  //     if (value) {
                  //       Navigator.pop(context);
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ScreenOTP(otp: otp)));
                  //     } else {
                  //       Navigator.pop(context);
                  //       dexSnackBar(context,
                  //           content: const Text("Sending OTP failed!!🥲"));
                  //     }
                  //   });
                  // }
//----Testng---------------------------------

                  Navigator.push(context,
                      dexRouteSlideFromLeft(nextPage: ScreenOTP(otp: 1234)));

//----------------------------------------
                  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
