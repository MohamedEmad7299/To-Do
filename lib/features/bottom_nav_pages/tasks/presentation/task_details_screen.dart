import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _editedTask = widget.task;
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task name cannot be empty'),
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
      const SnackBar(
        content: Text('Task updated successfully'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(_editedTask.id!));
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close details screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
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
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Task Details',
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
            'Task Name',
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
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter task name',
              isDense: true,
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
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
            'Description',
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
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter task description',
              isDense: true,
            ),
            maxLines: null,
            minLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailTile(
            icon: Icons.category_outlined,
            title: 'Category',
            value: _editedTask.tag,
            onTap: _selectCategory,
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.flag_outlined,
            title: 'Priority',
            value: 'Priority ${_editedTask.priority}',
            onTap: _selectPriority,
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.calendar_today_outlined,
            title: 'Due Date',
            value: DateFormat('MMM dd, yyyy').format(_editedTask.dateTime),
            onTap: _selectDateTime,
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.access_time_outlined,
            title: 'Due Time',
            value: DateFormat('hh:mm a').format(_editedTask.dateTime),
            onTap: _selectDateTime,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
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
            title: const Text('Mark as Complete'),
            subtitle: Text(
              _editedTask.isCompleted ? 'Completed' : 'In Progress',
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
            title: const Text('Created'),
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
              title: const Text('Completed'),
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
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _deleteTask,
        icon: const Icon(Icons.delete_outline),
        label: const Text('Delete Task'),
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
