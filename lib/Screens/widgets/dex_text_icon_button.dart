import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class DexTextIconButton extends StatelessWidget {
  const DexTextIconButton(
      {super.key, this.icon, required this.onPressed, this.text});

  final Icon? icon;
  final Function() onPressed;
  final Text? text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const SizedBox(),
          kGapWidth10,
          text ?? const SizedBox()
        ],
      ),
    );
  }
}
