// lib/features/report_control/presentation/pages/templates/financial_summary/widgets/transaction_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../domain/entities/transaction_entry.dart';

/// 개별 거래 카드 Widget
///
/// Debit/Credit 계정을 명확히 표시
class TransactionCard extends StatelessWidget {
  final TransactionEntry transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 금액 & 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.formattedAmount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                _formatTime(transaction.entryDate),
                style: const TextStyle(
                  fontSize: 13,
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Debit/Credit 계정 (핵심!)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildAccountRow(
                  label: 'Debit',
                  account: transaction.debitAccount,
                  color: TossColors.gray800,
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: TossColors.gray300),
                const SizedBox(height: 8),
                _buildAccountRow(
                  label: 'Credit',
                  account: transaction.creditAccount,
                  color: TossColors.gray700,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 직원 & 매장
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: TossColors.gray600,
              ),
              const SizedBox(width: 4),
              Text(
                transaction.employeeName,
                style: const TextStyle(
                  fontSize: 14,
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.store_outlined,
                size: 16,
                color: TossColors.gray600,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  transaction.storeName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: TossColors.gray700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // 설명 (있을 경우)
          if (transaction.description != null &&
              transaction.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                transaction.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: TossColors.gray800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 계정 행 빌더
  Widget _buildAccountRow({
    required String label,
    required String account,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            account,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  /// 시간 포맷 (HH:mm)
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
