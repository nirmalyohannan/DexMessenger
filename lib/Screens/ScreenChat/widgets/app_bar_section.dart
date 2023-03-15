import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenChat/widgets/menu_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/utils/get_message_card_time.dart';
import 'package:dex_messenger/utils/get_online_status.dart';
import 'package:dex_messenger/utils/get_story_view_time.dart';
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      recipentInfoModel.recipentName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  _RecipentOnlineStatus(
                    recipentUID: recipentInfoModel.recipentUID,
                  )
                ],
              ),
              MenuButtonChatScreen(
                recipentUID: recipentInfoModel.recipentUID,
              )
            ],
          ),
        ),
        _DpChatScreen(
            recipentInfoModel: recipentInfoModel, imageSize: imageSize),
      ],
    );
  }
}

//-----------------------------------
class _RecipentOnlineStatus extends StatelessWidget {
  const _RecipentOnlineStatus({
    required this.recipentUID,
  });

  final String recipentUID;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getOnlineStatusStream(recipentUID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
                visible: snapshot.data! == 'online',
                child: const CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  radius: 5,
                )),
            kGapWidth5,
            Text(snapshot.data!),
          ],
        );
      },
    );
  }
}

//-------------------------------------------------------

class _DpChatScreen extends StatelessWidget {
  const _DpChatScreen({
    required this.recipentInfoModel,
    required this.imageSize,
  });

  final RecipentInfoModel recipentInfoModel;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, 10),
      child: Material(
        elevation: 20,
        borderRadius: kradiusCircular,
        child: Hero(
          tag: recipentInfoModel.recipentUID,
          child: CircleAvatar(
            radius: imageSize / 1.9,
            backgroundColor: colorPrimary,
            child: ClipRRect(
              borderRadius: kradiusCircular,
              child: CachedNetworkImage(
                imageUrl: recipentInfoModel.recipentDpUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
