import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:flutter/material.dart';

class DexAlertDialog extends StatelessWidget {
  const DexAlertDialog(
      {super.key, this.icon, required this.title, this.actions});

  final Widget? icon;
  final String title;

  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorPrimaryBG,
      actions: actions,
      title: Row(
        children: [
          icon != null ? icon! : const SizedBox(),
          kGapWidth10,
          Text(
            title,
            style: TextStyle(color: colorTextPrimary),
          ),
        ],
      ),
    );
  }
}
