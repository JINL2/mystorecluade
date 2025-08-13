import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';

/// Widget to display a balance sheet item row
class BalanceSheetItemRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;
  final bool isSubtotal;
  final int indentLevel;

  const BalanceSheetItemRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.isSubtotal = false,
    this.indentLevel = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: TossSpacing.space4 * indentLevel,
        top: isTotal ? TossSpacing.space2 : TossSpacing.space1,
        bottom: isTotal ? TossSpacing.space2 : TossSpacing.space1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: isTotal
                  ? TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    )
                  : isSubtotal
                      ? TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        )
                      : TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: isTotal
                ? TossTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  )
                : isSubtotal
                    ? TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      )
                    : TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    // Format currency with comma separators
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '\$$formatted';
  }
}

/// Widget to display a balance sheet section
class BalanceSheetSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Color? backgroundColor;

  const BalanceSheetSection({
    super.key,
    required this.title,
    required this.items,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: TossShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                title,
                style: TossTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          ...items,
        ],
      ),
    );
  }
}

/// Widget to display financial ratio card
class FinancialRatioCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final Color? indicatorColor;
  final IconData? icon;

  const FinancialRatioCard({
    super.key,
    required this.title,
    required this.value,
    this.unit = '',
    this.indicatorColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: indicatorColor ?? Theme.of(context).colorScheme.primary,
                ),
              if (icon != null) SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.caption.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            '${value.toStringAsFixed(2)}$unit',
            style: TossTextStyles.h3.copyWith(
              color: indicatorColor ?? Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for balance sheet summary header
class BalanceSheetHeader extends StatelessWidget {
  final String companyName;
  final String storeName;
  final DateTime periodDate;

  const BalanceSheetHeader({
    super.key,
    required this.companyName,
    required this.storeName,
    required this.periodDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance Sheet',
            style: TossTextStyles.h1.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            companyName,
            style: TossTextStyles.h3.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (storeName.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space1),
            Text(
              storeName,
              style: TossTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: TossSpacing.space2),
          Text(
            'As of ${_formatDate(periodDate)}',
            style: TossTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}