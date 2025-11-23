
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../home/presentation/models/task_model.dart';
import '../../home/presentation/widgets/time_picker_dialog.dart';
import '../../home/presentation/widgets/task_priority_dialog.dart';
import '../../home/presentation/widgets/category_dialog.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TaskModel _editedTask;
  bool _isEditing = false;
  bool _hasNameText = false;
  bool _hasDescriptionText = false;

  @override
  void initState() {
    super.initState();
    _editedTask = widget.task;
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(text: widget.task.description);
    _hasNameText = _nameController.text.isNotEmpty;
    _hasDescriptionText = _descriptionController.text.isNotEmpty;
    _nameController.addListener(_onNameTextChanged);
    _descriptionController.addListener(_onDescriptionTextChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameTextChanged);
    _descriptionController.removeListener(_onDescriptionTextChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNameTextChanged() {
    final hasText = _nameController.text.isNotEmpty;
    if (hasText != _hasNameText) {
      setState(() => _hasNameText = hasText);
    }
  }

  void _onDescriptionTextChanged() {
    final hasText = _descriptionController.text.isNotEmpty;
    if (hasText != _hasDescriptionText) {
      setState(() => _hasDescriptionText = hasText);
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset if canceling
        _nameController.text = _editedTask.name;
        _descriptionController.text = _editedTask.description;
      }
    });
  }

  void _saveTask() {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.taskNameEmpty),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedTask = _editedTask.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    context.read<TaskBloc>().add(UpdateTaskEvent(
      taskId: updatedTask.id!,
      updates: updatedTask.toMap(),
    ));

    setState(() {
      _editedTask = updatedTask;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.taskUpdatedSuccessfully),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _selectCategory() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ChooseCategoryDialog(),
    );

    if (result != null) {
      setState(() {
        _editedTask = _editedTask.copyWith(tag: result);
      });
      _saveTaskImmediately();
    }
  }

  Future<void> _selectPriority() async {
    final priority = await showDialog<int>(
      context: context,
      builder: (context) => TaskPriorityDialog(initialPriority: _editedTask.priority),
    );

    if (priority != null) {
      setState(() {
        _editedTask = _editedTask.copyWith(priority: priority);
      });
      _saveTaskImmediately();
    }
  }

  Future<void> _selectDateTime() async {
    final result = await showDateTimePicker(context, initialDate: _editedTask.dateTime);

    if (result != null) {
      final selectedDate = result['date'] as DateTime;
      final selectedTime = result['time'] as TimeOfDay;

      final newDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      setState(() {
        _editedTask = _editedTask.copyWith(dateTime: newDateTime);
      });
      _saveTaskImmediately();
    }
  }

  void _saveTaskImmediately() {
    final updatedTask = _editedTask.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    context.read<TaskBloc>().add(UpdateTaskEvent(
      taskId: updatedTask.id!,
      updates: updatedTask.toMap(),
    ));
    setState(() {
      _editedTask = updatedTask;
    });
  }

  void _deleteTask() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text(l10n.deleteTaskConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(_editedTask.id!));
              Navigator.of(dialogContext).pop(); // Close dialog
              Navigator.of(context).pop(); // Close details screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.taskDeleted),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              l10n.delete,
              style: TextStyle(color: Theme.of(dialogContext).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleComplete() {
    final updatedTask = _editedTask.copyWith(
      isCompleted: !_editedTask.isCompleted,
      completedAt: !_editedTask.isCompleted ? DateTime.now() : null,
      clearCompletedAt: _editedTask.isCompleted,
    );

    context.read<TaskBloc>().add(UpdateTaskEvent(
      taskId: updatedTask.id!,
      updates: updatedTask.toMap(),
    ));
    setState(() {
      _editedTask = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskNameField(),
            const SizedBox(height: 24),
            _buildDescriptionField(),
            const SizedBox(height: 24),
            _buildDetailsCard(),
            const SizedBox(height: 24),
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        l10n.taskDetails,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _toggleEdit,
          ),
        IconButton(
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          onPressed: _isEditing ? _saveTask : _toggleEdit,
        ),
      ],
    );
  }

  Widget _buildTaskNameField() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.taskName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            enabled: _isEditing,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            decoration: InputDecoration(
              border: _isEditing ? const UnderlineInputBorder() : InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              hintText: l10n.enterTaskName,
              isDense: true,
              suffixIcon: _isEditing && _hasNameText
                  ? IconButton(
                      icon: Icon(
                        Icons.highlight_remove,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _nameController.clear(),
                    )
                  : null,
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.description,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            enabled: _isEditing,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: _isEditing ? const UnderlineInputBorder() : InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              hintText: l10n.enterTaskDescription,
              isDense: true,
              suffixIcon: _isEditing && _hasDescriptionText
                  ? IconButton(
                      icon: Icon(
                        Icons.highlight_remove,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _descriptionController.clear(),
                    )
                  : null,
            ),
            maxLines: null,
            minLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailTile(
            icon: Icons.category_outlined,
            title: l10n.category,
            value: _editedTask.category,
            onTap: _selectCategory,
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.flag_outlined,
            title: l10n.priority,
            value: '${l10n.priority} ${_editedTask.priority}',
            onTap: _selectPriority,
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.calendar_today_outlined,
            title: l10n.dueDate,
            value: DateFormat('MMM dd, yyyy').format(_editedTask.dateTime),
            onTap: _selectDateTime,
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.access_time_outlined,
            title: l10n.dueTime,
            value: DateFormat('hh:mm a').format(_editedTask.dateTime),
            onTap: _selectDateTime,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            secondary: Icon(
              _editedTask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: _editedTask.isCompleted ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.markAsComplete),
            subtitle: Text(
              _editedTask.isCompleted ? l10n.completed : l10n.inProgress,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _editedTask.isCompleted,
            onChanged: (value) => _toggleComplete(),
          ),
          _buildDivider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(
              Icons.create_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.created),
            subtitle: Text(
              DateFormat('MMM dd, yyyy at hh:mm a').format(_editedTask.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (_editedTask.completedAt != null) ...[
            _buildDivider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: Text(l10n.completed),
              subtitle: Text(
                DateFormat('MMM dd, yyyy at hh:mm a').format(_editedTask.completedAt!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: Theme.of(context).dividerColor,
    );
  }

  Widget _buildDeleteButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _deleteTask,
        icon: const Icon(Icons.delete_outline),
        label: Text(l10n.deleteTask),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
