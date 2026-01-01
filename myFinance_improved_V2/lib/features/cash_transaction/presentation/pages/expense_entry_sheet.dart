import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../providers/cash_transaction_providers.dart';
import '../widgets/amount_input_keypad.dart';
import '../widgets/transaction_confirm_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Expense Entry Bottom Sheet
/// Flow: Account -> Amount (Cash Location already selected on main page)
/// Features: Search + Recent usage from top_accounts_by_user
class ExpenseEntrySheet extends ConsumerStatefulWidget {
  final CashDirection direction;
  final String cashLocationId;
  final String cashLocationName;
  final VoidCallback onSuccess;

  const ExpenseEntrySheet({
    super.key,
    required this.direction,
    required this.cashLocationId,
    required this.cashLocationName,
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

  // Search state
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _searchFocusNode = FocusNode();

  // UI state
  int _currentStep = 0; // 0: account, 1: amount
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }

  void _onAccountSelected(ExpenseAccount account) {
    setState(() {
      _selectedAccountId = account.accountId;
      _selectedAccountName = account.accountName;
      _selectedAccountCode = account.accountCode;
      _currentStep = 1;
    });
    HapticFeedback.lightImpact();
  }

  void _onAmountChanged(double amount) {
    setState(() {
      _amount = amount;
    });
  }

  Future<void> _onSubmit() async {
    // Double-click prevention: check if already submitting
    if (_isSubmitting) {
      debugPrint('[ExpenseEntrySheet] ⚠️ Already submitting, ignoring duplicate tap');
      return;
    }

    if (_selectedAccountId == null || _amount <= 0) {
      return;
    }

    // Set submitting state IMMEDIATELY before any async operation
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Show confirmation dialog
      final result = await TransactionConfirmDialog.show(
        context,
        TransactionConfirmData(
          type: ConfirmTransactionType.expense,
          amount: _amount,
          fromCashLocationName: widget.cashLocationName,
          expenseAccountName: _selectedAccountName,
          expenseAccountCode: _selectedAccountCode,
        ),
      );

      if (result == null || !result.confirmed) {
        // User cancelled - reset submitting state
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
        return;
      }

      final appState = ref.read(appStateProvider);
      final repository = ref.read(cashTransactionRepositoryProvider);

      // Determine if this is a refund based on direction
      final isRefund = widget.direction == CashDirection.cashIn;
      debugPrint('[ExpenseEntrySheet] 📝 Creating expense entry, isRefund: $isRefund');

      // TODO: Upload attachments to storage and get URLs
      // For now, attachment upload is not implemented
      final attachmentUrls = <String>[];

      await repository.createExpenseEntry(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen.isEmpty ? null : appState.storeChoosen,
        createdBy: appState.userId,
        cashLocationId: widget.cashLocationId,
        expenseAccountId: _selectedAccountId!,
        amount: _amount,
        entryDate: DateTime.now(),
        isRefund: isRefund,
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
        // Reset submitting state on error
        setState(() {
          _isSubmitting = false;
        });
      }
    }
    // Note: Don't reset _isSubmitting on success - widget will be popped
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
                child: _buildCurrentStepContent(),
              ),
            ),

            // Fixed bottom button for amount input step
            if (_currentStep == 1) ...[
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
            ],

            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom + TossSpacing.space2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildAccountSelection();
      case 1:
        return _buildAmountInput();
      default:
        return const SizedBox();
    }
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
            child: Text(
              'Expense',
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

  Widget _buildAccountSelection() {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return const Center(
        child: Text('Please select a company first'),
      );
    }

    // Use expense-only provider (account_type = 'expense')
    // This ensures only expense accounts are shown, not Cash, Receivable, etc.
    final accountsAsync = ref.watch(expenseAccountsOnlyProvider(companyId));

    // For search, use the search provider if query is not empty
    final searchAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchExpenseAccountsProvider(companyId: companyId, query: _searchQuery))
        : null;

    return accountsAsync.when(
      data: (accounts) {
        // If searching, use search results; otherwise show all expense accounts
        final displayAccounts = searchAsync?.valueOrNull ?? accounts;
        final hasSearchResults = _searchQuery.isNotEmpty && displayAccounts.isNotEmpty;
        final hasNoSearchResults = _searchQuery.isNotEmpty && displayAccounts.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space3),

            // Cash location summary (read-only, from main page)
            _buildSummaryCard(
              icon: Icons.account_balance_wallet,
              label: 'Cash Location',
              value: widget.cashLocationName,
            ),

            const SizedBox(height: TossSpacing.space4),

            Text(
              'Expense Account',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              'Search or select from recent',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),

            const SizedBox(height: TossSpacing.space3),

            // Search field
            _buildSearchField(),

            const SizedBox(height: TossSpacing.space3),

            // Search results or All expense accounts
            if (hasSearchResults) ...[
              Text(
                'Search Results',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              ...displayAccounts.map((account) {
                final isSelected = _selectedAccountId == account.accountId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                  child: _buildSelectionCard(
                    title: account.accountName,
                    subtitle: 'Code: ${account.accountCode}',
                    icon: Icons.receipt_long,
                    isSelected: isSelected,
                    onTap: () => _onAccountSelected(account),
                  ),
                );
              }),
            ] else if (hasNoSearchResults) ...[
              _buildNoResultsMessage(),
            ] else ...[
              // All expense accounts (account_type = 'expense')
              Text(
                'Expense Accounts',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              ...accounts.map((account) {
                final isSelected = _selectedAccountId == account.accountId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                  child: _buildSelectionCard(
                    title: account.accountName,
                    subtitle: 'Code: ${account.accountCode}',
                    icon: Icons.receipt_long,
                    isSelected: isSelected,
                    onTap: () => _onAccountSelected(account),
                  ),
                );
              }),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: TossColors.gray300, size: 48),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Error loading accounts',
                style: TossTextStyles.body.copyWith(color: TossColors.gray500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: TossTextStyles.body.copyWith(color: TossColors.gray900),
        decoration: InputDecoration(
          hintText: 'Search by name or code...',
          hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
          prefixIcon: const Icon(
            Icons.search,
            color: TossColors.gray400,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                  child: const Icon(
                    Icons.close,
                    color: TossColors.gray400,
                    size: 18,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space3,
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsMessage() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          const Icon(
            Icons.search_off,
            color: TossColors.gray300,
            size: 40,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No accounts found',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Try a different search term',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: TossSpacing.space2),
            ],
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

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary cards (no top padding - header has enough)
        _buildSummaryCard(
          icon: Icons.account_balance_wallet,
          label: 'Cash Location',
          value: widget.cashLocationName,
        ),
        const SizedBox(height: TossSpacing.space2),
        _buildSummaryCard(
          icon: Icons.receipt_long,
          label: 'Expense',
          value: _selectedAccountName ?? '',
          onEdit: () => setState(() => _currentStep = 0),
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
