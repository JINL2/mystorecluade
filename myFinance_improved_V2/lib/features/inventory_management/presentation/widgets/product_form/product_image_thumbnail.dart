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
class ProductImageThumbnail extends StatelessWidget {
  const ProductImageThumbnail({
    super.key,
    required this.onTap,
    this.existingImageUrls = const [],
    this.selectedImages = const [],
  });

  final VoidCallback onTap;
  final List<String> existingImageUrls;
  final List<XFile> selectedImages;

  bool get _hasImages =>
      existingImageUrls.isNotEmpty || selectedImages.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TossSpacing.space4,
        bottom: TossSpacing.marginLG,
      ),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: _thumbnailSize,
            height: _thumbnailSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: TossColors.gray200,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: !_hasImages ? _buildPlaceholder() : _buildImage(),
          ),
        ),
      ),
    );
  }

  static const double _thumbnailSize = 88.0;

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.camera_alt_outlined,
          size: TossDimensions.transactionIconSize,
          color: TossColors.gray500,
        ),
        const SizedBox(height: TossSpacing.badgePaddingHorizontalXS),
        Text(
          'Add Photo',
          style: TossTextStyles.caption.copyWith(
            fontWeight: TossFontWeight.medium,
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(TossBorderRadius.lg - 1),
      child: existingImageUrls.isNotEmpty
          ? Image.network(
              existingImageUrls.first,
              fit: BoxFit.cover,
              width: _thumbnailSize,
              height: _thumbnailSize,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image,
                size: TossSpacing.iconXL,
                color: TossColors.gray400,
              ),
            )
          : Image.asset(
              selectedImages.first.path,
              fit: BoxFit.cover,
              width: _thumbnailSize,
              height: _thumbnailSize,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image,
                size: TossSpacing.iconXL,
                color: TossColors.gray400,
              ),
            ),
    );
  }
}
