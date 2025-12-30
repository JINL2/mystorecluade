import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

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
            width: 8,
            height: 8,
            margin: EdgeInsets.only(left: index > 0 ? 2 : 0),
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '×$count',
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
