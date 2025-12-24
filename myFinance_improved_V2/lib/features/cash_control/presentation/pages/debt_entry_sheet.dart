import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

import '../providers/cash_control_providers.dart';
import '../widgets/amount_input_keypad.dart';
import '../widgets/transaction_confirm_dialog.dart';

/// Debt Entry Bottom Sheet
/// Receives: direction, debtSubType, counterparty, cashLocation from main page
/// Flow: Amount only (Cash Location already selected)
class DebtEntrySheet extends ConsumerStatefulWidget {
  final CashDirection direction;
  final DebtSubType debtSubType;
  final String counterpartyId;
  final String? counterpartyName;
  final String cashLocationId;
  final String cashLocationName;
  final VoidCallback onSuccess;

  const DebtEntrySheet({
    super.key,
    required this.direction,
    required this.debtSubType,
    required this.counterpartyId,
    this.counterpartyName,
    required this.cashLocationId,
    required this.cashLocationName,
    required this.onSuccess,
  });

  @override
  ConsumerState<DebtEntrySheet> createState() => _DebtEntrySheetState();
}

class _DebtEntrySheetState extends ConsumerState<DebtEntrySheet> {
  // Form state
  double _amount = 0;

  // UI state
  bool _isSubmitting = false;

  void _onAmountChanged(double amount) {
    setState(() {
      _amount = amount;
    });
  }

  Future<void> _onSubmit() async {
    if (_amount <= 0) {
      return;
    }

    // Show confirmation dialog
    final result = await TransactionConfirmDialog.show(
      context,
      TransactionConfirmData(
        type: ConfirmTransactionType.debt,
        amount: _amount,
        fromCashLocationName: widget.cashLocationName,
        debtTypeName: widget.debtSubType.label,
        counterpartyName: widget.counterpartyName,
      ),
    );

    if (result == null || !result.confirmed) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(cashControlRepositoryProvider);

      // TODO: Upload attachments to storage and get URLs
      final attachmentUrls = <String>[];

      await repository.createDebtEntry(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen.isEmpty ? null : appState.storeChoosen,
        createdBy: appState.userId,
        cashLocationId: widget.cashLocationId,
        counterpartyId: widget.counterpartyId,
        debtSubType: widget.debtSubType,
        amount: _amount,
        entryDate: DateTime.now(),
        memo: result.memo,
        attachmentUrls: attachmentUrls.isEmpty ? null : attachmentUrls,
      );

      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: TossColors.gray900,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool get _canSubmit => _amount > 0;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xxl),
            topRight: Radius.circular(TossBorderRadius.xxl),
          ),
          boxShadow: TossShadows.bottomSheet,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: TossSpacing.space3),
            Container(
              width: TossSpacing.space9,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Header
            _buildHeader(),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: _buildAmountInput(),
              ),
            ),

            // Fixed bottom button
            Container(
              padding: const EdgeInsets.fromLTRB(
                TossSpacing.space4,
                TossSpacing.space2,
                TossSpacing.space4,
                TossSpacing.space2,
              ),
              decoration: const BoxDecoration(
                color: TossColors.white,
                border: Border(
                  top: BorderSide(color: TossColors.gray100),
                ),
              ),
              child: TossButton.primary(
                text: _isSubmitting ? 'Processing...' : 'Record',
                onPressed: _canSubmit && !_isSubmitting ? _onSubmit : null,
                isEnabled: _canSubmit && !_isSubmitting,
                isLoading: _isSubmitting,
                fullWidth: true,
                leadingIcon: const Icon(Icons.check),
              ),
            ),

            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom + TossSpacing.space2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space2,
        TossSpacing.space2,
        0,
      ),
      child: Row(
        children: [
          // Spacer for alignment
          const SizedBox(width: 48),

          Expanded(
            child: Text(
              'Debt Transaction',
              textAlign: TextAlign.center,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: TossColors.gray900,
              ),
            ),
          ),

          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: TossColors.gray500,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInfoSummary() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          // Debt type row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Center(
                  child: Icon(
                    widget.debtSubType.debtDirection == 'receivable'
                        ? Icons.arrow_forward
                        : Icons.arrow_back,
                    color: TossColors.gray600,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type',
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    Text(
                      widget.debtSubType.label,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space2),
          Container(
            height: 1,
            color: TossColors.gray200,
          ),
          const SizedBox(height: TossSpacing.space2),

          // Counterparty row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: const Center(
                  child: Icon(
                    Icons.business,
                    color: TossColors.gray600,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Counterparty',
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    Text(
                      widget.counterpartyName ?? 'Unknown',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transaction summary (no top padding - header has enough)
        _buildTransactionInfoSummary(),
        const SizedBox(height: TossSpacing.space2),
        _buildSummaryCard(
          icon: Icons.account_balance_wallet,
          label: 'Cash Location',
          value: widget.cashLocationName,
        ),

        const SizedBox(height: TossSpacing.space3),

        // Amount keypad
        AmountInputKeypad(
          initialAmount: _amount,
          onAmountChanged: _onAmountChanged,
          showSubmitButton: false,
        ),

        // Bottom padding for fixed button
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: TossColors.gray600, size: 18),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  value,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                'Change',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
