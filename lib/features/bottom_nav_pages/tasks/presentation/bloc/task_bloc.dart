
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/services/firestore_service.dart';
import '../../../home/presentation/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final FirestoreService _firestoreService;
  StreamSubscription? _taskSubscription;

  TaskBloc({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService(),
        super(TaskInitial()) {
    // Register event handlers
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTasksByTagEvent>(_onLoadTasksByTag);
    on<LoadTasksByStatusEvent>(_onLoadTasksByStatus);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<ToggleTaskEvent>(_onToggleTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<DeleteCompletedTasksEvent>(_onDeleteCompletedTasks);
    on<TasksUpdatedEvent>(_onTasksUpdated);
  }

  // ==================== LOAD TASKS ====================
  Future<void> _onLoadTasks(
      LoadTasksEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());

    // Cancel Previous Subscription
    await _taskSubscription?.cancel();

    _taskSubscription = _firestoreService.getUserTasks().listen(
          (tasks) {
        add(TasksUpdatedEvent(tasks));
      },
      onError: (error) {
        add(TasksUpdatedEvent([]));
      },
    );
  }

  // ==================== LOAD TASKS BY TAG ====================
  Future<void> _onLoadTasksByTag(
      LoadTasksByTagEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());

    await _taskSubscription?.cancel();

    _taskSubscription = _firestoreService.getTasksByTag(event.tag).listen(
          (tasks) {
        add(TasksUpdatedEvent(tasks));
      },
      onError: (error) {
        add(TasksUpdatedEvent([]));
      },
    );
  }

  // ==================== LOAD TASKS BY STATUS ====================
  Future<void> _onLoadTasksByStatus(
      LoadTasksByStatusEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());

    await _taskSubscription?.cancel();

    _taskSubscription =
        _firestoreService.getTasksByStatus(event.isCompleted).listen(
              (tasks) {
            add(TasksUpdatedEvent(tasks));
          },
          onError: (error) {
            add(TasksUpdatedEvent([]));
          },
        );
  }

  // ==================== TASKS UPDATED FROM STREAM ====================
  void _onTasksUpdated(
      TasksUpdatedEvent event,
      Emitter<TaskState> emit,
      ) {
    emit(TaskLoaded(event.tasks.cast<TaskModel>()));
  }

  // ==================== ADD TASK ====================
  Future<void> _onAddTask(
      AddTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(const TaskError('User not logged in'));
        return;
      }

      final task = TaskModel(
        userId: userId,
        name: event.name,
        description: event.description,
        tag: event.tag,
        priority: event.priority,
        dateTime: event.dateTime,
      );

      await _firestoreService.addTask(task);

      // Don't emit success here, the stream will update automatically
    } catch (e) {
      emit(TaskError('Failed to add task: ${e.toString()}'));
    }
  }

  // ==================== UPDATE TASK ====================
  Future<void> _onUpdateTask(
      UpdateTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await _firestoreService.updateTask(event.taskId, event.updates);

      // Stream will update automatically
    } catch (e) {
      emit(TaskError('Failed to update task: ${e.toString()}'));
    }
  }

  // ==================== TOGGLE TASK ====================
  Future<void> _onToggleTask(
      ToggleTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await _firestoreService.toggleTaskCompletion(
        event.taskId,
        !event.currentStatus,
      );

      // Stream will update automatically
    } catch (e) {
      emit(TaskError('Failed to toggle task: ${e.toString()}'));
    }
  }

  // ==================== DELETE TASK ====================
  Future<void> _onDeleteTask(
      DeleteTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await _firestoreService.deleteTask(event.taskId);

      // Stream will update automatically
    } catch (e) {
      emit(TaskError('Failed to delete task: ${e.toString()}'));
    }
  }

  // ==================== DELETE COMPLETED TASKS ====================
  Future<void> _onDeleteCompletedTasks(
      DeleteCompletedTasksEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await _firestoreService.deleteCompletedTasks();

      // Stream will update automatically
    } catch (e) {
      emit(TaskError('Failed to delete completed tasks: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}