import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';
import '../../domain/entities/proforma_invoice.dart';
import '../providers/pi_providers.dart';

class PIDetailPage extends ConsumerStatefulWidget {
  final String piId;

  const PIDetailPage({super.key, required this.piId});

  @override
  ConsumerState<PIDetailPage> createState() => _PIDetailPageState();
}

class _PIDetailPageState extends ConsumerState<PIDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(piDetailProvider.notifier).load(widget.piId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(piDetailProvider);

    return TossScaffold(
      appBar: AppBar(
        title: Text(state.pi?.piNumber ?? 'PI Detail'),
        actions: [
          if (state.pi != null && state.pi!.isEditable)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('/proforma-invoice/${widget.piId}/edit'),
            ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, state.pi),
            itemBuilder: (context) => [
              if (state.pi?.canSend == true)
                const PopupMenuItem(value: 'send', child: Text('Send to Buyer')),
              if (state.pi?.canConvertToPO == true)
                const PopupMenuItem(value: 'convert', child: Text('Convert to PO')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              if (state.pi?.isEditable == true)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PIDetailState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(state.error!, style: TossTextStyles.bodyMedium),
            TextButton(
              onPressed: () =>
                  ref.read(piDetailProvider.notifier).load(widget.piId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final pi = state.pi;
    if (pi == null) {
      return const Center(child: Text('PI not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status & Actions
          _buildStatusSection(pi),
          const SizedBox(height: TossSpacing.space5),

          // Basic Info
          _buildBasicInfoSection(pi),
          const SizedBox(height: TossSpacing.space5),

          // Buyer Info
          _buildCounterpartySection(pi),
          const SizedBox(height: TossSpacing.space5),

          // Shipping Info
          _buildShippingSection(pi),
          const SizedBox(height: TossSpacing.space5),

          // Items
          _buildItemsSection(pi),
          const SizedBox(height: TossSpacing.space5),

          // Totals
          _buildTotalsSection(pi),
          const SizedBox(height: TossSpacing.space5),

          // Notes
          if (pi.notes != null || pi.termsAndConditions != null)
            _buildNotesSection(pi),

          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  Widget _buildStatusSection(ProformaInvoice pi) {
    return TradeSimpleCard(
      child: Row(
        children: [
          _StatusBadge(status: pi.status),
          const Spacer(),
          if (pi.validityDate != null) ...[
            Icon(
              Icons.schedule,
              size: 16,
              color: pi.isExpired ? TossColors.error : TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              pi.isExpired
                  ? 'Expired'
                  : 'Valid until ${DateFormat('MMM dd, yyyy').format(pi.validityDate!)}',
              style: TossTextStyles.caption.copyWith(
                color: pi.isExpired ? TossColors.error : TossColors.gray600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(ProformaInvoice pi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Basic Information'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: [
              _InfoRow(label: 'PI Number', value: pi.piNumber),
              if (pi.createdAtUtc != null)
                _InfoRow(
                  label: 'Date',
                  value: DateFormat('MMM dd, yyyy').format(pi.createdAtUtc!),
                ),
              _InfoRow(label: 'Currency', value: pi.currencyCode),
              if (pi.incotermsCode != null)
                _InfoRow(
                  label: 'Incoterms',
                  value:
                      '${pi.incotermsCode}${pi.incotermsPlace != null ? ' - ${pi.incotermsPlace}' : ''}',
                ),
              if (pi.paymentTermsCode != null)
                _InfoRow(
                  label: 'Payment Terms',
                  value: pi.paymentTermsCode!,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterpartySection(ProformaInvoice pi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Counterparty'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pi.counterpartyName ?? 'Unknown Counterparty',
                style: TossTextStyles.bodyLarge
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              if (pi.counterpartyInfo != null && pi.counterpartyInfo!.isNotEmpty) ...[
                const SizedBox(height: TossSpacing.space2),
                Text(
                  _formatCounterpartyInfo(pi.counterpartyInfo!),
                  style: TossTextStyles.bodyMedium
                      .copyWith(color: TossColors.gray600),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatCounterpartyInfo(Map<String, dynamic> counterpartyInfo) {
    final parts = <String>[];
    if (counterpartyInfo['address'] != null) parts.add(counterpartyInfo['address'].toString());
    if (counterpartyInfo['city'] != null) parts.add(counterpartyInfo['city'].toString());
    if (counterpartyInfo['country'] != null) parts.add(counterpartyInfo['country'].toString());
    return parts.join(', ');
  }

  Widget _buildShippingSection(ProformaInvoice pi) {
    final hasShippingInfo = pi.portOfLoading != null ||
        pi.portOfDischarge != null ||
        pi.finalDestination != null ||
        pi.shippingMethodCode != null;

    if (!hasShippingInfo) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Shipping'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: [
              if (pi.portOfLoading != null)
                _InfoRow(label: 'Port of Loading', value: pi.portOfLoading!),
              if (pi.portOfDischarge != null)
                _InfoRow(label: 'Port of Discharge', value: pi.portOfDischarge!),
              if (pi.finalDestination != null)
                _InfoRow(label: 'Final Destination', value: pi.finalDestination!),
              if (pi.shippingMethodCode != null)
                _InfoRow(label: 'Shipping Method', value: pi.shippingMethodCode!),
              if (pi.estimatedShipmentDate != null)
                _InfoRow(
                  label: 'Est. Shipment Date',
                  value: DateFormat('MMM dd, yyyy').format(pi.estimatedShipmentDate!),
                ),
              _InfoRow(
                label: 'Partial Shipment',
                value: pi.partialShipmentAllowed ? 'Allowed' : 'Not Allowed',
              ),
              _InfoRow(
                label: 'Transshipment',
                value: pi.transshipmentAllowed ? 'Allowed' : 'Not Allowed',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(ProformaInvoice pi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TradeSectionHeader(title: 'Items', badge: '${pi.items.length}'),
        const SizedBox(height: TossSpacing.space2),
        ...pi.items
            .map((item) => _ItemCard(item: item, currencyCode: pi.currencyCode)),
      ],
    );
  }

  Widget _buildTotalsSection(ProformaInvoice pi) {
    return TradeSimpleCard(
      child: Column(
        children: [
          _InfoRow(
            label: 'Subtotal',
            value: '${pi.currencyCode} ${_formatAmount(pi.subtotal)}',
          ),
          if (pi.discountAmount > 0)
            _InfoRow(
              label: 'Discount',
              value: '-${pi.currencyCode} ${_formatAmount(pi.discountAmount)}',
              valueColor: TossColors.success,
            ),
          const Divider(height: TossSpacing.space4),
          _InfoRow(
            label: 'Total',
            value: '${pi.currencyCode} ${_formatAmount(pi.totalAmount)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(ProformaInvoice pi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Notes & Terms'),
        const SizedBox(height: TossSpacing.space2),
        if (pi.notes != null)
          TradeSimpleCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes',
                    style: TossTextStyles.caption
                        .copyWith(color: TossColors.gray500)),
                const SizedBox(height: TossSpacing.space1),
                Text(pi.notes!, style: TossTextStyles.bodyMedium),
              ],
            ),
          ),
        if (pi.termsAndConditions != null) ...[
          const SizedBox(height: TossSpacing.space3),
          TradeSimpleCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Terms & Conditions',
                    style: TossTextStyles.caption
                        .copyWith(color: TossColors.gray500)),
                const SizedBox(height: TossSpacing.space1),
                Text(pi.termsAndConditions!, style: TossTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }

  Future<void> _handleMenuAction(String action, ProformaInvoice? pi) async {
    if (pi == null) return;

    switch (action) {
      case 'send':
        await ref.read(piDetailProvider.notifier).send();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PI sent successfully')),
          );
        }
        break;

      case 'convert':
        final poId = await ref.read(piDetailProvider.notifier).convertToPO();
        if (mounted && poId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Converted to PO')),
          );
          context.go('/purchase-order/$poId');
        }
        break;

      case 'duplicate':
        final newPi = await ref.read(piDetailProvider.notifier).duplicate();
        if (mounted && newPi != null) {
          context.go('/proforma-invoice/${newPi.id}');
        }
        break;

      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete PI?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final success = await ref.read(piFormProvider.notifier).delete(pi.id);
          if (mounted && success) {
            context.go('/proforma-invoice');
          }
        }
        break;
    }
  }
}

/// Simple info row widget for displaying label-value pairs
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

class _StatusBadge extends StatelessWidget {
  final PIStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        label,
        style: TossTextStyles.bodyMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusStyle() {
    switch (status) {
      case PIStatus.draft:
        return (TossColors.gray700, TossColors.gray100, 'Draft');
      case PIStatus.sent:
        return (TossColors.primary, TossColors.primarySurface, 'Sent');
      case PIStatus.negotiating:
        return (TossColors.warning, TossColors.warningLight, 'Negotiating');
      case PIStatus.accepted:
        return (TossColors.success, TossColors.successLight, 'Accepted');
      case PIStatus.rejected:
        return (TossColors.error, TossColors.errorLight, 'Rejected');
      case PIStatus.expired:
        return (TossColors.gray500, TossColors.gray100, 'Expired');
      case PIStatus.converted:
        return (TossColors.info, TossColors.infoLight, 'Converted to PO');
    }
  }
}

class _ItemCard extends StatelessWidget {
  final PIItem item;
  final String currencyCode;

  const _ItemCard({required this.item, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            item.description,
            style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          if (item.sku != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              'SKU: ${item.sku}',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ],
          const SizedBox(height: TossSpacing.space2),
          // Quantity & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat('#,##0.##').format(item.quantity)} ${item.unit ?? 'PCS'}',
                style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
              ),
              Text(
                '@ $currencyCode ${NumberFormat('#,##0.00').format(item.unitPrice)}',
                style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          // Line total
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$currencyCode ${NumberFormat('#,##0.00').format(item.lineTotal)}',
                style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
