import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class DexCircleButton extends StatelessWidget {
  const DexCircleButton(
      {super.key,
      required this.onPressed,
      this.backgroundColor,
      required this.child,
      this.circleRadius});

  final Function() onPressed;
  final Color? backgroundColor;
  final Widget child;
  final double? circleRadius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundColor: backgroundColor ?? colorPrimary,
          radius: circleRadius,
          child: child,
        ));
  }
}
