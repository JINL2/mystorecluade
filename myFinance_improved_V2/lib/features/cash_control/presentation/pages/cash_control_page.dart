import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

import '../../domain/entities/cash_control_enums.dart';
import '../providers/cash_control_providers.dart';
import '../widgets/debt_subtype_card.dart';
import '../widgets/direction_selection_card.dart';
import '../widgets/transaction_type_card.dart';
import 'debt_entry_sheet.dart';
import 'expense_entry_sheet.dart';

import 'transfer_entry_sheet.dart';

const _tag = '[CashControlPage]';

/// Main Entry Type - first level selection
enum MainEntryType {
  cashInOut, // Expense, Debt - requires Direction
  transfer,  // Transfer - no Direction needed
}

extension MainEntryTypeX on MainEntryType {
  String get label {
    switch (this) {
      case MainEntryType.cashInOut:
        return 'Cash In/Out';
      case MainEntryType.transfer:
        return 'Transfer';
    }
  }

  String get description {
    switch (this) {
      case MainEntryType.cashInOut:
        return 'Expense or debt transaction';
      case MainEntryType.transfer:
        return 'Move cash between locations';
    }
  }

  IconData get icon {
    switch (this) {
      case MainEntryType.cashInOut:
        return Icons.monetization_on_outlined;
      case MainEntryType.transfer:
        return Icons.sync_alt;
    }
  }
}

/// Cash Control Main Page
/// Simple cash transaction entry for employees
///
/// New Flow:
/// 1. Cash Location (first - which vault?)
/// 2. Entry Type: Cash In/Out vs Transfer
/// 3. For Cash In/Out:
///    a. Direction (Cash In / Cash Out)
///    b. Transaction Type (Expense / Debt)
///    c. For Debt: SubType + Counterparty
/// 4. For Transfer: Goes directly to Transfer Sheet (with cash location pre-filled)
class CashControlPage extends ConsumerStatefulWidget {
  const CashControlPage({super.key});

  @override
  ConsumerState<CashControlPage> createState() => _CashControlPageState();
}

class _CashControlPageState extends ConsumerState<CashControlPage> {
  @override
  void initState() {
    super.initState();
    // Invalidate cache on page open to get fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      debugPrint('[CashControlPage] initState - invalidating provider cache');
      ref.invalidate(cashLocationsForStoreProvider((companyId: companyId, storeId: storeId)));
    });
  }

  // Step 0: Cash Location (always first)
  String? _selectedCashLocationId;
  String? _selectedCashLocationName;
  IconData? _selectedCashLocationIcon;

  // Step 1: Main Entry Type
  MainEntryType? _selectedEntryType;

  // Step 2 (Cash In/Out): Direction
  CashDirection? _selectedDirection;

  // Step 3 (Cash In/Out): Transaction Type (Expense or Debt only)
  TransactionType? _selectedType;

  // Step 4 (Debt only): SubType and Counterparty
  DebtSubType? _selectedDebtSubType;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyName;

  // Expansion state for each section
  bool _isCashLocationExpanded = true;
  bool _isEntryTypeExpanded = false;
  bool _isDirectionExpanded = false;
  bool _isTypeExpanded = false;
  bool _isDebtSubTypeExpanded = false;
  bool _isCounterpartyExpanded = false;

  // Available transaction types for Cash In/Out (no Transfer)
  List<TransactionType> get _availableTypes => [
        TransactionType.expense,
        TransactionType.debt,
      ];

  List<DebtSubType> get _availableDebtSubTypes {
    if (_selectedDirection == null) return [];
    return DebtSubTypeX.forDirection(_selectedDirection!);
  }

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
      _selectedDirection = null;
      _selectedType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      // Collapse cash location, expand entry type
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = true;
      _isDirectionExpanded = false;
      _isTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = false;
    });
  }

  void _onEntryTypeSelected(MainEntryType type) {
    HapticFeedback.lightImpact();

    if (type == MainEntryType.transfer) {
      // Go directly to Transfer Sheet with pre-selected cash location
      _showTransferSheet();
      return;
    }

    setState(() {
      _selectedEntryType = type;
      _selectedDirection = null;
      _selectedType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      // Collapse entry type, expand direction
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = false;
      _isDirectionExpanded = true;
      _isTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = false;
    });
  }

  void _onDirectionSelected(CashDirection direction) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDirection = direction;
      _selectedType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      // Collapse direction, expand type
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = false;
      _isDirectionExpanded = false;
      _isTypeExpanded = true;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = false;
    });
  }

  void _onTypeSelected(TransactionType type) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedType = type;
      // Reset debt-specific selections when type changes
      if (type != TransactionType.debt) {
        _selectedDebtSubType = null;
        _selectedCounterpartyId = null;
        _selectedCounterpartyName = null;
      }
      // Collapse type section
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = false;
      _isDirectionExpanded = false;
      _isTypeExpanded = false;
      // For debt, expand debt subtype section
      if (type == TransactionType.debt) {
        _isDebtSubTypeExpanded = true;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _onDebtSubTypeSelected(DebtSubType subType) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDebtSubType = subType;
      // Collapse debt subtype, expand counterparty
      _isCashLocationExpanded = false;
      _isEntryTypeExpanded = false;
      _isDirectionExpanded = false;
      _isTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = true;
    });
  }

  void _onCounterpartySelected(Counterparty counterparty) {
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
        _isDirectionExpanded = false;
        _isTypeExpanded = false;
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
        _isDirectionExpanded = false;
        _isTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleDirectionExpanded() {
    if (_selectedEntryType != MainEntryType.cashInOut) return;
    setState(() {
      _isDirectionExpanded = !_isDirectionExpanded;
      if (_isDirectionExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleTypeExpanded() {
    if (_selectedDirection == null) return;
    setState(() {
      _isTypeExpanded = !_isTypeExpanded;
      if (_isTypeExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isDirectionExpanded = false;
        _isDebtSubTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleDebtSubTypeExpanded() {
    if (_selectedType != TransactionType.debt) return;
    setState(() {
      _isDebtSubTypeExpanded = !_isDebtSubTypeExpanded;
      if (_isDebtSubTypeExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isDirectionExpanded = false;
        _isTypeExpanded = false;
        _isCounterpartyExpanded = false;
      }
    });
  }

  void _toggleCounterpartyExpanded() {
    if (_selectedDebtSubType == null) return;
    setState(() {
      _isCounterpartyExpanded = !_isCounterpartyExpanded;
      if (_isCounterpartyExpanded) {
        _isCashLocationExpanded = false;
        _isEntryTypeExpanded = false;
        _isDirectionExpanded = false;
        _isTypeExpanded = false;
        _isDebtSubTypeExpanded = false;
      }
    });
  }

  void _onProceed() {
    if (_selectedDirection == null || _selectedType == null) return;

    // Debt requires subtype and counterparty
    if (_selectedType == TransactionType.debt) {
      if (_selectedDebtSubType == null || _selectedCounterpartyId == null) {
        return;
      }
    }

    switch (_selectedType!) {
      case TransactionType.expense:
        _showExpenseSheet();
        break;
      case TransactionType.debt:
        _showDebtSheet();
        break;
      case TransactionType.transfer:
        // This shouldn't happen in new flow, but just in case
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => DebtEntrySheet(
        direction: _selectedDirection!,
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
      _selectedDirection = null;
      _selectedType = null;
      _selectedDebtSubType = null;
      _selectedCounterpartyId = null;
      _selectedCounterpartyName = null;
      _isCashLocationExpanded = true;
      _isEntryTypeExpanded = false;
      _isDirectionExpanded = false;
      _isTypeExpanded = false;
      _isDebtSubTypeExpanded = false;
      _isCounterpartyExpanded = false;
    });
  }

  bool get _canProceed {
    if (_selectedCashLocationId == null) return false;
    if (_selectedEntryType != MainEntryType.cashInOut) return false;
    if (_selectedDirection == null || _selectedType == null) return false;

    // Debt requires subtype and counterparty
    if (_selectedType == TransactionType.debt) {
      return _selectedDebtSubType != null && _selectedCounterpartyId != null;
    }

    return true;
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

              // Step 1: Entry Type (after cash location selected AND collapsed)
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

              // Step 2: Direction (only for Cash In/Out, when cash location & entry type collapsed)
              if (_selectedEntryType == MainEntryType.cashInOut &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildCollapsibleSection(
                  title: 'Cash Direction',
                  subtitle: 'Did money come in or go out?',
                  isExpanded: _isDirectionExpanded,
                  hasSelection: _selectedDirection != null,
                  selectedLabel: _selectedDirection?.label,
                  selectedIcon: _selectedDirection?.icon,
                  onToggle: _toggleDirectionExpanded,
                  content: _buildDirectionSelection(),
                ),
              ],

              // Step 3: Transaction Type (Expense or Debt)
              if (_selectedDirection != null &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded &&
                  !_isDirectionExpanded) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildCollapsibleSection(
                  title: 'Transaction Type',
                  subtitle: _selectedDirection == CashDirection.cashOut
                      ? 'Why did money go out?'
                      : 'Why did money come in?',
                  isExpanded: _isTypeExpanded,
                  hasSelection: _selectedType != null,
                  selectedLabel: _selectedType?.label,
                  selectedIcon: _selectedType?.icon,
                  onToggle: _toggleTypeExpanded,
                  content: _buildTypeSelection(),
                ),
              ],

              // Step 4 (Debt only): SubType Selection
              if (_selectedType == TransactionType.debt &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded &&
                  !_isDirectionExpanded &&
                  !_isTypeExpanded) ...[
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

              // Step 5 (Debt only): Counterparty Selection
              if (_selectedType == TransactionType.debt &&
                  _selectedDebtSubType != null &&
                  !_isCashLocationExpanded &&
                  !_isEntryTypeExpanded &&
                  !_isDirectionExpanded &&
                  !_isTypeExpanded &&
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
                const Icon(Icons.account_balance_wallet_outlined,
                    color: TossColors.gray300, size: 48),
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
        // Cash In/Out card
        _buildEntryTypeCard(
          type: MainEntryType.cashInOut,
          isSelected: _selectedEntryType == MainEntryType.cashInOut,
          onTap: () => _onEntryTypeSelected(MainEntryType.cashInOut),
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
    return Column(
      children: _availableTypes.map((type) {
        return Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space2),
          child: TransactionTypeCard(
            type: type,
            isSelected: _selectedType == type,
            onTap: () => _onTypeSelected(type),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDebtSubTypeSelection() {
    return Column(
      children: _availableDebtSubTypes.map((subType) {
        return Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space2),
          child: DebtSubtypeCard(
            subType: subType,
            isSelected: _selectedDebtSubType == subType,
            onTap: () => _onDebtSubTypeSelected(subType),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCounterpartySelector() {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return const Center(
        child: Text('Please select a company first'),
      );
    }

    final counterpartiesAsync = ref.watch(counterpartiesProvider(companyId));

    return counterpartiesAsync.when(
      data: (counterparties) {
        if (counterparties.isEmpty) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.business_outlined,
                    color: TossColors.gray300, size: 48),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No counterparties found',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              ],
            ),
          );
        }

        return Column(
          children: counterparties.map((counterparty) {
            final isSelected = _selectedCounterpartyId == counterparty.counterpartyId;
            return Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              child: _buildSelectionCard(
                title: counterparty.name,
                icon: counterparty.isInternal ? Icons.store : Icons.business,
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
