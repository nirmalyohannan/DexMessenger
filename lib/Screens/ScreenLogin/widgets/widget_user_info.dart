import 'dart:developer';
import 'dart:io';

import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/widgets/dex_circle_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';

import 'package:dex_messenger/data/states/user_data.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
                const UserInfoDpUsernameSection(),
                kGapHeight30,
                const _SubmitButtonSection()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButtonSection extends StatelessWidget {
  const _SubmitButtonSection();

  @override
  Widget build(BuildContext context) {
    return DexCircleButton(
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
    );
  }
}

class UserInfoDpUsernameSection extends StatelessWidget {
  const UserInfoDpUsernameSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userData, child) {
        final TextEditingController userNameTextController =
            TextEditingController(text: userData.user!.displayName);
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
                  userNameTextController: userNameTextController),
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

  final UserDataProvider userData;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;

    if (userData.userDpFile != null) {
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
    } else if (userData.user == null) {
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
