import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/style/text/app_texts.dart';
import 'package:to_do/core/services/category_firestore_service.dart';
import 'package:to_do/generated/assets.dart';
import 'package:to_do/l10n/app_localizations.dart';
import '../../home/presentation/models/task_model.dart';
import '../../home/presentation/models/category.dart';
import '../../tasks/presentation/bloc/task_bloc.dart';
import '../../tasks/presentation/bloc/task_event.dart';
import '../../tasks/presentation/bloc/task_state.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  bool _showCompleted = false;
  late ScrollController _weekScrollController;

  @override
  void initState() {
    super.initState();
    _weekScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    final daysDiff = _selectedDate.difference(_getFirstDayOfMonth()).inDays;
    final scrollPosition = (daysDiff * 56.0) - (MediaQuery.of(context).size.width / 2) + 28;
    if (_weekScrollController.hasClients) {
      _weekScrollController.animateTo(
        scrollPosition.clamp(0.0, _weekScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  DateTime _getFirstDayOfMonth() {
    return DateTime(_focusedMonth.year, _focusedMonth.month, 1);
  }

  int _getDaysInMonth() {
    return DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(l10n),

            // Month Navigation
            _buildMonthNavigation(l10n),

            // Week Days Row
            _buildWeekDaysRow(l10n),

            // Horizontal Date Picker
            _buildHorizontalDatePicker(),

            // Today/Completed Toggle
            _buildToggleTabs(l10n),

            // Task List
            Expanded(
              child: _buildTaskList(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        l10n.calendar,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMonthNavigation(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Column(
            children: [
              Text(
                DateFormat('MMMM').format(_focusedMonth).toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                _focusedMonth.year.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysRow(AppLocalizations l10n) {
    final weekDays = [
      l10n.sun,
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDays.map((day) {
          final index = weekDays.indexOf(day);
          final isWeekend = index == 0 || index == 6;
          return SizedBox(
            width: 40,
            child: Text(
              day.length > 3 ? day.substring(0, 3) : day,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isWeekend
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalDatePicker() {
    final daysInMonth = _getDaysInMonth();
    final firstDayOfMonth = _getFirstDayOfMonth();

    return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: _weekScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final date = firstDayOfMonth.add(Duration(days: index));
          final isSelected = _isSameDay(date, _selectedDate);
          final isToday = _isToday(date);
          final isWeekend = date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 3).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : isWeekend
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (_hasTasksOnDate(date))
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _hasTasksOnDate(DateTime date) {
    final taskState = context.read<TaskBloc>().state;
    if (taskState is TaskLoaded) {
      return taskState.tasks.any((task) => _isSameDay(task.dateTime, date));
    }
    return false;
  }

  Widget _buildToggleTabs(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              label: l10n.pending,
              isActive: !_showCompleted,
              onTap: () => setState(() => _showCompleted = false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
              label: l10n.completed,
              isActive: _showCompleted,
              onTap: () => setState(() => _showCompleted = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: !isActive
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                )
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(AppLocalizations l10n) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskLoaded) {
          final filteredTasks = state.tasks.where((task) {
            final isSameDate = _isSameDay(task.dateTime, _selectedDate);
            final matchesCompletion = _showCompleted
                ? task.isCompleted
                : !task.isCompleted;
            return isSameDate && matchesCompletion;
          }).toList();

          // Sort by time
          filteredTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));

          if (filteredTasks.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              return _CalendarTaskCard(task: filteredTasks[index]);
            },
          );
        }

        if (state is TaskError) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _showCompleted ? Icons.check_circle_outline : Icons.event_note,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _showCompleted
                ? l10n.completed
                : l10n.tapToAddTasks,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarTaskCard extends StatefulWidget {
  final TaskModel task;

  const _CalendarTaskCard({required this.task});

  @override
  State<_CalendarTaskCard> createState() => _CalendarTaskCardState();
}

class _CalendarTaskCardState extends State<_CalendarTaskCard> {
  final CategoryFirestoreService _categoryService = CategoryFirestoreService();
  CategoryModel? _categoryModel;

  @override
  void initState() {
    super.initState();
    _loadCategoryIfNeeded();
  }

  Future<void> _loadCategoryIfNeeded() async {
    final predefinedCategories = [
      'Grocery', 'Work', 'Sport', 'Design', 'University',
      'Social', 'Music', 'Health', 'Movie', 'Home'
    ];

    final isPredefined = predefinedCategories.any(
      (cat) => cat.toLowerCase() == widget.task.category.toLowerCase()
    );

    if (!isPredefined) {
      try {
        final categories = await _categoryService.getUserCategoriesFuture();
        final category = categories.firstWhere(
          (cat) => cat.name.toLowerCase() == widget.task.category.toLowerCase(),
          orElse: () => CategoryModel(
            userId: '',
            name: widget.task.category,
            icon: Icons.label.codePoint.toString(),
            colorValue: 0xFF8687E7,
          ),
        );

        if (mounted) {
          setState(() => _categoryModel = category);
        }
      } catch (e) {
        debugPrint('Error loading category: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.taskDetails, extra: widget.task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: widget.task.isCompleted
              ? Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            _buildCheckbox(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('hh:mm a').format(widget.task.dateTime),
                        style: AppTextStyles.font14GrayW400,
                      ),
                      const Spacer(),
                      _buildCategoryChip(),
                      const SizedBox(width: 8),
                      _buildPriorityChip(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TaskBloc>().add(
          ToggleTaskEvent(
            taskId: widget.task.id!,
            currentStatus: widget.task.isCompleted,
          ),
        );
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.task.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            width: 2,
          ),
          color: widget.task.isCompleted
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        child: widget.task.isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildCategoryChip() {
    final categoryColor = _getCategoryColor();
    final categoryIcon = _getCategoryIcon();

    return Container(
      constraints: const BoxConstraints(maxWidth: 90),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (categoryIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: categoryIcon,
            ),
          Flexible(
            child: Text(
              widget.task.category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 12,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 2),
          Text(
            '${widget.task.priority}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _getCategoryIcon() {
    final iconMap = {
      'grocery': Assets.svgsBread,
      'work': Assets.svgsBriefcase,
      'sport': Assets.svgsSport,
      'design': Assets.svgsXO,
      'university': Assets.svgsMortarboard,
      'social': Assets.svgsMegaphone,
      'music': Assets.svgsMusic,
      'health': Assets.svgsHeartbeat,
      'movie': Assets.svgsCameraV,
      'home': Assets.svgsHomeTag,
    };

    final iconPath = iconMap[widget.task.category.toLowerCase()];

    if (iconPath != null) {
      return SvgPicture.asset(
        iconPath,
        width: 12,
        height: 12,
        colorFilter: ColorFilter.mode(
          _getCategoryColor(),
          BlendMode.srcIn,
        ),
      );
    }

    if (_categoryModel != null) {
      try {
        final iconCodePoint = int.tryParse(_categoryModel!.icon);
        if (iconCodePoint != null) {
          return Icon(
            IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
            size: 12,
            color: _getCategoryColor(),
          );
        }
      } catch (e) {
        debugPrint('Error parsing custom icon: $e');
      }
    }

    return Icon(
      Icons.label,
      size: 12,
      color: _getCategoryColor(),
    );
  }

  Color _getCategoryColor() {
    final colorMap = {
      'grocery': const Color(0xFFCCFF80),
      'work': const Color(0xFFFF9680),
      'sport': const Color(0xFF80FFFF),
      'design': const Color(0xFF80FFD9),
      'university': const Color(0xFF809CFF),
      'social': const Color(0xFFFF80EB),
      'music': const Color(0xFFFC80FF),
      'health': const Color(0xFF80FFA3),
      'movie': const Color(0xFF80D1FF),
      'home': const Color(0xFFFFCC80),
    };

    final predefinedColor = colorMap[widget.task.category.toLowerCase()];
    if (predefinedColor != null) {
      return predefinedColor;
    }

    if (_categoryModel != null) {
      return _categoryModel!.color;
    }

    return Theme.of(context).colorScheme.primary;
  }
}
