import 'package:dex_messenger/Screens/ScreenHome/widgets/widget_direct_chat.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/widget_room_chat.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/widget_stories.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';

import 'package:flutter/material.dart';

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
    tabBarController = TabController(length: 3, vsync: this);
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
                    text: "Chats",
                  ),
                  Tab(
                    text: "Rooms",
                  ),
                  Tab(
                    text: "Stories",
                  )
                ]),
          ),
          Expanded(
            child: TabBarView(controller: tabBarController, children: const [
              WidgetDirectChat(),
              WidgetRoomChat(),
              WidgetStories()
            ]),
          ),
        ],
      ),
    );
  }
}
