import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../providers/invoice_list_provider.dart';

/// Today's sales by location bottom sheet
class TodaySalesBottomSheet {
  /// Show today's sales by location
  static void show(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.read(invoiceListProvider);
    final cashLocations = invoiceState.cashLocations;
    final allInvoices = invoiceState.invoices;

    // Filter today's invoices only
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final todayInvoices = allInvoices.where((invoice) {
      return invoice.saleDate
              .isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
          invoice.saleDate.isBefore(todayEnd) &&
          invoice.status == 'completed'; // Only completed invoices
    }).toList();

    // Calculate sales by cash location
    final salesByLocation = <String, double>{};
    final locationNames = <String, String>{};

    // Initialize with all cash locations (including those with 0 sales)
    for (final location in cashLocations) {
      salesByLocation[location.id] = 0.0;
      locationNames[location.id] = location.name;
    }

    // Sum up sales for each location
    for (final invoice in todayInvoices) {
      final locationId = invoice.cashLocation?.cashLocationId;
      if (locationId != null) {
        salesByLocation[locationId] =
            (salesByLocation[locationId] ?? 0.0) + invoice.amounts.totalAmount;
        if (!locationNames.containsKey(locationId)) {
          locationNames[locationId] =
              invoice.cashLocation?.locationName ?? 'Unknown';
        }
      }
    }

    // Calculate total
    final totalSales =
        salesByLocation.values.fold(0.0, (sum, amount) => sum + amount);

    TossBottomSheet.show<void>(
      context: context,
      title: "Today's Sales by Location",
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Total section
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.primary,
                      ),
                    ),
                    Text(
                      _formatCurrency(totalSales),
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Location list
              if (salesByLocation.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  child: Text(
                    'No cash locations available',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                )
              else
                ...salesByLocation.entries.map((entry) {
                  final locationName = locationNames[entry.key] ?? 'Unknown';
                  final amount = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius:
                                  BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: const Icon(
                              Icons.store_outlined,
                              color: TossColors.gray600,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Text(
                              locationName,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w500,
                                color: TossColors.gray900,
                              ),
                            ),
                          ),
                          Text(
                            _formatCurrency(amount),
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: amount > 0
                                  ? TossColors.success
                                  : TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
