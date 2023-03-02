import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/utils/ScreenChat/accept_request.dart';
import 'package:flutter/material.dart';

class ScreenAcceptRequest extends StatelessWidget {
  const ScreenAcceptRequest({super.key, required this.recipentInfoModel});

  final RecipentInfoModel recipentInfoModel;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: kradiusCircular,
              child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 1.5,
                  fit: BoxFit.cover,
                  imageUrl: recipentInfoModel.recipentDpUrl),
            ),
            kGapHeight10,
            Text(
              recipentInfoModel.recipentName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            kGapHeight10,
            DexButton(
              child: const Text('Accept Request'),
              onPressed: () {
                acceptRequest(recipentInfoModel.recipentUID);
              },
            )
          ],
        ),
      )),
    );
  }
}
