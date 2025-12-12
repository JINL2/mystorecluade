import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';

/// Image source options for the picker
enum ImageSourceOption {
  gallery,
  camera,
}

/// Widget for picking and displaying product images
class ProductImagePicker extends StatelessWidget {
  final List<XFile> selectedImages;
  final List<String> existingImageUrls;
  final void Function(ImageSourceOption source) onImageSourceSelected;
  final void Function(int index) onRemoveNewImage;
  final void Function(int index)? onRemoveExistingImage;
  final int maxImages;

  const ProductImagePicker({
    super.key,
    required this.selectedImages,
    this.existingImageUrls = const [],
    required this.onImageSourceSelected,
    required this.onRemoveNewImage,
    this.onRemoveExistingImage,
    this.maxImages = 3,
  });

  int get _totalImageCount => existingImageUrls.length + selectedImages.length;
  bool get _canAddMore => _totalImageCount < maxImages;

  void _showUploadImageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => _UploadImageBottomSheet(
        onOptionSelected: (option) {
          Navigator.pop(context);
          onImageSourceSelected(option);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUploadImageSheet(context),
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
          return _buildAddMoreButton(context);
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

  Widget _buildAddMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUploadImageSheet(context),
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

  /// Static helper method to pick images from gallery with size validation
  static Future<List<XFile>> pickFromGalleryWithValidation(
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

      return _validateImageSizes(context, images, maxSizeBytes);
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
  static Future<List<XFile>> takePhotoWithValidation(
    BuildContext context, {
    int maxSizeBytes = 10 * 1024 * 1024, // 10MB default
    int imageQuality = 80,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: imageQuality,
      );

      if (image == null) return [];

      return _validateImageSizes(context, [image], maxSizeBytes);
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

/// Upload Image Bottom Sheet with "Choose from Library" and "Take Photo" options
class _UploadImageBottomSheet extends StatelessWidget {
  final void Function(ImageSourceOption option) onOptionSelected;

  const _UploadImageBottomSheet({
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Upload Image',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Options
          _buildOptionItem(
            context: context,
            icon: Icons.photo_library_outlined,
            title: 'Choose from Library',
            onTap: () {
              HapticFeedback.selectionClick();
              onOptionSelected(ImageSourceOption.gallery);
            },
          ),
          _buildOptionItem(
            context: context,
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            onTap: () {
              HapticFeedback.selectionClick();
              onOptionSelected(ImageSourceOption.camera);
            },
            isLast: true,
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: TossColors.gray600,
              ),
            ),

            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
