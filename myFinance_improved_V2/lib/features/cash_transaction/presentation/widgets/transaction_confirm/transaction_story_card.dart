import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../transaction_confirm_dialog.dart';

/// Transaction Story Card Widget
/// Shows the transaction summary with cash flow diagram
class TransactionStoryCard extends StatelessWidget {
  final TransactionConfirmData data;

  const TransactionStoryCard({
    super.key,
    required this.data,
  });

  String get _formattedAmount {
    final formatter = NumberFormat('#,###');
    return '₩${formatter.format(data.amount.toInt())}';
  }

  /// Check if this is a complex transfer (needs vertical layout)
  bool get _isComplexTransfer {
    return data.type == ConfirmTransactionType.transferWithinCompany ||
        data.type == ConfirmTransactionType.transferBetweenCompanies;
  }

  /// Get detailed cash flow info for complex transfers
  ({
    String? fromCompany,
    String? fromStore,
    String fromLocation,
    String? toCompany,
    String? toStore,
    String? toLocation,
    String reason,
    bool isCashOut,
  }) get _detailedCashFlowInfo {
    switch (data.type) {
      case ConfirmTransactionType.expense:
        return (
          fromCompany: null,
          fromStore: null,
          fromLocation: data.fromCashLocationName,
          toCompany: null,
          toStore: null,
          toLocation: null,
          reason: data.expenseAccountName ?? 'Expense',
          isCashOut: true,
        );

      case ConfirmTransactionType.debt:
        final debtType = data.debtTypeName ?? '';
        final isCashOut = debtType.contains('Lend') || debtType.contains('Repay');

        if (isCashOut) {
          return (
            fromCompany: null,
            fromStore: null,
            fromLocation: data.fromCashLocationName,
            toCompany: null,
            toStore: null,
            toLocation: data.counterpartyName,
            reason: debtType,
            isCashOut: true,
          );
        } else {
          return (
            fromCompany: null,
            fromStore: null,
            fromLocation: data.counterpartyName ?? '—',
            toCompany: null,
            toStore: null,
            toLocation: data.fromCashLocationName,
            reason: debtType,
            isCashOut: false,
          );
        }

      case ConfirmTransactionType.transferWithinStore:
        return (
          fromCompany: null,
          fromStore: null,
          fromLocation: data.fromCashLocationName,
          toCompany: null,
          toStore: null,
          toLocation: data.toCashLocationName,
          reason: 'Transfer',
          isCashOut: true,
        );

      case ConfirmTransactionType.transferWithinCompany:
        return (
          fromCompany: null,
          fromStore: data.fromStoreName,
          fromLocation: data.fromCashLocationName,
          toCompany: null,
          toStore: data.toStoreName,
          toLocation: data.toCashLocationName,
          reason: 'Inter-store Transfer',
          isCashOut: true,
        );

      case ConfirmTransactionType.transferBetweenCompanies:
        return (
          fromCompany: null,
          fromStore: data.fromStoreName,
          fromLocation: data.fromCashLocationName,
          toCompany: data.toCompanyName,
          toStore: data.toStoreName,
          toLocation: data.toCashLocationName,
          reason: 'Inter-company Transfer',
          isCashOut: true,
        );
    }
  }

  /// Simple cash flow info for basic transactions
  ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) get _cashFlowInfo {
    final detailed = _detailedCashFlowInfo;
    return (
      decreaseFrom: detailed.fromLocation,
      increaseTo: detailed.toLocation,
      reason: detailed.reason,
      isCashOut: detailed.isCashOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cashFlow = _cashFlowInfo;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          // Amount and type - compact
          Column(
            children: [
              Text(
                _formattedAmount,
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cashFlow.reason,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Cash Flow Visual Diagram
          _buildCashFlowDiagram(cashFlow),
        ],
      ),
    );
  }

  Widget _buildCashFlowDiagram(
    ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) cashFlow,
  ) {
    if (_isComplexTransfer) {
      return _buildVerticalCashFlowDiagram();
    }
    return _buildHorizontalCashFlowDiagram(cashFlow);
  }

  Widget _buildHorizontalCashFlowDiagram(
    ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) cashFlow,
  ) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildLocationBox(
                  name: cashFlow.decreaseFrom ?? '—',
                  isCashOut: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                child: Container(
                  padding: const EdgeInsets.all(TossSpacing.space1 + 2),
                  decoration: const BoxDecoration(
                    color: TossColors.gray200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: cashFlow.increaseTo != null
                    ? _buildLocationBox(
                        name: cashFlow.increaseTo!,
                        isCashOut: false,
                      )
                    : _buildExpenseEndBox(cashFlow.reason),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space2),

          Text(
            _getSimpleExplanation(cashFlow),
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCashFlowDiagram() {
    final detailed = _detailedCashFlowInfo;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          _buildDetailedLocationCard(
            isCashOut: true,
            company: detailed.fromCompany,
            store: detailed.fromStore,
            location: detailed.fromLocation,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: TossColors.gray300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: TossColors.gray600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formattedAmount,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container(height: 1, color: TossColors.gray300)),
              ],
            ),
          ),

          _buildDetailedLocationCard(
            isCashOut: false,
            company: detailed.toCompany,
            store: detailed.toStore,
            location: detailed.toLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedLocationCard({
    required bool isCashOut,
    String? company,
    String? store,
    String? location,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCashOut ? 'FROM' : 'TO',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: TossSpacing.space1),

          if (company != null)
            _buildLocationRow(
              icon: Icons.business,
              label: '회사',
              value: company,
            ),
          if (store != null)
            _buildLocationRow(
              icon: Icons.store,
              label: '가게',
              value: store,
            ),
          if (location != null)
            _buildLocationRow(
              icon: Icons.account_balance_wallet,
              label: '위치',
              value: location,
              isBold: true,
            ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: TossColors.gray500),
        const SizedBox(width: TossSpacing.space1),
        Text(
          '$label:',
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(width: TossSpacing.space1),
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationBox({
    required String name,
    required bool isCashOut,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Text(
            isCashOut ? 'FROM' : 'TO',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            name,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseEndBox(String reason) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 24,
            color: TossColors.gray500,
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Spent',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            reason,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getSimpleExplanation(
    ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) cashFlow,
  ) {
    switch (data.type) {
      case ConfirmTransactionType.expense:
        return '${data.fromCashLocationName}에서 $_formattedAmount 나감';

      case ConfirmTransactionType.debt:
        if (cashFlow.isCashOut) {
          return '${data.fromCashLocationName} → ${cashFlow.increaseTo}';
        } else {
          return '${cashFlow.decreaseFrom} → ${data.fromCashLocationName}';
        }

      case ConfirmTransactionType.transferWithinStore:
        return '${data.fromCashLocationName} → ${data.toCashLocationName} (같은 가게)';

      case ConfirmTransactionType.transferWithinCompany:
        return '${data.fromStoreName} → ${data.toStoreName} (같은 회사)';

      case ConfirmTransactionType.transferBetweenCompanies:
        return '${data.fromStoreName} → ${data.toCompanyName} (다른 회사)';
    }
  }
}
