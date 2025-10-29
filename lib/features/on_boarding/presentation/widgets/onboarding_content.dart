

import 'package:flutter/material.dart';
import '../models/on_boarding_model.dart';
import 'on_boarding_page.dart';

class OnboardingContent extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingPageModel> pages;
  final ValueChanged<int> onPageChanged;

  const OnboardingContent({
    super.key,
    required this.pageController,
    required this.pages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      physics: const BouncingScrollPhysics(),
      itemCount: pages.length,
      itemBuilder: (context, index) => OnboardingPage(model: pages[index]),
    );
  }
}