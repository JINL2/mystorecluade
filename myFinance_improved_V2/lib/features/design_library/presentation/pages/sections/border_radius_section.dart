import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Border Radius Section - Showcases TossBorderRadius values
class BorderRadiusSection extends StatelessWidget {
  const BorderRadiusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Wrap(
        spacing: TossSpacing.space3,
        runSpacing: TossSpacing.space3,
        children: const [
          _BorderRadiusItem('none (0)', TossBorderRadius.none),
          _BorderRadiusItem('xs (4)', TossBorderRadius.xs),
          _BorderRadiusItem('sm (6)', TossBorderRadius.sm),
          _BorderRadiusItem('md (8)', TossBorderRadius.md),
          _BorderRadiusItem('lg (12)', TossBorderRadius.lg),
          _BorderRadiusItem('xl (16)', TossBorderRadius.xl),
          _BorderRadiusItem('xxl (20)', TossBorderRadius.xxl),
          _BorderRadiusItem('xxxl (24)', TossBorderRadius.xxxl),
          _BorderRadiusItem('full (999)', TossBorderRadius.full),
        ],
      ),
    );
  }
}

class _BorderRadiusItem extends StatelessWidget {
  const _BorderRadiusItem(this.name, this.radius);

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: TossColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: TossColors.primary),
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          name,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
