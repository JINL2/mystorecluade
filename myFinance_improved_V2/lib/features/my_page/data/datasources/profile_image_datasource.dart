import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImageDataSource {
  final _supabase = Supabase.instance.client;

  /// Smart image compression for profile images
  /// Aggressively optimizes for small display sizes (max 112x112 pixels in app)
  Future<File> _compressProfileImage(File originalFile) async {
    try {
      // Get original file size for smart compression logic
      final bytes = await originalFile.readAsBytes();
      final originalSize = bytes.length;

      // Aggressive compression optimized for small profile display (radius 56 = 112px)
      // Profile images are shown at max 112x112, so we target 256x256 for retina displays
      int quality = 50; // Aggressive default - still looks good at small sizes
      int targetWidth = 256; // 2.3x the display size for retina screens
      int targetHeight = 256;

      if (originalSize > 5 * 1024 * 1024) {
        // > 5MB - ultra aggressive
        quality = 40; // Very aggressive for large files
      } else if (originalSize > 2 * 1024 * 1024) {
        // > 2MB - aggressive
        quality = 45;
      } else if (originalSize > 1 * 1024 * 1024) {
        // > 1MB - moderate
        quality = 50;
      } else if (originalSize < 200 * 1024) {
        // < 200KB - already small
        quality = 60; // Slightly better quality for tiny images
        targetWidth = 300; // Slightly larger for already small images
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
      final compressedPath =
          '${directory.path}/${originalName}_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      // Verify compression was successful
      final compressedSize = compressedBytes.length;

      // Target: Keep compressed images under 100KB for fast loading
      // If still too large, compress more aggressively
      if (compressedSize > 100 * 1024 && quality > 30) {
        // File still too large, apply more aggressive compression
        final moreCompressedBytes = await FlutterImageCompress.compressWithFile(
          originalFile.absolute.path,
          minWidth: 200, // Even smaller for large files
          minHeight: 200,
          quality: 30, // Maximum compression
          format: CompressFormat.jpeg,
        );

        if (moreCompressedBytes != null && moreCompressedBytes.isNotEmpty) {
          await compressedFile.writeAsBytes(moreCompressedBytes);
        }
      }

      return compressedFile;
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }

  /// Upload profile image to Supabase storage
  Future<String> uploadProfileImage(String userId, String filePath) async {
    File? compressedFile;
    try {
      final imageFile = File(filePath);

      // Step 1: Compress the image for optimal storage and performance
      compressedFile = await _compressProfileImage(imageFile);

      // Step 2: Upload compressed image to Supabase Storage
      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'avatars/$fileName';

      await _supabase.storage.from('profileimage').upload(
            storagePath,
            compressedFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Step 3: Get public URL for the uploaded image
      final publicUrl = _supabase.storage.from('profileimage').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    } finally {
      // Clean up temporary compressed file
      if (compressedFile != null) {
        try {
          if (await compressedFile.exists()) {
            await compressedFile.delete();
          }
        } catch (cleanupError) {
          // Cleanup error ignored - upload was successful
        }
      }
    }
  }

  /// Remove profile image (just returns success, actual deletion can be handled by storage policies)
  Future<void> removeProfileImage(String userId) async {
    // No actual file deletion needed - just update database to null
    // Storage policies can handle cleanup
    return;
  }
}
