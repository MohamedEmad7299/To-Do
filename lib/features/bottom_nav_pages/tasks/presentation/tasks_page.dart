
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/style/text/app_texts.dart';
import '../../../../generated/assets.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.filter_list_outlined, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svgsEmptyPlaceholder,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 24),
              Text(
                "What do you want to do today?",
                style: AppTextStyles.font20White,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Tap + to add your tasks",
                style: AppTextStyles.font20White.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}