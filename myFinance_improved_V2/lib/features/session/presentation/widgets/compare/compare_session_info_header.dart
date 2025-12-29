import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_compare_result.dart';

/// Header widget showing source and target session info for comparison
class CompareSessionInfoHeader extends StatelessWidget {
  final String sourceSessionName;
  final String targetSessionName;
  final SessionCompareResult? compareResult;

  const CompareSessionInfoHeader({
    super.key,
    required this.sourceSessionName,
    required this.targetSessionName,
    this.compareResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          // Source session (Mine)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Session',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sourceSessionName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (compareResult != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${compareResult!.sourceSession.totalProducts} items',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Arrow
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
            child: Icon(
              Icons.compare_arrows,
              color: TossColors.gray400,
              size: 24,
            ),
          ),
          // Target session
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Target Session',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  targetSessionName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
                if (compareResult != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${compareResult!.targetSession.totalProducts} items',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
