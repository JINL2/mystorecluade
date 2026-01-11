import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/bcg_category.dart';

/// BCG Matrix Legend widget
class BcgLegend extends StatelessWidget {
  final BcgMatrix bcgMatrix;
  final Map<String, int>? counts;

  const BcgLegend({
    super.key,
    required this.bcgMatrix,
    this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final quadrants = [
      ('star', 'Star', TossColors.success),
      ('cash_cow', 'Cash Cow', TossColors.primary),
      ('problem_child', 'Question', TossColors.warning),
      ('dog', 'Dog', TossColors.error),
    ];

    return Wrap(
      spacing: TossSpacing.space3,
      runSpacing: TossSpacing.space2,
      children: quadrants.map((q) {
        final count = counts?[q.$1] ??
            bcgMatrix.categories.where((c) => c.quadrant == q.$1).length;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: q.$3.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: q.$3,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${q.$2} ($count)',
                style: TossTextStyles.caption.copyWith(
                  color: q.$3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
