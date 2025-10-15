
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do/core/style/text/app_texts.dart';
import '../models/on_boarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  final OnBoardingModel onBoardingModel;

  const OnBoardingPage({super.key, required this.onBoardingModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          SvgPicture.asset(onBoardingModel.image),
          const SizedBox(height: 40),
          Text(
            onBoardingModel.title,
            style: AppTexts.titleTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            onBoardingModel.description,
            style: AppTexts.descriptionTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
