// lib/features/report_control/presentation/widgets/detail/account_changes_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/entities/report_detail.dart';

/// Account Changes Section
///
/// Displays company-wide and per-store account changes.
class AccountChangesSection extends StatefulWidget {
  final AccountChanges accountChanges;

  const AccountChangesSection({
    super.key,
    required this.accountChanges,
  });

  @override
  State<AccountChangesSection> createState() => _AccountChangesSectionState();
}

class _AccountChangesSectionState extends State<AccountChangesSection> {
  bool _showStoreBreakdown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const Text(
          'Account Changes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),

        const SizedBox(height: 12),

        // Company-wide summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
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
              const Row(
                children: [
                  Icon(
                    LucideIcons.building2,
                    size: 18,
                    color: TossColors.gray600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Company-Wide Summary',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Categories
              ...widget.accountChanges.companyWide.map((category) =>
                  _AccountCategoryCard(category: category),),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Store breakdown toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _showStoreBreakdown = !_showStoreBreakdown;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.store,
                  size: 18,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Breakdown by Store',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                Icon(
                  _showStoreBreakdown
                      ? LucideIcons.chevronUp
                      : LucideIcons.chevronDown,
                  size: 20,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),

        // Store breakdown content
        if (_showStoreBreakdown) ...[
          const SizedBox(height: 12),
          ...widget.accountChanges.byStore.map((store) =>
              _StoreAccountCard(store: store),),
        ],
      ],
    );
  }
}

class _AccountCategoryCard extends StatelessWidget {
  final AccountCategory category;

  const _AccountCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getCategoryColor(category.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              category.category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getCategoryColor(category.category),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Accounts
          ...category.accounts.map((account) => _AccountItemRow(item: account)),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Assets':
        return TossColors.success;
      case 'Liabilities':
        return TossColors.error;
      case 'Income':
        return TossColors.primary;
      case 'Expenses':
        return TossColors.warning;
      default:
        return TossColors.gray600;
    }
  }
}

class _AccountItemRow extends StatelessWidget {
  final AccountItem item;

  const _AccountItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasChange = item.change != null;
    final isIncrease = item.isIncrease ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Dot indicator
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: hasChange
                  ? (isIncrease ? TossColors.success : TossColors.error)
                  : TossColors.gray400,
              shape: BoxShape.circle,
            ),
          ),

          // Account name
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                fontSize: 13,
                color: TossColors.gray700,
              ),
            ),
          ),

          // Amount
          Text(
            item.formatted,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: hasChange
                  ? (isIncrease ? TossColors.success : TossColors.error)
                  : TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreAccountCard extends StatelessWidget {
  final StoreAccountSummary store;

  const _StoreAccountCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.store,
                  size: 16,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.storeName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Revenue: ${_formatCurrency(store.revenue)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Categories
          ...store.categories.map((category) =>
              _AccountCategoryCard(category: category),),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}$formatted ₫';
  }
}
