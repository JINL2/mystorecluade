import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/themes/toss_colors.dart';
import '../providers/user_profile_provider.dart';
import '../providers/app_state_provider.dart';

class ProfileImageService {
  static final _supabase = Supabase.instance.client;
  
  /// Profile Image Optimization Strategy:
  /// - Display sizes in app: 40x40 to 112x112 pixels (radius 20-56)
  /// - Initial capture: 600x600 @ 70% quality
  /// - Final compression: 256x256 @ 30-60% quality
  /// - Target file size: <100KB for fast loading
  /// - Expected savings: 80-95% reduction from original photos
  
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
        maxWidth: 600,  // Reduced from 1080 - still 2.5x larger than display size
        maxHeight: 600,  // Reduced from 1080 - optimized for profile images
        imageQuality: 70,  // Reduced from 85 - still good quality for small display
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
  
  /// Smart image compression for profile images
  /// Aggressively optimizes for small display sizes (max 112x112 pixels in app)
  static Future<File> _compressProfileImage(File originalFile) async {
    try {
      // Get original file size for smart compression logic
      final bytes = await originalFile.readAsBytes();
      final originalSize = bytes.length;
      
      // Aggressive compression optimized for small profile display (radius 56 = 112px)
      // Profile images are shown at max 112x112, so we target 256x256 for retina displays
      int quality = 50; // Aggressive default - still looks good at small sizes
      int targetWidth = 256;  // 2.3x the display size for retina screens
      int targetHeight = 256;
      
      if (originalSize > 5 * 1024 * 1024) {        // > 5MB - ultra aggressive
        quality = 40;  // Very aggressive for large files
      } else if (originalSize > 2 * 1024 * 1024) { // > 2MB - aggressive
        quality = 45;
      } else if (originalSize > 1 * 1024 * 1024) { // > 1MB - moderate
        quality = 50;
      } else if (originalSize < 200 * 1024) {      // < 200KB - already small
        quality = 60;  // Slightly better quality for tiny images
        targetWidth = 300;  // Slightly larger for already small images
        targetHeight = 300;
      }
      
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalFile.absolute.path,
        minWidth: targetWidth,
        minHeight: targetHeight,
        quality: quality,
        format: CompressFormat.jpeg, // JPEG is optimal for photos
      );
      
      if (compressedBytes == null || compressedBytes.isEmpty) {
        throw Exception('Image compression failed - unable to process image');
      }
      
      // Create compressed file with distinctive name
      final directory = originalFile.parent;
      final originalName = originalFile.path.split('/').last.split('.').first;
      final compressedPath = '${directory.path}/${originalName}_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);
      
      // Verify compression was successful
      final compressedSize = compressedBytes.length;
      final compressionRatio = ((originalSize - compressedSize) / originalSize * 100);
      
      // Target: Keep compressed images under 100KB for fast loading
      // If still too large, compress more aggressively
      if (compressedSize > 100 * 1024 && quality > 30) {
        // File still too large, apply more aggressive compression
        final moreCompressedBytes = await FlutterImageCompress.compressWithFile(
          originalFile.absolute.path,
          minWidth: 200,  // Even smaller for large files
          minHeight: 200,
          quality: 30,  // Maximum compression
          format: CompressFormat.jpeg,
        );
        
        if (moreCompressedBytes != null && moreCompressedBytes.isNotEmpty) {
          await compressedFile.writeAsBytes(moreCompressedBytes);
          // Applied ultra compression - file was too large
        }
      }
      
      // Compression successful - saved ${compressionRatio.toStringAsFixed(1)}%
      
      return compressedFile;
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }
  
  /// Upload profile image to Supabase storage
  static Future<String?> uploadProfileImage(File imageFile, WidgetRef ref) async {
    File? compressedFile;
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Step 1: Compress the image for optimal storage and performance
      compressedFile = await _compressProfileImage(imageFile);
      
      // Step 2: Upload compressed image to Supabase Storage
      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'avatars/$fileName';
      
      // Step 2: Upload compressed image to Supabase Storage
      final uploadResponse = await _supabase.storage
          .from('profileimage')
          .upload(
            storagePath,
            compressedFile,  // Use compressed file
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      if (uploadResponse.isEmpty) {
        throw Exception('Failed to upload image to storage');
      }

      // Step 3: Get public URL for the uploaded image
      final publicUrl = _supabase.storage
          .from('profileimage')
          .getPublicUrl(storagePath);
      
      // Step 3: Update user profile in database
      await ref.read(userProfileServiceProvider.notifier).updateProfile(
        profileImage: publicUrl,
      );

      // Step 4: Update app state locally without RPC call
      await ref.read(appStateProvider.notifier).updateUserProfileLocally(
        profileImage: publicUrl,
      );
      
      // Refresh local user profile provider
      ref.invalidate(currentUserProfileProvider);
      
      // Profile image upload completed successfully
      return publicUrl;
    } catch (e) {
      // Profile image upload failed
      throw Exception('Failed to upload profile image: $e');
    } finally {
      // Step 6: Clean up temporary compressed file
      if (compressedFile != null) {
        try {
          if (await compressedFile.exists()) {
            await compressedFile.delete();
            // Temporary file cleaned up
          }
        } catch (cleanupError) {
          // Cleanup error ignored - upload was successful
        }
      }
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
      
      // Update app state locally without RPC call
      await ref.read(appStateProvider.notifier).updateUserProfileLocally(
        profileImage: '',  // Empty string to clear the image
      );
      
      // Refresh local user profile provider
      ref.invalidate(currentUserProfileProvider);
      
      // Profile image removed successfully
    } catch (e) {
      throw Exception('Failed to remove profile picture: $e');
    }
  }
}