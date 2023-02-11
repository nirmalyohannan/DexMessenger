import 'package:dex_messenger/core/colors.dart';
import 'package:flutter/material.dart';

dexSnackBar(BuildContext context, {required Widget content}) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: colorSecondaryBG, content: content));
}
