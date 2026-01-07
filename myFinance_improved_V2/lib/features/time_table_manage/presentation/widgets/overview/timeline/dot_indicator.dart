import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';

/// Dot indicator showing count
class DotIndicator extends StatelessWidget {
  final Color color;
  final int count;

  const DotIndicator({
    super.key,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Show up to 3 dots, then show number
    if (count <= 3) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
          (index) => Container(
            width: TossSpacing.space2,
            height: TossSpacing.space2,
            margin: EdgeInsets.only(left: index > 0 ? TossSpacing.space0_5 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
        ),
      );
    }

    // More than 3: show dot with number
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
        SizedBox(width: TossSpacing.space0_5),
        Text(
          '×$count',
          style: TossTextStyles.small.copyWith(
            color: color,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ],
    );
  }
}
