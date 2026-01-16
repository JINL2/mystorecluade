import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../providers/cash_transaction_providers.dart';
import '../widgets/cash_transaction/cash_transaction_widgets.dart';
import '../widgets/debt_subtype_card.dart';
import 'debt_entry_sheet.dart';
import 'expense_entry_sheet.dart';
import 'transfer_entry_sheet.dart';


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
    // Use cached data - no need to invalidate on every page open
    // Data is kept alive for 3 minutes in the provider
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
    if (_selectedDebtSubType == null) {
      return;
    }
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
    TossToast.success(context, 'Transaction recorded');
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
      appBar: const TossAppBar(
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
              CollapsibleSection(
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
                CollapsibleSection(
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
                CollapsibleSection(
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
                CollapsibleSection(
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
                CollapsibleSection(
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


    if (companyId.isEmpty) {
      return const Center(
        child: Text('Please select a company first'),
      );
    }


    final cashLocationsAsync = ref.watch(
      cashLocationsForStoreProvider(companyId: companyId, storeId: storeId),
    );

    return cashLocationsAsync.when(
      data: (locations) {
        if (locations.isEmpty) {
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
              child: CashLocationCard(
                location: location,
                isSelected: isSelected,
                icon: _getIconForLocationType(location.locationType),
                onTap: () => _onCashLocationSelected(location),
              ),
            );
          }).toList(),
        );
      },
      loading: () => _buildCashLocationSkeleton(),
      error: (error, _) => Center(
        child: Text(
          'Error loading cash locations',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
        ),
      ),
    );
  }

  Widget _buildEntryTypeSelection() {
    return Column(
      children: [
        // Expense card
        SelectionListItem(
          item: SelectionItem(
            id: 'expense',
            title: MainEntryType.expense.label,
            subtitle: MainEntryType.expense.description,
            icon: MainEntryType.expense.icon,
          ),
          isSelected: _selectedEntryType == MainEntryType.expense,
          onTap: () => _onEntryTypeSelected(MainEntryType.expense),
        ),
        // Debt card
        SelectionListItem(
          item: SelectionItem(
            id: 'debt',
            title: MainEntryType.debt.label,
            subtitle: MainEntryType.debt.description,
            icon: MainEntryType.debt.icon,
          ),
          isSelected: _selectedEntryType == MainEntryType.debt,
          onTap: () => _onEntryTypeSelected(MainEntryType.debt),
        ),
        // Transfer card
        SelectionListItem(
          item: SelectionItem(
            id: 'transfer',
            title: MainEntryType.transfer.label,
            subtitle: MainEntryType.transfer.description,
            icon: MainEntryType.transfer.icon,
          ),
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
        SelectionListItem(
          item: SelectionItem(
            id: 'pay',
            title: ExpenseSubType.pay.label,
            subtitle: ExpenseSubType.pay.description,
            icon: ExpenseSubType.pay.icon,
          ),
          isSelected: _selectedExpenseSubType == ExpenseSubType.pay,
          onTap: () => _onExpenseSubTypeSelected(ExpenseSubType.pay),
        ),
        // Refund card
        SelectionListItem(
          item: SelectionItem(
            id: 'refund',
            title: ExpenseSubType.refund.label,
            subtitle: ExpenseSubType.refund.description,
            icon: ExpenseSubType.refund.icon,
          ),
          isSelected: _selectedExpenseSubType == ExpenseSubType.refund,
          onTap: () => _onExpenseSubTypeSelected(ExpenseSubType.refund),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2 + 2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
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
            return SelectionListItem(
              item: SelectionItem(
                id: counterparty.counterpartyId,
                title: counterparty.name,
                icon: Icons.business,
              ),
              isSelected: isSelected,
              onTap: () => _onCounterpartySelected(counterparty),
            );
          }).toList(),
        );
      },
      loading: () => _buildCounterpartySkeleton(),
      error: (error, _) => Center(
        child: Text(
          'Error loading counterparties',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
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

  /// Skeleton loading UI for cash locations
  Widget _buildCashLocationSkeleton() {
    return Column(
      children: List.generate(3, (index) =>
        Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space2),
          child: _SkeletonCard(),
        ),
      ),
    );
  }

  /// Skeleton loading UI for counterparties
  Widget _buildCounterpartySkeleton() {
    return Column(
      children: List.generate(4, (index) =>
        Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space2),
          child: _SkeletonCard(),
        ),
      ),
    );
  }
}

/// Skeleton card for loading state
class _SkeletonCard extends StatefulWidget {
  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.loadingPulse,
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray100),
          ),
          child: Row(
            children: [
              // Icon placeholder
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: TossColors.gray200.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              // Text placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: TossSpacing.iconSM2,
                      decoration: BoxDecoration(
                        color: TossColors.gray200.withValues(alpha: _animation.value),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1 + 2),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: TossColors.gray100.withValues(alpha: _animation.value),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
