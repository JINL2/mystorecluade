import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/storage_url_helper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../journal_input/domain/entities/journal_attachment.dart';
import '../../domain/entities/invoice_detail.dart';
import '../providers/invoice_attachment_provider.dart';

/// Section widget for displaying and adding invoice attachments
class InvoiceAttachmentSection extends ConsumerStatefulWidget {
  /// Existing attachments from database
  final List<InvoiceAttachment> existingAttachments;

  const InvoiceAttachmentSection({
    super.key,
    this.existingAttachments = const [],
  });

  @override
  ConsumerState<InvoiceAttachmentSection> createState() =>
      _InvoiceAttachmentSectionState();
}

class _InvoiceAttachmentSectionState
    extends ConsumerState<InvoiceAttachmentSection> {
  final ImagePicker _picker = ImagePicker();

  /// Pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    final notifier = ref.read(invoiceAttachmentProvider.notifier);
    final state = ref.read(invoiceAttachmentProvider);

    if (state.isPickingImages || !state.canAddMoreAttachments) return;

    notifier.setPickingImages(true);

    try {
      final availableSlots =
          InvoiceAttachmentState.maxAttachments - state.attachmentCount;

      final images = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
        limit: availableSlots,
      );

      if (images.isNotEmpty) {
        final attachments = await processPickedFiles(images);
        notifier.addAttachments(attachments);
      }
    } catch (_) {
      _showError('Failed to pick images');
    } finally {
      notifier.setPickingImages(false);
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final notifier = ref.read(invoiceAttachmentProvider.notifier);
    final state = ref.read(invoiceAttachmentProvider);

    if (state.isPickingImages || !state.canAddMoreAttachments) return;

    notifier.setPickingImages(true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (image != null) {
        final attachments = await processPickedFiles([image]);
        notifier.addAttachments(attachments);
      }
    } catch (_) {
      _showError('Failed to take photo');
    } finally {
      notifier.setPickingImages(false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeAttachment(int index) {
    ref.read(invoiceAttachmentProvider.notifier).removeAttachment(index);
  }

  /// Show source selection dialog
  void _showSourceSelectionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Add Image',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: TossColors.primary,
                  ),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select multiple images'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: TossColors.success,
                  ),
                ),
                title: const Text('Take Photo'),
                subtitle: const Text('Use camera to capture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              const SizedBox(height: TossSpacing.space2),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceAttachmentProvider);
    final pendingAttachments = state.pendingAttachments;
    final existingAttachments = widget.existingAttachments;
    final totalCount = existingAttachments.length + pendingAttachments.length;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count and add button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.attach_file,
                  size: 18,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'Attachments',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              if (totalCount > 0) ...[
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
                    '$totalCount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Add button
              if (state.canAddMoreAttachments)
                TextButton.icon(
                  onPressed:
                      state.isPickingImages ? null : _showSourceSelectionDialog,
                  icon: state.isPickingImages
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_photo_alternate_outlined, size: 18),
                  label: Text(state.isPickingImages ? 'Loading...' : 'Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                    ),
                  ),
                ),
            ],
          ),

          // Attachments grid
          if (totalCount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: existingAttachments.length + pendingAttachments.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: TossSpacing.space2),
                itemBuilder: (context, index) {
                  // Existing attachments first
                  if (index < existingAttachments.length) {
                    return _buildExistingAttachment(existingAttachments[index]);
                  }
                  // Then pending attachments
                  final pendingIndex = index - existingAttachments.length;
                  return _buildPendingAttachment(
                    pendingAttachments[pendingIndex],
                    pendingIndex,
                  );
                },
              ),
            ),
          ] else ...[
            // Empty state
            const SizedBox(height: TossSpacing.space3),
            InkWell(
              onTap: state.isPickingImages ? null : _showSourceSelectionDialog,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TossColors.gray200,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  color: TossColors.gray50,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Tap to add receipts or screenshots',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build thumbnail for existing attachment (from database)
  Widget _buildExistingAttachment(InvoiceAttachment attachment) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
        child: attachment.isImage && attachment.fileUrl != null
            ? CachedNetworkImage(
                imageUrl: StorageUrlHelper.toAuthenticatedUrl(attachment.fileUrl!),
                httpHeaders: StorageUrlHelper.getAuthHeaders(),
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: TossColors.gray100,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => _buildFileIcon(),
              )
            : _buildFileIcon(),
      ),
    );
  }

  /// Build thumbnail for pending attachment (local file)
  Widget _buildPendingAttachment(JournalAttachment attachment, int index) {
    return Stack(
      children: [
        // Thumbnail
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.primary.withValues(alpha: 0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
            child: attachment.isImage && attachment.localFile != null
                ? Image.file(
                    File(attachment.localFile!.path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFileIcon(),
                  )
                : _buildFileIcon(),
          ),
        ),

        // "New" badge
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: const BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                bottomRight: Radius.circular(TossBorderRadius.sm),
              ),
            ),
            child: Text(
              'NEW',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.white,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        // Remove button
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: TossColors.error,
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
    );
  }

  Widget _buildFileIcon() {
    return Container(
      color: TossColors.gray100,
      child: const Center(
        child: Icon(
          Icons.image,
          color: TossColors.gray400,
          size: 28,
        ),
      ),
    );
  }
}
