import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_bloc.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_event.dart';
import 'package:to_do/generated/assets.dart';
import 'package:to_do/l10n/app_localizations.dart';
import 'category_dialog.dart';
import 'task_priority_dialog.dart';
import 'time_picker_dialog.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDateTime;
  String? _selectedCategory;
  int? _selectedPriority;
  String? _errorMessage;
  bool _hasTaskText = false;
  bool _hasDescriptionText = false;

  @override
  void initState() {
    super.initState();
    _taskController.addListener(_onTaskTextChanged);
    _descriptionController.addListener(_onDescriptionTextChanged);
  }

  @override
  void dispose() {
    _taskController.removeListener(_onTaskTextChanged);
    _descriptionController.removeListener(_onDescriptionTextChanged);
    _taskController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTaskTextChanged() {
    final hasText = _taskController.text.isNotEmpty;
    if (hasText != _hasTaskText) {
      setState(() => _hasTaskText = hasText);
    }
  }

  void _onDescriptionTextChanged() {
    final hasText = _descriptionController.text.isNotEmpty;
    if (hasText != _hasDescriptionText) {
      setState(() => _hasDescriptionText = hasText);
    }
  }

  Future<void> _selectDateTime() async {
    final result = await showDateTimePicker(context);
    if (result != null) {
      final date = result['date'] as DateTime;
      final time = result['time'] as TimeOfDay;

      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _errorMessage = null; // Clear error when selection is made
      });
    }
  }

  Future<void> _selectCategory() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ChooseCategoryDialog(
        initialCategory: _selectedCategory,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result;
        _errorMessage = null; // Clear error when selection is made
      });
    }
  }

  Future<void> _selectPriority() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => TaskPriorityDialog(
        initialPriority: _selectedPriority,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPriority = result;
        _errorMessage = null; // Clear error when selection is made
      });
    }
  }

  void _addTask() {
    final l10n = AppLocalizations.of(context)!;
    String? error;

    if (_taskController.text.isEmpty) {
      error = l10n.pleaseEnterTaskName;
    } else if (_selectedCategory == null) {
      error = l10n.pleaseSelectCategory;
    } else if (_selectedPriority == null) {
      error = l10n.pleaseSelectPriority;
    } else if (_selectedDateTime == null) {
      error = l10n.pleaseSelectDateTime;
    }

    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
      return;
    }

    // Add task using BLoC
    context.read<TaskBloc>().add(
      AddTaskEvent(
        name: _taskController.text.trim(),
        description: _descriptionController.text.trim(),
        tag: _selectedCategory!,
        priority: _selectedPriority!,
        dateTime: _selectedDateTime!,
      ),
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.taskAddedSuccessfully),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF363636),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addTask,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taskController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (value) {
                if (_errorMessage != null && value.isNotEmpty) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: l10n.taskNameHint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: _hasTaskText
                    ? IconButton(
                        icon: const Icon(Icons.highlight_remove, color: Colors.white70),
                        onPressed: () => _taskController.clear(),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: '',
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: _hasDescriptionText
                    ? IconButton(
                        icon: const Icon(Icons.highlight_remove, color: Colors.white70),
                        onPressed: () => _descriptionController.clear(),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Show selected values
            if (_selectedDateTime != null ||
                _selectedCategory != null ||
                _selectedPriority != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedDateTime != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd, yyyy - hh:mm a')
                                  .format(_selectedDateTime!),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.label,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedCategory!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedPriority != null)
                      Row(
                        children: [
                          const Icon(Icons.flag,
                              color: Colors.white70, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.priorityLabel}: $_selectedPriority',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Error message display
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red, size: 18),
                      onPressed: () => setState(() => _errorMessage = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            Row(
              children: [
                _buildIconButton(
                  Assets.svgsTimer,
                  _selectDateTime,
                  _selectedDateTime != null,
                ),
                const SizedBox(width: 16),
                _buildIconButton(
                  Assets.svgsTag,
                  _selectCategory,
                  _selectedCategory != null,
                ),
                const SizedBox(width: 16),
                _buildIconButton(
                  Assets.svgsFlag,
                  _selectPriority,
                  _selectedPriority != null,
                ),
                const Spacer(),
                IconButton(
                  onPressed: _addTask,
                  icon: Transform.flip(
                    flipX: Directionality.of(context) == ui.TextDirection.rtl,
                    child: SvgPicture.asset(
                      Assets.svgsSend,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      String icon, VoidCallback onPressed, bool isSelected) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1)
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

void showAddTaskBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddTaskBottomSheet(),
  );
}