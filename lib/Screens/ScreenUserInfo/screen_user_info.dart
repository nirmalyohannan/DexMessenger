import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/ScreenUserInfo/widgets/user_info_dp_username_section.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/global_variables.dart';
import 'package:dex_messenger/utils/ScreenUserInfo/upload_dp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScreenUserInfo extends StatelessWidget {
  ScreenUserInfo({super.key});
  final TextEditingController userNameTextController = TextEditingController();

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
                UserInfoDpUsernameSection(
                  userNameTextController: userNameTextController,
                ),
                kGapHeight30,
                _SubmitButtonSection(
                  userNameTextController: userNameTextController,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButtonSection extends StatelessWidget {
  const _SubmitButtonSection({required this.userNameTextController});

  final TextEditingController userNameTextController;
  @override
  Widget build(BuildContext context) {
    return DexCircleButton(
      circleRadius: 30,
      onPressed: () async {
        String imagePath;
        if (userDpFile != null) {
          imagePath = await uploadDP(userDpFile!);
        } else {
          log('Image File Null');
          log('Uploading Default Gmail Image');
          imagePath = FirebaseAuth.instance.currentUser!.photoURL!;
        }
        String uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': userNameTextController.text,
          'uid': uid,
          'image': imagePath,
        });
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              dexRouteSlideFromLeft(nextPage: const ScreenHome()),
              (route) => false);
        }
      },
      child: FaIcon(
        FontAwesomeIcons.rightLong,
        color: colorTextPrimary,
        size: 30,
      ),
    );
  }
}
