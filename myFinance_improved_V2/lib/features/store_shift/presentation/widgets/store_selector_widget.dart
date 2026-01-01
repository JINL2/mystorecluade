import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Store Selector Widget
///
/// A reusable widget for selecting stores from a list.
class StoreSelectorWidget extends ConsumerWidget {
  const StoreSelectorWidget({super.key});

  /// Extract stores from user data for the selected company
  List<dynamic> _extractStores(
      Map<String, dynamic> userData, String selectedCompanyId) {
    if (userData.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      // Find the company that matches the selected company ID
      Map<String, dynamic>? selectedCompany;
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        final companyId = companyMap['company_id'] as String? ?? '';
        if (companyId == selectedCompanyId) {
          selectedCompany = companyMap;
          break;
        }
      }

      // Fallback to first company if selected company not found
      selectedCompany ??= companies[0] as Map<String, dynamic>;

      final stores = selectedCompany['stores'] as List<dynamic>?;
      if (stores == null) return [];

      return stores;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    // Get selected store name from AppState (single source of truth)
    final storeName = appState.storeName.isNotEmpty
        ? appState.storeName
        : 'Select Store';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () async {
            // Extract stores from user data for the currently selected company
            final stores =
                _extractStores(appState.user, appState.companyChoosen);

            // Show store selector using TossSelectionBottomSheet
            final selectedItem =
                await TossSelectionBottomSheet.show<TossSelectionItem>(
              context: context,
              title: 'Select Store',
              items: stores.map((store) {
                final storeMap = store as Map<String, dynamic>;
                return TossSelectionItem.fromStore(storeMap);
              }).toList(),
              selectedId: appState.storeChoosen,
              showSubtitle: false, // Hide store code subtitle
              onItemSelected: (item) {
                // Item will be returned when bottom sheet closes
              },
            );

            // Update app state if store was selected
            if (selectedItem != null && selectedItem.data != null) {
              final storeId = selectedItem.data!['store_id'] as String? ?? '';
              final storeName =
                  selectedItem.data!['store_name'] as String? ?? '';
              ref
                  .read(appStateProvider.notifier)
                  .selectStore(storeId, storeName: storeName);
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray300),
            ),
            child: Row(
              children: [
                Container(
                  width: TossSpacing.iconXL,
                  height: TossSpacing.iconXL,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    LucideIcons.store,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    storeName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  IconMapper.getIcon('chevronDown'),
                  color: TossColors.gray500,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
