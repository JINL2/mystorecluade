import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_shadows.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Debt Settings Header Widget
///
/// Displays counterparty information and explains the account mapping concept.
class DebtSettingsHeader extends StatelessWidget {
  final String counterpartyName;

  const DebtSettingsHeader({
    super.key,
    required this.counterpartyName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderInfo(),
          const SizedBox(height: TossSpacing.space4),
          _buildFlowVisualization(),
          const SizedBox(height: TossSpacing.space3),
          _buildBenefits(),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: TossColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: const Icon(
            Icons.account_balance,
            color: TossColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                counterpartyName,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Internal Company Account Mappings',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlowVisualization() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'You record',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Receivable',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
            child: Icon(
              Icons.sync_alt,
              color: TossColors.gray400,
              size: 20,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'They record',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Payable',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle,
              color: TossColors.success,
              size: 16,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                'Automatic synchronization for accurate records',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: TossColors.info,
              size: 16,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                'Once mapped, record transactions in one company only. '
                'The other company\'s entry is created automatically.',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.info,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
