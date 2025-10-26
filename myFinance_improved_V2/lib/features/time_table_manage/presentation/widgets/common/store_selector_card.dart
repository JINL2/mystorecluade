import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Store Selector Card
///
/// Card widget for selecting a store from available stores
class StoreSelectorCard extends StatelessWidget {
  final String? selectedStoreId;
  final List<dynamic> stores;
  final VoidCallback onTap;

  const StoreSelectorCard({
    super.key,
    required this.selectedStoreId,
    required this.stores,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedStoreName = stores.firstWhere(
      (store) => store['store_id'] == selectedStoreId,
      orElse: () => {'store_name': 'Select Store'},
    )['store_name'] as String? ?? 'Select Store';

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space5),
      child: InkWell(
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.store_outlined,
                  size: 20,
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
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
                      selectedStoreName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: TossColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
