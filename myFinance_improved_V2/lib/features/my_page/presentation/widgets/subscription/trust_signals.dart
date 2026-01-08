import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

/// Trust signals section showing security, cancel policy, and no hidden fees
class TrustSignals extends StatelessWidget {
  const TrustSignals({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTrustItem(LucideIcons.shield, 'Secure'),
          Container(
            width: TossDimensions.dividerThickness,
            height: TossSpacing.space4,
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            color: TossColors.gray200,
          ),
          _buildTrustItem(LucideIcons.refreshCcw, 'Cancel anytime'),
          Container(
            width: TossDimensions.dividerThickness,
            height: TossSpacing.space4,
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            color: TossColors.gray200,
          ),
          _buildTrustItem(LucideIcons.creditCard, 'No hidden fees'),
        ],
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: TossSpacing.iconXS, color: TossColors.gray400),
        SizedBox(width: TossSpacing.space1),
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray500,
            fontWeight: TossFontWeight.medium,
          ),
        ),
      ],
    );
  }
}
