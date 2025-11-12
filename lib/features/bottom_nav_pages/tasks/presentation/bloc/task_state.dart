
import 'package:equatable/equatable.dart';

import '../../../home/presentation/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

// Initial state
class TaskInitial extends TaskState {}

// Loading state
class TaskLoading extends TaskState {}

// Tasks loaded successfully
class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

// Task operation success (add, update, delete)
class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Error state
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}