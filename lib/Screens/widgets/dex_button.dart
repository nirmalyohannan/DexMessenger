import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class DexButton extends StatelessWidget {
  const DexButton(
      {super.key,
      required this.child,
      this.isDisabled = false,
      required this.onPressed,
      this.minWidth,
      this.borderRadius,
      this.height});
  final Widget child;
  final bool isDisabled;
  final Function() onPressed;
  final double? minWidth;
  final double? height;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: colorPrimaryBG,
      shape:
          RoundedRectangleBorder(borderRadius: borderRadius ?? kradiusMedium),
      disabledColor: colorDisabledBG,
      onPressed: isDisabled ? null : onPressed,
      color: colorPrimary,
      textColor: colorTextPrimary,
      minWidth: minWidth,
      height: height,
      child: child,
    );
  }
}
