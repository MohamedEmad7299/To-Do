import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/core/style/text/app_texts.dart';

import '../models/on_boarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel model;

  const OnboardingPage({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: SvgPicture.asset(
              model.image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            model.title,
            style: AppTextStyles.font32White700W,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            model.description,
            style: AppTextStyles.font16White400W,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}