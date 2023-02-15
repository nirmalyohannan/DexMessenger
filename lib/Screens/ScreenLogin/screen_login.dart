import 'package:carousel_slider/carousel_slider.dart';
import 'package:dex_messenger/Screens/ScreenLogin/widgets/google_signin_button.dart';
import 'package:dex_messenger/Screens/widgets/flight_shuttle_builder.dart';
import 'package:dex_messenger/core/assets.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});

  final TextEditingController controllerEmail = TextEditingController();

  final emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 12,
            horizontal: 5,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    flightShuttleBuilder: flightShuttleBuilder,
                    tag: 'dexLogo',
                    child: Image.asset(
                      assetDexLogo,
                      width: 50,
                    ),
                  ),
                  kGapWidth10,
                  Text(
                    "Dex Messenger",
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
              const LoginCarousel(),
              Text(
                "LOGIN",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: colorTextSecondary),
              ),
              kGapHeight10,
              kGapHeight10,
              const GoogleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCarousel extends StatelessWidget {
  const LoginCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle firstLine = Theme.of(context).textTheme.titleLarge!;
    TextStyle secondLine = Theme.of(context)
        .textTheme
        .displayLarge!
        .copyWith(fontWeight: FontWeight.bold, color: Colors.white);
    return Expanded(
      child: CarouselSlider(
          items: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Texting Made",
                        style: firstLine.copyWith(color: Colors.green),
                      ),
                      Text(
                        "FUN",
                        style: secondLine,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Transform.scale(
                    scale: 1.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        LottieBuilder.asset(
                            'assets/loginScreen/loginLottie_chatting.json'),
                        LottieBuilder.asset(
                          "assets/loginScreen/loginLottie_reactionsFly.json",
                          repeat: false,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dex is More",
                  style: firstLine.copyWith(color: colorPrimary),
                ),
                Text(
                  "SECURE",
                  style: secondLine,
                ),
                Expanded(
                  child: LottieBuilder.asset(
                      'assets/loginScreen/loginLottie_privacy.json'),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Keep Your Loved Ones",
                  style: firstLine.copyWith(color: Colors.red),
                ),
                Text(
                  "CONNECTED",
                  style: secondLine,
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LottieBuilder.asset(
                          'assets/loginScreen/loginLottie_videoCall.json'),
                      LottieBuilder.asset(
                        "assets/loginScreen/loginLottie_loveRain.json",
                        repeat: false,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          options: CarouselOptions(
              aspectRatio: 1,
              viewportFraction: 1,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(seconds: 2))),
    );
  }
}
