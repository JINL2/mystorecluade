import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/value_objects/date_range.dart';
import '../providers/balance_sheet_providers.dart';

/// Balance Sheet Input Screen
///
/// Shows Store selector, Date selector (optional), and Generate button
/// Balance Sheet (v2) doesn't need date selector - all-time cumulative
/// Income Statement still needs date selector
class BalanceSheetInput extends ConsumerWidget {
  final String companyId;
  final VoidCallback onGenerate;
  final bool showDateSelector;
  final String buttonText;

  const BalanceSheetInput({
    super.key,
    required this.companyId,
    required this.onGenerate,
    this.showDateSelector = false, // Default: no date selector for Balance Sheet v2
    this.buttonText = 'Generate Balance Sheet',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(balanceSheetPageProvider);
    final appState = ref.watch(appStateProvider);
    final storesAsync = ref.watch(storesProvider(companyId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Store Selector
          _buildStoreSelector(context, ref, storesAsync, appState.storeChoosen),
          const SizedBox(height: TossSpacing.space4),

          // Date Selector (only for Income Statement)
          if (showDateSelector) ...[
            _buildDateSelector(context, ref, pageState.dateRange),
            const SizedBox(height: TossSpacing.space6),
          ] else ...[
            const SizedBox(height: TossSpacing.space2),
          ],

          // Generate Button
          _buildGenerateButton(context, onGenerate),
        ],
      ),
    );
  }

  Widget _buildStoreSelector(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Store>> storesAsync,
    String selectedStoreId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        storesAsync.when(
          data: (stores) => _buildStoreCard(context, ref, stores, selectedStoreId),
          loading: () => _buildLoadingCard('Loading stores...'),
          error: (error, _) => _buildErrorCard('Failed to load stores'),
        ),
      ],
    );
  }

  Widget _buildStoreCard(
    BuildContext context,
    WidgetRef ref,
    List<Store> stores,
    String selectedStoreId,
  ) {
    // Get selected store name
    String storeName = 'Select Store';
    if (selectedStoreId.isEmpty && stores.isNotEmpty) {
      storeName = 'All Stores (Headquarters)';
    } else if (selectedStoreId.isNotEmpty) {
      try {
        final store = stores.firstWhere((s) => s.id == selectedStoreId);
        storeName = store.storeName;
      } catch (e) {
        storeName = 'Select Store';
      }
    }

    return InkWell(
      onTap: () {
        _showStoreSelector(context, ref, stores, selectedStoreId);
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: Border.all(
            color: selectedStoreId.isNotEmpty
                ? TossColors.primary.withOpacity(0.3)
                : TossColors.gray200,
            width: selectedStoreId.isNotEmpty ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Store Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                selectedStoreId.isEmpty ? Icons.business_outlined : Icons.store_outlined,
                color: TossColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Store Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Store',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    storeName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    WidgetRef ref,
    DateRange dateRange,
  ) {
    final startDate = dateRange.startDateFormatted;
    final endDate = dateRange.endDateFormatted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Period',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),

        InkWell(
          onTap: () {
            _showDateRangePicker(context, ref, dateRange);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.primary.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Calendar Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: TossColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),

                // Date Range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Range',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$startDate ~ $endDate',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.chevron_right,
                  color: TossColors.gray400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context, VoidCallback onGenerate) {
    return ElevatedButton(
      onPressed: onGenerate,
      style: ElevatedButton.styleFrom(
        backgroundColor: TossColors.primary,
        foregroundColor: TossColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 20),
          const SizedBox(width: TossSpacing.space2),
          Text(
            buttonText,
            style: TossTextStyles.button,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(String message) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              message,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.errorLight,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: TossColors.error, size: 20),
          const SizedBox(width: TossSpacing.space2),
          Text(
            message,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ),
    );
  }

  /// Show store selector bottom sheet
  void _showStoreSelector(
    BuildContext context,
    WidgetRef ref,
    List<Store> stores,
    String selectedStoreId,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: TossSpacing.space3),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Text(
                  'Select Store',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Divider(height: 1, color: TossColors.gray200),

              // Store list
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // All Stores (Headquarters) option
                    _buildStoreOption(
                      context,
                      ref,
                      storeId: '',
                      storeName: 'All Stores (Headquarters)',
                      isSelected: selectedStoreId.isEmpty,
                    ),

                    // Individual stores
                    ...stores.map((store) => _buildStoreOption(
                          context,
                          ref,
                          storeId: store.id,
                          storeName: store.storeName,
                          isSelected: selectedStoreId == store.id,
                        ),),
                  ],
                ),
              ),

              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        );
      },
    );
  }

  /// Show date range picker bottom sheet
  void _showDateRangePicker(
    BuildContext context,
    WidgetRef ref,
    DateRange currentDateRange,
  ) {
    // Use device's local time for initial dates
    DateTime tempStartDate = currentDateRange.startDate;
    DateTime tempEndDate = currentDateRange.endDate;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: TossSpacing.space3),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: TossColors.gray300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Text(
                        'Select Period',
                        style: TossTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Divider(height: 1, color: TossColors.gray200),

                    // Date Selection Cards
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        children: [
                          // Start Date
                          _buildDatePickerCard(
                            context: context,
                            label: 'Start Date',
                            date: tempStartDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: TossColors.primary,
                                        onPrimary: TossColors.white,
                                        surface: TossColors.background,
                                        onSurface: TossColors.gray900,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  tempStartDate = picked;
                                  // Ensure end date is not before start date
                                  if (tempEndDate.isBefore(tempStartDate)) {
                                    tempEndDate = tempStartDate;
                                  }
                                });
                              }
                            },
                          ),

                          const SizedBox(height: TossSpacing.space3),

                          // End Date
                          _buildDatePickerCard(
                            context: context,
                            label: 'End Date',
                            date: tempEndDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempEndDate,
                                firstDate: tempStartDate,
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: TossColors.primary,
                                        onPrimary: TossColors.white,
                                        surface: TossColors.background,
                                        onSurface: TossColors.gray900,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  tempEndDate = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Quick Selection Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildQuickSelectButton(
                              context: context,
                              label: 'This Month',
                              onTap: () {
                                final now = DateTime.now();
                                setState(() {
                                  tempStartDate = DateTime(now.year, now.month, 1);
                                  tempEndDate = DateTime(now.year, now.month + 1, 0);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: _buildQuickSelectButton(
                              context: context,
                              label: 'Last Month',
                              onTap: () {
                                final now = DateTime.now();
                                setState(() {
                                  tempStartDate = DateTime(now.year, now.month - 1, 1);
                                  tempEndDate = DateTime(now.year, now.month, 0);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: _buildQuickSelectButton(
                              context: context,
                              label: 'This Year',
                              onTap: () {
                                final now = DateTime.now();
                                setState(() {
                                  tempStartDate = DateTime(now.year, 1, 1);
                                  tempEndDate = now;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space4),

                    // Apply Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Update the date range in provider using device's local time
                            final newDateRange = DateRange(
                              startDate: tempStartDate,
                              endDate: tempEndDate,
                            );
                            ref.read(balanceSheetPageProvider.notifier).changeDateRange(newDateRange);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            foregroundColor: TossColors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: TossTextStyles.button,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Build date picker card widget
  Widget _buildDatePickerCard({
    required BuildContext context,
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: TossColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Build quick select button widget
  Widget _buildQuickSelectButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: TossColors.primary,
        side: const BorderSide(color: TossColors.gray300),
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space2,
          horizontal: TossSpacing.space2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Build store option item
  Widget _buildStoreOption(
    BuildContext context,
    WidgetRef ref, {
    required String storeId,
    required String storeName,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        // Update app state with selected store
        ref.read(appStateProvider.notifier).selectStore(
          storeId,
          storeName: storeName,
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Store icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.1)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                storeId.isEmpty ? Icons.business_outlined : Icons.store_outlined,
                color: isSelected ? TossColors.primary : TossColors.gray500,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Store name
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                ),
              ),
            ),

            // Selected indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: TossColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
