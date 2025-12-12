import 'package:flutter/material.dart';

import '../../../../../../../core/themes/toss_animations.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../widgets/toss/toss_card.dart';

/// Total display widget for Cash Ending page
/// FROM PRODUCTION LINES 1964-2020
class TotalDisplay extends StatelessWidget {
  final String tabType;
  final String Function({required String tabType}) calculateTotal;

  const TotalDisplay({
    super.key,
    required this.tabType,
    required this.calculateTotal,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTotalSection(tabType: tabType);
  }

  Widget _buildTotalSection({String tabType = 'cash'}) {
    final total = calculateTotal(tabType: tabType);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          Flexible(
            flex: 2,
            child: AnimatedSwitcher(
              duration: TossAnimations.slow,
              child: Text(
                total,
                key: ValueKey(total),
                style: _getResponsiveTotalStyle(total),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get responsive text style for total amount based on length
  TextStyle _getResponsiveTotalStyle(String total) {
    final length = total.length;
    
    if (length <= 10) {
      // Short amounts: ₫50,000
      return TossTextStyles.amount.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
      );
    } else if (length <= 15) {
      // Medium amounts: ₫5,000,000
      return TossTextStyles.h4.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
      );
    } else if (length <= 20) {
      // Long amounts: ₫500,000,000
      return TossTextStyles.body.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
        fontSize: 16,
      );
    } else {
      // Very long amounts: ₫50,000,000,000+
      return TossTextStyles.body.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
        fontSize: 14,
      );
    }
  }

}