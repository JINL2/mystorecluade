import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../providers/cash_transaction_providers.dart';
import '../widgets/transaction_confirm_dialog.dart';

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

  // Exchange rate state
  bool _hasMultipleCurrencies = false;

  // Key for accessing TossAmountKeypad state
  final _amountKeypadKey = GlobalKey<TossAmountKeypadState>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _checkForMultipleCurrencies();
  }

  Future<void> _checkForMultipleCurrencies() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      if (mounted) setState(() => _hasMultipleCurrencies = false);
      return;
    }

    try {
      final exchangeRatesData = await ref.read(
        calculatorExchangeRateDataProvider(
          CalculatorExchangeRateParams(companyId: companyId),
        ).future,
      );
      if (!mounted) return;
      final exchangeRates = exchangeRatesData['exchange_rates'] as List? ?? [];
      setState(() => _hasMultipleCurrencies = exchangeRates.isNotEmpty);
    } catch (e) {
      if (mounted) setState(() => _hasMultipleCurrencies = false);
    }
  }

  void _showExchangeRateCalculator() {
    ExchangeRateCalculator.show(
      context: context,
      initialAmount: _amount > 0 ? _amount.toInt().toString() : null,
      onAmountSelected: (amount) {
        final numericValue = double.tryParse(amount) ?? 0;
        setState(() {
          _amount = numericValue;
        });
        // Update the keypad display
        _amountKeypadKey.currentState?.setAmount(numericValue);
      },
    );
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
      // Get currency symbol for dialog
      final currencyAsync = ref.read(
        companyCurrencySymbolProvider(ref.read(appStateProvider).companyChoosen),
      );
      final currencySymbol = currencyAsync.valueOrNull ?? '₩';

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
        currencySymbol: currencySymbol,
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
        TossToast.error(context, 'Error: $e');
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

    return Stack(
      children: [
        AnimatedPadding(
          duration: TossAnimations.normal,
          curve: TossAnimations.decelerate,
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
        ),

        // Loading overlay
        if (_isSubmitting)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: TossColors.black.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(TossBorderRadius.xxl),
                  topRight: Radius.circular(TossBorderRadius.xxl),
                ),
              ),
              child: const TossLoadingView(message: 'Recording...'),
            ),
          ),
      ],
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
            const SizedBox(width: TossSpacing.iconXXL),

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
            TossSummaryCard(
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
                  child: TossSelectionCard(
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
                  child: TossSelectionCard(
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
      loading: () => const Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: TossLoadingView(),
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
            'No expense accounts found',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Only expense-type accounts are shown here',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'The account may exist as Asset, Liability, or Equity type',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary cards with fade-in animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: TossAnimations.medium,
          curve: TossAnimations.decelerate,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: TossSummaryCard(
            icon: Icons.account_balance_wallet,
            label: 'Cash Location',
            value: widget.cashLocationName,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: TossAnimations.medium,
          curve: TossAnimations.decelerate,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: TossSummaryCard(
            icon: Icons.receipt_long,
            label: 'Expense',
            value: _selectedAccountName ?? '',
            onEdit: () => setState(() => _currentStep = 0),
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Amount keypad with fade-in animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: TossAnimations.slow,
          curve: TossAnimations.decelerate,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Consumer(
            builder: (context, ref, _) {
              final appState = ref.watch(appStateProvider);
              final currencyAsync = ref.watch(
                companyCurrencySymbolProvider(appState.companyChoosen),
              );
              return currencyAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(TossSpacing.space8),
                    child: TossLoadingView(),
                  ),
                ),
                error: (_, __) => TossAmountKeypad(
                  key: _amountKeypadKey,
                  initialAmount: _amount,
                  currencySymbol: '₩',
                  onAmountChanged: _onAmountChanged,
                  showSubmitButton: false,
                  onExchangeRateTap:
                      _hasMultipleCurrencies ? _showExchangeRateCalculator : null,
                ),
                data: (currencySymbol) => TossAmountKeypad(
                  key: _amountKeypadKey,
                  initialAmount: _amount,
                  currencySymbol: currencySymbol,
                  onAmountChanged: _onAmountChanged,
                  showSubmitButton: false,
                  onExchangeRateTap:
                      _hasMultipleCurrencies ? _showExchangeRateCalculator : null,
                ),
              );
            },
          ),
        ),

        // Bottom padding for fixed button
        const SizedBox(height: 80),
      ],
    );
  }
}
