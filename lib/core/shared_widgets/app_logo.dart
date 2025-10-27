


import 'package:flutter/material.dart';
import '../style/text/app_texts.dart';

class AppLogo extends StatelessWidget {
  final String text;

  const AppLogo({
    super.key,
    this.text = "TO-DO",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: AppTextStyles.font48LavenderPurpleW700,
      ),
    );
  }
}