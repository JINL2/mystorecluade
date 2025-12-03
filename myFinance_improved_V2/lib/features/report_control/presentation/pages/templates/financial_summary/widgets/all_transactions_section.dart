// lib/features/report_control/presentation/pages/templates/financial_summary/widgets/all_transactions_section.dart

import 'package:flutter/material.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../domain/entities/cpa_audit_data.dart';
import '../domain/entities/transaction_entry.dart';
import 'transaction_card.dart';

/// 모든 거래 내역 섹션
///
/// 어제 발생한 모든 거래를 시간순으로 표시
class AllTransactionsSection extends StatefulWidget {
  final CpaAuditData auditData;

  const AllTransactionsSection({
    super.key,
    required this.auditData,
  });

  @override
  State<AllTransactionsSection> createState() => _AllTransactionsSectionState();
}

class _AllTransactionsSectionState extends State<AllTransactionsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final transactions = widget.auditData.allTransactions;

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: TossColors.gray800,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'All Transactions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TossColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${transactions.length} transactions',
                          style: const TextStyle(
                            fontSize: 14,
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                  ),
                ],
              ),
            ),
          ),

          // 거래 목록
          if (_isExpanded) ...[
            const Divider(height: 1, color: TossColors.gray200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: transactions.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: transactions
                          .map((txn) => TransactionCard(transaction: txn))
                          .toList(),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  /// 거래 없을 때
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 16,
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
