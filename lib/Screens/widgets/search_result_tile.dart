import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenChat/screen_chat.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:flutter/material.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile(
      {super.key, required this.recipentInfo, this.trailing, this.subtitle});

  final RecipentInfoModel recipentInfo;
  final Widget? trailing;
  final Widget? subtitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            dexRouteSlideFromLeft(
              nextPage: ScreenChat(
                recipentInfoModel: recipentInfo,
              ),
            ));
      },
      leading: ClipRRect(
        borderRadius: kradiusCircular,
        child: CachedNetworkImage(
          imageUrl: recipentInfo.recipentDpUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      subtitle: subtitle,
      trailing: trailing,
      title: Text(
        recipentInfo.recipentName,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}
