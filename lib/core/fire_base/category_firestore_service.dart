
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/bottom_nav_pages/home/presentation/models/category.dart';

class CategoryFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _categoriesCollection =>
      _firestore.collection('categories');

  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== CREATE ====================
  Future<String> addCategory(CategoryModel category) async {
    try {
      if (currentUserId == null) throw Exception('User not logged in');

      DocumentReference docRef =
      await _categoriesCollection.add(category.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // ==================== READ ====================
  Stream<List<CategoryModel>> getUserCategories() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _categoriesCollection
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<List<CategoryModel>> getUserCategoriesFuture() async {
    if (currentUserId == null) {
      return [];
    }

    QuerySnapshot snapshot = await _categoriesCollection
        .where('userId', isEqualTo: currentUserId)
        .get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  // ==================== UPDATE ====================
  Future<void> updateCategory(
      String categoryId, Map<String, dynamic> updates) async {
    try {
      await _categoriesCollection.doc(categoryId).update(updates);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // ==================== DELETE ====================
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoriesCollection.doc(categoryId).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // ==================== INITIALIZE DEFAULT CATEGORIES ====================
  Future<void> initializeDefaultCategories() async {
    try {
      if (currentUserId == null) throw Exception('User not logged in');

      // Check if user already has categories
      final existingCategories = await getUserCategoriesFuture();
      if (existingCategories.isNotEmpty) return;

      // Default categories
      final defaultCategories = [
        CategoryModel(
          userId: currentUserId!,
          name: 'Grocery',
          icon: 'bread',
          colorValue: 0xFFCCFF80,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Work',
          icon: 'briefcase',
          colorValue: 0xFFFF9680,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Sport',
          icon: 'sport',
          colorValue: 0xFF80FFFF,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Design',
          icon: 'xo',
          colorValue: 0xFF80FFD9,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'University',
          icon: 'mortarboard',
          colorValue: 0xFF809CFF,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Social',
          icon: 'megaphone',
          colorValue: 0xFFFF80EB,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Music',
          icon: 'music',
          colorValue: 0xFFFC80FF,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Health',
          icon: 'heartbeat',
          colorValue: 0xFF80FFA3,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Movie',
          icon: 'camera_v',
          colorValue: 0xFF80D1FF,
        ),
        CategoryModel(
          userId: currentUserId!,
          name: 'Home',
          icon: 'home_tag',
          colorValue: 0xFFFFCC80,
        ),
      ];

      WriteBatch batch = _firestore.batch();
      for (var category in defaultCategories) {
        DocumentReference docRef = _categoriesCollection.doc();
        batch.set(docRef, category.toMap());
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to initialize categories: $e');
    }
  }
}