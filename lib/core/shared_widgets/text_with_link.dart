


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../style/text/app_texts.dart';

class TextWithLink extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onLinkTap;

  const TextWithLink({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: normalText,
            style: AppTextStyles.font16GrayW400,
          ),
          TextSpan(
            text: linkText,
            style: AppTextStyles.font16White400W,
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );
  }
}