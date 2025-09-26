
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/generated/assets.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearBlack,
      body: Center(
        child: SvgPicture.asset(
            Assets.svgsSplash
        ),
      ),
    );
  }
}