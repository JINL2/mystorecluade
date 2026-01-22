import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../attendance/presentation/providers/attendance_providers.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';
import '../../di/shipment_providers.dart';
import '../../domain/entities/shipment.dart';
import '../providers/shipment_providers.dart';
import '../widgets/shipment_list_item.dart';

class ShipmentDetailPage extends ConsumerStatefulWidget {
  final String shipmentId;

  const ShipmentDetailPage({super.key, required this.shipmentId});

  @override
  ConsumerState<ShipmentDetailPage> createState() => _ShipmentDetailPageState();
}

class _ShipmentDetailPageState extends ConsumerState<ShipmentDetailPage> {
  bool _isClosing = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(shipmentDetailV2Provider(widget.shipmentId));
    final baseCurrencyAsync = ref.watch(baseCurrencyProvider);
    final baseCurrencySymbol = baseCurrencyAsync.valueOrNull?.symbol ?? '\$';
    final baseCurrencyCode = baseCurrencyAsync.valueOrNull?.currencyCode ?? 'USD';

    return TossScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateBack(context),
        ),
        title: Text(
          detailAsync.valueOrNull?.shipmentNumber ?? 'Shipment Detail',
        ),
      ),
      body: _isClosing
          ? const TossLoadingView(message: 'Cancelling shipment...')
          : detailAsync.when(
              loading: () => const TossLoadingView(message: 'Loading...'),
              error: (error, _) => _buildErrorView(context, error.toString()),
              data: (detail) {
                if (detail == null) {
                  return _buildNotFoundView(context);
                }
                return _buildContent(
                  context,
                  detail,
                  baseCurrencySymbol,
                  baseCurrencyCode,
                );
              },
            ),
    );
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/shipment');
    }
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: TossSpacing.iconXXL,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Failed to load',
            style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
          ),
          const SizedBox(height: TossSpacing.space2),
          TossButton.textButton(
            text: 'Retry',
            onPressed: () => ref.invalidate(shipmentDetailV2Provider(widget.shipmentId)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: TossSpacing.icon4XL,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Shipment not found',
            style: TossTextStyles.h3.copyWith(color: TossColors.gray600),
          ),
          const SizedBox(height: TossSpacing.space4),
          TossButton.secondary(
            text: 'Go Back',
            onPressed: () => _navigateBack(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ShipmentDetail detail,
    String baseCurrencySymbol,
    String baseCurrencyCode,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status & Progress
          _buildStatusSection(detail),
          const SizedBox(height: TossSpacing.space5),

          // Basic Info
          _buildBasicInfoSection(detail),
          const SizedBox(height: TossSpacing.space5),

          // Supplier Info
          _buildSupplierSection(detail),
          const SizedBox(height: TossSpacing.space5),

          // Receiving Summary
          if (detail.receivingSummary != null)
            _buildReceivingSummarySection(detail.receivingSummary!),
          if (detail.receivingSummary != null)
            const SizedBox(height: TossSpacing.space5),

          // Items
          _buildItemsSection(detail, baseCurrencySymbol, baseCurrencyCode),
          const SizedBox(height: TossSpacing.space5),

          // Totals
          _buildTotalsSection(detail, baseCurrencySymbol, baseCurrencyCode),
          const SizedBox(height: TossSpacing.space5),

          // Linked Orders
          if (detail.hasOrders) _buildLinkedOrdersSection(detail),
          if (detail.hasOrders) const SizedBox(height: TossSpacing.space5),

          // Notes
          if (detail.notes != null && detail.notes!.isNotEmpty)
            _buildNotesSection(detail.notes!),

          // Cancel Button - show if shipment is cancellable (pending/process status)
          if (detail.isCancellable) ...[
            const SizedBox(height: TossSpacing.space5),
            _buildCancelButton(context, detail),
          ],

          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  Widget _buildStatusSection(ShipmentDetail detail) {
    return TradeSimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShipmentStatusChip(status: detail.status),
              const Spacer(),
              if (detail.shippedDate != null) ...[
                const Icon(
                  Icons.calendar_today,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  DateFormat('MMM dd, yyyy').format(detail.shippedDate!),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ],
          ),
          if (detail.receivingSummary != null &&
              detail.receivingSummary!.progressPercentage > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildReceivingProgress(detail.receivingSummary!.progressPercentage),
          ],
        ],
      ),
    );
  }

  Widget _buildReceivingProgress(double percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Receiving Progress',
              style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        ClipRRect(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: TossColors.gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(TossColors.primary),
            minHeight: TossSpacing.space2,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(ShipmentDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Basic Information'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: [
              _InfoRow(label: 'Shipment Number', value: detail.shipmentNumber),
              if (detail.trackingNumber != null)
                _InfoRow(label: 'Tracking Number', value: detail.trackingNumber!),
              if (detail.shippedDate != null)
                _InfoRow(
                  label: 'Shipped Date',
                  value: DateFormat('MMM dd, yyyy').format(detail.shippedDate!),
                ),
              if (detail.createdAt != null)
                _InfoRow(
                  label: 'Created',
                  value: DateFormat('MMM dd, yyyy HH:mm').format(detail.createdAt!),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierSection(ShipmentDetail detail) {
    final supplier = detail.supplierInfo;
    if (supplier == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Supplier'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                supplier.supplierName ?? 'Unknown Supplier',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!supplier.isRegisteredSupplier) ...[
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Unregistered Supplier',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.warning,
                  ),
                ),
              ],
              if (supplier.supplierPhone != null ||
                  supplier.supplierEmail != null) ...[
                const SizedBox(height: TossSpacing.space3),
                if (supplier.supplierPhone != null)
                  _InfoRow(label: 'Phone', value: supplier.supplierPhone!),
                if (supplier.supplierEmail != null)
                  _InfoRow(label: 'Email', value: supplier.supplierEmail!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReceivingSummarySection(ShipmentReceivingSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Receiving Summary'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: [
              _InfoRow(
                label: 'Total Shipped',
                value: NumberFormat('#,##0.##').format(summary.totalShipped),
              ),
              _InfoRow(
                label: 'Total Received',
                value: NumberFormat('#,##0.##').format(summary.totalReceived),
                valueColor: TossColors.primary,
              ),
              _InfoRow(
                label: 'Accepted',
                value: NumberFormat('#,##0.##').format(summary.totalAccepted),
                valueColor: TossColors.success,
              ),
              if (summary.totalRejected > 0)
                _InfoRow(
                  label: 'Rejected',
                  value: NumberFormat('#,##0.##').format(summary.totalRejected),
                  valueColor: TossColors.error,
                ),
              _InfoRow(
                label: 'Remaining',
                value: NumberFormat('#,##0.##').format(summary.totalRemaining),
                valueColor: summary.totalRemaining > 0
                    ? TossColors.warning
                    : TossColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(
    ShipmentDetail detail,
    String baseCurrencySymbol,
    String baseCurrencyCode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TradeSectionHeader(title: 'Items', badge: '${detail.items.length}'),
        const SizedBox(height: TossSpacing.space2),
        ...detail.items.map(
          (item) => _ShipmentItemCard(
            item: item,
            currencySymbol: baseCurrencySymbol,
            currencyCode: baseCurrencyCode,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsSection(
    ShipmentDetail detail,
    String baseCurrencySymbol,
    String baseCurrencyCode,
  ) {
    return TradeSimpleCard(
      child: _InfoRow(
        label: 'Total',
        value: '$baseCurrencySymbol ${_formatAmount(detail.totalAmount, baseCurrencyCode)}',
        isBold: true,
      ),
    );
  }

  String _formatAmount(double amount, String currencyCode) {
    final noDecimalCurrencies = ['VND', 'KRW', 'JPY', 'IDR'];
    if (noDecimalCurrencies.contains(currencyCode)) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  Widget _buildLinkedOrdersSection(ShipmentDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TradeSectionHeader(title: 'Linked Orders', badge: '${detail.orderCount}'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: detail.linkedOrders.map((order) {
              return InkWell(
                onTap: () {
                  // Navigate to order detail
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TossSpacing.space2,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: TossSpacing.iconSM,
                        color: TossColors.primary,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderNumber,
                              style: TossTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: TossColors.primary,
                              ),
                            ),
                            if (order.orderDate != null)
                              Text(
                                order.orderDate!,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (order.orderStatus != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: Text(
                            order.orderStatus!,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Notes'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Text(notes, style: TossTextStyles.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    ShipmentDetail detail,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TossButton.destructive(
        text: 'Cancel Shipment',
        onPressed: () => _showCancelConfirmDialog(context, detail),
      ),
    );
  }

  Future<void> _showCancelConfirmDialog(
    BuildContext context,
    ShipmentDetail detail,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Shipment'),
        content: Text(
          'Are you sure you want to cancel shipment ${detail.shipmentNumber}?\n\n'
          'This will also close all linked sessions.',
        ),
        actions: [
          TossButton.textButton(
            text: 'No',
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          TossButton.textButton(
            text: 'Yes, Cancel',
            textColor: TossColors.error,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _closeShipment(detail);
    }
  }

  Future<void> _closeShipment(ShipmentDetail detail) async {
    setState(() => _isClosing = true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final userId = appState.userId;

      if (companyId.isEmpty || userId.isEmpty) {
        if (mounted) {
          TossToast.error(context, 'Invalid session. Please login again.');
        }
        return;
      }

      final useCase = ref.read(closeShipmentUseCaseProvider);
      final result = await useCase(
        shipmentId: detail.shipmentId,
        userId: userId,
        companyId: companyId,
      );

      if (mounted) {
        if (result['success'] == true) {
          final data = result['data'] as Map<String, dynamic>?;
          final shipmentNumber = data?['shipment_number'] as String? ?? detail.shipmentNumber;

          // Show success dialog
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => TossDialog.success(
              title: 'Shipment Cancelled',
              subtitle: shipmentNumber,
              message: 'Shipment has been cancelled successfully.',
              primaryButtonText: 'Done',
              onPrimaryPressed: () => Navigator.of(dialogContext).pop(),
            ),
          );

          // Refresh shipment list
          ref.invalidate(shipmentsWithContextProvider);

          // Navigate back
          if (mounted) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/shipment');
            }
          }
        } else {
          final error = result['error'] as String? ?? 'Failed to cancel shipment';
          // Show error dialog
          await showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) => TossDialog.error(
              title: 'Failed to Cancel',
              message: error,
              primaryButtonText: 'OK',
              onPrimaryPressed: () => Navigator.of(dialogContext).pop(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to cancel shipment: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isClosing = false);
      }
    }
  }
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray600),
          ),
          Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              color: valueColor ?? TossColors.gray900,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShipmentItemCard extends StatelessWidget {
  final ShipmentDetailItem item;
  final String currencySymbol;
  final String currencyCode;

  const _ShipmentItemCard({
    required this.item,
    required this.currencySymbol,
    required this.currencyCode,
  });

  String _formatAmount(double amount) {
    final noDecimalCurrencies = ['VND', 'KRW', 'JPY', 'IDR'];
    if (noDecimalCurrencies.contains(currencyCode)) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final hasReceived = item.quantityReceived > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name with variant
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.effectiveDisplayName,
                      style: TossTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.hasVariants && item.variantName != null)
                      Text(
                        item.variantName!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (item.sku != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              'SKU: ${item.sku}',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ],
          const SizedBox(height: TossSpacing.space2),

          // Quantity info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat('#,##0.##').format(item.quantityShipped)} ${item.unit ?? 'PCS'}',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                'per $currencySymbol ${_formatAmount(item.unitCost)}',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),

          // Receiving progress
          if (hasReceived) ...[
            const SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                const Icon(
                  Icons.inventory_2,
                  size: TossSpacing.iconXS,
                  color: TossColors.success,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  'Received: ${NumberFormat('#,##0.##').format(item.quantityReceived)}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.success,
                  ),
                ),
                if (item.quantityRemaining > 0) ...[
                  const Text(
                    ' | ',
                    style: TextStyle(color: TossColors.gray400),
                  ),
                  Text(
                    'Remaining: ${NumberFormat('#,##0.##').format(item.quantityRemaining)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.warning,
                    ),
                  ),
                ],
              ],
            ),
            if (item.quantityRejected > 0) ...[
              const SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    size: TossSpacing.iconXS,
                    color: TossColors.error,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    'Rejected: ${NumberFormat('#,##0.##').format(item.quantityRejected)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ],

          const SizedBox(height: TossSpacing.space2),

          // Line total
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$currencySymbol ${_formatAmount(item.totalAmount)}',
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
