import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// Load tasks
class LoadTasksEvent extends TaskEvent {}

// Load tasks by tag
class LoadTasksByTagEvent extends TaskEvent {
  final String tag;

  const LoadTasksByTagEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}

// Load tasks by status
class LoadTasksByStatusEvent extends TaskEvent {
  final bool isCompleted;

  const LoadTasksByStatusEvent(this.isCompleted);

  @override
  List<Object?> get props => [isCompleted];
}

// Add task
class AddTaskEvent extends TaskEvent {
  final String name;
  final String description;
  final String tag;
  final int priority;
  final DateTime dateTime;

  const AddTaskEvent({
    required this.name,
    required this.description,
    required this.tag,
    required this.priority,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [name, description, tag, priority, dateTime];
}

// Update task
class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  final Map<String, dynamic> updates;

  const UpdateTaskEvent({
    required this.taskId,
    required this.updates,
  });

  @override
  List<Object?> get props => [taskId, updates];
}

// Toggle task completion
class ToggleTaskEvent extends TaskEvent {
  final String taskId;
  final bool currentStatus;

  const ToggleTaskEvent({
    required this.taskId,
    required this.currentStatus,
  });

  @override
  List<Object?> get props => [taskId, currentStatus];
}

// Delete task
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Delete all completed tasks
class DeleteCompletedTasksEvent extends TaskEvent {}

// Task stream updated (from Firestore)
class TasksUpdatedEvent extends TaskEvent {
  final List<dynamic> tasks;

  const TasksUpdatedEvent(this.tasks);

  @override
  List<Object?> get props => [tasks];
}