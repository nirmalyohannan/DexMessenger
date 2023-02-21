import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CryFG extends StatelessWidget {
  const CryFG({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.network(
          'https://assets1.lottiefiles.com/packages/lf20_SIpqxt.json'),
    );
  }
}

class CryBG extends StatelessWidget {
  const CryBG({super.key});

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.network(
      'https://assets7.lottiefiles.com/packages/lf20_h0cc4ii6.json',
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }
}
