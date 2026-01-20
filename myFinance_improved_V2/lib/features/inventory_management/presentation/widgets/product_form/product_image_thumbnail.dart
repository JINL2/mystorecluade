import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Thumbnail widget for product image upload
/// Used in both AddProductPage and EditProductPage
/// Supports up to 3 images with add/remove functionality
class ProductImageThumbnail extends StatelessWidget {
  const ProductImageThumbnail({
    super.key,
    required this.onTap,
    this.existingImageUrls = const [],
    this.selectedImages = const [],
    this.onRemoveExistingImage,
    this.onRemoveSelectedImage,
    this.maxImages = 3,
  });

  final VoidCallback onTap;
  final List<String> existingImageUrls;
  final List<XFile> selectedImages;
  final void Function(int index)? onRemoveExistingImage;
  final void Function(int index)? onRemoveSelectedImage;
  final int maxImages;

  int get _totalImageCount => existingImageUrls.length + selectedImages.length;
  bool get _canAddMore => _totalImageCount < maxImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TossSpacing.space4,
        bottom: TossSpacing.marginLG,
        left: TossSpacing.space4,
        right: TossSpacing.space4,
      ),
      child: SizedBox(
        height: _thumbnailSize + 20, // Extra space for remove button
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Existing images from URLs
            ...existingImageUrls.asMap().entries.map((entry) {
              return _buildImageItem(
                child: _buildNetworkImage(entry.value),
                onRemove: onRemoveExistingImage != null
                    ? () => onRemoveExistingImage!(entry.key)
                    : null,
              );
            }),
            // Newly selected images
            ...selectedImages.asMap().entries.map((entry) {
              return _buildImageItem(
                child: _buildFileImage(entry.value),
                onRemove: onRemoveSelectedImage != null
                    ? () => onRemoveSelectedImage!(entry.key)
                    : null,
              );
            }),
            // Add image button (if can add more)
            if (_canAddMore) _buildAddButton(),
          ],
        ),
      ),
    );
  }

  static const double _thumbnailSize = 88.0;

  Widget _buildImageItem({
    required Widget child,
    VoidCallback? onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: TossSpacing.space2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _thumbnailSize,
            height: _thumbnailSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: TossColors.gray200,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg - 1),
              child: child,
            ),
          ),
          // Remove button
          if (onRemove != null)
            Positioned(
              top: -8,
              right: -8,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: TossColors.gray600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: TossColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _thumbnailSize,
        height: _thumbnailSize,
        decoration: BoxDecoration(
          border: Border.all(
            color: TossColors.gray300,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              size: TossDimensions.transactionIconSize,
              color: TossColors.gray500,
            ),
            const SizedBox(height: TossSpacing.badgePaddingHorizontalXS),
            Text(
              'Add Image',
              style: TossTextStyles.caption.copyWith(
                fontWeight: TossFontWeight.medium,
                color: TossColors.gray500,
              ),
            ),
            Text(
              '$_totalImageCount/$maxImages',
              style: TossTextStyles.caption.copyWith(
                fontSize: 10,
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: _thumbnailSize,
      height: _thumbnailSize,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: TossSpacing.iconXL,
          color: TossColors.gray400,
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: TossColors.gray400,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileImage(XFile file) {
    return Image.file(
      File(file.path),
      fit: BoxFit.cover,
      width: _thumbnailSize,
      height: _thumbnailSize,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: TossSpacing.iconXL,
          color: TossColors.gray400,
        ),
      ),
    );
  }
}
