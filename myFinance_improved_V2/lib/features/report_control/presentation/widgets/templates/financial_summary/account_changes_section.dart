// lib/features/report_control/presentation/widgets/detail/account_changes_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
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
        Text(
          'Account Changes',
          style: TossTextStyles.titleMedium.copyWith(
            fontWeight: TossFontWeight.bold,
            color: TossColors.gray900,
          ),
        ),

        SizedBox(height: TossSpacing.space3),

        // Company-wide summary
        Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            border: Border.all(color: TossColors.gray100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.building2,
                    size: TossSpacing.iconSM,
                    color: TossColors.gray600,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Company-Wide Summary',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),

              SizedBox(height: TossSpacing.space4),

              // Categories (빈 카테고리는 숨김)
              ...widget.accountChanges.companyWide
                  .where((category) => category.accounts.isNotEmpty)
                  .map((category) => _AccountCategoryCard(category: category)),
            ],
          ),
        ),

        SizedBox(height: TossSpacing.space4),

        // Store breakdown toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _showStoreBreakdown = !_showStoreBreakdown;
            });
          },
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(color: TossColors.gray100),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.store,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray600,
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Breakdown by Store',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                Icon(
                  _showStoreBreakdown
                      ? LucideIcons.chevronUp
                      : LucideIcons.chevronDown,
                  size: TossSpacing.iconMD,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),

        // Store breakdown content
        if (_showStoreBreakdown) ...[
          SizedBox(height: TossSpacing.space3),
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
      padding: EdgeInsets.only(bottom: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Container(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
            decoration: BoxDecoration(
              color: _getCategoryColor(category.category).withValues(alpha: TossOpacity.light),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              category.category,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: _getCategoryColor(category.category),
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space2),

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
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          // Dot indicator
          Container(
            width: TossDimensions.timelineDotSmall,
            height: TossDimensions.timelineDotSmall,
            margin: EdgeInsets.only(right: TossSpacing.space2),
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
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),

          // Amount
          Text(
            item.formatted,
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: TossFontWeight.semibold,
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
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
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
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  LucideIcons.store,
                  size: TossSpacing.iconSM2,
                  color: TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.storeName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space0_5),
                    Text(
                      'Revenue: ${_formatCurrency(store.revenue)}',
                      style: TossTextStyles.labelSmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space3),

          // Categories (빈 카테고리는 숨김)
          ...store.categories
              .where((category) => category.accounts.isNotEmpty)
              .map((category) => _AccountCategoryCard(category: category)),
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
