
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/style/text/app_texts.dart';
import '../../../../generated/assets.dart';
import '../../home/presentation/models/task_model.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'bloc/task_state.dart';
import 'widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _sortBy = 'date'; // 'date', 'name', 'priority'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Active Sort Display
          _buildActiveSortChip(),

          // Tasks List
          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: _handleBlocListener,
              builder: _buildBlocBuilder,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: _buildSortMenu(),
      title: Text(
        'Tasks',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.filter_list_sharp,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      tooltip: 'Sort by',
      onSelected: (value) {
        setState(() {
          _sortBy = value;
        });
      },
      itemBuilder: (context) => [
        _buildSortMenuItem('date', Icons.calendar_today, 'Date'),
        _buildSortMenuItem('name', Icons.sort_by_alpha, 'Name'),
        _buildSortMenuItem('priority', Icons.flag, 'Priority'),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(
      String value,
      IconData icon,
      String label,
      ) {
    final isSelected = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? const Color(0xFF8687E7) : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF8687E7) : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSortChip() {
    if (_sortBy == 'date') return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Sorted by: ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          Chip(
            label: Text(
              _sortBy == 'name' ? 'Name (A-Z)' : 'Priority (1-12)',
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: const Color(0xFF8687E7),
            deleteIcon: Icon(
              Icons.close,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onDeleted: () {
              setState(() {
                _sortBy = 'date';
              });
            },
          ),
        ],
      ),
    );
  }

  void _handleBlocListener(BuildContext context, TaskState state) {
    if (state is TaskError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBlocBuilder(BuildContext context, TaskState state) {
    if (state is TaskLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8687E7),
        ),
      );
    }

    if (state is TaskLoaded) {
      return _buildTasksList(state.tasks);
    }

    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF8687E7),
      ),
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
    var sortedTasks = _sortTasks(tasks);

    // Split into pending and completed
    final pendingTasks =
    sortedTasks.where((task) => !task.isCompleted).toList();
    final completedTasks =
    sortedTasks.where((task) => task.isCompleted).toList();

    if (sortedTasks.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TaskBloc>().add(LoadTasksEvent());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Pending Section
          if (pendingTasks.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.pending_actions,
              color: Colors.orange,
              title: 'Pending',
              count: pendingTasks.length,
            ),
            const SizedBox(height: 12),
            ...pendingTasks.map((task) => TaskCard(task: task)),
            const SizedBox(height: 24),
          ],

          // Completed Section
          if (completedTasks.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.check_circle,
              color: Colors.green,
              title: 'Completed',
              count: completedTasks.length,
            ),
            const SizedBox(height: 12),
            ...completedTasks.map((task) => TaskCard(task: task)),
          ],
        ],
      ),
    );
  }

  List<TaskModel> _sortTasks(List<TaskModel> tasks) {
    var sortedTasks = List<TaskModel>.from(tasks);

    if (_sortBy == 'name') {
      sortedTasks.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_sortBy == 'priority') {
      sortedTasks.sort((a, b) => a.priority.compareTo(b.priority));
    } else {
      // Default: sort by date
      sortedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }

    return sortedTasks;
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required Color color,
    required String title,
    required int count,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          '$title ($count)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}