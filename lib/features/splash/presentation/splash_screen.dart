
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/generated/assets.dart';
import '../../../core/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.replace(Routes.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.nearBlack,
      body: Center(
        child: SvgPicture.asset(
          Assets.svgsSplash,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}