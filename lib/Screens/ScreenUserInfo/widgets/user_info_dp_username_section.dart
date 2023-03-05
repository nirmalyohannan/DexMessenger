import 'dart:developer';
import 'dart:io';

import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
      builder: (context, userInfo, child) {
        return Column(
          children: [
            kGapHeight30,
            kGapHeight30,
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                _DpImage(
                    userInfo: userInfo,
                    diameter: MediaQuery.of(context).size.width / 2),
                Visibility(
                  visible: userInfo.isUploadingDp,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      child: CircularProgressIndicator(
                        color: colorPrimary,
                        strokeWidth: 6,
                      )),
                ),
                GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (xFile != null) {
                      if (context.mounted) {
                        userInfo.uploadDP(File(xFile.path));
                        userInfo.setUserDpFile = File(xFile.path);
                        log("userData.userDp updated");
                      }
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
  const _DpImage({required this.userInfo, required this.diameter});

  final UserInfoProvider userInfo;
  final double diameter;
  @override
  Widget build(BuildContext context) {
    if (userInfo.userDpFile != null) {
      log("UserInfoScreen: UserInfo is not null");

      return ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.file(
          userInfo.userDpFile!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
        ),
      );
    } else if (userInfo.userDpUrl == null) {
      log("UserInfoScreen: user is null");
      return Icon(
        Icons.account_circle,
        color: colorSecondaryBG,
        size: diameter,
      );
    }

    return ClipRRect(
      borderRadius: kradiusCircular,
      child: Image.network(
        userInfo.userDpUrl!,
        width: diameter,
        height: diameter,
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
