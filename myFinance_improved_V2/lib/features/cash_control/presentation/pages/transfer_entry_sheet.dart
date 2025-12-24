import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

import '../widgets/amount_input_keypad.dart';

/// 현금 이동 Bottom Sheet
/// 금고 간 현금 이동을 위한 간편 입력
class TransferEntrySheet extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;

  const TransferEntrySheet({
    super.key,
    required this.onSuccess,
  });

  @override
  ConsumerState<TransferEntrySheet> createState() => _TransferEntrySheetState();
}

class _TransferEntrySheetState extends ConsumerState<TransferEntrySheet> {
  // Form state
  String? _fromCashLocationId;
  String? _fromCashLocationName;
  String? _toCashLocationId;
  String? _toCashLocationName;
  double _amount = 0;
  final _memoController = TextEditingController();

  // UI state
  int _currentStep = 0; // 0: 출발지, 1: 도착지, 2: 금액
  bool _isSubmitting = false;

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onFromLocationSelected(CashLocationData location) {
    setState(() {
      _fromCashLocationId = location.id;
      _fromCashLocationName = location.name;
      // 같은 위치가 선택되어 있으면 초기화
      if (_toCashLocationId == location.id) {
        _toCashLocationId = null;
        _toCashLocationName = null;
      }
      _currentStep = 1;
    });
    HapticFeedback.lightImpact();
  }

  void _onToLocationSelected(CashLocationData location) {
    setState(() {
      _toCashLocationId = location.id;
      _toCashLocationName = location.name;
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
    if (_fromCashLocationId == null ||
        _toCashLocationId == null ||
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
      // 현금 이동 분개 로직:
      // Dr. Cash (도착지 - 현금 증가)
      // Cr. Cash (출발지 - 현금 감소)
      //
      // 두 개의 journal_lines 생성:
      // 1. debit line: to_cash_location_id
      // 2. credit line: from_cash_location_id

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
      _fromCashLocationId != null &&
      _toCashLocationId != null &&
      _fromCashLocationId != _toCashLocationId &&
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
        return _buildFromLocationSelection();
      case 1:
        return _buildToLocationSelection();
      case 2:
        return _buildAmountInput();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHeader() {
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
                  '현금 이동',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '🔄 금고 간 이동',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
          _buildProgressStep(0, '출발', _currentStep >= 0),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 0 ? TossColors.primary : TossColors.gray200,
            ),
          ),
          _buildProgressStep(1, '도착', _currentStep >= 1),
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

  Widget _buildFromLocationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        Text(
          '어디서 현금을 빼나요?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          '출발 금고를 선택해주세요',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // From cash location selector
        AutonomousCashLocationSelector(
          selectedLocationId: _fromCashLocationId,
          onCashLocationSelected: _onFromLocationSelected,
          label: '출발 금고',
          hint: '현금을 빼는 금고를 선택하세요',
          showSearch: true,
          showScopeTabs: true,
          hideLabel: true,
        ),

        // Visual transfer indicator
        if (_fromCashLocationId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          _buildLocationCard(
            name: _fromCashLocationName ?? '',
            icon: Icons.logout,
            color: TossColors.error,
            label: 'FROM',
          ),
        ],
      ],
    );
  }

  Widget _buildToLocationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From location summary
        _buildLocationCard(
          name: _fromCashLocationName ?? '',
          icon: Icons.logout,
          color: TossColors.error,
          label: 'FROM',
          onEdit: () => setState(() => _currentStep = 0),
        ),

        // Arrow
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Icon(
              Icons.arrow_downward,
              color: TossColors.primary,
              size: 28,
            ),
          ),
        ),

        Text(
          '어디로 현금을 넣나요?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          '도착 금고를 선택해주세요',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // To cash location selector (block the from location)
        AutonomousCashLocationSelector(
          selectedLocationId: _toCashLocationId,
          onCashLocationSelected: _onToLocationSelected,
          label: '도착 금고',
          hint: '현금을 넣는 금고를 선택하세요',
          showSearch: true,
          showScopeTabs: true,
          hideLabel: true,
          blockedLocationIds: _fromCashLocationId != null
              ? {_fromCashLocationId!}
              : null,
        ),

        // Selected to location
        if (_toCashLocationId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          _buildLocationCard(
            name: _toCashLocationName ?? '',
            icon: Icons.login,
            color: TossColors.success,
            label: 'TO',
          ),
        ],
      ],
    );
  }

  Widget _buildLocationCard({
    required String name,
    required IconData icon,
    required Color color,
    required String label,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.small.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                '변경',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Icon(Icons.check_circle, color: color, size: 22),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // Transfer summary
        _buildTransferSummary(),

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
          text: _isSubmitting ? '처리 중...' : '이동하기',
          onPressed: _canSubmit && !_isSubmitting ? _onSubmit : null,
          isEnabled: _canSubmit && !_isSubmitting,
          isLoading: _isSubmitting,
          fullWidth: true,
          leadingIcon: const Icon(Icons.swap_horiz),
        ),
      ],
    );
  }

  Widget _buildTransferSummary() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          // From
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: TossColors.error,
                    size: 18,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'FROM',
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _fromCashLocationName ?? '',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Arrow
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
            child: Icon(
              Icons.arrow_forward,
              color: TossColors.primary,
              size: 24,
            ),
          ),

          // To
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.login,
                    color: TossColors.success,
                    size: 18,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'TO',
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _toCashLocationName ?? '',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
