import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Attachments Section Widget for transaction confirmation
class AttachmentsSection extends StatelessWidget {
  final List<XFile> attachments;
  final ValueChanged<int> onRemove;

  const AttachmentsSection({
    super.key,
    required this.attachments,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attachments',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${attachments.length}/3',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: attachments.length,
            separatorBuilder: (_, __) => const SizedBox(width: TossSpacing.space2),
            itemBuilder: (context, index) => _AttachmentThumbnail(
              file: attachments[index],
              onRemove: () => onRemove(index),
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual attachment thumbnail widget
class _AttachmentThumbnail extends StatelessWidget {
  final XFile file;
  final VoidCallback onRemove;

  const _AttachmentThumbnail({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
            child: Image.file(
              File(file.path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: TossColors.gray100,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: TossColors.gray400,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space1),
              decoration: const BoxDecoration(
                color: TossColors.gray600,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: TossColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
