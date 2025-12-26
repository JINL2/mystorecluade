import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../providers/financial_statements_provider.dart';

/// Quick period selector chips
class PeriodSelector extends StatelessWidget {
  final QuickPeriod selectedPeriod;
  final ValueChanged<QuickPeriod> onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(QuickPeriod.today, 'Today'),
          const SizedBox(width: TossSpacing.space2),
          _buildChip(QuickPeriod.yesterday, 'Yesterday'),
          const SizedBox(width: TossSpacing.space2),
          _buildChip(QuickPeriod.thisWeek, 'Week'),
          const SizedBox(width: TossSpacing.space2),
          _buildChip(QuickPeriod.thisMonth, 'Month'),
          const SizedBox(width: TossSpacing.space2),
          _buildChip(QuickPeriod.thisYear, 'Year'),
        ],
      ),
    );
  }

  Widget _buildChip(QuickPeriod period, String label) {
    final isSelected = selectedPeriod == period;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.gray900 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
