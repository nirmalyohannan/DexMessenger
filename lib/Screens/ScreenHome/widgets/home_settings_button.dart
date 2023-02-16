import 'package:dex_messenger/Screens/ScreenSettings/screen_settings.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeSettingsButton extends StatelessWidget {
  const HomeSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScreenSettings(),
            ));
      },
      child: FaIcon(
        FontAwesomeIcons.gear,
        color: colorIcon1,
        size: 35,
      ),
    );
  }
}
