// lib/features/transaction_history/presentation/widgets/detail_sheet/transaction_attachments_section.dart
//
// Transaction attachments section extracted from transaction_detail_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/storage_url_helper.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/ai/index.dart';
import '../../../../../shared/widgets/index.dart';
import '../../../domain/entities/transaction.dart';
import '../attachment_fullscreen_viewer.dart';

/// Attachments section for transaction detail
class TransactionAttachmentsSection extends StatelessWidget {
  final List<TransactionAttachment> attachments;

  const TransactionAttachmentsSection({
    super.key,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final imageAttachments = attachments.where((a) => a.isImage).toList();
    final otherAttachments = attachments.where((a) => !a.isImage).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _AttachmentsHeader(count: attachments.length),
        const SizedBox(height: TossSpacing.space3),

        // Image Gallery
        if (imageAttachments.isNotEmpty)
          _ImageGallery(images: imageAttachments),

        // Other files (PDF, etc.)
        if (otherAttachments.isNotEmpty) ...[
          if (imageAttachments.isNotEmpty)
            const SizedBox(height: TossSpacing.space3),
          ...otherAttachments.map((attachment) => _FileItem(attachment: attachment)),
        ],

        // Per-image AI Analysis Details
        if (attachments.any((a) => a.hasOcr)) ...[
          const SizedBox(height: TossSpacing.space4),
          AiAnalysisDetailsBox(
            items: attachments
                .where((a) => a.hasOcr)
                .map((a) => a.ocrText!)
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Attachments header
class _AttachmentsHeader extends StatelessWidget {
  final int count;

  const _AttachmentsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.attach_file,
          size: 16,
          color: TossColors.gray500,
        ),
        const SizedBox(width: TossSpacing.space1),
        Text(
          'Attachments',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: TossColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.full),
          ),
          child: Text(
            '$count',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

/// Image gallery with first image large, rest small
class _ImageGallery extends StatelessWidget {
  final List<TransactionAttachment> images;

  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    final firstImage = images.first;
    final remainingImages =
        images.length > 1 ? images.sublist(1) : <TransactionAttachment>[];

    return Column(
      children: [
        // First image - large (contain to show full image)
        GestureDetector(
          onTap: () => _openFullscreenViewer(context, images, 0),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
              child: _NetworkImage(
                url: firstImage.fileUrl ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Remaining images - small thumbnails
        if (remainingImages.isNotEmpty) ...[
          const SizedBox(height: TossSpacing.space2),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: remainingImages.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: TossSpacing.space2),
              itemBuilder: (context, index) {
                final image = remainingImages[index];
                final actualIndex = index + 1;

                return GestureDetector(
                  onTap: () =>
                      _openFullscreenViewer(context, images, actualIndex),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(TossBorderRadius.sm - 1),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _NetworkImage(
                            url: image.fileUrl ?? '',
                            fit: BoxFit.cover,
                          ),
                          // Show count overlay on last thumbnail if more than 4 images
                          if (index == 2 && remainingImages.length > 3)
                            Container(
                              color: TossColors.black54,
                              child: Center(
                                child: Text(
                                  '+${remainingImages.length - 3}',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _openFullscreenViewer(
    BuildContext context,
    List<TransactionAttachment> images,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AttachmentFullscreenViewer(
          attachments: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

/// Network image with loading and error states
class _NetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const _NetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        color: TossColors.gray100,
        child: const Center(
          child: Icon(Icons.image_not_supported, color: TossColors.gray400),
        ),
      );
    }

    final authenticatedUrl = StorageUrlHelper.toAuthenticatedUrl(url);
    final authHeaders = StorageUrlHelper.getAuthHeaders();

    return CachedNetworkImage(
      imageUrl: authenticatedUrl,
      httpHeaders: authHeaders,
      fit: fit,
      placeholder: (context, url) => Container(
        color: TossColors.gray100,
        child: const Center(
          child: TossLoadingView.inline(size: 24, color: TossColors.gray400),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: TossColors.gray100,
        child: const Center(
          child: Icon(Icons.broken_image, color: TossColors.gray400),
        ),
      ),
    );
  }
}

/// File item for non-image attachments
class _FileItem extends StatelessWidget {
  final TransactionAttachment attachment;

  const _FileItem({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: attachment.isPdf
                  ? TossColors.error.withValues(alpha: 0.1)
                  : TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Icon(
              attachment.isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
              size: 20,
              color: attachment.isPdf ? TossColors.error : TossColors.gray500,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  attachment.fileExtension.toUpperCase(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new,
            size: 16,
            color: TossColors.gray400,
          ),
        ],
      ),
    );
  }
}
