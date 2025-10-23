import 'package:flutter/material.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_card.dart';

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

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: color ?? TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

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
          _buildDetailRow('Store Code', store['store_code']?.toString() ?? 'N/A'),
          const SizedBox(height: TossSpacing.space2),

          if (store['store_address'] != null && store['store_address'].toString().isNotEmpty) ...[
            _buildDetailRow('Address', store['store_address'].toString()),
            const SizedBox(height: TossSpacing.space2),
          ],

          if (store['store_phone'] != null && store['store_phone'].toString().isNotEmpty) ...[
            _buildDetailRow('Phone', store['store_phone'].toString()),
            const SizedBox(height: TossSpacing.space2),
          ],

          _buildDetailRow(
            'Status',
            store['is_deleted'] == true ? 'Inactive' : 'Active',
            color: store['is_deleted'] == true ? TossColors.error : TossColors.success,
          ),
        ],
      ),
    );
  }
}
