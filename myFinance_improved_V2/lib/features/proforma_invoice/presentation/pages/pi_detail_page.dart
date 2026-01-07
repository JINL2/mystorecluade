import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../../trade_shared/presentation/services/trade_pdf_service.dart';
import '../../../trade_shared/presentation/widgets/trade_amount_display.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';
import '../../domain/entities/proforma_invoice.dart';
import '../providers/pi_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class PIDetailPage extends ConsumerStatefulWidget {
  final String piId;

  const PIDetailPage({super.key, required this.piId});

  @override
  ConsumerState<PIDetailPage> createState() => _PIDetailPageState();
}

class _PIDetailPageState extends ConsumerState<PIDetailPage> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(piDetailProvider.notifier).load(widget.piId);
    });
  }

  void _markAsChanged() {
    _hasChanges = true;
    // 리스트를 바로 새로고침하여 UI에 상태 변경 반영
    ref.read(piListProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(piDetailProvider);

    return TossScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(_hasChanges);
            } else {
              context.go('/proforma-invoice');
            }
          },
        ),
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
              if (state.pi?.status == PIStatus.sent)
                const PopupMenuItem(
                  value: 'accept',
                  child: Text('Mark as Accepted', style: TextStyle(color: TossColors.success)),
                ),
              if (state.pi?.status == PIStatus.sent)
                const PopupMenuItem(
                  value: 'reject',
                  child: Text('Mark as Rejected', style: TextStyle(color: TossColors.error)),
                ),
              const PopupMenuItem(value: 'share_pdf', child: Text('Share PDF')),
              const PopupMenuItem(value: 'print', child: Text('Print')),
              const PopupMenuDivider(),
              if (state.pi?.canConvertToPO == true)
                const PopupMenuItem(value: 'convert', child: Text('Convert to PO')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              if (state.pi?.isEditable == true)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: TossColors.error)),
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
      return const TossLoadingView();
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: TossSpacing.iconXXL, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(state.error!, style: TossTextStyles.bodyMedium),
            TossButton.textButton(
              text: 'Retry',
              onPressed: () =>
                  ref.read(piDetailProvider.notifier).load(widget.piId),
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
              size: TossSpacing.iconSM2,
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
                    .copyWith(fontWeight: TossFontWeight.semibold),
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
    // Get exchange rate data
    final exchangeRateAsync = ref.watch(tradeExchangeRateProvider(pi.companyId));

    return exchangeRateAsync.when(
      loading: () => _buildItemsSectionContent(pi, null),
      error: (_, __) => _buildItemsSectionContent(pi, null),
      data: (exchangeRateData) => _buildItemsSectionContent(pi, exchangeRateData),
    );
  }

  Widget _buildItemsSectionContent(ProformaInvoice pi, TradeExchangeRateData? exchangeRateData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TradeSectionHeader(title: 'Items', badge: '${pi.items.length}'),
        const SizedBox(height: TossSpacing.space2),
        ...pi.items.map((item) => _ItemCard(
              item: item,
              currencyCode: pi.currencyCode,
              exchangeRateData: exchangeRateData,
            )),
      ],
    );
  }

  Widget _buildTotalsSection(ProformaInvoice pi) {
    // Get exchange rate data
    final exchangeRateAsync = ref.watch(tradeExchangeRateProvider(pi.companyId));

    return exchangeRateAsync.when(
      loading: () => _buildTotalsSectionContent(pi, null),
      error: (_, __) => _buildTotalsSectionContent(pi, null),
      data: (exchangeRateData) => _buildTotalsSectionContent(pi, exchangeRateData),
    );
  }

  Widget _buildTotalsSectionContent(ProformaInvoice pi, TradeExchangeRateData? exchangeRateData) {
    // Calculate converted amounts if exchange rate is available
    final baseCurrency = exchangeRateData?.baseCurrencyCode;
    final showDualCurrency = baseCurrency != null && baseCurrency != pi.currencyCode;
    final rate = exchangeRateData?.getRate(pi.currencyCode);

    double? convertedSubtotal;
    double? convertedDiscount;
    double? convertedTotal;

    if (showDualCurrency && rate != null) {
      convertedSubtotal = pi.subtotal * rate;
      convertedDiscount = pi.discountAmount * rate;
      convertedTotal = pi.totalAmount * rate;
    }

    return TradeSimpleCard(
      child: Column(
        children: [
          TradeDualCurrencyInfoRow(
            label: 'Subtotal',
            primaryCurrency: pi.currencyCode,
            primaryAmount: pi.subtotal,
            secondaryCurrency: baseCurrency,
            secondaryAmount: convertedSubtotal,
          ),
          if (pi.discountAmount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discount',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '-${pi.currencyCode} ${_formatAmount(pi.discountAmount)}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.success,
                          fontWeight: TossFontWeight.semibold,
                        ),
                      ),
                      if (showDualCurrency && convertedDiscount != null)
                        Text(
                          '≈ -${exchangeRateData!.baseCurrencySymbol}${_formatAmountForCurrency(convertedDiscount, baseCurrency!)}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          const Divider(height: TossSpacing.space4),
          TradeDualCurrencyInfoRow(
            label: 'Total',
            primaryCurrency: pi.currencyCode,
            primaryAmount: pi.totalAmount,
            secondaryCurrency: baseCurrency,
            secondaryAmount: convertedTotal,
            highlight: true,
          ),
          // Show exchange rate info
          if (showDualCurrency && rate != null)
            Padding(
              padding: const EdgeInsets.only(
                top: TossSpacing.space2,
                right: TossSpacing.space3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.info_outline, size: TossSpacing.iconXXS, color: TossColors.gray400),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    'Rate: 1 ${pi.currencyCode} = ${_formatAmountForCurrency(rate, baseCurrency!)} $baseCurrency',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
                ],
              ),
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

  String _formatAmountForCurrency(double amount, String currency) {
    final noDecimalCurrencies = ['VND', 'KRW', 'JPY', 'IDR'];
    if (noDecimalCurrencies.contains(currency)) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  Future<void> _handleMenuAction(String action, ProformaInvoice? pi) async {
    if (pi == null) return;

    switch (action) {
      case 'send':
        // Show option to share PDF before marking as sent
        final shareOption = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Send to Buyer'),
            content: const Text(
              'Would you like to generate a PDF and share it with the buyer?',
            ),
            actions: [
              TossButton.textButton(
                text: 'Skip PDF',
                onPressed: () => Navigator.pop(context, 'skip'),
              ),
              TossButton.textButton(
                text: 'Share PDF',
                onPressed: () => Navigator.pop(context, 'share'),
              ),
            ],
          ),
        );

        if (shareOption == 'share') {
          await _generateAndSharePdf(pi);
        }

        // Mark as sent
        await ref.read(piDetailProvider.notifier).send();
        if (mounted) {
          _markAsChanged();
          TossToast.success(context, 'PI sent successfully');
        }
        break;

      case 'accept':
        final confirmAccept = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Accept PI'),
            content: const Text(
              'Mark this PI as accepted by the buyer? You can then convert it to a Purchase Order.',
            ),
            actions: [
              TossButton.textButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context, false),
              ),
              TossButton.textButton(
                text: 'Accept',
                textColor: TossColors.success,
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );

        if (confirmAccept == true) {
          // Show loading
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    TossLoadingView.inline(size: TossSpacing.iconMD, color: TossColors.white),
                    const SizedBox(width: TossSpacing.space3),
                    const Text('Processing...'),
                  ],
                ),
                duration: const Duration(seconds: 10),
              ),
            );
          }

          await ref.read(piDetailProvider.notifier).accept();

          // Check for errors
          final detailState = ref.read(piDetailProvider);
          if (mounted) {
            TossToast.hide(context);
            if (detailState.error != null) {
              TossToast.error(context, 'Error: ${detailState.error}');
            } else {
              _markAsChanged();
              TossToast.success(context, 'PI marked as Accepted!');
            }
          }
        }
        break;

      case 'reject':
        final rejectReason = await showDialog<String>(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              title: const Text('Reject PI'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please provide a reason for rejection (optional):'),
                  const SizedBox(height: TossSpacing.space4),
                  TossTextField.filled(
                    controller: controller,
                    maxLines: 3,
                    hintText: 'Enter rejection reason...',
                  ),
                ],
              ),
              actions: [
                TossButton.secondary(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context, null),
                ),
                TossButton.primary(
                  text: 'Reject',
                  onPressed: () => Navigator.pop(context, controller.text),
                  backgroundColor: TossColors.error,
                ),
              ],
            );
          },
        );

        if (rejectReason != null) {
          // Show loading
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    TossLoadingView.inline(size: TossSpacing.iconMD, color: TossColors.white),
                    const SizedBox(width: TossSpacing.space3),
                    const Text('Processing...'),
                  ],
                ),
                duration: const Duration(seconds: 10),
              ),
            );
          }

          await ref.read(piDetailProvider.notifier).reject(rejectReason.isNotEmpty ? rejectReason : null);

          // Check for errors
          final detailState = ref.read(piDetailProvider);
          if (mounted) {
            TossToast.hide(context);
            if (detailState.error != null) {
              TossToast.error(context, 'Error: ${detailState.error}');
            } else {
              _markAsChanged();
              TossToast.warning(context, 'PI marked as Rejected');
            }
          }
        }
        break;

      case 'share_pdf':
        await _generateAndSharePdf(pi);
        break;

      case 'print':
        await _generateAndPrintPdf(pi);
        break;

      case 'convert':
        final poId = await ref.read(piDetailProvider.notifier).convertToPO();
        if (mounted && poId != null) {
          TossToast.success(context, 'Converted to PO');
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
              TossButton.textButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context, false),
              ),
              TossButton.textButton(
                text: 'Delete',
                textColor: TossColors.error,
                onPressed: () => Navigator.pop(context, true),
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

  Future<void> _generateAndSharePdf(ProformaInvoice pi) async {
    try {
      // Show loading indicator
      if (mounted) {
        TossToast.info(context, 'Generating PDF...');
      }

      // Generate PDF
      final pdfBytes = await TradePdfService.generateProformaInvoicePdf(pi);

      // Share PDF
      await TradePdfService.sharePdf(pdfBytes, '${pi.piNumber}.pdf');
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to generate PDF: $e');
      }
    }
  }

  Future<void> _generateAndPrintPdf(ProformaInvoice pi) async {
    try {
      // Show loading indicator
      if (mounted) {
        TossToast.info(context, 'Preparing print...');
      }

      // Generate PDF
      final pdfBytes = await TradePdfService.generateProformaInvoicePdf(pi);

      // Print PDF
      await TradePdfService.printPdf(pdfBytes);
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to print: $e');
      }
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
              fontWeight: isBold ? TossFontWeight.semibold : TossFontWeight.regular,
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
          fontWeight: TossFontWeight.semibold,
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
  final TradeExchangeRateData? exchangeRateData;

  const _ItemCard({
    required this.item,
    required this.currencyCode,
    this.exchangeRateData,
  });

  String _formatAmountForCurrency(double amount, String currency) {
    final noDecimalCurrencies = ['VND', 'KRW', 'JPY', 'IDR'];
    if (noDecimalCurrencies.contains(currency)) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate converted amount
    final baseCurrency = exchangeRateData?.baseCurrencyCode;
    final showDualCurrency = baseCurrency != null && baseCurrency != currencyCode;
    final rate = exchangeRateData?.getRate(currencyCode);
    final convertedTotal = showDualCurrency && rate != null ? item.lineTotal * rate : null;

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
          // Description
          Text(
            item.description,
            style: TossTextStyles.bodyMedium.copyWith(fontWeight: TossFontWeight.medium),
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
          // Line total with dual currency
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currencyCode ${NumberFormat('#,##0.00').format(item.lineTotal)}',
                    style: TossTextStyles.bodyMedium.copyWith(fontWeight: TossFontWeight.semibold),
                  ),
                  if (showDualCurrency && convertedTotal != null)
                    Text(
                      '≈ ${exchangeRateData!.baseCurrencySymbol}${_formatAmountForCurrency(convertedTotal, baseCurrency!)}',
                      style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
