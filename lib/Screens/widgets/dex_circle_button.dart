import 'package:dex_messenger/core/colors.dart';
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
    return InkWell(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundColor: backgroundColor ?? colorPrimary,
          radius: circleRadius,
          child: child,
        ));
  }
}
