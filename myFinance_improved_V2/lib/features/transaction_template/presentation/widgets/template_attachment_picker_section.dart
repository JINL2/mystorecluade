// Widget: TemplateAttachmentPickerSection
// Handles image/file attachment selection and preview for template transactions

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';
import '../../domain/entities/template_attachment.dart';

/// Section widget for picking and displaying template transaction attachments
class TemplateAttachmentPickerSection extends StatefulWidget {
  final List<TemplateAttachment> attachments;
  final ValueChanged<List<TemplateAttachment>> onAttachmentsChanged;
  final bool canAddMore;
  final bool isRequired;

  const TemplateAttachmentPickerSection({
    super.key,
    required this.attachments,
    required this.onAttachmentsChanged,
    this.canAddMore = true,
    this.isRequired = false,
  });

  @override
  State<TemplateAttachmentPickerSection> createState() =>
      _TemplateAttachmentPickerSectionState();
}

class _TemplateAttachmentPickerSectionState
    extends State<TemplateAttachmentPickerSection> {
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImages = false;

  /// Pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    if (_isPickingImages) return;

    if (!widget.canAddMore) {
      _showMaxAttachmentsError();
      return;
    }

    if (mounted) {
      setState(() => _isPickingImages = true);
    }

    try {
      final availableSlots =
          TemplateAttachment.maxAttachments - widget.attachments.length;

      final images = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
        limit: availableSlots,
      );

      if (images.isNotEmpty) {
        await _processPickedFiles(images);
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      _showError('Failed to pick images');
    } finally {
      if (mounted) {
        setState(() => _isPickingImages = false);
      }
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    if (_isPickingImages) return;

    if (!widget.canAddMore) {
      _showMaxAttachmentsError();
      return;
    }

    if (mounted) {
      setState(() => _isPickingImages = true);
    }

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (!mounted) return;

      if (image != null) {
        await _processPickedFiles([image]);
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      if (mounted) {
        _showError('Failed to take photo');
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImages = false);
      }
    }
  }

  /// Process picked files and add to state
  Future<void> _processPickedFiles(List<XFile> files) async {
    final newAttachments = <TemplateAttachment>[];

    for (final file in files) {
      final fileSize = await file.length();

      newAttachments.add(
        TemplateAttachment(
          localFile: file,
          fileName: file.name,
          fileSizeBytes: fileSize,
          mimeType: _getMimeType(file.name),
        ),
      );
    }

    if (!mounted) return;

    // Filter out oversized files and respect limit
    final availableSlots =
        TemplateAttachment.maxAttachments - widget.attachments.length;
    final validAttachments = newAttachments
        .where((a) => !a.exceedsSizeLimit)
        .take(availableSlots)
        .toList();

    if (validAttachments.isNotEmpty) {
      widget.onAttachmentsChanged([...widget.attachments, ...validAttachments]);
    }

    // Notify if some attachments were skipped
    final skippedCount = newAttachments.length - validAttachments.length;
    if (skippedCount > 0 && mounted) {
      _showError('$skippedCount file(s) skipped (too large or limit reached)');
    }
  }

  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  void _showMaxAttachmentsError() {
    _showError('Maximum ${TemplateAttachment.maxAttachments} attachments allowed');
  }

  void _showError(String message) {
    if (!mounted) return;
    TossToast.error(context, message);
  }

  void _removeAttachment(int index) {
    final newList = List<TemplateAttachment>.from(widget.attachments);
    newList.removeAt(index);
    widget.onAttachmentsChanged(newList);
  }

  /// Show source selection dialog
  void _showSourceSelectionDialog() {
    SelectionBottomSheetCommon.show(
      context: context,
      title: 'Add Attachment',
      maxHeightRatio: 0.4,
      children: [
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
            if (mounted) {
              _pickImagesFromGallery();
            }
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
          onTap: () async {
            Navigator.pop(context);
            await Future.delayed(TossAnimations.quick);
            if (mounted) {
              _pickImageFromCamera();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final attachments = widget.attachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_file,
                  size: TossSpacing.iconSM,
                  color: widget.isRequired ? TossColors.primary : TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  'Attachments',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                if (widget.isRequired) ...[
                  SizedBox(width: TossSpacing.space1 / 2),
                  Text(
                    '*',
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.error,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ],
                if (attachments.isNotEmpty) ...[
                  const SizedBox(width: TossSpacing.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1 / 2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                    child: Text(
                      '${attachments.length}/${TemplateAttachment.maxAttachments}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // Add button
            if (widget.canAddMore)
              TossButton.textButton(
                text: _isPickingImages ? 'Loading...' : 'Add',
                onPressed: _isPickingImages ? null : _showSourceSelectionDialog,
                leadingIcon: _isPickingImages ? null : Icon(Icons.add_photo_alternate_outlined, size: TossSpacing.iconSM),
                isLoading: _isPickingImages,
              ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),

        // Attachments grid or empty state
        if (attachments.isEmpty)
          _buildEmptyState()
        else
          _buildAttachmentsGrid(attachments),
      ],
    );
  }

  Widget _buildEmptyState() {
    return InkWell(
      onTap: _isPickingImages ? null : _showSourceSelectionDialog,
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
            Icon(
              Icons.add_photo_alternate_outlined,
              size: TossSpacing.iconLG2,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Tap to add receipts or documents',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsGrid(List<TemplateAttachment> attachments) {
    return SizedBox(
      height: TossSpacing.space20,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (_, __) => const SizedBox(width: TossSpacing.space2),
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          return _buildAttachmentThumbnail(attachment, index);
        },
      ),
    );
  }

  Widget _buildAttachmentThumbnail(TemplateAttachment attachment, int index) {
    return Stack(
      children: [
        // Thumbnail
        Container(
          width: TossSpacing.space20,
          height: TossSpacing.space20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
            child: attachment.isImage && attachment.localFile != null
                ? Image.file(
                    File(attachment.localFile!.path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFileIcon(attachment),
                  )
                : _buildFileIcon(attachment),
          ),
        ),

        // Remove button
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space1 / 2),
              decoration: const BoxDecoration(
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

        // File size indicator (if oversized)
        if (attachment.exceedsSizeLimit)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space1 / 2),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(TossBorderRadius.md - 1),
                ),
              ),
              child: Text(
                'Too large',
                textAlign: TextAlign.center,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFileIcon(TemplateAttachment attachment) {
    IconData icon;
    Color color;

    if (attachment.isPdf) {
      icon = Icons.picture_as_pdf;
      color = TossColors.error;
    } else if (attachment.isImage) {
      icon = Icons.image;
      color = TossColors.primary;
    } else {
      icon = Icons.insert_drive_file;
      color = TossColors.gray500;
    }

    return Container(
      color: TossColors.gray100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: TossSpacing.iconLG),
            SizedBox(height: TossSpacing.space1 / 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
              child: Text(
                attachment.fileName,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
