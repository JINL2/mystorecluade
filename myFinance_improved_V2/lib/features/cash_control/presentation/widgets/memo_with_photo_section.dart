import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Memo input with photo attachment for cash control
/// Simple, minimal design with gray tones
class MemoWithPhotoSection extends StatefulWidget {
  final TextEditingController memoController;
  final List<XFile> attachments;
  final ValueChanged<List<XFile>> onAttachmentsChanged;
  final int maxAttachments;

  const MemoWithPhotoSection({
    super.key,
    required this.memoController,
    required this.attachments,
    required this.onAttachmentsChanged,
    this.maxAttachments = 3,
  });

  @override
  State<MemoWithPhotoSection> createState() => _MemoWithPhotoSectionState();
}

class _MemoWithPhotoSectionState extends State<MemoWithPhotoSection> {
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;

  bool get _canAddMore => widget.attachments.length < widget.maxAttachments;

  Future<void> _pickFromGallery() async {
    if (_isPickingImage || !_canAddMore) return;

    setState(() => _isPickingImage = true);

    try {
      final availableSlots = widget.maxAttachments - widget.attachments.length;
      final images = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
        limit: availableSlots,
      );

      if (images.isNotEmpty) {
        final newList = [...widget.attachments, ...images];
        widget.onAttachmentsChanged(newList.take(widget.maxAttachments).toList());
      }
    } catch (_) {
      // Silent fail
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _pickFromCamera() async {
    if (_isPickingImage || !_canAddMore) return;

    setState(() => _isPickingImage = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (image != null) {
        widget.onAttachmentsChanged([...widget.attachments, image]);
      }
    } catch (_) {
      // Silent fail
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _removeAttachment(int index) {
    final newList = [...widget.attachments];
    newList.removeAt(index);
    widget.onAttachmentsChanged(newList);
  }

  void _showSourceDialog() {
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
              // Handle
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
                'Add Photo',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),

              // Gallery option
              _buildSourceOption(
                icon: Icons.photo_library_outlined,
                title: 'Gallery',
                subtitle: 'Choose from photos',
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),

              const SizedBox(height: TossSpacing.space2),

              // Camera option
              _buildSourceOption(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),

              const SizedBox(height: TossSpacing.space2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(icon, color: TossColors.gray600, size: 20),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Memo input with photo button
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              // Text field row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Memo text field
                  Expanded(
                    child: TextField(
                      controller: widget.memoController,
                      maxLines: 2,
                      minLines: 1,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Memo (optional)',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(TossSpacing.space3),
                      ),
                    ),
                  ),

                  // Photo button
                  if (_canAddMore)
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      child: InkWell(
                        onTap: _isPickingImage ? null : _showSourceDialog,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Center(
                            child: _isPickingImage
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: TossColors.gray500,
                                    ),
                                  )
                                : const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: TossColors.gray500,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Attachments row (if any)
              if (widget.attachments.isNotEmpty) ...[
                Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
                Padding(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  child: SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.attachments.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: TossSpacing.space2),
                      itemBuilder: (context, index) {
                        return _buildThumbnail(widget.attachments[index], index);
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Attachment count hint
        if (widget.attachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: TossSpacing.space1),
            child: Text(
              '${widget.attachments.length}/${widget.maxAttachments} photos',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildThumbnail(XFile file, int index) {
    return Stack(
      children: [
        // Image
        Container(
          width: 60,
          height: 60,
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
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Remove button
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => _removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(2),
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
