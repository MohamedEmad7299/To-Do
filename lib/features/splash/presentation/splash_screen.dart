
import 'package:firebase_auth/firebase_auth.dart';
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
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      // Add a small delay for splash screen visibility
      // Remove this if you want instant navigation
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Check if user is signed in
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is signed in, navigate to home
        debugPrint('✅ User is signed in: ${user.email}');
        context.go(Routes.home);
      } else {
        // User is NOT signed in, navigate to login
        debugPrint('❌ User is NOT signed in, showing login');
        context.go(Routes.onBoarding);
      }
    } catch (e) {
      // Handle any errors during auth check
      debugPrint('Error checking auth state: $e');

      if (mounted) {
        // On error, default to login screen
        context.go(Routes.login);
      }
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