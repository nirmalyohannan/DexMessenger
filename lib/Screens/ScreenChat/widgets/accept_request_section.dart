import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/utils/ScreenChat/accept_request.dart';
import 'package:flutter/material.dart';

class ScreenAcceptRequest extends StatelessWidget {
  const ScreenAcceptRequest({super.key, required this.recipentInfoModel});

  final RecipentInfoModel recipentInfoModel;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DexButton(
        child: const Text('Accept Request'),
        onPressed: () {
          acceptRequest(recipentInfoModel.recipentUID);
        },
      ),
    );
  }
}
