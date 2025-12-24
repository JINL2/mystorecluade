import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_counterparty_selector.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

import '../../domain/entities/cash_control_enums.dart';
import '../widgets/amount_input_keypad.dart';
import '../widgets/debt_subtype_card.dart';

/// 부채 입력 Bottom Sheet
/// 채권(Receivable) / 채무(Payable) 거래 입력
class DebtEntrySheet extends ConsumerStatefulWidget {
  final CashDirection direction;
  final String cashLocationId;
  final String? cashLocationName;
  final VoidCallback onSuccess;

  const DebtEntrySheet({
    super.key,
    required this.direction,
    required this.cashLocationId,
    this.cashLocationName,
    required this.onSuccess,
  });

  @override
  ConsumerState<DebtEntrySheet> createState() => _DebtEntrySheetState();
}

class _DebtEntrySheetState extends ConsumerState<DebtEntrySheet> {
  // Form state
  DebtSubType? _selectedSubType;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyName;
  double _amount = 0;
  final _memoController = TextEditingController();

  // UI state
  int _currentStep = 0; // 0: 세부유형, 1: 거래처, 2: 금액
  bool _isSubmitting = false;

  List<DebtSubType> get _availableSubTypes =>
      DebtSubTypeX.forDirection(widget.direction);

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onSubTypeSelected(DebtSubType subType) {
    setState(() {
      _selectedSubType = subType;
      _currentStep = 1;
    });
    HapticFeedback.lightImpact();
  }

  void _onCounterpartySelected(CounterpartyData counterparty) {
    setState(() {
      _selectedCounterpartyId = counterparty.id;
      _selectedCounterpartyName = counterparty.name;
      _currentStep = 2;
    });
    HapticFeedback.lightImpact();
  }

  void _onAmountChanged(double amount) {
    setState(() {
      _amount = amount;
    });
  }

  Future<void> _onSubmit() async {
    if (_selectedSubType == null ||
        _selectedCounterpartyId == null ||
        _amount <= 0) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: RPC 호출 구현
      // journal_insert_with_everything_utc 또는 simple_cash_entry RPC
      //
      // 부채 분개 로직:
      //
      // 1. 돈 빌려줌 (Lend Money) - Cash Out + Receivable 증가
      //    Dr. Accounts Receivable (채권 증가)
      //    Cr. Cash (현금 감소)
      //
      // 2. 빌려준 돈 회수 (Collect Debt) - Cash In + Receivable 감소
      //    Dr. Cash (현금 증가)
      //    Cr. Accounts Receivable (채권 감소)
      //
      // 3. 돈 빌림 (Borrow Money) - Cash In + Payable 증가
      //    Dr. Cash (현금 증가)
      //    Cr. Accounts Payable (채무 증가)
      //
      // 4. 빌린 돈 갚음 (Repay Debt) - Cash Out + Payable 감소
      //    Dr. Accounts Payable (채무 감소)
      //    Cr. Cash (현금 감소)

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

  bool get _canSubmit =>
      _selectedSubType != null &&
      _selectedCounterpartyId != null &&
      _amount > 0;

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
                child: _buildCurrentStepContent(),
              ),
            ),

            // Bottom padding
            SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom + TossSpacing.space2),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildSubTypeSelection();
      case 1:
        return _buildCounterpartySelection();
      case 2:
        return _buildAmountInput();
      default:
        return const SizedBox();
    }
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
          // Back button
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _currentStep--),
              color: TossColors.gray600,
            )
          else
            const SizedBox(width: 48),

          Expanded(
            child: Column(
              children: [
                Text(
                  '부채 거래',
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
          _buildProgressStep(0, '유형', _currentStep >= 0),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 0 ? TossColors.primary : TossColors.gray200,
            ),
          ),
          _buildProgressStep(1, '거래처', _currentStep >= 1),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 1 ? TossColors.primary : TossColors.gray200,
            ),
          ),
          _buildProgressStep(2, '금액', _currentStep >= 2),
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

  Widget _buildSubTypeSelection() {
    final isIn = widget.direction == CashDirection.cashIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        Text(
          isIn ? '어떻게 돈이 들어왔나요?' : '어떻게 돈이 나갔나요?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          '거래 유형을 선택해주세요',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Sub type cards
        ..._availableSubTypes.map((subType) {
          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space2),
            child: DebtSubtypeCard(
              subType: subType,
              isSelected: _selectedSubType == subType,
              onTap: () => _onSubTypeSelected(subType),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCounterpartySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // Selected subtype summary
        if (_selectedSubType != null)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: _selectedSubType!.debtDirection == 'receivable'
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    _selectedSubType!.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    _selectedSubType!.labelKo,
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

        Text(
          '누구와 거래하나요?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          '거래처를 선택해주세요',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Counterparty selector
        AutonomousCounterpartySelector(
          selectedCounterpartyId: _selectedCounterpartyId,
          onCounterpartySelected: _onCounterpartySelected,
          label: '거래처',
          hint: '거래처를 검색하세요',
          showSearch: true,
        ),

        // Selected counterparty display
        if (_selectedCounterpartyId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          _buildSelectedCounterpartyCard(),
        ],
      ],
    );
  }

  Widget _buildSelectedCounterpartyCard() {
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
                Icons.business,
                color: TossColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              _selectedCounterpartyName ?? '',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: TossColors.gray900,
              ),
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

        // Summary row
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              // SubType
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _selectedSubType?.debtDirection == 'receivable'
                            ? TossColors.success.withValues(alpha: 0.1)
                            : TossColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        _selectedSubType?.emoji ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Flexible(
                      child: Text(
                        _selectedSubType?.labelKo ?? '',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: TossColors.gray200,
              ),
              const SizedBox(width: TossSpacing.space3),
              // Counterparty
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.business,
                      size: 18,
                      color: TossColors.gray500,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Flexible(
                      child: Text(
                        _selectedCounterpartyName ?? '',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
