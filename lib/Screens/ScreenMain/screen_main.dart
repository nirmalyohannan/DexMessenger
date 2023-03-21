import 'dart:developer';

import 'package:dex_messenger/Screens/ScreenHome/screen_home.dart';
import 'package:dex_messenger/Screens/ScreenLogin/Screen_login.dart';
import 'package:dex_messenger/Screens/ScreenUserInfo/screen_user_info.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/global_variables.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';
import 'package:dex_messenger/data/states/recent_chat_provider.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:dex_messenger/utils/NotificationService/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorPrimaryBG,
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                log(":::::::::Loading");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                String userUID = snapshot.data!.uid;
                log(":::::::::Logged In");
                //------------------------
                log(':::::Setting Up Firebase Push Notifications');
                loadFCM();
                listenFCM();

                //----------------
                log(":::Inititing Friends Provider:: Listening to Friendship statuses");
                context.read<FriendsProvider>().initiate();
                context.read<RecentChatProvider>().initiate();
                context.read<RecentRoomChatProvider>().initiating();
                context.read<UserInfoProvider>().readUserInfo(userUID);
                return isLoggedInNow ? ScreenUserInfo() : const ScreenHome();
              } else if (snapshot.hasError) {
                log(":::::::::SomethingWrong");

                return Text(
                    "Something went wrong: ${snapshot.error.toString()}");
              } else {
                log(":::::::::SignInPage");

                return ScreenLogin();
              }
            },
          ),
        ),
      ),
    );
  }
}

//---------------------------------


