
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/generated/assets.dart';

import '../../../core/routing/routes.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) {
          context.replace(Routes.onBoarding);
        }
      });
    });


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