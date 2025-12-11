import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/constants/ui_constants.dart';

/// Store selector bottom sheet for Cash Ending page
/// FROM PRODUCTION LINES 4148-4392
class StoreSelectorSheet {
  
  /// Show store selector bottom sheet
  /// FROM PRODUCTION LINES 4148-4392
  static void showStoreSelector({
    required BuildContext context,
    required WidgetRef ref,
    required List<Map<String, dynamic>> stores,
    required String? selectedStoreId,
    required dynamic appStateProvider,
    required Function(String storeId) onStoreSelected,
    required Future<void> Function(String) fetchLocations,
    required VoidCallback refreshData,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: UIConstants.modalDragHandleWidth,
              height: UIConstants.modalDragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray600,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Text(
                    'Select Store',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Store list
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length + 1, // +1 for Headquarter
                itemBuilder: (context, index) {
                  // First item is Headquarter
                  if (index == 0) {
                    final isSelected = selectedStoreId == 'headquarter';
                    return InkWell(
                      onTap: () async {
                        HapticFeedback.selectionClick();
                        Navigator.pop(context);
                        
                        onStoreSelected('headquarter');
                        
                        // Fetch cash locations for headquarter
                        await fetchLocations('cash');
                        await fetchLocations('bank');
                        await fetchLocations('vault');
                        
                        // Refresh data
                        refreshData();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space5,
                          vertical: TossSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.transparent,
                          border: const Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray50,
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                              child: Icon(
                                TossIcons.business,
                                size: 20,
                                color: isSelected ? TossColors.primary : TossColors.gray500,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Headquarter',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Company Level',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                size: 20,
                                color: TossColors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  // Regular stores (adjust index by -1)
                  final store = stores[index - 1];
                  final isSelected = store['store_id'] == selectedStoreId;
                  
                  return InkWell(
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      
                      onStoreSelected(store['store_id']);
                      
                      // Update app state with the new store selection
                      await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
                      
                      // Fetch locations for the new store
                      await fetchLocations('cash');
                      await fetchLocations('bank');
                      await fetchLocations('vault');
                      
                      // Refresh data for the new store
                      refreshData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: index == stores.length ? 0 : 0.5, // Adjusted for +1 Headquarter
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray50,
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Icon(
                              TossIcons.store,
                              size: 20,
                              color: isSelected ? TossColors.primary : TossColors.gray500,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store['store_name'] ?? 'Unknown Store',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                if (store['store_code'] != null)
                                  Text(
                                    'Code: ${store['store_code']}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              size: 20,
                              color: TossColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }
}