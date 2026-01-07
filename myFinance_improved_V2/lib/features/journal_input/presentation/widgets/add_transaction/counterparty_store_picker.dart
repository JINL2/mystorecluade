import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/journal_input_providers.dart';
import 'store_selection_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// A widget for selecting a counterparty's store
///
/// Uses [journalCounterpartyStoresProvider] to load available stores
/// and displays them in a selection sheet.
class CounterpartyStorePicker extends ConsumerWidget {
  final String? linkedCompanyId;
  final String? selectedStoreId;
  final String? selectedStoreName;
  final void Function(String storeId, String storeName) onStoreSelected;
  final VoidCallback? onStoreClear;

  const CounterpartyStorePicker({
    super.key,
    required this.linkedCompanyId,
    this.selectedStoreId,
    this.selectedStoreName,
    required this.onStoreSelected,
    this.onStoreClear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (linkedCompanyId == null) {
      return const SizedBox.shrink();
    }

    final storesAsync = ref.watch(journalCounterpartyStoresProvider(linkedCompanyId));

    return storesAsync.when(
      data: (stores) {
        if (stores.isEmpty) {
          return _buildNoStoresInfo();
        }
        return _buildStorePicker(context, stores);
      },
      loading: () => _buildLoadingState(),
      error: (_, __) => _buildErrorState(),
    );
  }

  Widget _buildNoStoresInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Counterparty Store',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: TossSpacing.iconMD, color: TossColors.gray500),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  'This counterparty has no stores configured',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorePicker(BuildContext context, List<Map<String, dynamic>> stores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Counterparty Store',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        GestureDetector(
          onTap: () {
            StoreSelectionSheet.show(
              context: context,
              stores: stores,
              onStoreSelected: onStoreSelected,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3 + TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  size: TossSpacing.iconMD,
                  color: selectedStoreId != null
                      ? TossColors.primary
                      : TossColors.gray400,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: selectedStoreName != null
                      ? Text(
                          selectedStoreName!,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          'Select counterparty store (optional)',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: selectedStoreId != null
                      ? TossColors.primary
                      : TossColors.gray400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Counterparty Store',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space5),
          child: const Center(
            child: TossLoadingView(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Counterparty Store',
          style: TossTextStyles.body.copyWith(
            color: TossColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Error loading stores',
          style: TossTextStyles.body.copyWith(
            color: TossColors.error,
          ),
        ),
      ],
    );
  }
}
