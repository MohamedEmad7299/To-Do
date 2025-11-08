
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/core/style/text/app_texts.dart';
import 'package:to_do/features/bottom_nav_pages/home/presentation/widgets/add_task_dialog.dart';
import '../../../../core/style/colors/app_colors.dart';
import '../../../../generated/assets.dart';
import '../../calender/presentation/calender_page.dart';
import '../../focus/presentation/focus_page.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../tasks/presentation/tasks_page.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.Onyx,
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.Onyx,
            body: _getPage(state.currentIndex),
            floatingActionButton: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                onPressed: () {
                  showAddTaskBottomSheet(context);
                },
                backgroundColor: AppColors.lavenderPurple,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: AppColors.Onyx,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      Assets.svgsTask,
                      'Tasks',
                      0,
                      state.currentIndex == 0,
                    ),
                    _buildNavItem(
                      context,
                      Assets.svgsCalendar,
                      'Calendar',
                      1,
                      state.currentIndex == 1,
                    ),
                    const SizedBox(width: 48), // Space for FAB
                    _buildNavItem(
                      context,
                      Assets.svgsClock,
                      'Focus',
                      2,
                      state.currentIndex == 2,
                    ),
                    _buildNavItem(
                      context,
                      Assets.svgsUser,
                      'Profile',
                      3,
                      state.currentIndex == 3,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const TasksPage();
      case 1:
        return const CalendarPage();
      case 2:
        return const FocusPage();
      case 3:
        return const ProfilePage();
      default:
        return const TasksPage();
    }
  }

  Widget _buildNavItem(
      BuildContext context,
      String icon,
      String label,
      int index,
      bool isActive,
      ) {
    return InkWell(
      onTap: () {
        context.read<HomeBloc>().add(NavigationChanged(index));
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon, height: 24, width: 24),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.font12White),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}