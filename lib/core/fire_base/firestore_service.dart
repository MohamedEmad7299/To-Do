
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/bottom_nav_pages/home/presentation/models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== CREATE ====================
  Future<String> addTask(TaskModel task) async {
    try {
      if (currentUserId == null) throw Exception('User not logged in');

      print('Adding task for user: $currentUserId');
      DocumentReference docRef = await _tasksCollection.add(task.toMap());
      print('Task added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error in addTask: $e');
      throw Exception('Failed to add task: $e');
    }
  }

  // ==================== READ ====================
  Stream<List<TaskModel>> getUserTasks() {
    if (currentUserId == null) {
      print('No user logged in, returning empty stream');
      return Stream.value([]);
    }

    print('Setting up stream for user: $currentUserId');

    return _tasksCollection
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      print('Stream received ${snapshot.docs.length} tasks');
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<TaskModel>> getTasksByTag(String tag) {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _tasksCollection
        .where('userId', isEqualTo: currentUserId)
        .where('tag', isEqualTo: tag)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<TaskModel>> getTasksByStatus(bool isCompleted) {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _tasksCollection
        .where('userId', isEqualTo: currentUserId)
        .where('isCompleted', isEqualTo: isCompleted)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<TaskModel?> getTask(String taskId) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  // ==================== UPDATE ====================
  Future<void> updateTask(String taskId, Map<String, dynamic> updates) async {
    try {
      await _tasksCollection.doc(taskId).update(updates);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      print('Toggling task $taskId to isCompleted: $isCompleted');

      final updates = {
        'isCompleted': isCompleted,
        'completedAt': isCompleted
            ? Timestamp.fromDate(DateTime.now())
            : null, // Set completedAt when marking as complete
      };

      print('Updating task with: $updates');
      await _tasksCollection.doc(taskId).update(updates);
      print('Task update completed successfully');
    } catch (e) {
      print('Error in toggleTaskCompletion: $e');
      throw Exception('Failed to toggle task: $e');
    }
  }

  // ==================== DELETE ====================
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> deleteCompletedTasks() async {
    try {
      if (currentUserId == null) throw Exception('User not logged in');

      QuerySnapshot snapshot = await _tasksCollection
          .where('userId', isEqualTo: currentUserId)
          .where('isCompleted', isEqualTo: true)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete completed tasks: $e');
    }
  }

  // ==================== AUTO-DELETE OLD COMPLETED TASKS ====================
  Future<int> deleteOldCompletedTasks() async {
    try {
      if (currentUserId == null) {
        print('No user logged in');
        return 0;
      }

      // Calculate 24 hours ago
      final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));

      print('Checking for tasks completed before: $twentyFourHoursAgo');

      // Get all completed tasks
      QuerySnapshot snapshot = await _tasksCollection
          .where('userId', isEqualTo: currentUserId)
          .where('isCompleted', isEqualTo: true)
          .get();

      // Filter tasks completed more than 24 hours ago
      final tasksToDelete = <DocumentSnapshot>[];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final completedAt = data['completedAt'] as Timestamp?;

        if (completedAt != null) {
          final completedDate = completedAt.toDate();
          if (completedDate.isBefore(twentyFourHoursAgo)) {
            tasksToDelete.add(doc);
          }
        }
      }

      if (tasksToDelete.isEmpty) {
        print('No old completed tasks to delete');
        return 0;
      }

      print('Deleting ${tasksToDelete.length} old completed tasks');

      // Delete in batch
      WriteBatch batch = _firestore.batch();
      for (var doc in tasksToDelete) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      print('Successfully deleted ${tasksToDelete.length} old tasks');
      return tasksToDelete.length;
    } catch (e) {
      print('Error deleting old completed tasks: $e');
      throw Exception('Failed to delete old completed tasks: $e');
    }
  }
}