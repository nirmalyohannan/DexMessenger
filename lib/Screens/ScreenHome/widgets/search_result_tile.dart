import 'package:cached_network_image/cached_network_image.dart';
import 'package:dex_messenger/Screens/ScreenChat/screen_chat.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/search_result_model.dart';
import 'package:flutter/material.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.searchResultModel});

  final SearchResultModel searchResultModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            dexRouteSlideFromLeft(
              nextPage: ScreenChat(
                recipentUID: searchResultModel.uid,
                recipentName: searchResultModel.name,
                recipentDpUrl: searchResultModel.dpUrl,
              ),
            ));
      },
      leading: ClipRRect(
        borderRadius: kradiusCircular,
        child: CachedNetworkImage(
          imageUrl: searchResultModel.dpUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        searchResultModel.name,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}
