import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/states/search_controller_provider.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        context.read<SearchControllerProvider>().notify();
      },
      controller: context.read<SearchControllerProvider>().searchController,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        suffixIcon: SizedBox(
          width: 50,
          child: context
                  .watch<SearchControllerProvider>()
                  .searchController
                  .text
                  .isEmpty
              ? DexButton(
                  color: colorDisabledBG,
                  onPressed: () {},
                  child: const Icon(Icons.search),
                )
              : DexButton(
                  color: colorDisabledBG,
                  onPressed: () {
                    context.read<SearchControllerProvider>().clear();

                    FocusScope.of(context).unfocus();
                  },
                  child: const FaIcon(FontAwesomeIcons.xmark),
                ),
        ),
        hintText: "Search",
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: colorTextSecondary),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: colorDisabledBG),
            borderRadius: kradiusMedium),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: colorPrimary),
            borderRadius: kradiusMedium),
        fillColor: colorSecondaryBG,
        filled: true,
      ),
    );
  }
}
