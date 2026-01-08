import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/storage_url_helper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_opacity.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
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
    final notifier = ref.read(invoiceAttachmentNotifierProvider.notifier);
    final state = ref.read(invoiceAttachmentNotifierProvider);

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
    final notifier = ref.read(invoiceAttachmentNotifierProvider.notifier);
    final state = ref.read(invoiceAttachmentNotifierProvider);

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
    TossToast.error(context, message);
  }

  void _removeAttachment(int index) {
    ref.read(invoiceAttachmentNotifierProvider.notifier).removeAttachment(index);
  }

  /// Show source selection dialog
  void _showSourceSelectionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: TossDimensions.dragHandleWidth,
                height: TossDimensions.dragHandleHeight,
                margin: EdgeInsets.only(bottom: TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
                ),
              ),
              Text(
                'Add Image',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: TossColors.primary,
                    size: TossSpacing.iconMD2,
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
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: TossColors.success,
                    size: TossSpacing.iconMD2,
                  ),
                ),
                title: const Text('Take Photo'),
                subtitle: const Text('Use camera to capture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              SizedBox(height: TossSpacing.space2),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceAttachmentNotifierProvider);
    final pendingAttachments = state.pendingAttachments;
    final existingAttachments = widget.existingAttachments;
    final totalCount = existingAttachments.length + pendingAttachments.length;

    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
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
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  Icons.attach_file,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                'Attachments',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: TossColors.gray900,
                ),
              ),
              if (totalCount > 0) ...[
                SizedBox(width: TossSpacing.space2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.badgePaddingVerticalSM,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                  child: Text(
                    '$totalCount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Add button
              if (state.canAddMoreAttachments)
                TossButton.textButton(
                  text: state.isPickingImages ? 'Loading...' : 'Add',
                  onPressed:
                      state.isPickingImages ? null : _showSourceSelectionDialog,
                  leadingIcon: state.isPickingImages
                      ? TossLoadingView.inline(size: TossSpacing.iconSM2)
                      : Icon(Icons.add_photo_alternate_outlined, size: TossSpacing.iconSM),
                ),
            ],
          ),

          // Attachments grid
          if (totalCount > 0) ...[
            SizedBox(height: TossSpacing.space3),
            SizedBox(
              height: TossDimensions.productImageLarge,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: existingAttachments.length + pendingAttachments.length,
                separatorBuilder: (_, __) =>
                    SizedBox(width: TossSpacing.space2),
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
            SizedBox(height: TossSpacing.space3),
            InkWell(
              onTap: state.isPickingImages ? null : _showSourceSelectionDialog,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(TossSpacing.space4),
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
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: TossSpacing.iconLG2,
                      color: TossColors.gray400,
                    ),
                    SizedBox(height: TossSpacing.space2),
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
    final fileUrl = attachment.fileUrl;
    final showImage = attachment.isImage && fileUrl != null;

    return Container(
      width: TossDimensions.productImageLarge,
      height: TossDimensions.productImageLarge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
        child: showImage
            ? CachedNetworkImage(
                imageUrl: StorageUrlHelper.toAuthenticatedUrl(fileUrl),
                httpHeaders: StorageUrlHelper.getAuthHeaders(),
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: TossColors.gray100,
                  child: Center(
                    child: TossLoadingView.inline(size: TossSpacing.iconMD),
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
          width: TossDimensions.productImageLarge,
          height: TossDimensions.productImageLarge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.primary.withValues(alpha: TossOpacity.scrim)),
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
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space1,
              vertical: TossSpacing.badgePaddingVerticalSM,
            ),
            decoration: BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                bottomRight: Radius.circular(TossBorderRadius.sm),
              ),
            ),
            child: Text(
              'NEW',
              style: TossTextStyles.small.copyWith(
                color: TossColors.white,
                fontWeight: TossFontWeight.bold,
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
              padding: EdgeInsets.all(TossSpacing.space0_5),
              decoration: BoxDecoration(
                color: TossColors.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: TossSpacing.iconXS,
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
      child: Center(
        child: Icon(
          Icons.image,
          color: TossColors.gray400,
          size: TossSpacing.iconLG,
        ),
      ),
    );
  }
}
