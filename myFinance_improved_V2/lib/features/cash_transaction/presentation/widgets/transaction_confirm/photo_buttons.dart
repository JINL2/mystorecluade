import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Photo Buttons Widget for transaction confirmation
class PhotoButtons extends StatelessWidget {
  final bool canAddMore;
  final bool isPickingImage;
  final VoidCallback onPickGallery;
  final VoidCallback onTakePhoto;

  const PhotoButtons({
    super.key,
    required this.canAddMore,
    required this.isPickingImage,
    required this.onPickGallery,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PhotoButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            onTap: canAddMore && !isPickingImage ? onPickGallery : null,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: _PhotoButton(
            icon: Icons.camera_alt_outlined,
            label: 'Camera',
            onTap: canAddMore && !isPickingImage ? onTakePhoto : null,
          ),
        ),
      ],
    );
  }
}

/// Individual photo button widget
class _PhotoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _PhotoButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? TossColors.gray50 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isEnabled ? TossColors.gray600 : TossColors.gray400,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: isEnabled ? TossColors.gray700 : TossColors.gray400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
