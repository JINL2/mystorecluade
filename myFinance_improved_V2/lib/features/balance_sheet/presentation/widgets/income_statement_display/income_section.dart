import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Income statement section widget
class IncomeSection extends StatelessWidget {
  final Map<String, dynamic> section;
  final String currencySymbol;

  const IncomeSection({
    super.key,
    required this.section,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final sectionName = section['section'] as String;
    final sectionTotal = section['section_total'];
    final subcategories = section['subcategories'] as List<dynamic>? ?? [];

    // Determine section type and styling
    final isPositiveSection = [
      'Revenue',
      'Gross Profit',
      'Operating Income',
      'EBITDA',
      'Net Income',
      'Income Before Tax'
    ].contains(sectionName);
    final isNegativeSection =
        ['Cost of Goods Sold', 'Expenses'].contains(sectionName);
    final isMarginSection = sectionName.contains('Margin');

    Color sectionColor = TossColors.gray600;
    IconData sectionIcon = Icons.analytics_outlined;

    if (isPositiveSection) {
      sectionColor = TossColors.success;
      sectionIcon = Icons.trending_up_outlined;
    } else if (isNegativeSection) {
      sectionColor = TossColors.error;
      sectionIcon = Icons.trending_down_outlined;
    } else if (isMarginSection) {
      sectionColor = TossColors.primary;
      sectionIcon = Icons.percent_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(sectionName, sectionTotal, sectionIcon, sectionColor,
              isMarginSection),
          if (subcategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space4,
              ),
              child: Column(
                children: subcategories
                    .map<Widget>(
                      (subcategory) => _SubcategoryWidget(
                        subcategory: subcategory as Map<String, dynamic>,
                        currencySymbol: currencySymbol,
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    String sectionName,
    dynamic sectionTotal,
    IconData sectionIcon,
    Color sectionColor,
    bool isMarginSection,
  ) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: sectionColor.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.lg),
          topRight: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: sectionColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(sectionIcon, color: sectionColor, size: 20),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              sectionName,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 140),
            child: Text(
              isMarginSection
                  ? '${sectionTotal.toString()}%'
                  : _formatCurrency(sectionTotal.toString()),
              style: TossTextStyles.bodyLarge.copyWith(
                color: sectionColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null ||
        amount.toString().isEmpty ||
        amount.toString() == 'null') {
      return '$currencySymbol 0';
    }

    try {
      double numericAmount;
      if (amount is num) {
        numericAmount = amount.toDouble();
      } else {
        numericAmount = double.tryParse(amount.toString()) ?? 0.0;
      }

      final formatter = NumberFormat('#,##0', 'en_US');
      final absAmount = numericAmount.abs();
      final formatted = formatter.format(absAmount);

      if (numericAmount < 0) {
        return '-$currencySymbol$formatted';
      }
      return '$currencySymbol$formatted';
    } catch (e) {
      return '$currencySymbol 0';
    }
  }
}

class _SubcategoryWidget extends StatelessWidget {
  final Map<String, dynamic> subcategory;
  final String currencySymbol;

  const _SubcategoryWidget({
    required this.subcategory,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final subcategoryName = subcategory['subcategory'] as String;
    final subcategoryTotal = subcategory['subcategory_total'];
    final accounts = subcategory['accounts'] as List<dynamic>? ?? [];

    return Column(
      children: [
        if (subcategoryName.isNotEmpty && subcategoryTotal != null)
          _buildSubcategoryHeader(subcategoryName, subcategoryTotal),
        if (accounts.isNotEmpty)
          ...accounts.map<Widget>(
            (account) => _AccountItemWidget(
              account: account as Map<String, dynamic>,
              currencySymbol: currencySymbol,
            ),
          ),
        const SizedBox(height: TossSpacing.space3),
      ],
    );
  }

  Widget _buildSubcategoryHeader(String name, dynamic total) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
            child: Text(
              _formatCurrency(total?.toString() ?? '0'),
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null ||
        amount.toString().isEmpty ||
        amount.toString() == 'null') {
      return '$currencySymbol 0';
    }

    try {
      double numericAmount;
      if (amount is num) {
        numericAmount = amount.toDouble();
      } else {
        numericAmount = double.tryParse(amount.toString()) ?? 0.0;
      }

      final formatter = NumberFormat('#,##0', 'en_US');
      final absAmount = numericAmount.abs();
      final formatted = formatter.format(absAmount);

      if (numericAmount < 0) {
        return '-$currencySymbol$formatted';
      }
      return '$currencySymbol$formatted';
    } catch (e) {
      return '$currencySymbol 0';
    }
  }
}

class _AccountItemWidget extends StatelessWidget {
  final Map<String, dynamic> account;
  final String currencySymbol;

  const _AccountItemWidget({
    required this.account,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final accountName = account['account_name'] as String;
    final netAmount = account['net_amount'];
    final accountType = account['account_type'] as String;

    final isIncome = accountType == 'income';
    final hasActivity = netAmount != null && netAmount != 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text('  ', style: TossTextStyles.bodySmall), // Indentation
                Flexible(
                  child: Text(
                    accountName,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (hasActivity) ...[
                  const SizedBox(width: TossSpacing.space1),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isIncome ? TossColors.success : TossColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
            child: Text(
              _formatCurrency(netAmount?.toString() ?? '0'),
              style: TossTextStyles.body.copyWith(
                color: hasActivity
                    ? (isIncome ? TossColors.success : TossColors.error)
                    : TossColors.gray500,
                fontWeight: hasActivity ? FontWeight.w500 : FontWeight.w400,
                fontSize: 13,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null ||
        amount.toString().isEmpty ||
        amount.toString() == 'null') {
      return '$currencySymbol 0';
    }

    try {
      double numericAmount;
      if (amount is num) {
        numericAmount = amount.toDouble();
      } else {
        numericAmount = double.tryParse(amount.toString()) ?? 0.0;
      }

      final formatter = NumberFormat('#,##0', 'en_US');
      final absAmount = numericAmount.abs();
      final formatted = formatter.format(absAmount);

      if (numericAmount < 0) {
        return '-$currencySymbol$formatted';
      }
      return '$currencySymbol$formatted';
    } catch (e) {
      return '$currencySymbol 0';
    }
  }
}
