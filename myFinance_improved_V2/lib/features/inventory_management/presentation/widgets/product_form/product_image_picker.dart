import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';

/// Widget for picking and displaying product images
class ProductImagePicker extends StatelessWidget {
  final List<XFile> selectedImages;
  final List<String> existingImageUrls;
  final VoidCallback onPickImages;
  final void Function(int index) onRemoveNewImage;
  final void Function(int index)? onRemoveExistingImage;
  final int maxImages;

  const ProductImagePicker({
    super.key,
    required this.selectedImages,
    this.existingImageUrls = const [],
    required this.onPickImages,
    required this.onRemoveNewImage,
    this.onRemoveExistingImage,
    this.maxImages = 3,
  });

  int get _totalImageCount => existingImageUrls.length + selectedImages.length;
  bool get _canAddMore => _totalImageCount < maxImages;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImages,
      child: Container(
        width: double.infinity,
        height: _totalImageCount == 0 ? 120 : 180,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TossColors.gray300),
        ),
        child: _totalImageCount == 0
            ? _buildEmptyState()
            : _buildImageList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.camera_alt_outlined,
          size: 40,
          color: TossColors.gray400,
        ),
        const SizedBox(height: 8),
        Text(
          'Add Photo',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildImageList() {
    // Only show add button if we can add more images
    final itemCount = _canAddMore ? _totalImageCount + 1 : _totalImageCount;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Add more photos button at the end (only if under max)
        if (_canAddMore && index == _totalImageCount) {
          return _buildAddMoreButton();
        }

        // Existing images first
        if (index < existingImageUrls.length) {
          return _buildExistingImage(index);
        }

        // Then new images
        final newImageIndex = index - existingImageUrls.length;
        return _buildNewImage(newImageIndex);
      },
    );
  }

  Widget _buildAddMoreButton() {
    return GestureDetector(
      onTap: onPickImages,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: TossColors.gray200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          color: TossColors.gray500,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildExistingImage(int index) {
    return Stack(
      children: [
        Container(
          width: 140,
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(existingImageUrls[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (onRemoveExistingImage != null)
          Positioned(
            top: 4,
            right: 12,
            child: GestureDetector(
              onTap: () => onRemoveExistingImage!(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNewImage(int index) {
    return Stack(
      children: [
        Container(
          width: 140,
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(selectedImages[index].path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: GestureDetector(
            onTap: () => onRemoveNewImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Static helper method to pick images with size validation
  static Future<List<XFile>> pickImagesWithValidation(
    BuildContext context, {
    int maxSizeBytes = 10 * 1024 * 1024, // 10MB default
    int imageQuality = 80,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: imageQuality,
      );

      if (images.isEmpty) return [];

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
}
