import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';

/// Legend item for timeline
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: TossSpacing.space2,
          height: TossSpacing.space2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
        SizedBox(width: TossSpacing.space1),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }
}
