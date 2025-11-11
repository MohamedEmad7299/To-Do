import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String? id;
  final String userId;
  final String name;
  final String icon; // SVG path or IconData codePoint
  final int colorValue; // Store color as int
  final DateTime createdAt;

  CategoryModel({
    this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.colorValue,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'icon': icon,
      'colorValue': colorValue,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      colorValue: data['colorValue'] ?? 0xFF8687E7,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  CategoryModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    int? colorValue,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}