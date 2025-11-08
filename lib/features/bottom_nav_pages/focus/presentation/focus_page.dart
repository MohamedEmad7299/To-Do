

import 'package:flutter/material.dart';
import 'package:to_do/core/style/text/app_texts.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 120,
            color: const Color(0xFF7B68EE),
          ),
          const SizedBox(height: 24),
          Text(
            "Focus Mode",
            style: AppTextStyles.font20White.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 12),
          Text(
            "Stay focused on your tasks\nwith Pomodoro timer",
            style: AppTextStyles.font20White.copyWith(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}