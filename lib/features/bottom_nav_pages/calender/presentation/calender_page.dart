
import 'package:flutter/material.dart';
import '../../../../core/style/text/app_texts.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_rounded,
            size: 120,
            color: const Color(0xFF7B68EE),
          ),
          const SizedBox(height: 24),
          Text(
            "Your Calendar",
            style: AppTextStyles.font20White.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 12),
          Text(
            "View all your scheduled tasks",
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