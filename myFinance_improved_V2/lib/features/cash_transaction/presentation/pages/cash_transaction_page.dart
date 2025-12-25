import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

import '../providers/cash_transaction_providers.dart';
import '../widgets/debt_subtype_card.dart';
import 'debt_entry_sheet.dart';
import 'expense_entry_sheet.dart';

import 'transfer_entry_sheet.dart';

const _tag = '[CashTransactionPage]';

/// Main Entry Type - first level selection
enum MainEntryType {
  expense,   // Pay or refund expenses
  debt,      // Lend or borrow money
  transfer,  // Move cash between locations
}

extension MainEntryTypeX on MainEntryType {
  String get label {
    switch (this) {
      case MainEntryType.expense:
        return 'Expense';
      case MainEntryType.debt:
        return 'Debt';
      case MainEntryType.transfer:
        return 'Transfer';
    }
  }

  String get description {
    switch (this) {
      case MainEntryType.expense:
        return 'Pay or refund expenses';
      case MainEntryType.debt:
        return 'Lend or borrow money';
      case MainEntryType.transfer:
        return 'Move cash between locations';
    }
  }

  IconData get icon {
    switch (this) {
      case MainEntryType.expense:
        return Icons.receipt_long_outlined;
      case MainEntryType.debt:
        return Icons.handshake_outlined;
      case MainEntryType.transfer:
        return Icons.sync_alt;
    }
  }
}

/// Expense SubType - Pay or Refund
enum ExpenseSubType {
  pay,    // Cash goes out
  refund, // Cash comes back
}

extension ExpenseSubTypeX on ExpenseSubType {
  String get label {
    switch (this) {
      case ExpenseSubType.pay:
        return 'Pay';
      case ExpenseSubType.refund:
        return 'Refund';
    }
  }

  String get description {
    switch (this) {
      case ExpenseSubType.pay:
        return 'Record an expense payment';
      case ExpenseSubType.refund:
        return 'Received money back';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseSubType.pay:
        return Icons.arrow_upward;
      case ExpenseSubType.refund:
        return Icons.arrow_downward;
    }
  }

  /// Convert to CashDirection for the sheet
  CashDirection get direction {
    switch (this) {
      case ExpenseSubType.pay:
        return CashDirection.cashOut;
      case ExpenseSubType.refund:
        return CashDirection.cashIn;
    }
  }
}

/// Cash Control Main Page
/// Simple cash transaction entry for employees
///
/// New Flow:
/// 1. Cash Location (first - which vault?)
/// 2. Entry Type: Expense / Debt / Transfer
/// 3. For Expense: Pay/Refund selection → goes to Expense Sheet
/// 4. For Debt: SubType + Counterparty selection → goes to Debt Sheet
/// 5. For Transfer: Goes directly to Transfer Sheet
class CashTransactionPage extends ConsumerStatefulWidget {
  const CashTransactionPage({super.key});

  @override
  ConsumerState<CashTransactionPage> createState() => _CashTransactionPageState();
}

class _CashTransactionPageState extends ConsumerState<CashTransactionPage> {
  @override
  void initState() {
    super.initState();
    // Invalidate cache on page open to get fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      debugPrint('[CashTransactionPage] initState - invalidating provider cache');
      ref.invalidate(cashLocationsForStoreProvider((companyId: companyId, storeId: storeId)));
    });
  }

  // Step 0: Cash Location (always first)
  String? _selectedCashLocationId;
  String? _selectedCashLocationName;
  IconData? _selectedCashLocationIcon;

  // Step 1: Main Entry Type (Expense / Debt / Transfer)
  MainEntryType? _selectedEntryType;

  // Step 2 (Expense only): Pay or Refund
  ExpenseSubType? _selectedExpenseSubType;

  // Step 2 (Debt only): SubType and Counterparty
  DebtSubType? _selectedDebtSubType;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyName;

  // Expansion state for each section
  bool _isCashLocationExpanded = true;
  bool _isEntryTypeExpanded = false;
  bool _isExpenseSubTypeExpanded = false;
  bool _isDebtSubTypeExpanded = false;
  bool _isCounterpartyExpanded = false;

  List<DebtSubType> get _availableDebtSubTypes => DebtSubType.values;

  /// Get icon for cash location type
  IconData _getIconForLocationType(String locationType) {
    switch (locationType.toLowerCase()) {
      case 'vault':
        return Icons.account_balance;
      case 'safe':
        return Icons.safety_check;
      case 'register':
        return Icons.point_of_sale;
      case 'bank':
        return Icons.account_balance_wallet;
      case 'petty_cash':
        return Icons.payments;
      default:
        return Icons.account_balance_wallet;
    }
  }

  void _onCashLocationSelected(CashLocation location) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedCashLocationId = location.cashLocationId;
      _selectedCashLocationName = location.locationName;
      _selectedCashLocationIcon = _getIconForLocationType(location.locationType);
      // Reset everything else
      _selectedEntryType = null;
      _selectedExpenseSubType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      // Collapse cash location, expand entry type
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = true;
      _isExpenseSubTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = false;
    });
  }

  void _onEntryTypeSelected(MainEntryType type) {
    HapticFeedback.lightImpact();

    if (type == MainEntryType.transfer) {
      // Go directly to Transfer Sheet
      _showTransferSheet();
      return;
    }

    setState(() {
      _selectedEntryType = type;
      _selectedExpenseSubType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      // Collapse entry type
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = false;

      // Expand next section based on type
      if (type == MainEntryType.expense) {
        _isExpenseSubTypeExpanded = true;
        _isDebtSubTypeExpanded = false;
      } else if (type == MainEntryType.debt) {
        _isExpenseSubTypeExpanded = false;
        _isDebtSubTypeExpanded = true;
      }
      _isCounterpartyExpanded = false;
    });
  }

  void _onExpenseSubTypeSelected(ExpenseSubType subType) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedExpenseSubType = subType;
    });
    // Go to Expense Sheet with direction
    _showExpenseSheet();
  }

  void _onDebtSubTypeSelected(DebtSubType subType) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDebtSubType = subType;
      // Collapse debt subtype, expand counterparty
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = false;
      _isExpenseSubTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = true;
    });
  }

  void _onCounterpartySelected(Counterparty counterparty) {
    debugPrint('$_tag 👤 Counterparty selected:');
    debugPrint('$_tag   - id: ${counterparty.counterpartyId}');
    debugPrint('$_tag   - name: ${counterparty.name}');
    debugPrint('$_tag   - isInternal: ${counterparty.isInternal}');
    HapticFeedback.lightImpact();
    setState(() {
      _selectedCounterpartyId = counterparty.counterpartyId;
      _selectedCounterpartyName = counterparty.name;
      // Collapse counterparty section
      _isCounterpartyExpanded = false;
    });
  }

  void _toggleCashLocationExpanded() {
    setState(() {
      _isCashLocationExpanded = !_isCashLocationExpanded;
      if (_isCashLocationExpanded) {
        _isEntryTypeExpanded = false;
        _isExpenseSubTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleEntryTypeExpanded() {
    if (_selectedCashLocationId == null) return;
    setState(() {
      _isEntryTypeExpanded = !_isEntryTypeExpanded;
      if (_isEntryTypeExpanded) {
        _isCashLocationExpanded = false;
        _isExpenseSubTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleExpenseSubTypeExpanded() {
    if (_selectedEntryType != MainEntryType.expense) return;
    setState(() {
      _isExpenseSubTypeExpanded = !_isExpenseSubTypeExpanded;
      if (_isExpenseSubTypeExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleDebtSubTypeExpanded() {
    if (_selectedEntryType != MainEntryType.debt) return;
    setState(() {
      _isDebtSubTypeExpanded = !_isDebtSubTypeExpanded;
      if (_isDebtSubTypeExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isExpenseSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleCounterpartyExpanded() {
    debugPrint('$_tag 🔄 _toggleCounterpartyExpanded called');
    debugPrint('$_tag   - _selectedDebtSubType: $_selectedDebtSubType');
    if (_selectedDebtSubType == null) {
      debugPrint('$_tag   ❌ Returning early - no debt subtype selected');
      return;
    }
    debugPrint('$_tag   ✅ Toggling counterparty expanded: $_isCounterpartyExpanded -> ${!_isCounterpartyExpanded}');
    setState(() {
      _isCounterpartyExpanded = !_isCounterpartyExpanded;
      if (_isCounterpartyExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isExpenseSubTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
      }
    });
  }

  void _onProceed() {
    // Debt requires counterparty
    if (_selectedEntryType == MainEntryType.debt) {
      if (_selectedDebtSubType == null || _selectedCounterpartyId == null) {
        return;
      }
      _showDebtSheet();
    }
  }

  void _showExpenseSheet() {
    if (_selectedExpenseSubType == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => ExpenseEntrySheet(
        direction: _selectedExpenseSubType!.direction,
        cashLocationId: _selectedCashLocationId!,
        cashLocationName: _selectedCashLocationName!,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessMessage();
          _resetForm();
        },
      ),
    );
  }

  void _showDebtSheet() {
    if (_selectedDebtSubType == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => DebtEntrySheet(
        direction: _selectedDebtSubType!.applicableDirection,
        debtSubType: _selectedDebtSubType!,
        counterpartyId: _selectedCounterpartyId!,
        counterpartyName: _selectedCounterpartyName,
        cashLocationId: _selectedCashLocationId!,
        cashLocationName: _selectedCashLocationName!,
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
        fromCashLocationId: _selectedCashLocationId!,
        fromCashLocationName: _selectedCashLocationName!,
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
              'Transaction recorded',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
          ],
        ),
        backgroundColor: TossColors.gray900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedCashLocationId = null;
      _selectedCashLocationName = null;
      _selectedCashLocationIcon = null;
      _selectedEntryType = null;
      _selectedExpenseSubType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      _isCashLocationExpanded = true;
      _isEntryTypeExpanded = false;
      _isExpenseSubTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = false;
    });
  }

  bool get _canProceed {
    if (_selectedCashLocationId == null) return false;

    // Debt requires subtype and counterparty
    if (_selectedEntryType == MainEntryType.debt) {
      return _selectedDebtSubType != null && _selectedCounterpartyId != null;
    }

    return false; // Expense goes to sheet directly after Pay/Refund selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: const TossAppBar1(
        title: 'Cash Transaction',
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 0: Cash Location (always first)
              _buildCollapsibleSection(
                title: 'Cash Location',
                subtitle: 'Which vault is involved?',
                isExpanded: _isCashLocationExpanded,
                hasSelection: _selectedCashLocationId != null,
                selectedLabel: _selectedCashLocationName,
                selectedIcon: _selectedCashLocationIcon,
                onToggle: _toggleCashLocationExpanded,
                content: _buildCashLocationSelection(),
              ),

              // Step 1: Entry Type (Expense / Debt / Transfer)
              if (_selectedCashLocationId != null &&
                  !_isCashLocationExpanded) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildCollapsibleSection(
                  title: 'What do you want to do?',
                  subtitle: 'Select transaction type',
                  isExpanded: _isEntryTypeExpanded,
                  hasSelection: _selectedEntryType != null,
                  selectedLabel: _selectedEntryType?.label,
                  selectedIcon: _selectedEntryType?.icon,
                  onToggle: _toggleEntryTypeExpanded,
                  content: _buildEntryTypeSelection(),
                ),
              ],

              // Step 2 (Expense only): Pay or Refund
              if (_selectedEntryType == MainEntryType.expense &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildCollapsibleSection(
                  title: 'Expense Type',
                  subtitle: 'Are you paying or getting a refund?',
                  isExpanded: _isExpenseSubTypeExpanded,
                  hasSelection: _selectedExpenseSubType != null,
                  selectedLabel: _selectedExpenseSubType?.label,
                  selectedIcon: _selectedExpenseSubType?.icon,
                  onToggle: _toggleExpenseSubTypeExpanded,
                  content: _buildExpenseSubTypeSelection(),
                ),
              ],

              // Step 2 (Debt only): Debt SubType Selection
              if (_selectedEntryType == MainEntryType.debt &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildCollapsibleSection(
                  title: 'Debt Type',
                  subtitle: 'What kind of debt transaction?',
                  isExpanded: _isDebtSubTypeExpanded,
                  hasSelection: _selectedDebtSubType != null,
                  selectedLabel: _selectedDebtSubType?.label,
                  selectedIcon: Icons.swap_horiz,
                  onToggle: _toggleDebtSubTypeExpanded,
                  content: _buildDebtSubTypeSelection(),
                ),
              ],

              // Step 3 (Debt only): Counterparty Selection
              if (_selectedEntryType == MainEntryType.debt &&
                  _selectedDebtSubType != null &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded &&
                  !_isDebtSubTypeExpanded) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildCollapsibleSection(
                  title: 'Counterparty',
                  subtitle: 'Who is involved?',
                  isExpanded: _isCounterpartyExpanded,
                  hasSelection: _selectedCounterpartyId != null,
                  selectedLabel: _selectedCounterpartyName,
                  selectedIcon: Icons.business,
                  onToggle: _toggleCounterpartyExpanded,
                  content: _buildCounterpartySelector(),
                ),
              ],

              // Proceed Button
              if (_canProceed) ...[
                const SizedBox(height: TossSpacing.space6),
                _buildProceedButton(),
              ],

              const SizedBox(height: TossSpacing.space8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCashLocationSelection() {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    debugPrint('$_tag 🏠 _buildCashLocationSelection called');
    debugPrint('$_tag 📋 AppState - companyId: "$companyId", storeId: "$storeId"');
    debugPrint('$_tag 📋 companyId.isEmpty: ${companyId.isEmpty}');

    if (companyId.isEmpty) {
      debugPrint('$_tag ⚠️ companyId is empty, showing "Please select a company first"');
      return const Center(
        child: Text('Please select a company first'),
      );
    }

    debugPrint('$_tag 📡 Watching cashLocationsForStoreProvider with companyId: "$companyId", storeId: "$storeId"');

    final cashLocationsAsync = ref.watch(
      cashLocationsForStoreProvider((companyId: companyId, storeId: storeId)),
    );

    return cashLocationsAsync.when(
      data: (locations) {
        debugPrint('$_tag ✅ Got ${locations.length} locations from provider');
        if (locations.isEmpty) {
          debugPrint('$_tag ⚠️ locations.isEmpty == true, showing "No cash locations found"');
          return Center(
            child: Column(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: TossColors.gray300,
                  size: 48,
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No cash locations found',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              ],
            ),
          );
        }

        return Column(
          children: locations.map((location) {
            final isSelected = _selectedCashLocationId == location.cashLocationId;
            return Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              child: _buildCashLocationCard(
                location: location,
                isSelected: isSelected,
                onTap: () => _onCashLocationSelected(location),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text(
          'Error loading cash locations',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
        ),
      ),
    );
  }

  Widget _buildCashLocationCard({
    required CashLocation location,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final icon = _getIconForLocationType(location.locationType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                location.locationName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryTypeSelection() {
    return Column(
      children: [
        // Expense card
        _buildEntryTypeCard(
          type: MainEntryType.expense,
          isSelected: _selectedEntryType == MainEntryType.expense,
          onTap: () => _onEntryTypeSelected(MainEntryType.expense),
        ),
        const SizedBox(height: TossSpacing.space2),
        // Debt card
        _buildEntryTypeCard(
          type: MainEntryType.debt,
          isSelected: _selectedEntryType == MainEntryType.debt,
          onTap: () => _onEntryTypeSelected(MainEntryType.debt),
        ),
        const SizedBox(height: TossSpacing.space2),
        // Transfer card
        _buildEntryTypeCard(
          type: MainEntryType.transfer,
          isSelected: false, // Never shows as selected since it goes to sheet
          onTap: () => _onEntryTypeSelected(MainEntryType.transfer),
        ),
      ],
    );
  }

  Widget _buildExpenseSubTypeSelection() {
    return Column(
      children: [
        // Pay card
        _buildExpenseSubTypeCard(
          subType: ExpenseSubType.pay,
          isSelected: _selectedExpenseSubType == ExpenseSubType.pay,
          onTap: () => _onExpenseSubTypeSelected(ExpenseSubType.pay),
        ),
        const SizedBox(height: TossSpacing.space2),
        // Refund card
        _buildExpenseSubTypeCard(
          subType: ExpenseSubType.refund,
          isSelected: _selectedExpenseSubType == ExpenseSubType.refund,
          onTap: () => _onExpenseSubTypeSelected(ExpenseSubType.refund),
        ),
      ],
    );
  }

  Widget _buildExpenseSubTypeCard({
    required ExpenseSubType subType,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  subType.icon,
                  color: TossColors.gray600,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subType.label,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subType.description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryTypeCard({
    required MainEntryType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: type == MainEntryType.transfer
                    ? TossColors.gray200
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  type.icon,
                  color: TossColors.gray600,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required String subtitle,
    required bool isExpanded,
    required bool hasSelection,
    String? selectedLabel,
    IconData? selectedIcon,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return AnimatedContainer(
      duration: TossAnimations.normal,
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          GestureDetector(
            onTap: onToggle,
            child: hasSelection && !isExpanded
                ? _buildCollapsedHeader(
                    title: title,
                    selectedLabel: selectedLabel ?? '',
                    selectedIcon: selectedIcon,
                  )
                : _buildExpandedHeader(
                    title: title,
                    subtitle: subtitle,
                    hasSelection: hasSelection,
                    isExpanded: isExpanded,
                  ),
          ),

          // Content
          AnimatedCrossFade(
            duration: TossAnimations.normal,
            crossFadeState:
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space3),
              child: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedHeader({
    required String title,
    required String subtitle,
    required bool hasSelection,
    required bool isExpanded,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (hasSelection)
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: TossColors.gray400,
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildCollapsedHeader({
    required String title,
    required String selectedLabel,
    IconData? selectedIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          // Icon
          if (selectedIcon != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  selectedIcon,
                  color: TossColors.gray600,
                  size: 18,
                ),
              ),
            ),
          if (selectedIcon != null) const SizedBox(width: TossSpacing.space3),

          // Title and selection
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  selectedLabel,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Arrow only
          const Icon(
            Icons.keyboard_arrow_down,
            color: TossColors.gray400,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildDebtSubTypeSelection() {
    // Group by Money In / Money Out
    final moneyInTypes = _availableDebtSubTypes
        .where((t) => t.applicableDirection == CashDirection.cashIn)
        .toList();
    final moneyOutTypes = _availableDebtSubTypes
        .where((t) => t.applicableDirection == CashDirection.cashOut)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Money In Section
        _buildDebtSectionHeader(
          label: 'Money In',
          color: const Color(0xFF2E7D32),
          backgroundColor: const Color(0xFFE8F5E9),
        ),
        const SizedBox(height: TossSpacing.space2),
        ...moneyInTypes.map((subType) {
          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space2),
            child: DebtSubtypeCard(
              subType: subType,
              isSelected: _selectedDebtSubType == subType,
              onTap: () => _onDebtSubTypeSelected(subType),
            ),
          );
        }),

        const SizedBox(height: TossSpacing.space3),

        // Money Out Section
        _buildDebtSectionHeader(
          label: 'Money Out',
          color: const Color(0xFFC62828),
          backgroundColor: const Color(0xFFFFEBEE),
        ),
        const SizedBox(height: TossSpacing.space2),
        ...moneyOutTypes.map((subType) {
          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space2),
            child: DebtSubtypeCard(
              subType: subType,
              isSelected: _selectedDebtSubType == subType,
              onTap: () => _onDebtSubTypeSelected(subType),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDebtSectionHeader({
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCounterpartySelector() {
    debugPrint('$_tag 🏗️ _buildCounterpartySelector called');
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    debugPrint('$_tag   - companyId: $companyId');

    if (companyId.isEmpty) {
      debugPrint('$_tag   ❌ No company selected');
      return const Center(
        child: Text('Please select a company first'),
      );
    }

    final counterpartiesAsync = ref.watch(counterpartiesProvider(companyId));

    return counterpartiesAsync.when(
      data: (counterparties) {
        debugPrint('$_tag 📋 Counterparties loaded: ${counterparties.length} total');
        for (final c in counterparties) {
          debugPrint('$_tag   - ${c.name} (isInternal: ${c.isInternal})');
        }

        if (counterparties.isEmpty) {
          return Center(
            child: Column(
              children: [
                const Icon(
                  Icons.business_outlined,
                  color: TossColors.gray300,
                  size: 48,
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No counterparties found',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              ],
            ),
          );
        }

        // Filter out internal counterparties - they should use Transfer instead
        final externalCounterparties = counterparties
            .where((c) => !c.isInternal)
            .toList();

        debugPrint('$_tag 📋 External counterparties (after filter): ${externalCounterparties.length}');

        if (externalCounterparties.isEmpty) {
          return Center(
            child: Column(
              children: [
                const Icon(
                  Icons.business_outlined,
                  color: TossColors.gray300,
                  size: 48,
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No external counterparties',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Use Transfer for internal stores',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray400),
                ),
              ],
            ),
          );
        }

        return Column(
          children: externalCounterparties.map((counterparty) {
            final isSelected = _selectedCounterpartyId == counterparty.counterpartyId;
            return Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              child: _buildSelectionCard(
                title: counterparty.name,
                icon: Icons.business,
                isSelected: isSelected,
                onTap: () => _onCounterpartySelected(counterparty),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text(
          'Error loading counterparties',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedButton() {
    return TossButton.primary(
      text: 'Next',
      onPressed: _canProceed ? _onProceed : null,
      isEnabled: _canProceed,
      fullWidth: true,
      leadingIcon: const Icon(Icons.arrow_forward),
    );
  }
}
