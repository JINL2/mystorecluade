import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Summary card for dashboard statistics
class TradeSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? trailing;

  const TradeSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
    this.isLoading = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? TossColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? _buildLoadingState()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          icon,
                          color: cardColor,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      if (trailing != null) trailing!,
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    value,
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    title,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle!,
                      style: TossTextStyles.caption.copyWith(
                        color: cardColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: TossColors.gray200,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          width: 60,
          height: 28,
          decoration: BoxDecoration(
            color: TossColors.gray200,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 80,
          height: 16,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
        ),
      ],
    );
  }
}

/// Compact summary card (for grid layout)
class TradeCompactSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TradeCompactSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
                const Spacer(),
                Text(
                  value,
                  style: TossTextStyles.h3.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              title,
              style: TossTextStyles.caption.copyWith(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Amount card with currency
class TradeAmountCard extends StatelessWidget {
  final String title;
  final String amount;
  final String currency;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final double? progress;
  final VoidCallback? onTap;

  const TradeAmountCard({
    super.key,
    required this.title,
    required this.amount,
    this.currency = 'USD',
    required this.icon,
    this.color,
    this.subtitle,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? TossColors.success;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cardColor.withOpacity(0.08),
              cardColor.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: cardColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    color: cardColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    title,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  currency,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    amount,
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: TossSpacing.space2),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress!.clamp(0.0, 1.0),
                  backgroundColor: TossColors.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(cardColor),
                  minHeight: 4,
                ),
              ),
            ],
            if (subtitle != null) ...[
              const SizedBox(height: TossSpacing.space2),
              Text(
                subtitle!,
                style: TossTextStyles.caption.copyWith(
                  color: cardColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
