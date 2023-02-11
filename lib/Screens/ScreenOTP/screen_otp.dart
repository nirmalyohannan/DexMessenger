import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/ScreenOTP/widgets/otp_section.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_snackbar.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class ScreenOTP extends StatelessWidget {
  ScreenOTP({super.key, required this.otp});

  final int otp;
  final TextEditingController otpTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 7,
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Enter OTP",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                OTPSection(
                  controller: otpTextController,
                ),
                DexButton(
                  height: 45,
                  minWidth: 150,
                  onPressed: () {
                    if (otpTextController.text == otp.toString()) {
                      dexSnackBar(context,
                          content:
                              const Text("OTP verified✅\nLogin Successful"));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenHome(),
                        ),
                        (route) {
                          return false;
                        },
                      );
                    }
                  },
                  child: Text(
                    "Next",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
