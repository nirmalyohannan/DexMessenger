import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoveFG extends StatelessWidget {
  const LoveFG({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.network(
          'https://assets1.lottiefiles.com/packages/lf20_wMezg6.json'),
    );
  }
}

class LoveBG extends StatelessWidget {
  const LoveBG({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LottieBuilder.network(
          'https://assets8.lottiefiles.com/packages/lf20_DH0HdV.json',
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        LottieBuilder.network(
          'https://assets8.lottiefiles.com/packages/lf20_DH0HdV.json',
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
