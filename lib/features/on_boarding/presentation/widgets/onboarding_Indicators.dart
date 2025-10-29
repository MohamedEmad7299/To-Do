


import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingIndicators extends StatelessWidget {
  final PageController controller;
  final int count;

  const OnboardingIndicators({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: const ExpandingDotsEffect(
        dotColor: Colors.grey,
        activeDotColor: Colors.white,
        dotHeight: 8,
        dotWidth: 8,
        spacing: 8,
      ),
    );
  }
}