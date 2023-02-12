import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:dex_messenger/data/states/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WidgetUserInfo extends StatelessWidget {
  const WidgetUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 7,
              horizontal: 10,
            ),
            // alignment: AlignmentDirectional.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Info",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Consumer<UserDataProvider>(
                  builder: (context, value, child) {
                    final TextEditingController userNameTextController =
                        TextEditingController(text: value.user!.displayName);
                    return Column(
                      children: [
                        kGapHeight30,
                        kGapHeight30,
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            _DpImage(userData: value),
                            CircleAvatar(
                              backgroundColor: colorPrimary,
                              child: Icon(
                                Icons.add_a_photo,
                                color: colorTextPrimary,
                              ),
                            )
                          ],
                        ),
                        kGapHeight30,
                        Padding(
                          padding: kScreenPaddingHoriMedium,
                          child: TextFormField(
                            controller: userNameTextController,
                            style: Theme.of(context).textTheme.titleMedium,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, color: colorDisabledBG),
                                  borderRadius: kradiusMedium),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: colorPrimary),
                                  borderRadius: kradiusMedium),
                              fillColor: colorSecondaryBG,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                kGapHeight30,
                DexCircleButton(
                  circleRadius: 30,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        dexRouteSlideFromLeft(nextPage: const ScreenHome()),
                        (route) => false);
                  },
                  child: FaIcon(
                    FontAwesomeIcons.rightLong,
                    color: colorTextPrimary,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DpImage extends StatelessWidget {
  const _DpImage({required this.userData});

  final UserDataProvider userData;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    if (userData.user == null) {
      return Icon(
        Icons.account_circle,
        color: colorSecondaryBG,
        size: width,
      );
    } else if (userData.user!.photoURL == null) {
      return Icon(
        Icons.account_circle,
        color: colorSecondaryBG,
        size: width,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: Image.network(
        userData.user!.photoURL!,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : CircularProgressIndicator(
                    color: colorPrimary,
                  ),
      ),
    );
  }
}
