import 'package:flutter/material.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Store Info Card Widget
///
/// Displays store information with edit action.
/// Feature-specific widget for store_shift.
class StoreInfoCard extends StatelessWidget {
  final Map<String, dynamic> store;
  final VoidCallback? onEdit;
  final VoidCallback? onShowQR;

  const StoreInfoCard({
    super.key,
    required this.store,
    this.onEdit,
    this.onShowQR,
  });

@override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: TossSpacing.iconXL + TossSpacing.space2,
                height: TossSpacing.iconXL + TossSpacing.space2,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  IconMapper.getIcon('building'),
                  color: TossColors.primary,
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Information',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      store['store_name']?.toString() ?? 'Unnamed Store',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    IconMapper.getIcon('editRegular'),
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Store Details
          InfoRow.fixed(
            label: 'Store Code',
            value: store['store_code']?.toString() ?? 'N/A',
            labelWidth: 100,
          ),
          const SizedBox(height: TossSpacing.space2),

          if (store['store_address'] != null && store['store_address'].toString().isNotEmpty) ...[
            InfoRow.fixed(
              label: 'Address',
              value: store['store_address'].toString(),
              labelWidth: 100,
            ),
            const SizedBox(height: TossSpacing.space2),
          ],

          if (store['store_phone'] != null && store['store_phone'].toString().isNotEmpty) ...[
            InfoRow.fixed(
              label: 'Phone',
              value: store['store_phone'].toString(),
              labelWidth: 100,
            ),
            const SizedBox(height: TossSpacing.space2),
          ],

          InfoRow.fixed(
            label: 'Status',
            value: store['is_deleted'] == true ? 'Inactive' : 'Active',
            labelWidth: 100,
            valueColor: store['is_deleted'] == true ? TossColors.error : TossColors.success,
          ),
        ],
      ),
    );
  }
}
