import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Spacing Section - Showcases TossSpacing values
class SpacingSection extends StatelessWidget {
  const SpacingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SpacingItem('space0', TossSpacing.space0),
          _SpacingItem('space1 (4px)', TossSpacing.space1),
          _SpacingItem('space2 (8px)', TossSpacing.space2),
          _SpacingItem('space3 (12px)', TossSpacing.space3),
          _SpacingItem('space4 (16px)', TossSpacing.space4),
          _SpacingItem('space5 (20px)', TossSpacing.space5),
          _SpacingItem('space6 (24px)', TossSpacing.space6),
          _SpacingItem('space8 (32px)', TossSpacing.space8),
          _SpacingItem('space10 (40px)', TossSpacing.space10),
          _SpacingItem('space12 (48px)', TossSpacing.space12),
        ],
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  const _SpacingItem(this.name, this.value);

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              name,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: value,
            height: 24,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              border: Border.all(color: TossColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
