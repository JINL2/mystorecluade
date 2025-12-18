import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_button.dart';
import '../../../journal_input/data/datasources/journal_entry_datasource.dart';
import '../../../journal_input/domain/entities/journal_attachment.dart';

/// Page for adding screenshots/receipts after successful invoice
class InvoiceAttachmentPage extends ConsumerStatefulWidget {
  final String journalId;
  final String invoiceNumber;
  final double totalAmount;
  final String currencySymbol;

  const InvoiceAttachmentPage({
    super.key,
    required this.journalId,
    required this.invoiceNumber,
    required this.totalAmount,
    this.currencySymbol = 'đ',
  });

  @override
  ConsumerState<InvoiceAttachmentPage> createState() =>
      _InvoiceAttachmentPageState();
}

class _InvoiceAttachmentPageState extends ConsumerState<InvoiceAttachmentPage> {
  final ImagePicker _picker = ImagePicker();
  final List<JournalAttachment> _pendingAttachments = [];
  bool _isPickingImages = false;
  bool _isUploading = false;
  static const int maxAttachments = 5;

  bool get _canAddMore => _pendingAttachments.length < maxAttachments;

  /// Pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    if (_isPickingImages || !_canAddMore) return;

    setState(() => _isPickingImages = true);

    try {
      final availableSlots = maxAttachments - _pendingAttachments.length;
      final images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
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
    if (_isPickingImages || !_canAddMore) return;

    setState(() => _isPickingImages = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (image != null) {
        await _processPickedFiles([image]);
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      _showError('Failed to take photo');
    } finally {
      if (mounted) {
        setState(() => _isPickingImages = false);
      }
    }
  }

  Future<void> _processPickedFiles(List<XFile> files) async {
    for (final file in files) {
      final fileSize = await file.length();
      setState(() {
        _pendingAttachments.add(
          JournalAttachment(
            localFile: file,
            fileName: file.name,
            fileSizeBytes: fileSize,
            mimeType: _getMimeType(file.name),
          ),
        );
      });
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
      default:
        return 'image/jpeg';
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _pendingAttachments.removeAt(index);
    });
  }

  Future<void> _uploadAttachments() async {
    if (_pendingAttachments.isEmpty || _isUploading) return;

    setState(() => _isUploading = true);

    try {
      final appState = ref.read(appStateProvider);
      final authState = ref.read(authStateProvider);
      final companyId = appState.companyChoosen;
      final userId = authState.value?.id;

      if (companyId.isEmpty || userId == null) {
        _showError('Missing company or user information');
        return;
      }

      // Use the journal entry datasource to upload attachments
      final datasource = JournalEntryDataSource(
        ref.read(supabaseClientProvider),
      );

      final files = _pendingAttachments
          .where((a) => a.localFile != null)
          .map((a) => a.localFile!)
          .toList();

      await datasource.uploadAttachments(
        companyId: companyId,
        journalId: widget.journalId,
        uploadedBy: userId,
        files: files,
      );

      if (mounted) {
        _showSuccess('Screenshots uploaded successfully!');
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      debugPrint('Error uploading attachments: $e');
      _showError('Failed to upload screenshots');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
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

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
                'Add Screenshot',
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
                subtitle: const Text('Select payment screenshots'),
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
                subtitle: const Text('Capture receipt or transfer'),
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
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: TossColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Payment Proof',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Invoice info card
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: TossColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice ${widget.invoiceNumber}',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.currencySymbol}${_formatNumber(widget.totalAmount.toInt())}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space2),

          // Main content
          Expanded(
            child: Container(
              color: TossColors.white,
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: TossColors.gray600,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Screenshots',
                            style: TossTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
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
                              borderRadius:
                                  BorderRadius.circular(TossBorderRadius.full),
                            ),
                            child: Text(
                              '${_pendingAttachments.length}/$maxAttachments',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_canAddMore)
                        TextButton.icon(
                          onPressed:
                              _isPickingImages ? null : _showSourceSelectionDialog,
                          icon: _isPickingImages
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.add_photo_alternate_outlined,
                                  size: 18),
                          label: Text(_isPickingImages ? 'Loading...' : 'Add'),
                          style: TextButton.styleFrom(
                            foregroundColor: TossColors.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space3),

                  // Description
                  Text(
                    'Add screenshots of bank transfers, payment receipts, or any proof of payment for this sale.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  // Attachments grid or empty state
                  Expanded(
                    child: _pendingAttachments.isEmpty
                        ? _buildEmptyState()
                        : _buildAttachmentsGrid(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TossButton.secondary(
                      text: 'Skip',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    flex: 2,
                    child: TossButton.primary(
                      text: _isUploading ? 'Uploading...' : 'Save Screenshots',
                      onPressed: _pendingAttachments.isEmpty || _isUploading
                          ? null
                          : _uploadAttachments,
                      isEnabled:
                          _pendingAttachments.isNotEmpty && !_isUploading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return InkWell(
      onTap: _isPickingImages ? null : _showSourceSelectionDialog,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(TossSpacing.space6),
        decoration: BoxDecoration(
          border: Border.all(
            color: TossColors.gray200,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          color: TossColors.gray50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                size: 48,
                color: TossColors.primary,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Add Payment Screenshots',
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              'Tap to add receipts or bank transfer screenshots',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: TossSpacing.space3,
        mainAxisSpacing: TossSpacing.space3,
        childAspectRatio: 1,
      ),
      itemCount: _pendingAttachments.length,
      itemBuilder: (context, index) {
        final attachment = _pendingAttachments[index];
        return _buildAttachmentThumbnail(attachment, index);
      },
    );
  }

  Widget _buildAttachmentThumbnail(JournalAttachment attachment, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg - 1),
            child: attachment.isImage && attachment.localFile != null
                ? Image.file(
                    File(attachment.localFile!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Container(
                    color: TossColors.gray100,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        color: TossColors.gray400,
                        size: 48,
                      ),
                    ),
                  ),
          ),
        ),
        // Remove button
        Positioned(
          top: TossSpacing.space2,
          right: TossSpacing.space2,
          child: GestureDetector(
            onTap: () => _removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space1),
              decoration: BoxDecoration(
                color: TossColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: TossColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

// Supabase client provider (reuse from existing)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
