import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_product.dart';

/// 비정상 재고 알림 카드 위젯
class AbnormalAlertCard extends StatelessWidget {
  final List<InventoryProduct> abnormalProducts;
  final VoidCallback? onViewAll;

  const AbnormalAlertCard({
    super.key,
    required this.abnormalProducts,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (abnormalProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: TossColors.error,
                size: TossSpacing.iconMD2,
              ),
              const SizedBox(width: TossSpacing.gapSM),
              Expanded(
                child: Text(
                  'Abnormal Stock Alert',
                  style: TossTextStyles.subtitle.copyWith(
                    color: TossColors.error,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.gapMD),
          Text(
            '${abnormalProducts.length} products have data issues (negative stock)',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textPrimary,
            ),
          ),
          const SizedBox(height: TossSpacing.gapMD),
          TossButton.destructive(
            text: 'View Abnormal Items',
            fullWidth: true,
            onPressed: onViewAll,
          ),
        ],
      ),
    );
  }
}
