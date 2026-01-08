import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/fixed_asset.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class AssetListItem extends StatelessWidget {
  final FixedAsset asset;
  final String currencySymbol;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssetListItem({
    super.key,
    required this.asset,
    required this.currencySymbol,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final depreciation = asset.calculateDepreciation();
    final acquisitionCost = asset.financialInfo.acquisitionCost;
    final usefulLifeYears = asset.financialInfo.usefulLifeYears;
    final salvageValue = asset.financialInfo.salvageValue;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5, vertical: TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: const BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
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
                  child: Icon(
                    Icons.business_center_outlined,
                    size: TossSpacing.iconSM,
                    color: TossColors.primary,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.assetName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.gray900,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1 / 2),
                      Text(
                        'Purchased ${_formatDate(asset.acquisitionDate)}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SafePopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: TossSpacing.iconMD,
                    color: TossColors.gray600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: TossSpacing.iconSM, color: TossColors.gray700),
                          SizedBox(width: TossSpacing.space3),
                          Text('Edit Asset'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: TossSpacing.iconSM, color: TossColors.error),
                          const SizedBox(width: TossSpacing.space3),
                          Text('Delete', style: TossTextStyles.body.copyWith(color: TossColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: [
                // Current value display
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        TossColors.primary.withValues(alpha: 0.05),
                        TossColors.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Value',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              '$currencySymbol${depreciation.currentValue.toStringAsFixed(0)}',
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space1 + 2),
                        decoration: BoxDecoration(
                          color: depreciation.depreciationRate > 50
                              ? TossColors.error.withValues(alpha: 0.1)
                              : TossColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_down,
                              size: TossSpacing.iconSM,
                              color: depreciation.depreciationRate > 50
                                  ? TossColors.error
                                  : TossColors.warning,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              '${depreciation.depreciationRate.toStringAsFixed(1)}%',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: depreciation.depreciationRate > 50
                                    ? TossColors.error
                                    : TossColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TossSpacing.space3),

                // Metrics grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Original Cost',
                        '$currencySymbol${acquisitionCost.toStringAsFixed(0)}',
                        Icons.attach_money,
                        TossColors.success,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: _buildMetricTile(
                        'Annual Deprec.',
                        '$currencySymbol${depreciation.annualDepreciation.toStringAsFixed(0)}',
                        Icons.calendar_today_outlined,
                        TossColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Useful Life',
                        '$usefulLifeYears years',
                        Icons.schedule,
                        TossColors.warning,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: _buildMetricTile(
                        'Salvage Value',
                        '$currencySymbol${salvageValue.toStringAsFixed(0)}',
                        Icons.savings_outlined,
                        TossColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: TossSpacing.iconLG2,
            height: TossSpacing.iconLG2,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              icon,
              size: TossSpacing.iconSM2,
              color: color,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: TossSpacing.space1 / 2),
                Text(
                  value,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
