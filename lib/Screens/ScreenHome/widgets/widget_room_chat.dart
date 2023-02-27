import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WidgetRoomChat extends StatelessWidget {
  const WidgetRoomChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.network(
        "https://assets9.lottiefiles.com/private_files/lf30_y9czxcb9.json");
  }
}
