import 'dart:developer';

import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
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
    log(tabBarController.index.toString());
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

class WidgetRoomChat extends StatelessWidget {
  const WidgetRoomChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.network(
        "https://assets9.lottiefiles.com/private_files/lf30_y9czxcb9.json");
  }
}

class WidgetDirectChat extends StatelessWidget {
  const WidgetDirectChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => kGapHeight10,
      itemBuilder: (context, index) => const ChatTile(),
    );
  }
}
