import 'dart:async';

import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPSection extends StatelessWidget {
  const OTPSection({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;
  // final String userEmail;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "An OTP has been send to 'placeholder'.\nPlease check your mail."),
        const TimerOTP(
          timeInSeconds: 60,
        ),
        kGapHeight10,
        Pinput(
          controller: controller,
          validator: (value) {
            if (value == null) {
              return "Enter OTP";
            } else if (value.length != 4) {
              return "Enter OTP completely";
            } else {
              return null;
            }
          },
          length: 4,
          defaultPinTheme: PinTheme(
            constraints: const BoxConstraints.expand(width: 70, height: 70),
            textStyle: Theme.of(context).primaryTextTheme.headlineMedium,
            decoration: BoxDecoration(
                color: colorSecondaryBG,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}

class TimerOTP extends StatefulWidget {
  const TimerOTP({super.key, required this.timeInSeconds});
  final int timeInSeconds;
  @override
  State<TimerOTP> createState() => _TimerOTPState();
}

class _TimerOTPState extends State<TimerOTP> {
  late int time;
  Color timerColor = colorOTPTimer;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timerOTP();
  }

  @override
  void dispose() {
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  timerOTP() {
    time = widget.timeInSeconds;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time--;
      });
      if (time == 10) {
        setState(() {
          timerColor = colorOTPTimerAlert;
        });
      }
      if (time == 0) {
        timer.cancel();
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      " $time seconds",
      style: TextStyle(color: timerColor),
    );
  }
}
