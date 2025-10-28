import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/core/style/text/app_texts.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearBlack,
      body: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.mark_email_read_rounded,
                        color: AppColors.lavenderPurple,
                        size: 80,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Check Your Email 📩",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font32LavenderPurpleW500.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "We’ve sent you a password reset link.\nPlease check your inbox and follow the instructions to reset your password.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font16GrayW400.copyWith(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lavenderPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => context.replace(Routes.login),
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
