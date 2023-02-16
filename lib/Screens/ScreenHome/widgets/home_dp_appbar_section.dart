import 'package:auto_size_text/auto_size_text.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_settings_button.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDpNameAppBarSection extends StatelessWidget {
  const HomeDpNameAppBarSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(
      builder: (context, value, child) {
        User? user = FirebaseAuth.instance.currentUser;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: kradiusCircular,
              child: Image.network(
                user!.photoURL ??
                    "https://cdn.statusqueen.com/dpimages/thumbnail/No_Dp_-1507.jpg",
                width: MediaQuery.of(context).size.width / 6,
              ),
            ),
            AutoSizeText(
              value.userName ?? "No Name",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const HomeSettingsButton(),
          ],
        );
      },
    );
  }
}
