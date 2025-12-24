import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_detail.dart';
import '../providers/invoice_detail_provider.dart';

/// Invoice Detail Page - Full page view for invoice details
///
/// Features:
/// - Loads invoice detail from RPC on init
/// - AppBar with invoice number, date/time/store info
/// - Collapsible "View items" card with actual item details
/// - Payment breakdown section (subtotal, discount, total)
/// - Payment method section with icon
/// - Created by section with avatar
/// - Refund action for completed invoices
class InvoiceDetailPage extends ConsumerStatefulWidget {
  final Invoice invoice;
  final String? currencySymbol;
  final void Function(Invoice invoice)? onRefundPressed;
  final void Function(Invoice invoice)? onDeletePressed;

  const InvoiceDetailPage({
    super.key,
    required this.invoice,
    this.currencySymbol,
    this.onRefundPressed,
    this.onDeletePressed,
  });

  /// Navigate to invoice detail page
  static void navigate(
    BuildContext context,
    Invoice invoice,
    String? currencySymbol, {
    void Function(Invoice invoice)? onRefundPressed,
    void Function(Invoice invoice)? onDeletePressed,
  }) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InvoiceDetailPage(
          invoice: invoice,
          currencySymbol: currencySymbol,
          onRefundPressed: onRefundPressed,
          onDeletePressed: onDeletePressed,
        ),
      ),
    );
  }

  @override
  ConsumerState<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends ConsumerState<InvoiceDetailPage> {
  bool _isItemsExpanded = true;
  static final _currencyFormat =
      NumberFormat.currency(symbol: '', decimalDigits: 0);

  String get _symbol => widget.currencySymbol ?? '';

  Invoice get invoice => widget.invoice;

  @override
  void initState() {
    super.initState();
    // Load invoice detail on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceDetailProvider.notifier).loadDetail(invoice.invoiceId);
    });
  }

  /// Get payment method icon based on cash location type
  IconData _getPaymentIcon(InvoiceDetail? detail) {
    final locationType = detail?.cashLocationType?.toLowerCase() ??
        invoice.cashLocation?.locationType.toLowerCase() ??
        '';
    final paymentMethod =
        detail?.paymentMethod.toLowerCase() ?? invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return Icons.payments_outlined;
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return Icons.account_balance_outlined;
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return Icons.grid_view_outlined;
    }
    return Icons.payments_outlined;
  }

  /// Get payment method display name
  String _getPaymentMethodName(InvoiceDetail? detail) {
    final locationType = detail?.cashLocationType?.toLowerCase() ??
        invoice.cashLocation?.locationType.toLowerCase() ??
        '';
    final paymentMethod =
        detail?.paymentMethod.toLowerCase() ?? invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return 'Cash';
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return 'Bank Transfer';
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return 'Vault';
    }
    return detail?.paymentMethod ?? invoice.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(invoiceDetailProvider);
    final detail = detailState.detail;

    return TossScaffold(
      appBar: _buildAppBar(context, detail),
      body: detailState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
              ),
            )
          : detailState.error != null
              ? _buildErrorState(detailState.error!)
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // View Items Card (Collapsible)
                            Padding(
                              padding: const EdgeInsets.all(TossSpacing.space4),
                              child: _buildViewItemsCard(detail),
                            ),

                            // Gray divider before Payment breakdown
                            const GrayDividerSpace(),

                            // Payment Breakdown Section
                            _buildPaymentBreakdownSection(detail),

                            // Gray divider before Payment method
                            const GrayDividerSpace(),

                            // Payment Method Section
                            _buildPaymentMethodSection(detail),

                            // Gray divider before Created by
                            const GrayDividerSpace(),

                            // Created By Section
                            _buildCreatedBySection(detail),

                            // AI Description Section (if available)
                            if (detail?.hasAiDescription == true) ...[
                              const GrayDividerSpace(),
                              _buildAiDescriptionSection(detail!),
                            ],

                            // Attachments Section (if available)
                            if (detail?.hasAttachments == true) ...[
                              const GrayDividerSpace(),
                              _buildAttachmentsSection(detail!),
                            ],

                            const SizedBox(height: TossSpacing.space6),
                          ],
                        ),
                      ),
                    ),

                    // Refund Button (only for completed invoices)
                    if (invoice.isCompleted && widget.onRefundPressed != null)
                      _buildRefundButton(context),
                  ],
                ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: TossColors.error,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Error loading invoice',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Text(
              error,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(invoiceDetailProvider.notifier)
                  .loadDetail(invoice.invoiceId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, InvoiceDetail? detail) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final saleDate = detail?.saleDate ?? invoice.saleDate;
    final storeName = detail?.storeName ?? invoice.storeName;
    final invoiceNumber = detail?.invoiceNumber ?? invoice.invoiceNumber;

    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24),
        onPressed: () => Navigator.of(context).pop(),
        color: TossColors.gray900,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoiceNumber,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${dateFormat.format(saleDate)} · ${timeFormat.format(saleDate)} · $storeName',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (widget.onDeletePressed != null && !invoice.isCancelled)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 24),
            onPressed: () => _showDeleteConfirmation(context),
            color: TossColors.gray600,
          ),
      ],
    );
  }

  Widget _buildViewItemsCard(InvoiceDetail? detail) {
    final itemCount = detail?.itemCount ?? invoice.itemsSummary.itemCount;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _isItemsExpanded = !_isItemsExpanded;
        });
      },
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'View items',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                // Item count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                  child: Text(
                    '$itemCount',
                    style: TossTextStyles.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isItemsExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildItemsList(detail),
            crossFadeState: _isItemsExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(InvoiceDetail? detail) {
    // Use actual items from detail if available
    if (detail != null && detail.items.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          children: [
            const SizedBox(height: TossSpacing.space3),
            ...detail.items.map((item) => _buildItemRow(item)),
          ],
        ),
      );
    }

    // Fallback to summary info
    final itemCount = invoice.itemsSummary.itemCount;
    final totalQty = invoice.itemsSummary.totalQuantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: TossColors.gray500,
                  size: 24,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$itemCount product${itemCount > 1 ? 's' : ''}',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total quantity: $totalQty',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatAmount(invoice.amounts.subtotal),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(InvoiceDetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image or placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              image: item.productImage != null
                  ? DecorationImage(
                      image: NetworkImage(item.productImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.productImage == null
                ? const Icon(
                    Icons.shopping_bag_outlined,
                    color: TossColors.gray500,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatAmount(item.unitPrice)} × ${item.quantity}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                if (item.discountAmount > 0)
                  Text(
                    'Discount: -${_formatAmount(item.discountAmount)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            _formatAmount(item.totalPrice),
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdownSection(InvoiceDetail? detail) {
    final subtotal = detail?.subtotal ?? invoice.amounts.subtotal;
    final discountAmount = detail?.discountAmount ?? invoice.amounts.discountAmount;
    final taxAmount = detail?.taxAmount ?? invoice.amounts.taxAmount;
    final totalAmount = detail?.totalAmount ?? invoice.amounts.totalAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Payment breakdown',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Sub-total
          _buildPaymentRow(
            'Sub-total',
            _formatAmount(subtotal),
          ),

          // Discount (if any)
          if (discountAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildDiscountRow(subtotal, discountAmount),
          ],

          // Tax (if any)
          if (taxAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildPaymentRow(
              'Tax',
              _formatAmount(taxAmount),
            ),
          ],

          const SizedBox(height: TossSpacing.space4),

          // Divider before total
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Total payment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total payment',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                _formatAmount(totalAmount),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(double subtotal, double discountAmount) {
    final discountPercent = _calculateDiscountPercent(subtotal, discountAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Text(
              '-${_formatAmount(discountAmount)}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.error,
              ),
            ),
          ],
        ),
        if (discountPercent.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            '~$discountPercent discount',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodSection(InvoiceDetail? detail) {
    final locationName =
        detail?.cashLocationName ?? invoice.cashLocation?.locationName;
    final isPaid = detail?.isPaid ?? invoice.isPaid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Payment method',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              // Payment icon
              Icon(
                _getPaymentIcon(detail),
                color: TossColors.gray700,
                size: 24,
              ),
              const SizedBox(width: TossSpacing.space3),
              // Payment method name
              Text(
                _getPaymentMethodName(detail),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
              const Spacer(),
              // Location name or status
              if (locationName != null)
                Text(
                  locationName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                )
              else
                // Payment status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    isPaid ? 'Paid' : 'Pending',
                    style: TossTextStyles.small.copyWith(
                      color: isPaid ? TossColors.success : TossColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedBySection(InvoiceDetail? detail) {
    final createdByName =
        detail?.createdByName ?? invoice.createdByName ?? 'Unknown';
    final profileImage = detail?.createdByProfileImage;
    final initials = _getInitials(createdByName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section title
          Text(
            'Created by',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          // Avatar and name
          Row(
            children: [
              // Avatar - show profile image if available, otherwise initials
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  shape: BoxShape.circle,
                  image: profileImage != null && profileImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(profileImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                child: profileImage == null || profileImage.isEmpty
                    ? Center(
                        child: Text(
                          initials,
                          style: TossTextStyles.small.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.white,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: TossSpacing.space2),
              // Name
              Text(
                createdByName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiDescriptionSection(InvoiceDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: TossColors.primary,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'AI Description',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Description text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Text(
              detail.aiDescription ?? '',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(InvoiceDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              const Icon(
                Icons.attach_file,
                color: TossColors.gray700,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Attachments',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
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
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Text(
                  '${detail.validAttachments.length}',
                  style: TossTextStyles.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Attachments grid - only show valid attachments with fileUrl
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: detail.validAttachments.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: TossSpacing.space2),
              itemBuilder: (context, index) {
                final attachment = detail.validAttachments[index];
                return _buildAttachmentThumbnail(attachment);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentThumbnail(InvoiceAttachment attachment) {
    return GestureDetector(
      onTap: () {
        if (attachment.fileUrl != null) {
          _showFullImageDialog(attachment);
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: TossColors.gray200,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(color: TossColors.gray300),
        ),
        clipBehavior: Clip.antiAlias,
        child: attachment.isImage && attachment.fileUrl != null
            ? Image.network(
                attachment.fileUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        TossColors.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: TossColors.gray500,
                      size: 32,
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    attachment.isPdf
                        ? Icons.picture_as_pdf
                        : Icons.insert_drive_file,
                    color: TossColors.gray500,
                    size: 32,
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      attachment.fileName,
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showFullImageDialog(InvoiceAttachment attachment) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(TossSpacing.space4),
        child: Stack(
          children: [
            // Image
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  attachment.fileUrl!,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 200,
                      height: 200,
                      color: TossColors.white,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            TossColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: TossColors.white,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: TossColors.gray500,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: TossColors.gray900,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showRefundConfirmation(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.error,
            foregroundColor: TossColors.white,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay, size: 20),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Refund',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRefundConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.replay,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Refund Invoice'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to refund this invoice?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Column(
                children: [
                  Text(
                    'Refund Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    _formatAmount(invoice.amounts.totalAmount),
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Invoice: ${invoice.invoiceNumber}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            // Buttons row - Cancel and Refund side by side
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TossColors.gray700,
                      side: const BorderSide(color: TossColors.gray300),
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // Refund button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Close dialog
                      Navigator.pop(context); // Close page
                      widget.onRefundPressed?.call(invoice);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.error,
                      foregroundColor: TossColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Refund',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [], // Empty actions since we have custom buttons in content
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Delete Invoice'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete invoice ${invoice.invoiceNumber}? This action cannot be undone.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close page
              widget.onDeletePressed?.call(invoice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
              foregroundColor: TossColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatted = _currencyFormat.format(amount);
    if (_symbol.isEmpty || _symbol == '\$') {
      return '$formattedđ';
    }
    return '$_symbol$formatted';
  }

  String _calculateDiscountPercent(double subtotal, double discountAmount) {
    if (subtotal <= 0) return '';
    final percent = (discountAmount / subtotal) * 100;
    return '${percent.toStringAsFixed(1)}%';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
