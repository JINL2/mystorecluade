import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'product_image_picker.dart';

/// A bottom sheet for selecting image upload options
///
/// Provides options to choose from gallery or take a photo.
class ImageUploadSheet extends StatelessWidget {
  final void Function(List<XFile> images) onImagesSelected;

  const ImageUploadSheet({
    super.key,
    required this.onImagesSelected,
  });

  /// Shows the image upload sheet as a modal bottom sheet
  static Future<void> show({
    required BuildContext context,
    required void Function(List<XFile> images) onImagesSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ImageUploadSheet(
        onImagesSelected: onImagesSelected,
      ),
    );
  }

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
          _ImageOptionItem(
            icon: Icons.photo_library_outlined,
            title: 'Choose from Library',
            onTap: () async {
              Navigator.pop(context);
              final images =
                  await ProductImagePicker.pickFromGalleryWithValidation(
                context,
              );
              if (images.isNotEmpty) {
                onImagesSelected(images);
              }
            },
          ),
          _ImageOptionItem(
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            onTap: () async {
              Navigator.pop(context);
              final images = await ProductImagePicker.takePhotoWithValidation(
                context,
              );
              if (images.isNotEmpty) {
                onImagesSelected(images);
              }
            },
            isLast: true,
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

/// A single option item in the image upload sheet
class _ImageOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLast;

  const _ImageOptionItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
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
