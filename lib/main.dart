import 'package:dex_messenger/Screens/ScreenSplash/screen_splash.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/data/states/google_login_in.dart';
import 'package:dex_messenger/data/states/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DexMessenger());
}

class DexMessenger extends StatelessWidget {
  const DexMessenger({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<GoogleSignInProvider>(
            create: (context) => GoogleSignInProvider()),
        ListenableProvider<UserDataProvider>(
            create: (context) => UserDataProvider()),
      ],
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
            // bodySmall: TextStyle(color: colorTextPrimary),
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
    );
  }
}
