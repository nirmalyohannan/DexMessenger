import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';

import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
      onPressed: () {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': userNameTextController.text,
          'uid': uid,
          'image': '',
        });
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
    );
  }
}

class UserInfoDpUsernameSection extends StatefulWidget {
  const UserInfoDpUsernameSection({
    super.key,
    required this.userNameTextController,
  });
  final TextEditingController userNameTextController;

  @override
  State<UserInfoDpUsernameSection> createState() =>
      _UserInfoDpUsernameSectionState();
}

class _UserInfoDpUsernameSectionState extends State<UserInfoDpUsernameSection> {
  @override
  void initState() {
    widget.userNameTextController.text =
        context.read<UserInfoProvider>().userName ??
            FirebaseAuth.instance.currentUser!.displayName ??
            '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(
      builder: (context, userData, child) {
        return Column(
          children: [
            kGapHeight30,
            kGapHeight30,
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                _DpImage(userData: userData),
                GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (xFile != null) {
                      userData.setUserDpFile = File(xFile.path);

                      log("userData.userDp updated");
                    } else {
                      log("xFile is null");
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: colorPrimary,
                    child: Icon(
                      Icons.add_a_photo,
                      color: colorTextPrimary,
                    ),
                  ),
                )
              ],
            ),
            kGapHeight30,
            Padding(
              padding: kScreenPaddingHoriMedium,
              child: _UsernameTextField(
                  userNameTextController: widget.userNameTextController),
            ),
          ],
        );
      },
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({
    required this.userNameTextController,
  });

  final TextEditingController userNameTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: userNameTextController,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: colorDisabledBG),
            borderRadius: kradiusMedium),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: colorPrimary),
            borderRadius: kradiusMedium),
        fillColor: colorSecondaryBG,
        filled: true,
      ),
    );
  }
}

class _DpImage extends StatelessWidget {
  const _DpImage({required this.userData});

  final UserInfoProvider userData;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    User? user = FirebaseAuth.instance.currentUser;

    if (userData.userDpFile != null) {
      log("UserInfoScreen: UserInfo is not null");
      var dpImage = userData.userDpFile;
      return ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.file(
          dpImage!,
          width: width,
          height: width,
          fit: BoxFit.cover,
        ),
      );
    } else if (user == null) {
      log("UserInfoScreen: user is null");
      return Icon(
        Icons.account_circle,
        color: colorSecondaryBG,
        size: width,
      );
    } else if (user.photoURL == null) {
      return Icon(
        Icons.account_circle,
        color: colorSecondaryBG,
        size: width,
      );
    }
    log(":::${user.displayName}");
    return ClipRRect(
      borderRadius: kradiusCircular,
      child: Image.network(
        user.photoURL!,
        width: width,
        height: width,
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
