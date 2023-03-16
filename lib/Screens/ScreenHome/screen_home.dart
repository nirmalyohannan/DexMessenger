import 'dart:async';

import 'package:dex_messenger/Screens/ScreenHome/widgets/home_dp_appbar_section.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_screen_search_section.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_screen_tabbar_section.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_search_result_section.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/widget_foreground_monitor.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/search_controller_provider.dart';
import 'package:dex_messenger/utils/ScreenHome/listen_messages.dart';
import 'package:dex_messenger/utils/listen_update_user_info.dart';
import 'package:dex_messenger/utils/refresh_online_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    //------------------------------
    Timer.periodic(
      const Duration(seconds: 15),
      (timer) => refreshOnlineStatus(),
    );
//-----------------------------------
    listenUserInfo(context); //To write in Background Service
    listenMesssagesToSetRecieved(); //To write in Background Service

    return Padding(
      padding: kScreenPaddingAllLight,
      child: Column(
        children: [
          const ForegroundMonitor(), //This is to check if app is in Foreground
          const HomeDpNameAppBarSection(),
          kGapHeight10,
          const HomeSearchSection(),
          context
                  .watch<SearchControllerProvider>()
                  .searchController
                  .text
                  .isEmpty
              ? const HomeScreenTabBarSection()
              : const HomeSearchResultSection(),
        ],
      ),
    );
  }
}
