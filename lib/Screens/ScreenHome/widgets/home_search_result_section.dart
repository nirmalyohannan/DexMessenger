import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenHome/widgets/search_result_tile.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/search_result_model.dart';

import 'package:dex_messenger/data/states/search_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeSearchResultSection extends StatelessWidget {
  const HomeSearchResultSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kGapHeight10,
            Text("Search Result",
                style: Theme.of(context).textTheme.titleLarge!),
            kGapHeight10,
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: colorPrimary),
                    );
                  } else if (snapshot.hasData) {
                    var searchResult = snapshot.data!.docs
                        .where((element) => element
                            .data()['name']
                            .toString()
                            .toLowerCase()
                            .contains(context
                                .watch<SearchControllerProvider>()
                                .searchController
                                .text
                                .toLowerCase()))
                        .toList();
                    if (searchResult.isEmpty) {
                      return Center(
                          child: LottieBuilder.network(
                              'https://assets9.lottiefiles.com/packages/lf20_fmieo0wt.json'));
                    } else {
                      return ListView.separated(
                          shrinkWrap: true,
                          itemCount: searchResult.length,
                          separatorBuilder: (context, index) => kGapHeight10,
                          itemBuilder: (context, index) {
                            SearchResultModel searchResultModel =
                                SearchResultModel.fromJson(
                                    searchResult[index].data());
                            return SearchResultTile(
                              searchResultModel: searchResultModel,
                            );
                          });
                    }
                  } else {
                    return const Center(
                      child: SizedBox(
                          height: 60, child: Text("Error Loading data")),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
