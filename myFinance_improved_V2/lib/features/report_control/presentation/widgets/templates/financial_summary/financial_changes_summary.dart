// lib/features/report_control/presentation/widgets/detail/financial_changes_summary.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/report_detail.dart';

/// Financial Changes Summary
///
/// Shows company-wide and per-store changes in a clear, compact format
class FinancialChangesSummary extends StatelessWidget {
  final AccountChanges accountChanges;

  const FinancialChangesSummary({
    super.key,
    required this.accountChanges,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate company-wide totals
    final companyTotals = _calculateCompanyTotals();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space3),
          child: Text(
            'Financial Changes',
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
        ),

        // Company-wide summary card
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      LucideIcons.building2,
                      size: 20,
                      color: TossColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Company-Wide',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Changes grid
              Row(
                children: [
                  Expanded(
                    child: _ChangeCard(
                      label: 'Assets',
                      value: companyTotals['assets']!,
                      icon: LucideIcons.trendingUp,
                      color: TossColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChangeCard(
                      label: 'Liabilities',
                      value: companyTotals['liabilities']!,
                      icon: LucideIcons.trendingDown,
                      color: TossColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChangeCard(
                      label: 'Income',
                      value: companyTotals['income']!,
                      icon: LucideIcons.dollarSign,
                      color: TossColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Store breakdown
        ...accountChanges.byStore.map((store) => _StoreChangeCard(store: store)),
      ],
    );
  }

  Map<String, double> _calculateCompanyTotals() {
    double assets = 0;
    double liabilities = 0;
    double income = 0;

    for (var category in accountChanges.companyWide) {
      for (var account in category.accounts) {
        switch (category.category) {
          case 'Assets':
            assets += account.change ?? account.amount ?? 0;
            break;
          case 'Liabilities':
            liabilities += account.change ?? account.amount ?? 0;
            break;
          case 'Income':
            income += account.amount ?? 0;
            break;
        }
      }
    }

    return {
      'assets': assets,
      'liabilities': liabilities,
      'income': income,
    };
  }
}

/// Change Card for metrics
class _ChangeCard extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;

  const _ChangeCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final formatted = _formatCurrency(value.abs());

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(
            icon,
            size: 20,
            color: color,
          ),

          const SizedBox(height: 8),

          // Label
          Text(
            label,
            style: TossTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),

          const SizedBox(height: 4),

          // Value
          Row(
            children: [
              if (label != 'Income')
                Icon(
                  isPositive ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                  size: 14,
                  color: color,
                ),
              if (label != 'Income') const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${isPositive && label != 'Income' ? '+' : ''}$formatted',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted ₫';
  }
}

/// Store Change Card
class _StoreChangeCard extends StatelessWidget {
  final StoreAccountSummary store;

  const _StoreChangeCard({required this.store});

  @override
  Widget build(BuildContext context) {
    final storeTotals = _calculateStoreTotals();

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: const Icon(
                  LucideIcons.store,
                  size: 16,
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  store.storeName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              // Revenue badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  _formatCurrency(store.revenue),
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Changes
          Row(
            children: [
              Expanded(
                child: _MiniChangeCard(
                  label: 'Assets',
                  value: storeTotals['assets']!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniChangeCard(
                  label: 'Income',
                  value: storeTotals['income']!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniChangeCard(
                  label: 'Expenses',
                  value: storeTotals['expenses']!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateStoreTotals() {
    double assets = 0;
    double income = 0;
    double expenses = 0;

    for (var category in store.categories) {
      for (var account in category.accounts) {
        switch (category.category) {
          case 'Assets':
            assets += account.change ?? account.amount ?? 0;
            break;
          case 'Income':
            income += account.amount ?? 0;
            break;
          case 'Expenses':
            expenses += account.amount ?? 0;
            break;
        }
      }
    }

    return {
      'assets': assets,
      'income': income,
      'expenses': expenses,
    };
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted ₫';
  }
}

/// Mini Change Card for stores
class _MiniChangeCard extends StatelessWidget {
  final String label;
  final double value;

  const _MiniChangeCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = label == 'Expenses'
        ? TossColors.warning
        : (isPositive ? TossColors.success : TossColors.error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelSmall.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (label != 'Income')
              Icon(
                isPositive ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                size: 12,
                color: color,
              ),
            if (label != 'Income') const SizedBox(width: 2),
            Expanded(
              child: Text(
                _formatShort(value),
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatShort(double amount) {
    final abs = amount.abs();
    final sign = amount >= 0 && label != 'Income' ? '+' : '';

    if (abs >= 1000000) {
      return '$sign${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      return '$sign${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '$sign${amount.toStringAsFixed(0)}';
  }
}
