// lib/features/report_control/presentation/pages/templates/financial_summary/widgets/all_transactions_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../../shared/themes/toss_shadows.dart';
import '../domain/entities/cpa_audit_data.dart';
import '../domain/entities/transaction_entry.dart';
import 'transaction_card.dart';

/// 모든 거래 내역 섹션
///
/// 어제 발생한 모든 거래를 시간순으로 표시
class AllTransactionsSection extends StatefulWidget {
  final CpaAuditData auditData;
  final bool isMinimal; // 미니멀 모드

  const AllTransactionsSection({
    super.key,
    required this.auditData,
    this.isMinimal = false, // 기본값은 일반 모드
  });

  @override
  State<AllTransactionsSection> createState() => _AllTransactionsSectionState();
}

class _AllTransactionsSectionState extends State<AllTransactionsSection> {
  bool _isExpanded = false; // 기본값을 false로 (접힌 상태)

  @override
  Widget build(BuildContext context) {
    final transactions = widget.auditData.allTransactions;

    // 가게별로 그룹화
    final Map<String, List<TransactionEntry>> transactionsByStore = {};
    for (final tx in transactions) {
      final storeName = tx.storeName ?? 'Unknown Store';
      transactionsByStore.putIfAbsent(storeName, () => []).add(tx);
    }

    // 각 가게의 거래를 금액 큰 순으로 정렬
    for (final storeTransactions in transactionsByStore.values) {
      storeTransactions.sort((a, b) => b.amount.compareTo(a.amount));
    }

    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (다른 섹션과 통일)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    LucideIcons.receipt,
                    size: TossSpacing.iconSM,
                    color: TossColors.gray600,
                  ),
                ),
                SizedBox(width: TossSpacing.gapMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction History',
                        style: TossTextStyles.h4.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '${transactions.length} transactions',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? LucideIcons.chevronUp
                      : LucideIcons.chevronDown,
                  color: TossColors.gray600,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),

          // 거래 목록 (가게별로 그룹화)
          if (_isExpanded) ...[
            SizedBox(height: TossSpacing.gapLG),
            transactions.isEmpty
                ? _buildEmptyState()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 가게별로 표시
                      ...transactionsByStore.entries.map((entry) {
                        final storeName = entry.key;
                        final storeTransactions = entry.value;
                        final totalAmount = storeTransactions.fold<double>(
                          0,
                          (sum, tx) => sum + tx.amount,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 가게 헤더
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: TossSpacing.space3,
                                top: TossSpacing.gapMD,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.store,
                                    size: TossSpacing.iconXS,
                                    color: TossColors.gray600,
                                  ),
                                  SizedBox(width: TossSpacing.marginXS),
                                  Expanded(
                                    child: Text(
                                      storeName,
                                      style: TossTextStyles.bodyMedium.copyWith(
                                        color: TossColors.gray900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${storeTransactions.length} txs · ${_formatAmount(totalAmount)}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 거래 목록 (금액 큰 순)
                            ...storeTransactions.map((txn) =>
                                TransactionCard(transaction: txn),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
          ],
        ],
      ),
    );
  }

  /// 금액 포맷
  String _formatAmount(double amount) {
    final absAmount = amount.abs();
    if (absAmount >= 1000000) {
      return '${(absAmount / 1000000).toStringAsFixed(1)}M ₫';
    } else if (absAmount >= 1000) {
      return '${(absAmount / 1000).toStringAsFixed(0)}K ₫';
    }
    return '${absAmount.toStringAsFixed(0)} ₫';
  }

  /// 거래 없을 때
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: TossSpacing.iconXL + TossSpacing.space2,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.gapLG),
            Text(
              'No transactions found',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
