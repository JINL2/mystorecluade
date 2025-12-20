// Widget: AttachmentPickerSection
// Handles image/file attachment selection and preview for journal entries

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/journal_attachment.dart';
import '../providers/journal_input_providers.dart';
import '../providers/states/journal_entry_state.dart';

/// Section widget for picking and displaying journal attachments
class AttachmentPickerSection extends ConsumerStatefulWidget {
  const AttachmentPickerSection({super.key});

  @override
  ConsumerState<AttachmentPickerSection> createState() =>
      _AttachmentPickerSectionState();
}

class _AttachmentPickerSectionState
    extends ConsumerState<AttachmentPickerSection> {
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImages = false;

  /// Pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    if (_isPickingImages) return;

    final state = ref.read(journalEntryStateProvider);
    if (!state.canAddMoreAttachments) {
      _showMaxAttachmentsError();
      return;
    }

    setState(() => _isPickingImages = true);

    try {
      final availableSlots =
          JournalEntryState.maxAttachments - state.attachmentCount;

      final images = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
        limit: availableSlots,
      );

      if (images.isNotEmpty) {
        await _processPickedFiles(images);
      }
    } catch (_) {
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

    final state = ref.read(journalEntryStateProvider);
    if (!state.canAddMoreAttachments) {
      _showMaxAttachmentsError();
      return;
    }

    setState(() => _isPickingImages = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (image != null) {
        await _processPickedFiles([image]);
      }
    } catch (_) {
      _showError('Failed to take photo');
    } finally {
      if (mounted) {
        setState(() => _isPickingImages = false);
      }
    }
  }

  /// Process picked files and add to state
  Future<void> _processPickedFiles(List<XFile> files) async {
    final attachments = <JournalAttachment>[];

    for (final file in files) {
      final fileSize = await file.length();

      attachments.add(
        JournalAttachment(
          localFile: file,
          fileName: file.name,
          fileSizeBytes: fileSize,
          mimeType: _getMimeType(file.name),
        ),
      );
    }

    ref.read(journalEntryStateProvider.notifier).addAttachments(attachments);
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
    _showError('Maximum ${JournalEntryState.maxAttachments} attachments allowed');
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
    ref.read(journalEntryStateProvider.notifier).removeAttachment(index);
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
                'Add Attachment',
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
    final state = ref.watch(journalEntryStateProvider);
    final attachments = state.pendingAttachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  size: 18,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  'Attachments',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (attachments.isNotEmpty) ...[
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
                      '${attachments.length}/${JournalEntryState.maxAttachments}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // Add button
            if (state.canAddMoreAttachments)
              TextButton.icon(
                onPressed: _isPickingImages ? null : _showSourceSelectionDialog,
                icon: _isPickingImages
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(_isPickingImages ? 'Loading...' : 'Add'),
                style: TextButton.styleFrom(
                  foregroundColor: TossColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                  ),
                ),
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
            const Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
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

  Widget _buildAttachmentsGrid(List<JournalAttachment> attachments) {
    return SizedBox(
      height: 80,
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

  Widget _buildAttachmentThumbnail(JournalAttachment attachment, int index) {
    return Stack(
      children: [
        // Thumbnail
        Container(
          width: 80,
          height: 80,
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

        // File size indicator (if oversized)
        if (attachment.exceedsSizeLimit)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(TossBorderRadius.md - 1),
                ),
              ),
              child: Text(
                'Too large',
                textAlign: TextAlign.center,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFileIcon(JournalAttachment attachment) {
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
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                attachment.fileName,
                style: TossTextStyles.caption.copyWith(
                  fontSize: 8,
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
