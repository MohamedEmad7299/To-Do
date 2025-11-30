
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<String> uploadProfileImage(File imageFile) async {
    try {

      if (currentUserId == null) {
        throw 'User not logged in';
      }

      print('StorageService: Saving image for user $currentUserId');

      final Directory appDocDir = await getApplicationDocumentsDirectory();


      final Directory profileImagesDir = Directory('${appDocDir.path}/profile_images');
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // Create a file name based on user ID
      final String fileName = 'profile_$currentUserId.jpg';
      final String localPath = '${profileImagesDir.path}/$fileName';

      // Copy the image file to the local directory
      final File localFile = await imageFile.copy(localPath);

      print('StorageService: Image saved to: $localPath');

      // Save the path in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_$currentUserId', localFile.path);

      print('StorageService: Path saved to SharedPreferences');

      return localFile.path;
    } catch (e) {
      print('StorageService: Error saving image: $e');
      throw 'Failed to save image: $e';
    }
  }

  /// Delete user's profile image from local storage
  Future<void> deleteProfileImage() async {
    try {
      if (currentUserId == null) {
        throw 'User not logged in';
      }

      // Get the saved path from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final String? imagePath = prefs.getString('profile_image_$currentUserId');

      if (imagePath != null) {
        final File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      // Remove the path from shared preferences
      await prefs.remove('profile_image_$currentUserId');
    } catch (e) {
      throw 'Failed to delete image: $e';
    }
  }

  /// Get profile image path for current user
  Future<String?> getProfileImagePath() async {
    try {
      if (currentUserId == null) {
        print('StorageService: No current user');
        return null;
      }

      print('StorageService: Getting image path for user $currentUserId');

      final prefs = await SharedPreferences.getInstance();
      final String? imagePath = prefs.getString('profile_image_$currentUserId');

      print('StorageService: Path from SharedPreferences: $imagePath');

      if (imagePath != null) {
        final File imageFile = File(imagePath);
        final exists = await imageFile.exists();
        print('StorageService: File exists: $exists');

        if (exists) {
          return imagePath;
        } else {
          // File doesn't exist, remove the reference
          print('StorageService: File not found, removing reference');
          await prefs.remove('profile_image_$currentUserId');
        }
      }

      return null;
    } catch (e) {
      print('StorageService: Error getting image path: $e');
      return null;
    }
  }
}
