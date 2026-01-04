import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../journal_input/presentation/providers/journal_input_providers.dart';
import '../../../../domain/entities/sales_product.dart';
import '../../common/product_image_widget.dart';
import '../helpers/payment_helpers.dart';

/// Bottom sheet for showing invoice creation success
class InvoiceSuccessBottomSheet extends ConsumerStatefulWidget {
  final String invoiceNumber;
  final double totalAmount;
  final String currencySymbol;
  final String storeName;
  final String paymentType;
  final String cashLocationName;
  final List<SalesProduct> products;
  final Map<String, int> quantities;
  final String warningMessage;
  final String? journalEntryId;
  final String? companyId;
  final String? userId;
  final VoidCallback onDismiss;

  const InvoiceSuccessBottomSheet({
    super.key,
    required this.invoiceNumber,
    required this.totalAmount,
    this.currencySymbol = 'đ',
    required this.storeName,
    required this.paymentType,
    required this.cashLocationName,
    required this.products,
    required this.quantities,
    this.warningMessage = '',
    this.journalEntryId,
    this.companyId,
    this.userId,
    required this.onDismiss,
  });

  /// Show the invoice success page (full screen)
  static void show(
    BuildContext context, {
    required String invoiceNumber,
    required double totalAmount,
    String currencySymbol = 'đ',
    required String storeName,
    required String paymentType,
    required String cashLocationName,
    required List<SalesProduct> products,
    required Map<String, int> quantities,
    String warningMessage = '',
    String? journalEntryId,
    String? companyId,
    String? userId,
    required VoidCallback onDismiss,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InvoiceSuccessBottomSheet(
          invoiceNumber: invoiceNumber,
          totalAmount: totalAmount,
          currencySymbol: currencySymbol,
          storeName: storeName,
          paymentType: paymentType,
          cashLocationName: cashLocationName,
          products: products,
          quantities: quantities,
          warningMessage: warningMessage,
          journalEntryId: journalEntryId,
          companyId: companyId,
          userId: userId,
          onDismiss: onDismiss,
        ),
      ),
    );
  }

  @override
  ConsumerState<InvoiceSuccessBottomSheet> createState() =>
      _InvoiceSuccessBottomSheetState();
}

class _InvoiceSuccessBottomSheetState
    extends ConsumerState<InvoiceSuccessBottomSheet> {
  bool _isItemsExpanded = true;
  bool _isAttachmentsExpanded = false;
  final List<XFile> _pendingAttachments = [];
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  bool get _canAddAttachment =>
      widget.journalEntryId != null &&
      widget.companyId != null &&
      widget.userId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - Title centered at top
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Sale Completed!',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    const SizedBox(height: TossSpacing.space4),

                    // Total amount with currency symbol before number
                    Text(
                      '${widget.currencySymbol}${PaymentHelpers.formatPrice(widget.totalAmount)}',
                      style: TossTextStyles.display.copyWith(
                        color: TossColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TossSpacing.space2),

                    // Store • Payment Type • Location
                    Text(
                      '${widget.paymentType} · ${widget.storeName} · ${widget.cashLocationName}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TossSpacing.space6),

                    // View items section
                    _buildViewItemsSection(),

                    // Attachment section (if journal entry exists)
                    if (_canAddAttachment) ...[
                      const SizedBox(height: TossSpacing.space3),
                      _buildAttachmentSection(),
                    ],
                  ],
                ),
              ),
            ),

            // OK button - fixed at bottom
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: _buildOkButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isAttachmentsExpanded = !_isAttachmentsExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.lg),
              bottom: _isAttachmentsExpanded
                  ? Radius.zero
                  : const Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 20,
                        color: TossColors.gray600,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        'Add Receipt Screenshot',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      if (_pendingAttachments.isNotEmpty) ...[
                        const SizedBox(width: TossSpacing.space2),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TossColors.primarySurface,
                          ),
                          child: Center(
                            child: Text(
                              '${_pendingAttachments.length}',
                              style: TossTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Icon(
                    _isAttachmentsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ],
              ),
            ),
          ),

          // Attachment content
          if (_isAttachmentsExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray200,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description text
                  Text(
                    'Take a photo of the receipt or bank transfer screenshot as proof of sale.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),

                  // Camera and Gallery buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildImageButton(
                          icon: Icons.camera_alt,
                          label: 'Camera',
                          onTap: _isUploading ? null : _pickFromCamera,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: _buildImageButton(
                          icon: Icons.photo_library,
                          label: 'Gallery',
                          onTap: _isUploading ? null : _pickFromGallery,
                        ),
                      ),
                    ],
                  ),

                  // Pending attachments preview
                  if (_pendingAttachments.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space3),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _pendingAttachments.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: TossSpacing.space2),
                        itemBuilder: (context, index) {
                          final file = _pendingAttachments[index];
                          return _buildAttachmentPreview(file, index);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: TossColors.gray200),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: TossColors.primary),
            const SizedBox(height: TossSpacing.space1),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentPreview(XFile file, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          child: Image.file(
            File(file.path),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _pendingAttachments.removeAt(index);
              });
            },
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

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _pendingAttachments.add(image);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        setState(() {
          _pendingAttachments.addAll(images);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick images: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      TossToast.error(context, message);
    }
  }

  Widget _buildViewItemsSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isItemsExpanded = !_isItemsExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.lg),
              bottom: _isItemsExpanded
                  ? Radius.zero
                  : const Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'View items',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      // Item count badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: TossColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.products.length}',
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isItemsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ],
              ),
            ),
          ),

          // Items list
          if (_isItemsExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray200,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Column(
                children: widget.products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final quantity = widget.quantities[product.productId] ?? 0;
                  final price = product.pricing.sellingPrice ?? 0;
                  final isLast = index == widget.products.length - 1;
                  return _buildItemRow(product, quantity, price, isLast);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow(
    SalesProduct product,
    int quantity,
    double price,
    bool isLast,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : TossSpacing.space3),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: ProductImageWidget(
              imageUrl: product.images.mainImage,
              size: 48,
              fallbackIcon: Icons.inventory_2,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.sku,
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          // Quantity x Price
          Text(
            '$quantity × ${PaymentHelpers.formatPrice(price)}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOkButton(BuildContext context) {
    final hasAttachments = _pendingAttachments.isNotEmpty;
    final buttonText = hasAttachments ? 'Upload and Back to Sale' : 'OK! Back to Sale';

    return SizedBox(
      width: double.infinity,
      child: TossButton.primary(
        text: buttonText,
        onPressed: _isUploading ? null : () => _handleButtonPress(context),
        isLoading: _isUploading,
      ),
    );
  }

  Future<void> _handleButtonPress(BuildContext context) async {
    // If there are attachments, upload first then go back
    if (_pendingAttachments.isNotEmpty && _canAddAttachment) {
      setState(() {
        _isUploading = true;
      });

      try {
        await ref.read(journalActionsNotifierProvider.notifier).uploadAttachments(
          companyId: widget.companyId!,
          journalId: widget.journalEntryId!,
          uploadedBy: widget.userId!,
          files: _pendingAttachments,
        );

        // Upload successful, go back
        if (mounted) {
          context.pop();
          widget.onDismiss();
        }
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        _showErrorSnackBar('Failed to upload: $e');
      }
    } else {
      // No attachments, just go back
      context.pop();
      widget.onDismiss();
    }
  }
}
