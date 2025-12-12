import 'package:flutter/material.dart';

import '../../../../../../../core/constants/ui_constants.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../widgets/toss/toss_card.dart';

/// Store selector widget for Cash Ending page
/// FROM PRODUCTION LINES 1315-1441
class StoreSelector extends StatelessWidget {
  final List<Map<String, dynamic>> stores;
  final String? selectedStoreId;
  final VoidCallback onTap;

  const StoreSelector({
    super.key,
    required this.stores,
    required this.selectedStoreId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildStoreSelector();
  }

  Widget _buildStoreSelector() {
    // If no stores available
    if (stores.isEmpty) {
      return TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        backgroundColor: TossColors.gray50,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                color: TossColors.gray500,
                size: 24,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'No stores available',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    // Get selected store name
    String storeName = 'Select Store';
    if (selectedStoreId == 'headquarter') {
      storeName = 'Headquarter';
    } else if (selectedStoreId != null) {
      try {
        final store = stores.firstWhere(
          (s) => s['store_id'] == selectedStoreId,
        );
        storeName = store['store_name']?.toString() ?? 'Unknown Store';
      } catch (e) {
        // Store not found in the list
        storeName = 'Select Store';
      }
    }
    
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: UIConstants.avatarSizeSmall,
                  height: UIConstants.avatarSizeSmall,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    TossIcons.getStoreIcon(selectedStoreId == 'headquarter' ? 'headquarter' : 'store'),
                    size: UIConstants.iconSizeMedium,
                    color: TossColors.primary,
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
                const Icon(
                  TossIcons.forward,
                  color: TossColors.gray400,
                  size: UIConstants.iconSizeLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}