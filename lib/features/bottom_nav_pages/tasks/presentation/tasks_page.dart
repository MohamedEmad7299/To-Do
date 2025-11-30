
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do/l10n/app_localizations.dart';
import '../../../../core/style/text/app_texts.dart';
import '../../../../generated/assets.dart';
import '../../home/presentation/models/task_model.dart';
import '../../home/presentation/widgets/category_dialog.dart';
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
  String? _filterByCategory; // null means show all

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [

          _buildActiveSortChip(),

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
        AppLocalizations.of(context)!.tasks,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: _showCategoryFilterDialog,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: _filterByCategory != null
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              child: Icon(
                Icons.label_outline,
                color: _filterByCategory != null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
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
      tooltip: AppLocalizations.of(context)!.sortBy,
      onSelected: (value) {
        setState(() {
          _sortBy = value;
        });
      },
      itemBuilder: (context) => [
        _buildSortMenuItem('date', Icons.calendar_today, AppLocalizations.of(context)!.date),
        _buildSortMenuItem('name', Icons.sort_by_alpha, AppLocalizations.of(context)!.name),
        _buildSortMenuItem('priority', Icons.flag, AppLocalizations.of(context)!.priority),
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
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryFilterDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ChooseCategoryDialog(
        initialCategory: _filterByCategory,
      ),
    );

    if (result != null) {
      setState(() {
        _filterByCategory = result;
      });
    }
  }

  Widget _buildActiveSortChip() {
    final hasSort = _sortBy != 'date';
    final hasFilter = _filterByCategory != null;

    if (!hasSort && !hasFilter) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (hasSort)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.sortedBy,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                Chip(
                  label: Text(
                    _sortBy == 'name' ? AppLocalizations.of(context)!.nameAZ : AppLocalizations.of(context)!.priority112,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
          if (hasFilter)
            Chip(
              avatar: Icon(
                Icons.label,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: Text(
                _filterByCategory!,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              deleteIcon: Icon(
                Icons.close,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onDeleted: () {
                setState(() {
                  _filterByCategory = null;
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
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (state is TaskLoaded) {
      return _buildTasksList(state.tasks);
    }

    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
    // Filter by category first
    var filteredTasks = tasks;
    if (_filterByCategory != null) {
      filteredTasks = tasks.where((task) => task.category == _filterByCategory).toList();
    }

    var sortedTasks = _sortTasks(filteredTasks);

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
              context: context,
              icon: Icons.pending_actions,
              color: Colors.orange,
              title: AppLocalizations.of(context)!.pending,
              count: pendingTasks.length,
            ),
            const SizedBox(height: 12),
            ...pendingTasks.map((task) => TaskCard(task: task)),
            const SizedBox(height: 24),
          ],

          // Completed Section
          if (completedTasks.isNotEmpty) ...[
            _buildSectionHeader(
              context: context,
              icon: Icons.check_circle,
              color: Colors.green,
              title: AppLocalizations.of(context)!.completed,
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
      sortedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }

    return sortedTasks;
  }

  Widget _buildSectionHeader({
    required BuildContext context,
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
              AppLocalizations.of(context)!.whatToDoToday,
              style: AppTextStyles.font20White,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tapToAddTasks,
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