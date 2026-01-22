import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';
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
    return SelectionBottomSheetCommon.show(
      context: context,
      title: 'Upload Image',
      maxHeightRatio: 0.4,
      children: [
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space2),
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
            child: Text(
              'Upload Image',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: TossFontWeight.semibold,
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
          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space2),
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
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: TossDimensions.dividerThicknessThin,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: TossDimensions.minTouchTargetSmall,
              height: TossDimensions.minTouchTargetSmall,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                size: TossSpacing.iconSM,
                color: TossColors.gray600,
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Title
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: TossFontWeight.regular,
                ),
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconMD,
            ),
          ],
        ),
      ),
    );
  }
}
