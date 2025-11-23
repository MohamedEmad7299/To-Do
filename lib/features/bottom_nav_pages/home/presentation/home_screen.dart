import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/features/bottom_nav_pages/home/presentation/widgets/add_task_dialog.dart';
import 'package:to_do/l10n/app_localizations.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: _getPage(state.currentIndex),
            floatingActionButton: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                onPressed: () {
                  showAddTaskBottomSheet(context);
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).colorScheme.surface,
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
                      AppLocalizations.of(context)!.tasks,
                      0,
                      state.currentIndex == 0,
                    ),
                    _buildNavItem(
                      context,
                      Assets.svgsCalendar,
                      AppLocalizations.of(context)!.calendar,
                      1,
                      state.currentIndex == 1,
                    ),
                    const SizedBox(width: 48), // Space for FAB
                    _buildNavItem(
                      context,
                      Assets.svgsClock,
                      AppLocalizations.of(context)!.focus,
                      2,
                      state.currentIndex == 2,
                    ),
                    _buildNavItem(
                      context,
                      Assets.svgsUser,
                      AppLocalizations.of(context)!.profile,
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
        return ProfilePage();
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
    return GestureDetector(
      onTap: () {
        context.read<HomeBloc>().add(NavigationChanged(index));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}