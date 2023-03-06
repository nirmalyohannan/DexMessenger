import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/menu_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:flutter/material.dart';

class AppBarSectionChatScreen extends StatelessWidget {
  const AppBarSectionChatScreen(
      {super.key, required this.imageSize, required this.recipentInfoModel});

  final double imageSize;
  final RecipentInfoModel recipentInfoModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Container(
          color: colorPrimary,
          height: imageSize / 1.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: imageSize,
              ),
              Flexible(
                child: AutoSizeText(
                  recipentInfoModel.recipentName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              MenuButtonChatScreen(
                recipentUID: recipentInfoModel.recipentUID,
              )
            ],
          ),
        ),
        _DpChatScreen(
            recipentDpUrl: recipentInfoModel.recipentDpUrl,
            imageSize: imageSize),
      ],
    );
  }
}

class _DpChatScreen extends StatelessWidget {
  const _DpChatScreen({
    required this.recipentDpUrl,
    required this.imageSize,
  });

  final String recipentDpUrl;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, 10),
      child: Material(
        elevation: 20,
        borderRadius: kradiusCircular,
        child: CircleAvatar(
          radius: imageSize / 1.9,
          backgroundColor: colorPrimary,
          child: ClipRRect(
            borderRadius: kradiusCircular,
            child: CachedNetworkImage(
              imageUrl: recipentDpUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
