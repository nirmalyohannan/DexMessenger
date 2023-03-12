import 'package:dex_messenger/Screens/ScreenSplash/screen_splash.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/states/room_provider.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';
import 'package:dex_messenger/data/states/live_emojis_provider.dart';
import 'package:dex_messenger/data/states/recent_chat_provider.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';
import 'package:dex_messenger/data/states/search_controller_provider.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// @pragma('vm:entry-point') // Mandatory
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     //Task to be Executed;
//     log("Native called background task: ");
//     log("+++++++++Native called background task: ");
//     await NotificationService.init();
//     await NotificationService.showNotification(
//         0, 'Notification from Background Service', 'Called from Background');

//     log('Entering Timer Periodic++++++++++');

//     // Timer.periodic(const Duration(seconds: 5), (timer) async {
//     //   count++;
//     //   log("This Task is executed Every 5 Seconds: Current Count: $count");

//     //   await NotificationService.showNotification(
//     //       0, 'Notification from Background Service', 'Called from Background');
//     // });

//     log("::::::call Dispatcher Execution Completed::::::::s ");
//     return Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await NotificationService.init();

  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  // Workmanager()
  //     .registerPeriodicTask('DexPeriodicTaskUniqueName', 'DexPeriodicTask');
  // Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  runApp(const DexMessenger());
}

class DexMessenger extends StatelessWidget {
  const DexMessenger({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserInfoProvider>(
            create: (context) => UserInfoProvider()),
        ListenableProvider<SearchControllerProvider>(
            create: (context) => SearchControllerProvider()),
        ListenableProvider<FriendsProvider>(
            create: (context) => FriendsProvider()),
        ListenableProvider<LiveEmojisProvider>(
            create: (context) => LiveEmojisProvider()),
        ListenableProvider<RecentChatProvider>(
            create: (context) => RecentChatProvider()),
        ListenableProvider<RoomProvider>(create: (context) => RoomProvider()),
        ListenableProvider<RecentRoomChatProvider>(
            create: (context) => RecentRoomChatProvider()),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // supportedLocales: AppLocalizations.supportedLocales,
          // localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: colorPrimaryBG,
            textTheme: TextTheme(
              // displayLarge: TextStyle(color: colorTextPrimary),
              // displayMedium: TextStyle(color: colorTextPrimary),
              // displaySmall: TextStyle(color: colorTextPrimary),
              titleLarge: TextStyle(color: colorTextPrimary),
              titleMedium: TextStyle(color: colorTextPrimary),
              // titleSmall: TextStyle(color: colorTextPrimary),
              // labelLarge: TextStyle(color: colorTextPrimary),
              // labelMedium: TextStyle(color: colorTextPrimary),
              // labelSmall: TextStyle(color: colorTextPrimary),
              // bodyLarge: TextStyle(color: colorTextPrimary),
              bodyMedium: TextStyle(color: colorTextPrimary),
              bodySmall: TextStyle(color: colorTextSecondary),
              // headline1: TextStyle(color: colorTextPrimary),
              // headline2: TextStyle(color: colorTextPrimary),
              // headline3: TextStyle(color: colorTextPrimary),
              headlineLarge: TextStyle(color: colorTextPrimary, fontSize: 40),
              headlineMedium: TextStyle(color: colorTextPrimary),
              // headlineSmall: TextStyle(color: colorTextPrimary),
            ),
          ),
          home: const ScreenSplash(),
        ),
      ),
    );
  }
}
