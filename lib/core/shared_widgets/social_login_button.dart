
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../style/colors/app_colors.dart';
import '../style/text/app_texts.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconAsset;
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconAsset,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            BorderSide(
              color: AppColors.lavenderPurple,
              width: 1,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: AppTextStyles.font16White400W,
            ),
          ],
        ),
      ),
    );
  }
}