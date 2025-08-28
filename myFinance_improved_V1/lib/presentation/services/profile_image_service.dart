import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/themes/toss_colors.dart';
import '../providers/user_profile_provider.dart';

class ProfileImageService {
  static final _supabase = Supabase.instance.client;
  
  /// Pick an image from camera or gallery with proper permission handling
  static Future<File?> pickImage(ImageSource source, BuildContext context) async {
    try {
      // Request appropriate permission
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        // For iOS 14+, we need photos permission
        if (Platform.isIOS) {
          status = await Permission.photos.request();
        } else {
          // Android uses storage permission
          status = await Permission.storage.request();
        }
      }

      if (status.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permission denied. Please enable in settings.'),
              backgroundColor: TossColors.error,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return null;
      }

      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permission permanently denied. Please enable in settings.'),
              backgroundColor: TossColors.error,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return null;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
      return null;
    }
  }
  
  /// Upload profile image to Supabase storage
  static Future<String?> uploadProfileImage(File imageFile, WidgetRef ref) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Upload image to Supabase Storage
      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'avatars/$fileName';

      final uploadResponse = await _supabase.storage
          .from('user-profiles')
          .upload(
            storagePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      if (uploadResponse.isEmpty) {
        throw Exception('Failed to upload image');
      }

      // Get public URL
      final publicUrl = _supabase.storage
          .from('user-profiles')
          .getPublicUrl(storagePath);

      // Update user profile with new avatar URL
      await ref.read(userProfileServiceProvider.notifier).updateProfile(
        profileImage: publicUrl,
      );

      // Refresh user profile
      ref.invalidate(currentUserProfileProvider);
      
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }
  
  /// Remove profile image
  static Future<void> removeProfileImage(WidgetRef ref) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Update user profile to remove avatar URL
      await ref.read(userProfileServiceProvider.notifier).updateProfile(
        profileImage: null,
      );

      // Refresh user profile
      ref.invalidate(currentUserProfileProvider);
    } catch (e) {
      throw Exception('Failed to remove profile picture: $e');
    }
  }
}