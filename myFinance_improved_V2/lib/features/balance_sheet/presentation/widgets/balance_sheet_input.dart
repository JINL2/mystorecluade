import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/balance_sheet_providers.dart';

/// Balance Sheet Input Screen
///
/// Shows Store selector, Date selector, and Generate button
/// Matches the UI from lib_old balance_sheet_page.dart
class BalanceSheetInput extends ConsumerWidget {
  final String companyId;
  final VoidCallback onGenerate;

  const BalanceSheetInput({
    super.key,
    required this.companyId,
    required this.onGenerate,
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

          // Date Selector
          _buildDateSelector(context, ref, pageState.dateRange),
          const SizedBox(height: TossSpacing.space6),

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
    String storeName = 'Gangnam Branch'; // Default from app state
    if (selectedStoreId.isEmpty && stores.isNotEmpty) {
      storeName = 'Headquarters';
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
        // TODO: Show store selector bottom sheet
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
    dynamic dateRange,
  ) {
    final startDate = dateRange.startDateFormatted as String;
    final endDate = dateRange.endDateFormatted as String;

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
            // TODO: Show date picker bottom sheet
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
            'Generate Balance Sheet',
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
}
