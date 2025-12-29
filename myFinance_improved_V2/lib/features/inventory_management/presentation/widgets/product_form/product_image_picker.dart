import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';

/// Image source options for the picker
enum ImageSourceOption {
  gallery,
  camera,
}

/// Utility class for picking and validating product images
///
/// Provides static helper methods for image picking with compression
/// and size validation. Used by [ImageUploadSheet].
class ProductImagePicker {
  ProductImagePicker._();

  /// Static helper method to pick images from gallery with size validation
  /// Applies double compression (80% → 80%) for optimal file size
  static Future<List<XFile>> pickFromGalleryWithValidation(
    BuildContext context, {
    int maxSizeBytes = 10 * 1024 * 1024, // 10MB default
    int imageQuality = 80,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      // First compression by image_picker
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: imageQuality,
      );

      if (images.isEmpty) return [];

      // Second compression using flutter_image_compress
      final List<XFile> doubleCompressedImages = await _applySecondCompression(
        images,
        imageQuality,
      );

      return _validateImageSizes(context, doubleCompressedImages, maxSizeBytes);
    } catch (e) {
      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Image Selection Failed',
            message: 'Failed to pick images: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
      return [];
    }
  }

  /// Static helper method to take photo from camera with size validation
  /// Applies double compression (80% → 80%) for optimal file size
  static Future<List<XFile>> takePhotoWithValidation(
    BuildContext context, {
    int maxSizeBytes = 10 * 1024 * 1024, // 10MB default
    int imageQuality = 80,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      // First compression by image_picker
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: imageQuality,
      );

      if (image == null) return [];

      // Second compression using flutter_image_compress
      final List<XFile> doubleCompressedImages = await _applySecondCompression(
        [image],
        imageQuality,
      );

      return _validateImageSizes(context, doubleCompressedImages, maxSizeBytes);
    } catch (e) {
      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Camera Failed',
            message: 'Failed to take photo: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
      return [];
    }
  }

  /// Apply second compression to images using flutter_image_compress
  static Future<List<XFile>> _applySecondCompression(
    List<XFile> images,
    int quality,
  ) async {
    final List<XFile> compressedImages = [];
    final tempDir = await getTemporaryDirectory();

    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: quality,
        minWidth: 1920,
        minHeight: 1920,
      );

      if (compressedFile != null) {
        compressedImages.add(compressedFile);
      } else {
        // If compression fails, use original image
        compressedImages.add(image);
      }
    }

    return compressedImages;
  }

  /// Validate image sizes and show error for oversized images
  static Future<List<XFile>> _validateImageSizes(
    BuildContext context,
    List<XFile> images,
    int maxSizeBytes,
  ) async {
    final List<XFile> validImages = [];
    final List<String> oversizedFiles = [];

    for (final image in images) {
      final fileSize = await image.length();
      if (fileSize > maxSizeBytes) {
        oversizedFiles.add(image.name);
      } else {
        validImages.add(image);
      }
    }

    if (oversizedFiles.isNotEmpty && context.mounted) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Image Too Large',
          message:
              'The following images exceed ${maxSizeBytes ~/ (1024 * 1024)}MB and were not added:\n${oversizedFiles.join(', ')}',
          primaryButtonText: 'OK',
        ),
      );
    }

    return validImages;
  }
}
