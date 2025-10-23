
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/core/style/text/app_texts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearBlack,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Text(
              "Welcome to UpTodo",
              style: AppTextStyles.font32White700W,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Please login to your account or create new account to continue",
              style: AppTextStyles.font16White400W,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () { context.push(Routes.login); },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.lavenderPurple),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Text(
                  'LOGIN',
                  style: AppTextStyles.font16White400W,
                ),
              ),
            ),
            SizedBox(height: 16,),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () { context.push(Routes.register); },
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    BorderSide(color: AppColors.lavenderPurple, width: 1),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Text(
                  'CREATE ACCOUNT',
                  style: AppTextStyles.font16White400W,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
