import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../extensions/invoice_period_extension.dart';
import '../../providers/invoice_list_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Filter bottom sheets helper class
class InvoiceFilterBottomSheets {
  /// Show period filter bottom sheet
  static void showPeriodFilter(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.read(invoiceListNotifierProvider);

    TossBottomSheet.show<void>(
      context: context,
      title: 'Filter by Period',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: InvoicePeriod.values.map((period) {
            final isSelected = invoiceState.selectedPeriod == period;
            return ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              title: Text(
                period.displayName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: TossColors.primary, size: TossSpacing.iconMD)
                  : null,
              onTap: () {
                ref.read(invoiceListNotifierProvider.notifier).updatePeriod(period);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Show status filter bottom sheet
  static void showStatusFilter(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.read(invoiceListNotifierProvider);
    final selectedStatus = invoiceState.selectedStatus;

    TossBottomSheet.show<void>(
      context: context,
      title: 'Filter by Status',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // All option
            _buildStatusOption(
              context,
              ref,
              label: 'All',
              value: null,
              selectedStatus: selectedStatus,
            ),
            // Completed option
            _buildStatusOption(
              context,
              ref,
              label: 'Completed',
              value: 'completed',
              selectedStatus: selectedStatus,
            ),
            // Cancelled/Refunded option
            _buildStatusOption(
              context,
              ref,
              label: 'Refunded',
              value: 'cancelled',
              selectedStatus: selectedStatus,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusOption(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String? value,
    required String? selectedStatus,
  }) {
    final isSelected = selectedStatus == value;
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: TossColors.primary, size: TossSpacing.iconMD)
          : null,
      onTap: () {
        ref.read(invoiceListNotifierProvider.notifier).updateStatus(value);
        Navigator.pop(context);
      },
    );
  }

  /// Show cash location filter bottom sheet
  static void showCashLocationFilter(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.read(invoiceListNotifierProvider);
    final cashLocations = invoiceState.cashLocations;
    final selectedCashLocation = invoiceState.selectedCashLocation;

    TossBottomSheet.show<void>(
      context: context,
      title: 'Filter by Location',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "All Locations" option
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'All Locations',
                style: TossTextStyles.body.copyWith(
                  fontWeight:
                      selectedCashLocation == null ? TossFontWeight.semibold : TossFontWeight.regular,
                  color: selectedCashLocation == null
                      ? TossColors.primary
                      : TossColors.gray900,
                ),
              ),
              trailing: selectedCashLocation == null
                  ? Icon(Icons.check, color: TossColors.primary, size: TossSpacing.iconMD)
                  : null,
              onTap: () {
                ref.read(invoiceListNotifierProvider.notifier).clearCashLocationFilter();
                Navigator.pop(context);
              },
            ),
            // Cash location options
            ...cashLocations.map((location) {
              final isSelected = selectedCashLocation?.id == location.id;
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  location.name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                  ),
                ),
                subtitle: Text(
                  location.type.toUpperCase(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: TossColors.primary, size: TossSpacing.iconMD)
                    : null,
                onTap: () {
                  ref.read(invoiceListNotifierProvider.notifier).updateCashLocation(location);
                  Navigator.pop(context);
                },
              );
            }),
            // Loading indicator
            if (invoiceState.isLoadingCashLocations)
              const Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: TossLoadingView(),
              ),
            // Empty state
            if (!invoiceState.isLoadingCashLocations && cashLocations.isEmpty)
              Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Text(
                  'No cash locations available',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Show generic filter bottom sheet (placeholder)
  static void showGenericFilter(BuildContext context, String filterType) {
    TossBottomSheet.show<void>(
      context: context,
      title: filterType,
      content: Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Text(
            'Filter by $filterType coming soon',
            style: TossTextStyles.body.copyWith(color: TossColors.gray600),
          ),
        ),
      ),
    );
  }
}
