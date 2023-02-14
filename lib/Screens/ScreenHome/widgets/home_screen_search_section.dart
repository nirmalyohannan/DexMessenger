import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        suffixIcon: SizedBox(
          width: 50,
          child: DexButton(
            color: colorDisabledBG,
            onPressed: () {},
            child: const Icon(Icons.search),
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
