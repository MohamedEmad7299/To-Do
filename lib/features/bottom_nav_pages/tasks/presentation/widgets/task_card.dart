
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/style/text/app_texts.dart';
import 'package:to_do/core/services/category_firestore_service.dart';
import 'package:to_do/generated/assets.dart';
import '../../../home/presentation/models/task_model.dart';
import '../../../home/presentation/models/category.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final CategoryFirestoreService _categoryService = CategoryFirestoreService();
  CategoryModel? _categoryModel;

  @override
  void initState() {
    super.initState();
    _loadCategoryIfNeeded();
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if task tag changed
    if (oldWidget.task.tag != widget.task.tag) {
      _loadCategoryIfNeeded();
    }
  }

  Future<void> _loadCategoryIfNeeded() async {
    // Check if it's a predefined category (case-insensitive)
    final predefinedCategories = [
      'Grocery', 'Work', 'Sport', 'Design', 'University',
      'Social', 'Music', 'Health', 'Movie', 'Home'
    ];

    final isPredefined = predefinedCategories.any(
            (cat) => cat.toLowerCase() == widget.task.tag.toLowerCase()
    );

    if (!isPredefined) {
      // It's a custom category, fetch from Firestore
      try {
        final categories = await _categoryService.getUserCategoriesFuture();
        print('Loaded ${categories.length} custom categories from Firestore');
        print('Looking for category: "${widget.task.tag}"');

        // Debug: print all category names
        for (var cat in categories) {
          print('  - ${cat.name} (color: ${cat.colorValue}, icon: ${cat.icon})');
        }

        final category = categories.firstWhere(
              (cat) => cat.name.toLowerCase() == widget.task.tag.toLowerCase(),
          orElse: () {
            print('Category "${widget.task.tag}" not found in Firestore, using fallback');
            return CategoryModel(
              userId: '',
              name: widget.task.tag,
              icon: Icons.label.codePoint.toString(),
              colorValue: 0xFF8687E7,
            );
          },
        );

        if (mounted) {
          setState(() {
            _categoryModel = category;
          });
          print('Loaded custom category: ${category.name}, color: ${category.colorValue}, icon: ${category.icon}');
        }
      } catch (e) {
        print('Error loading category: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.id!),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (direction) => _confirmDismiss(context),
      onDismissed: (direction) => _onDismissed(context),
      child: _buildTaskCard(),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool?> _confirmDismiss(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF363636),
          title: const Text(
            'Delete Task',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this task?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onDismissed(BuildContext context) {
    context.read<TaskBloc>().add(DeleteTaskEvent(widget.task.id!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.task.name} deleted', style: AppTextStyles.font12White,),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTaskCard() {
    return GestureDetector(
      onTap: () {
        context.push(Routes.taskDetails, extra: widget.task);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF363636),
          borderRadius: BorderRadius.circular(12),
          border: widget.task.isCompleted
              ? Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            _buildCheckbox(),
            const SizedBox(width: 12),
            Expanded(child: _buildTaskDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Builder(
      builder: (context) {
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.task.isCompleted
                    ? const Color(0xFF8687E7)
                    : Colors.white,
                width: 2,
              ),
              color: widget.task.isCompleted
                  ? const Color(0xFF8687E7)
                  : Colors.transparent,
            ),
            child: widget.task.isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildTaskDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.task.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration:
            widget.task.isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildTaskMetadata(),
      ],
    );
  }

  Widget _buildTaskMetadata() {
    return Row(
      children: [
        Expanded(
          child: _buildDateTimeChip(),
        ),
        const SizedBox(width: 8),
        _buildCategoryChip(),
        const SizedBox(width: 8),
        _buildPriorityChip(),
      ],
    );
  }

  Widget _buildDateTimeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            size: 12,
            color: Colors.white70,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              DateFormat('MMM dd, hh:mm a').format(widget.task.dateTime),
              style: AppTextStyles.font14GrayW400,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    final categoryColor = _getCategoryColor();
    final categoryIcon = _getCategoryIcon();

    return Container(
      height: 30,
      constraints: const BoxConstraints(
        maxWidth: 100, // Fixed maximum width for category chip
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: categoryColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          if (categoryIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: categoryIcon,
            ),
          // Category Name
          Flexible(
            child: Text(
              widget.task.tag,
              style: AppTextStyles.font12White,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip() {
    final priorityColor = _getPriorityColor();
    return Container(
      height: 32,
      width: 54,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: priorityColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag,
            size: 16,
            color: priorityColor,
          ),
          const SizedBox(width: 2),
          Text(
            '${widget.task.priority}',
            style: TextStyle(
              color: priorityColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get category icon
  Widget? _getCategoryIcon() {
    // Check predefined categories first (case-insensitive)
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

    final iconPath = iconMap[widget.task.tag.toLowerCase()];

    if (iconPath != null) {
      // Predefined category with SVG icon
      return SvgPicture.asset(
        iconPath,
        width: 14,
        height: 14,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    // For custom categories, use the icon from Firestore
    if (_categoryModel != null) {
      try {
        // Custom category icon stored as codePoint
        final iconCodePoint = int.tryParse(_categoryModel!.icon);
        if (iconCodePoint != null) {
          return Icon(
            IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
            size: 14,
            color: Colors.white,
          );
        }
      } catch (e) {
        print('Error parsing custom icon: $e');
      }
    }

    // Fallback icon - but this means the category isn't loaded yet or doesn't exist
    return const Icon(
      Icons.label,
      size: 14,
      color: Colors.white,
    );
  }

  Color _getCategoryColor() {
    // Check predefined categories first (case-insensitive)
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

    final predefinedColor = colorMap[widget.task.tag.toLowerCase()];
    if (predefinedColor != null) {
      return predefinedColor;
    }

    // For custom categories, use the color from Firestore
    if (_categoryModel != null) {
      print('Using custom category color: ${_categoryModel!.color}');
      return _categoryModel!.color;
    }

    // Fallback color - means the category isn't loaded yet
    print('Using fallback color for category: ${widget.task.tag}');
    return const Color(0xFF8687E7);
  }

  Color _getPriorityColor() {
    if (widget.task.priority <= 4) {
      return Colors.green;
    } else if (widget.task.priority <= 8) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}