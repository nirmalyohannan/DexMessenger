import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/home_settings_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
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
        double imageWidth = MediaQuery.of(context).size.width / 6;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: kradiusCircular,
              child: value.userDpUrl != null
                  ? CachedNetworkImage(
                      imageUrl: value.userDpUrl!,
                      width: imageWidth,
                      height: imageWidth,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: CircularProgressIndicator(color: colorPrimary),
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
