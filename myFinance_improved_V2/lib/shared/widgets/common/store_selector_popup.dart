import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_state_provider.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';
import '../../themes/toss_spacing.dart';
import '../toss/toss_bottom_sheet.dart';

/// Store Selector Popup
///
/// Reusable widget for selecting a store from available stores.
/// Can be used across multiple features that require store selection.
class StoreSelectorPopup extends ConsumerWidget {
  final Function(String storeId, String storeName) onStoreSelected;
  final String? currentStoreId;

  const StoreSelectorPopup({
    super.key,
    required this.onStoreSelected,
    this.currentStoreId,
  });

  /// Show the store selector as a bottom sheet
  static Future<void> show(
    BuildContext context, {
    required Function(String storeId, String storeName) onStoreSelected,
    String? currentStoreId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoreSelectorPopup(
        onStoreSelected: onStoreSelected,
        currentStoreId: currentStoreId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    // Get stores from user data in AppState
    final stores = _extractStores(appState.user);

    return TossBottomSheet(
      title: '매장 선택',
      content: stores.isEmpty
          ? _buildEmptyState()
          : _buildStoreList(context, stores),
    );
  }

  List<Map<String, dynamic>> _extractStores(Map<String, dynamic> userData) {
    // Extract stores from user data structure
    // This depends on your actual data structure
    if (userData.isEmpty) return [];

    // Assuming stores are in user['companies'][0]['stores']
    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      final firstCompany = companies[0] as Map<String, dynamic>;
      final stores = firstCompany['stores'] as List<dynamic>?;
      if (stores == null) return [];

      return stores.map((store) => store as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            '등록된 매장이 없습니다',
            style: TossTextStyles.h4.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            '매장을 먼저 등록해주세요',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  Widget _buildStoreList(
    BuildContext context,
    List<Map<String, dynamic>> stores,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(TossSpacing.space4),
      itemCount: stores.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: TossColors.gray200,
      ),
      itemBuilder: (context, index) {
        final store = stores[index];
        final storeId = store['store_id'] as String? ?? '';
        final storeName = store['store_name'] as String? ?? 'Unknown Store';
        final isSelected = storeId == currentStoreId;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? TossColors.primarySurface : TossColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.store,
              color: isSelected ? TossColors.primary : TossColors.gray500,
            ),
          ),
          title: Text(
            storeName,
            style: TossTextStyles.h4.copyWith(
              color: isSelected ? TossColors.primary : TossColors.gray900,
            ),
          ),
          subtitle: store['address'] != null
              ? Text(
                  store['address'] as String,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: TossColors.primary,
                )
              : null,
          onTap: () {
            onStoreSelected(storeId, storeName);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
