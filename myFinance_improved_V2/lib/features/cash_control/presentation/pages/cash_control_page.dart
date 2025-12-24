import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

import '../../domain/entities/cash_control_enums.dart';
import '../widgets/direction_selection_card.dart';
import '../widgets/transaction_type_card.dart';
import 'expense_entry_sheet.dart';
import 'debt_entry_sheet.dart';
import 'transfer_entry_sheet.dart';

/// Cash Control 메인 페이지
/// 직원용 간편 현금 입출금 시스템
///
/// 2025 UI/UX 트렌드:
/// - Progressive Disclosure (단계별 표시)
/// - Minimalism (필수 정보만)
/// - Smart Defaults (마지막 사용값 기억)
class CashControlPage extends ConsumerStatefulWidget {
  const CashControlPage({super.key});

  @override
  ConsumerState<CashControlPage> createState() => _CashControlPageState();
}

class _CashControlPageState extends ConsumerState<CashControlPage> {
  // Step 1: Cash Direction
  CashDirection? _selectedDirection;

  // Step 2: Transaction Type
  TransactionType? _selectedType;

  // Current cash location
  String? _selectedCashLocationId;
  String? _selectedCashLocationName;

  @override
  void initState() {
    super.initState();
    // Smart default: 마지막 사용한 현금 위치 불러오기 (향후 구현)
  }

  void _onDirectionSelected(CashDirection direction) {
    setState(() {
      _selectedDirection = direction;
      _selectedType = null; // Reset transaction type when direction changes
    });
  }

  void _onTypeSelected(TransactionType type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _onCashLocationChanged(String? id) {
    setState(() {
      _selectedCashLocationId = id;
    });
  }

  void _onCashLocationChangedWithName(String? id, String? name) {
    setState(() {
      _selectedCashLocationId = id;
      _selectedCashLocationName = name;
    });
  }

  void _onProceed() {
    if (_selectedDirection == null || _selectedType == null) return;

    // 현금이동은 cash location 선택 불필요
    if (_selectedType != TransactionType.transfer && _selectedCashLocationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('현금 위치를 선택해주세요'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    switch (_selectedType!) {
      case TransactionType.expense:
        _showExpenseSheet();
        break;
      case TransactionType.debt:
        _showDebtSheet();
        break;
      case TransactionType.transfer:
        _showTransferSheet();
        break;
    }
  }

  void _showExpenseSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => ExpenseEntrySheet(
        direction: _selectedDirection!,
        cashLocationId: _selectedCashLocationId!,
        cashLocationName: _selectedCashLocationName,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessMessage();
          _resetForm();
        },
      ),
    );
  }

  void _showDebtSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => DebtEntrySheet(
        direction: _selectedDirection!,
        cashLocationId: _selectedCashLocationId!,
        cashLocationName: _selectedCashLocationName,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessMessage();
          _resetForm();
        },
      ),
    );
  }

  void _showTransferSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TransferEntrySheet(
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessMessage();
          _resetForm();
        },
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: TossColors.white),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '${_selectedType?.labelKo ?? "거래"}가 기록되었습니다',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
          ],
        ),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedDirection = null;
      _selectedType = null;
      // Cash location은 유지 (Smart Default)
    });
  }

  bool get _canProceed {
    if (_selectedDirection == null || _selectedType == null) return false;
    if (_selectedType == TransactionType.transfer) return true;
    return _selectedCashLocationId != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar1(
        title: 'Cash Transaction',
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1: Direction Selection
              _buildSectionHeader(
                step: 1,
                title: '현금 방향',
                subtitle: '돈이 들어왔나요, 나갔나요?',
                isActive: true,
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildDirectionSelection(),

              // Step 2: Transaction Type (Progressive Disclosure)
              if (_selectedDirection != null) ...[
                const SizedBox(height: TossSpacing.space6),
                _buildSectionHeader(
                  step: 2,
                  title: '거래 유형',
                  subtitle: _selectedDirection == CashDirection.cashOut
                      ? '왜 돈이 나갔나요?'
                      : '왜 돈이 들어왔나요?',
                  isActive: true,
                ),
                const SizedBox(height: TossSpacing.space3),
                _buildTypeSelection(),
              ],

              // Step 3: Cash Location (Progressive Disclosure)
              // 현금이동은 별도로 출발지/도착지 선택하므로 여기서는 제외
              if (_selectedType != null && _selectedType != TransactionType.transfer) ...[
                const SizedBox(height: TossSpacing.space6),
                _buildSectionHeader(
                  step: 3,
                  title: '현금 위치',
                  subtitle: '어떤 금고에서 거래하나요?',
                  isActive: true,
                ),
                const SizedBox(height: TossSpacing.space3),
                _buildCashLocationSelector(),
              ],

              // Proceed Button
              if (_selectedType != null) ...[
                const SizedBox(height: TossSpacing.space8),
                _buildProceedButton(),
              ],

              // Bottom padding
              const SizedBox(height: TossSpacing.space8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required int step,
    required String title,
    required String subtitle,
    required bool isActive,
  }) {
    return Row(
      children: [
        // Step indicator
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? TossColors.primary : TossColors.gray200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TossTextStyles.body.copyWith(
                color: isActive ? TossColors.white : TossColors.gray500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),

        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? TossColors.gray900 : TossColors.gray400,
                ),
              ),
              Text(
                subtitle,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDirectionSelection() {
    return Row(
      children: [
        Expanded(
          child: DirectionSelectionCard(
            direction: CashDirection.cashIn,
            isSelected: _selectedDirection == CashDirection.cashIn,
            onTap: () => _onDirectionSelected(CashDirection.cashIn),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: DirectionSelectionCard(
            direction: CashDirection.cashOut,
            isSelected: _selectedDirection == CashDirection.cashOut,
            onTap: () => _onDirectionSelected(CashDirection.cashOut),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelection() {
    // 거래 유형 목록 (direction에 따라 추천 표시)
    const types = TransactionType.values;

    return Column(
      children: types.map((type) {
        // Cash Out일 때 비용을 추천
        final isRecommended = _selectedDirection == CashDirection.cashOut
            && type == TransactionType.expense;

        return Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space2),
          child: TransactionTypeCard(
            type: type,
            isSelected: _selectedType == type,
            isRecommended: isRecommended,
            onTap: () => _onTypeSelected(type),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCashLocationSelector() {
    return AutonomousCashLocationSelector(
      selectedLocationId: _selectedCashLocationId,
      onChanged: _onCashLocationChanged,
      onChangedWithName: _onCashLocationChangedWithName,
      label: '현금 위치',
      hint: '금고를 선택하세요',
      showSearch: true,
      showScopeTabs: true,
      hideLabel: true,
    );
  }

  Widget _buildProceedButton() {
    return TossButton.primary(
      text: '다음 단계로',
      onPressed: _canProceed ? _onProceed : null,
      isEnabled: _canProceed,
      fullWidth: true,
      leadingIcon: const Icon(Icons.arrow_forward),
    );
  }
}
