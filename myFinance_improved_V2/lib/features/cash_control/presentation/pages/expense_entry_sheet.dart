import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/selectors/enhanced_account_selector.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

import '../../domain/entities/cash_control_enums.dart';
import '../widgets/amount_input_keypad.dart';

/// 비용 입력 Bottom Sheet
/// 2025 트렌드: 단계별 입력, 큰 터치 영역, 시각적 피드백
class ExpenseEntrySheet extends ConsumerStatefulWidget {
  final CashDirection direction;
  final String cashLocationId;
  final String? cashLocationName;
  final VoidCallback onSuccess;

  const ExpenseEntrySheet({
    super.key,
    required this.direction,
    required this.cashLocationId,
    this.cashLocationName,
    required this.onSuccess,
  });

  @override
  ConsumerState<ExpenseEntrySheet> createState() => _ExpenseEntrySheetState();
}

class _ExpenseEntrySheetState extends ConsumerState<ExpenseEntrySheet> {
  // Form state
  String? _selectedAccountId;
  String? _selectedAccountName;
  String? _selectedAccountCode;
  double _amount = 0;
  final _memoController = TextEditingController();

  // UI state
  int _currentStep = 0; // 0: 계정 선택, 1: 금액 입력
  bool _isSubmitting = false;

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onAccountSelected(AccountData account) {
    setState(() {
      _selectedAccountId = account.id;
      _selectedAccountName = account.name;
      _selectedAccountCode = account.accountCode;
      _currentStep = 1; // Move to amount input
    });
    HapticFeedback.lightImpact();
  }

  void _onAmountChanged(double amount) {
    setState(() {
      _amount = amount;
    });
  }

  Future<void> _onSubmit() async {
    if (_selectedAccountId == null || _amount <= 0) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: RPC 호출 구현
      // journal_insert_with_everything_utc 또는 simple_cash_entry RPC
      //
      // 비용 분개 로직:
      // Cash Out (돈 나감):
      //   Dr. Expense Account (비용 증가)
      //   Cr. Cash (현금 감소)
      //
      // Cash In (돈 받음 - 비용 환급 등):
      //   Dr. Cash (현금 증가)
      //   Cr. Expense Account (비용 감소)

      // Simulate API call
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: TossColors.error,
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

  bool get _canSubmit => _selectedAccountId != null && _amount > 0;

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
          color: TossColors.surface,
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

            // Progress indicator
            _buildProgressIndicator(),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: _currentStep == 0
                    ? _buildAccountSelection()
                    : _buildAmountInput(),
              ),
            ),

            // Bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space2),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isOut = widget.direction == CashDirection.cashOut;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space4,
        TossSpacing.space2,
        TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Back button (when on step 1)
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _currentStep = 0),
              color: TossColors.gray600,
            )
          else
            const SizedBox(width: 48),

          Expanded(
            child: Column(
              children: [
                Text(
                  '비용 입력',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOut
                            ? TossColors.error.withValues(alpha: 0.1)
                            : TossColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        isOut ? '💸 Cash Out' : '💵 Cash In',
                        style: TossTextStyles.small.copyWith(
                          color: isOut ? TossColors.error : TossColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      widget.cashLocationName ?? 'Cash Location',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
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

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          _buildProgressStep(0, '계정 선택', _currentStep >= 0),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 0 ? TossColors.primary : TossColors.gray200,
            ),
          ),
          _buildProgressStep(1, '금액 입력', _currentStep >= 1),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? TossColors.primary : TossColors.gray200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive && _currentStep > step
                ? const Icon(Icons.check, size: 14, color: TossColors.white)
                : Text(
                    '${step + 1}',
                    style: TossTextStyles.small.copyWith(
                      color: isActive ? TossColors.white : TossColors.gray500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: isActive ? TossColors.primary : TossColors.gray400,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        Text(
          '어떤 비용인가요?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          '비용 계정을 선택해주세요',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Account selector (expense accounts only: 5000-9999)
        EnhancedAccountSelector(
          selectedAccountId: _selectedAccountId,
          onAccountSelected: _onAccountSelected,
          accountType: 'expense', // Filter for expense accounts
          label: '비용 계정',
          hint: '비용 항목을 검색하세요',
          showQuickAccess: true,
          maxQuickItems: 6,
          contextType: 'expense',
        ),

        // Selected account display
        if (_selectedAccountId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          _buildSelectedAccountCard(),
        ],
      ],
    );
  }

  Widget _buildSelectedAccountCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const Center(
              child: Icon(
                Icons.receipt_long,
                color: TossColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedAccountName ?? '',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                if (_selectedAccountCode != null)
                  Text(
                    'Code: $_selectedAccountCode',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: TossColors.primary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // Selected account summary
        if (_selectedAccountName != null)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: TossColors.gray600,
                  size: 18,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    _selectedAccountName!,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _currentStep = 0),
                  child: Text(
                    '변경',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: TossSpacing.space4),

        // Amount keypad
        AmountInputKeypad(
          initialAmount: _amount,
          onAmountChanged: _onAmountChanged,
          showSubmitButton: false,
        ),

        const SizedBox(height: TossSpacing.space4),

        // Memo field
        TossTextField(
          controller: _memoController,
          hintText: '메모 (선택)',
          label: '메모',
          maxLines: 1,
        ),

        const SizedBox(height: TossSpacing.space4),

        // Submit button
        TossButton.primary(
          text: _isSubmitting ? '처리 중...' : '기록하기',
          onPressed: _canSubmit && !_isSubmitting ? _onSubmit : null,
          isEnabled: _canSubmit && !_isSubmitting,
          isLoading: _isSubmitting,
          fullWidth: true,
          leadingIcon: const Icon(Icons.check),
        ),
      ],
    );
  }
}
