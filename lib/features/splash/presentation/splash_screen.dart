
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/core/theme/theme_bloc.dart';
import 'package:to_do/core/theme/theme_state.dart';
import 'package:to_do/generated/assets.dart';
import '../../../core/routing/routes.dart';
import '../../../core/services/biometric_auth_service.dart';
import '../../../core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricAuthService _biometricService = BiometricAuthService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {

        debugPrint('✅ User is signed in: ${user.email}');
        context.go(Routes.home);
      } else {

        debugPrint('❌ User is NOT signed in');

        final shouldPrompt = await _biometricService.shouldPromptBiometric();

        if (shouldPrompt) {
          debugPrint('🔐 Prompting biometric authentication');
          await _handleBiometricAuth();
        } else {
          debugPrint('➡️ Going to onboarding');
          if (mounted) {
            context.go(Routes.onBoarding);
          }
        }
      }
    } catch (e) {

      debugPrint('Error checking auth state: $e');

      if (mounted) {

        context.go(Routes.login);
      }
    }
  }

  Future<void> _handleBiometricAuth() async {
    try {
      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to access your account',
      );

      if (!mounted) return;

      if (!authenticated) {

        debugPrint('❌ Biometric authentication failed or cancelled');
        context.go(Routes.login);
        return;
      }


      debugPrint('✅ Biometric authentication successful');

      final authMethod = await _biometricService.getAuthMethod();

      if (!mounted) return;

      if (authMethod == null) {
        debugPrint('⚠️ No auth method found, going to login');
        context.go(Routes.login);
        return;
      }

      try {
        switch (authMethod) {
          case AuthMethod.email:
            await _handleEmailReauth();
            break;
          case AuthMethod.google:
            await _handleGoogleReauth();
            break;
          case AuthMethod.facebook:
            await _handleFacebookReauth();
            break;
        }
      } catch (e) {
        debugPrint('❌ Re-authentication failed: $e');
        if (mounted) {
          context.go(Routes.login);
        }
      }
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  Future<void> _handleEmailReauth() async {
    final credentials = await _biometricService.getCredentials();

    if (!mounted) return;

    if (credentials == null) {
      debugPrint('⚠️ No credentials found, going to login');
      context.go(Routes.login);
      return;
    }

    try {
      debugPrint('🔑 Re-authenticating with email/password...');
      await _authService.signIn(
        email: credentials['email']!,
        password: credentials['password']!,
      );

      if (!mounted) return;

      debugPrint('✅ Email re-authentication successful, navigating to home');
      context.go(Routes.home);
    } catch (e) {
      debugPrint('❌ Email re-authentication failed: $e');
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  Future<void> _handleGoogleReauth() async {
    try {
      debugPrint('🔑 Re-authenticating with Google...');
      await _authService.continueWithGoogle();

      if (!mounted) return;

      debugPrint('✅ Google re-authentication successful, navigating to home');
      context.go(Routes.home);
    } catch (e) {
      debugPrint('❌ Google re-authentication failed: $e');
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  Future<void> _handleFacebookReauth() async {
    try {
      debugPrint('🔑 Re-authenticating with Facebook...');
      await _authService.continueWithFacebook();

      if (!mounted) return;

      debugPrint('✅ Facebook re-authentication successful, navigating to home');
      context.go(Routes.home);
    } catch (e) {
      debugPrint('❌ Facebook re-authentication failed: $e');
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearBlack,
      body: Center(
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return SvgPicture.asset(
              Assets.svgsSplash,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                themeState.primaryColor,
                BlendMode.srcIn,
              ),
            );
          },
        ),
      ),
    );
  }
}