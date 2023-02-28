import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/widget_direct_chat.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/widget_room_chat.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'chat_tile.dart';

class HomeScreenTabBarSection extends StatefulWidget {
  const HomeScreenTabBarSection({
    super.key,
  });

  @override
  State<HomeScreenTabBarSection> createState() =>
      _HomeScreenTabBarSectionState();
}

class _HomeScreenTabBarSectionState extends State<HomeScreenTabBarSection>
    with SingleTickerProviderStateMixin {
  late final TabController tabBarController;
  @override
  void initState() {
    tabBarController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log('TabBar Index: ${tabBarController.index.toString()}');
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            child: TabBar(
                splashBorderRadius: kradiusCircular,
                splashFactory: NoSplash.splashFactory,
                controller: tabBarController,
                labelColor: colorTextPrimary,
                labelStyle: Theme.of(context).textTheme.titleLarge,
                unselectedLabelColor: colorTextSecondary,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
                tabs: const [
                  Tab(
                    text: "Direct Chat",
                  ),
                  Tab(
                    text: "Room Chat",
                  )
                ]),
          ),
          Expanded(
            child: TabBarView(controller: tabBarController, children: const [
              WidgetDirectChat(),
              WidgetRoomChat(),
            ]),
          ),
        ],
      ),
    );
  }
}
