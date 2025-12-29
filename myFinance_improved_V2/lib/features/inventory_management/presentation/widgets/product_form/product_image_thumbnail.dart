import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/themes/toss_colors.dart';
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
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              border: Border.all(
                color: TossColors.gray200,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: !_hasImages ? _buildPlaceholder() : _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.camera_alt_outlined,
          size: 26,
          color: TossColors.gray500,
        ),
        const SizedBox(height: 6),
        Text(
          'Add Photo',
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: existingImageUrls.isNotEmpty
          ? Image.network(
              existingImageUrls.first,
              fit: BoxFit.cover,
              width: 88,
              height: 88,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image,
                size: 40,
                color: TossColors.gray400,
              ),
            )
          : Image.asset(
              selectedImages.first.path,
              fit: BoxFit.cover,
              width: 88,
              height: 88,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image,
                size: 40,
                color: TossColors.gray400,
              ),
            ),
    );
  }
}
