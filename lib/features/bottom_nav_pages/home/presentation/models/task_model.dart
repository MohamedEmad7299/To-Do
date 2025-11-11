import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String userId;
  final String name;
  final String description;
  final String tag;
  final int priority;
  final DateTime dateTime;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt; // NEW: Track when task was completed

  TaskModel({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.tag,
    required this.priority,
    required this.dateTime,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt, // NEW
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'tag': tag,
      'priority': priority,
      'dateTime': Timestamp.fromDate(dateTime),
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null, // NEW
    };
  }

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      tag: data['tag'] ?? '',
      priority: data['priority'] ?? 1,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null, // NEW
    );
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? tag,
    int? priority,
    DateTime? dateTime,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    bool clearCompletedAt = false, // Flag to explicitly clear completedAt
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      priority: priority ?? this.priority,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  // NEW: Check if task should be auto-deleted (completed more than 24 hours ago)
  bool shouldAutoDelete() {
    if (!isCompleted || completedAt == null) return false;

    final hoursSinceCompletion = DateTime.now().difference(completedAt!).inHours;
    return hoursSinceCompletion >= 24;
  }
}