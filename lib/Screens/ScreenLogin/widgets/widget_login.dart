import 'package:dex_messenger/Screens/ScreenLogin/widgets/google_signin_button.dart';
import 'package:flutter/material.dart';

class WidgetLogin extends StatefulWidget {
  const WidgetLogin({super.key});

  @override
  State<WidgetLogin> createState() => _WidgetLoginState();
}

class _WidgetLoginState extends State<WidgetLogin> {
  TextEditingController controllerEmail = TextEditingController();

  final emailFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
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
              const GoogleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}
