import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Metric card for profile header
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? footnote;
  final bool showInfoIcon;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.footnote,
    this.showInfoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showInfoIcon) ...[
              const SizedBox(width: TossSpacing.space0_5),
              const Icon(
                Icons.info_outline,
                size: TossSpacing.iconXS,
                color: TossColors.gray400,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: TossTextStyles.titleLarge.copyWith(
            fontWeight: TossFontWeight.bold,
          ),
        ),
        if (footnote != null) ...[
          const SizedBox(height: TossSpacing.space0_5),
          Text(
            footnote!,
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Vertical divider between metrics
class MetricDivider extends StatelessWidget {
  const MetricDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TossDimensions.dividerThickness,
      height: TossDimensions.dividerHeightXL,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      color: TossColors.gray200,
    );
  }
}
