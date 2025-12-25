import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

import '../providers/cash_transaction_providers.dart';
import '../widgets/amount_input_keypad.dart';
import '../widgets/transaction_confirm_dialog.dart';

const _tag = '[TransferEntrySheet]';

/// Transfer Scope - determines accounting treatment
enum TransferScope {
  withinStore,      // 같은 가게 내: Simple cash transfer
  withinCompany,    // 같은 회사 내 다른 가게: Inter-store debt (A/R, A/P)
  betweenCompanies, // 다른 회사: Inter-company debt (A/R, A/P)
}

extension TransferScopeExtension on TransferScope {
  String get label {
    switch (this) {
      case TransferScope.withinStore:
        return 'Within Store';
      case TransferScope.withinCompany:
        return 'Within Company';
      case TransferScope.betweenCompanies:
        return 'Between Companies';
    }
  }

  String get labelKo {
    switch (this) {
      case TransferScope.withinStore:
        return '가게 내 이동';
      case TransferScope.withinCompany:
        return '회사 내 이동';
      case TransferScope.betweenCompanies:
        return '다른 회사로 이동';
    }
  }

  String get description {
    switch (this) {
      case TransferScope.withinStore:
        return 'Move cash between vaults in this store';
      case TransferScope.withinCompany:
        return 'Transfer to another store in your company';
      case TransferScope.betweenCompanies:
        return 'Transfer to another company you own';
    }
  }

  IconData get icon {
    switch (this) {
      case TransferScope.withinStore:
        return Icons.swap_horiz;
      case TransferScope.withinCompany:
        return Icons.store;
      case TransferScope.betweenCompanies:
        return Icons.business;
    }
  }

  bool get isDebtTransaction => this != TransferScope.withinStore;
}

/// Cash Transfer Bottom Sheet
/// 3 Transfer Scopes:
/// 1. Within Store: Simple vault-to-vault (no debt)
/// 2. Within Company: Store-to-store in same company (debt transaction)
/// 3. Between Companies: Company-to-company (debt transaction)
///
/// FROM Cash Location is pre-selected from main page.
class TransferEntrySheet extends ConsumerStatefulWidget {
  final String fromCashLocationId;
  final String fromCashLocationName;
  final VoidCallback onSuccess;

  const TransferEntrySheet({
    super.key,
    required this.fromCashLocationId,
    required this.fromCashLocationName,
    required this.onSuccess,
  });

  @override
  ConsumerState<TransferEntrySheet> createState() => _TransferEntrySheetState();
}

class _TransferEntrySheetState extends ConsumerState<TransferEntrySheet> {
  // Transfer scope
  TransferScope? _selectedScope;

  // FROM side (pre-set from main page)
  String? _fromCompanyId;
  String? _fromCompanyName;
  String? _fromStoreId;
  String? _fromStoreName;

  // TO side
  String? _toCompanyId;
  String? _toCompanyName;
  String? _toStoreId;
  String? _toStoreName;
  String? _toCashLocationId;
  String? _toCashLocationName;

  // Amount
  double _amount = 0;

  // UI state
  int _currentStep = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Set current context from app state
    // Note: In real app, this would come from app state
    // For now we use mock data for the multi-company/store selection
    // but the actual transfer submission uses real repository
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      setState(() {
        _fromCompanyId = appState.companyChoosen;
        _fromCompanyName = 'Current Company'; // Would come from company provider
        _fromStoreId = appState.storeChoosen;
        _fromStoreName = 'Current Store'; // Would come from store provider
      });
    });
  }

  // ==================== HELPER METHODS FOR DATA ACCESS ====================

  /// Get all companies from user data
  List<Map<String, dynamic>> _getCompanies() {
    final appState = ref.read(appStateProvider);
    final companies = appState.user['companies'] as List<dynamic>? ?? [];
    return companies.cast<Map<String, dynamic>>();
  }

  /// Get current company data
  Map<String, dynamic>? _getCurrentCompany() {
    final appState = ref.read(appStateProvider);
    final companies = _getCompanies();
    for (final company in companies) {
      if (company['company_id'] == appState.companyChoosen) {
        return company;
      }
    }
    return null;
  }

  /// Get stores for current company (excluding current store)
  List<Map<String, dynamic>> _getOtherStoresInCompany() {
    final appState = ref.read(appStateProvider);
    final currentCompany = _getCurrentCompany();
    if (currentCompany == null) return [];

    final stores = currentCompany['stores'] as List<dynamic>? ?? [];
    return stores
        .cast<Map<String, dynamic>>()
        .where((s) => s['store_id'] != appState.storeChoosen)
        .toList();
  }

  /// Get other companies (excluding current company)
  List<Map<String, dynamic>> _getOtherCompanies() {
    final appState = ref.read(appStateProvider);
    return _getCompanies()
        .where((c) => c['company_id'] != appState.companyChoosen)
        .toList();
  }

  /// Get stores for a specific company
  List<Map<String, dynamic>> _getStoresForCompany(String companyId) {
    final companies = _getCompanies();
    for (final company in companies) {
      if (company['company_id'] == companyId) {
        final stores = company['stores'] as List<dynamic>? ?? [];
        return stores.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  // ==================== STEP LOGIC ====================

  /// Get total steps based on scope
  int get _totalSteps {
    switch (_selectedScope) {
      case TransferScope.withinStore:
        return 4; // scope -> from cash loc -> to cash loc -> amount
      case TransferScope.withinCompany:
        return 5; // scope -> from cash loc -> to store -> to cash loc -> amount
      case TransferScope.betweenCompanies:
        return 6; // scope -> from cash loc -> to company -> to store -> to cash loc -> amount
      case null:
        return 1;
    }
  }

  void _onScopeSelected(TransferScope scope) {
    debugPrint('[TransferSheet] 🎯 _onScopeSelected called with scope: $scope');
    debugPrint('[TransferSheet] 📋 Before reset - _toStoreId: "$_toStoreId", _currentStep: $_currentStep');
    setState(() {
      _selectedScope = scope;
      // Reset TO selections
      _toCompanyId = null;
      _toCompanyName = null;
      _toStoreId = null;
      _toStoreName = null;
      _toCashLocationId = null;
      _toCashLocationName = null;
      _currentStep = 1;
    });
    debugPrint('[TransferSheet] ✅ After reset - _toStoreId: "$_toStoreId", _currentStep: $_currentStep');
    HapticFeedback.lightImpact();
  }

  void _onAmountChanged(double amount) {
    setState(() {
      _amount = amount;
    });
  }

  Future<void> _onSubmit() async {
    if (_toCashLocationId == null || _amount <= 0 || _selectedScope == null) {
      return;
    }

    // Determine confirmation type based on scope
    ConfirmTransactionType confirmType;
    switch (_selectedScope!) {
      case TransferScope.withinStore:
        confirmType = ConfirmTransactionType.transferWithinStore;
        break;
      case TransferScope.withinCompany:
        confirmType = ConfirmTransactionType.transferWithinCompany;
        break;
      case TransferScope.betweenCompanies:
        confirmType = ConfirmTransactionType.transferBetweenCompanies;
        break;
    }

    // Show confirmation dialog
    final result = await TransactionConfirmDialog.show(
      context,
      TransactionConfirmData(
        type: confirmType,
        amount: _amount,
        fromCashLocationName: widget.fromCashLocationName,
        fromStoreName: _fromStoreName,
        toStoreName: _toStoreName,
        toCompanyName: _toCompanyName,
        toCashLocationName: _toCashLocationName,
      ),
    );

    if (result == null || !result.confirmed) {
      debugPrint('$_tag User cancelled confirmation dialog');
      return;
    }

    debugPrint('$_tag 🚀 Starting transfer submission...');
    debugPrint('$_tag   scope: $_selectedScope');
    debugPrint('$_tag   from: ${widget.fromCashLocationId} (${widget.fromCashLocationName})');
    debugPrint('$_tag   to: $_toCashLocationId ($_toCashLocationName)');
    debugPrint('$_tag   amount: $_amount');

    setState(() {
      _isSubmitting = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(cashTransactionRepositoryProvider);

      // TODO: Upload attachments to storage and get URLs
      final attachmentUrls = <String>[];

      String journalId;
      if (_selectedScope == TransferScope.withinStore) {
        // Simple within-store transfer
        debugPrint('$_tag 📤 Calling createTransferWithinStore...');
        journalId = await repository.createTransferWithinStore(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
          createdBy: appState.userId,
          fromCashLocationId: widget.fromCashLocationId,
          toCashLocationId: _toCashLocationId!,
          amount: _amount,
          entryDate: DateTime.now(),
          memo: result.memo,
          attachmentUrls: attachmentUrls.isEmpty ? null : attachmentUrls,
        );
      } else {
        // Inter-store or inter-company transfer (creates debt)
        // Both Within Company and Between Companies need counterparty
        String? counterpartyId;

        if (_selectedScope == TransferScope.withinCompany) {
          // Within Company: use self-counterparty (company_id = linked_company_id)
          debugPrint('$_tag 🏢 Within Company transfer - getting self-counterparty...');
          final selfCounterparty = await repository.getSelfCounterparty(
            companyId: appState.companyChoosen,
          );
          if (selfCounterparty != null) {
            counterpartyId = selfCounterparty.counterpartyId;
            debugPrint('$_tag ✅ Found self-counterparty: ${selfCounterparty.name} ($counterpartyId)');
          } else {
            debugPrint('$_tag ⚠️ No self-counterparty found, proceeding without counterparty');
          }
        } else if (_selectedScope == TransferScope.betweenCompanies) {
          // Between Companies: need to find counterparty linked to target company
          // TODO: Implement counterparty lookup for between-companies transfers
          debugPrint('$_tag 🏢 Between Companies transfer - counterparty lookup not yet implemented');
        }

        debugPrint('$_tag 📤 Calling createTransferBetweenEntities...');
        debugPrint('$_tag 📤 counterpartyId: $counterpartyId');
        journalId = await repository.createTransferBetweenEntities(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen.isEmpty ? null : appState.storeChoosen,
          createdBy: appState.userId,
          fromCashLocationId: widget.fromCashLocationId,
          toCashLocationId: _toCashLocationId!,
          toStoreId: _toStoreId,
          toCompanyId: _toCompanyId,
          counterpartyId: counterpartyId,
          amount: _amount,
          entryDate: DateTime.now(),
          memo: result.memo,
          attachmentUrls: attachmentUrls.isEmpty ? null : attachmentUrls,
        );
      }

      debugPrint('$_tag ✅ Transfer completed successfully! journal_id: $journalId');

      if (mounted) {
        // Show success feedback before closing
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Transfer completed!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Wait a moment for user to see success feedback
        await Future<void>.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          widget.onSuccess();
        }
      }
    } catch (e) {
      debugPrint('$_tag ❌ Transfer FAILED: $e');
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

  bool get _canSubmit =>
      _toCashLocationId != null &&
      widget.fromCashLocationId != _toCashLocationId &&
      _amount > 0;

  /// Check if current step is amount input step
  bool get _isAmountInputStep {
    if (_selectedScope == null) return false;
    switch (_selectedScope!) {
      case TransferScope.withinStore:
        return _currentStep == 2;
      case TransferScope.withinCompany:
        return _currentStep == 3;
      case TransferScope.betweenCompanies:
        return _currentStep == 4;
    }
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
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
            if (_isAmountInputStep) ...[
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
                  text: _isSubmitting
                      ? 'Processing...'
                      : _selectedScope?.isDebtTransaction == true
                          ? 'Create Transfer'
                          : 'Transfer',
                  onPressed: _canSubmit && !_isSubmitting ? _onSubmit : null,
                  isEnabled: _canSubmit && !_isSubmitting,
                  isLoading: _isSubmitting,
                  fullWidth: true,
                  leadingIcon: Icon(
                    _selectedScope?.icon ?? Icons.swap_horiz,
                  ),
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
    debugPrint('[TransferSheet] 📍 _buildCurrentStepContent - _currentStep: $_currentStep, _selectedScope: $_selectedScope');
    if (_currentStep == 0) {
      return _buildScopeSelection();
    }

    switch (_selectedScope) {
      case TransferScope.withinStore:
        return _buildWithinStoreContent();
      case TransferScope.withinCompany:
        debugPrint('[TransferSheet] 📍 Calling _buildWithinCompanyContent');
        return _buildWithinCompanyContent();
      case TransferScope.betweenCompanies:
        return _buildBetweenCompaniesContent();
      case null:
        return _buildScopeSelection();
    }
  }

  Widget _buildWithinStoreContent() {
    // From cash location already selected from main page
    // Step 1: To cash location, Step 2: Amount
    switch (_currentStep) {
      case 1:
        return _buildToCashLocationSelectionWithinStore();
      case 2:
        return _buildAmountInput();
      default:
        return const SizedBox();
    }
  }

  Widget _buildWithinCompanyContent() {
    // From cash location already selected from main page
    // Step 1: To store, Step 2: To cash location, Step 3: Amount
    debugPrint('[TransferSheet] 📍 _buildWithinCompanyContent - _currentStep: $_currentStep');
    switch (_currentStep) {
      case 1:
        debugPrint('[TransferSheet] 📍 Step 1 -> _buildToStoreSelectionWithinCompany');
        return _buildToStoreSelectionWithinCompany();
      case 2:
        debugPrint('[TransferSheet] 📍 Step 2 -> _buildToCashLocationSelection');
        return _buildToCashLocationSelection();
      case 3:
        debugPrint('[TransferSheet] 📍 Step 3 -> _buildAmountInput');
        return _buildAmountInput();
      default:
        debugPrint('[TransferSheet] ⚠️ Unknown step: $_currentStep -> SizedBox()');
        return const SizedBox();
    }
  }

  Widget _buildBetweenCompaniesContent() {
    // From cash location already selected from main page
    // Step 1: To company, Step 2: To store, Step 3: To cash location, Step 4: Amount
    switch (_currentStep) {
      case 1:
        return _buildToCompanySelection();
      case 2:
        return _buildToStoreSelectionInCompany();
      case 3:
        return _buildToCashLocationSelection();
      case 4:
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
            child: Column(
              children: [
                Text(
                  'Cash Transfer',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                if (_selectedScope != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _selectedScope!.label,
                    style: TossTextStyles.caption.copyWith(
                      color: _selectedScope!.isDebtTransaction
                          ? TossColors.gray700
                          : TossColors.gray500,
                      fontWeight: _selectedScope!.isDebtTransaction
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
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

  // ==================== STEP 0: SCOPE SELECTION ====================

  Widget _buildScopeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        Text(
          'What type of transfer?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select where the money is going',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Scope options
        ...TransferScope.values.map((scope) {
          final isSelected = _selectedScope == scope;
          // Check if option is available
          final isAvailable = _isScopeAvailable(scope);

          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space2),
            child: _buildScopeCard(
              scope: scope,
              isSelected: isSelected,
              isAvailable: isAvailable,
              onTap: isAvailable ? () => _onScopeSelected(scope) : null,
            ),
          );
        }),
      ],
    );
  }

  bool _isScopeAvailable(TransferScope scope) {
    switch (scope) {
      case TransferScope.withinStore:
        // Need at least 2 cash locations in current store
        // For simplicity, always enable - actual check happens in UI
        return true;
      case TransferScope.withinCompany:
        // Need at least 1 other store in company
        return _getOtherStoresInCompany().isNotEmpty;
      case TransferScope.betweenCompanies:
        // Need at least 1 other company
        return _getOtherCompanies().isNotEmpty;
    }
  }

  Widget _buildScopeCard({
    required TransferScope scope,
    required bool isSelected,
    required bool isAvailable,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.5,
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
                  color: scope.isDebtTransaction
                      ? TossColors.gray200
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Center(
                  child: Icon(
                    scope.icon,
                    color: TossColors.gray600,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scope.label,
                      style: TossTextStyles.body.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scope.description,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    if (scope.isDebtTransaction) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          'Creates A/R & A/P',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
      ),
    );
  }

  // ==================== WITHIN STORE: TO CASH LOCATION ====================

  Widget _buildToCashLocationSelectionWithinStore() {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    final cashLocationsAsync = ref.watch(
      cashLocationsForStoreProvider((companyId: companyId, storeId: storeId)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        _buildFromSummary(),

        // Arrow
        _buildArrow(),

        Text(
          'Which Cash Location?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination in ${_fromStoreName}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        cashLocationsAsync.when(
          data: (locations) {
            // Exclude the FROM location
            final availableLocations = locations
                .where((loc) => loc.cashLocationId != widget.fromCashLocationId)
                .toList();

            if (availableLocations.isEmpty) {
              return Center(
                child: Text(
                  'No other cash locations available',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              );
            }

            return Column(
              children: availableLocations.map((location) {
                final isSelected = _toCashLocationId == location.cashLocationId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                  child: _buildSelectionCard(
                    title: location.locationName,
                    icon: Icons.account_balance_wallet,
                    isSelected: isSelected,
                    onTap: () => _onToCashLocationSelectedReal(location),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(
              'Error loading locations',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ),
        ),
      ],
    );
  }

  void _onToCashLocationSelectedReal(CashLocation location) {
    HapticFeedback.lightImpact();
    debugPrint('[TransferSheet] 💰 _onToCashLocationSelectedReal called');
    debugPrint('[TransferSheet] 📋 location: ${location.locationName} (${location.cashLocationId})');
    debugPrint('[TransferSheet] 📋 _selectedScope: $_selectedScope');
    setState(() {
      _toCashLocationId = location.cashLocationId;
      _toCashLocationName = location.locationName;
      // Move to amount step
      // withinStore: step 1 = cash loc, step 2 = amount
      // withinCompany: step 1 = store, step 2 = cash loc, step 3 = amount
      // betweenCompanies: step 1 = company, step 2 = store, step 3 = cash loc, step 4 = amount
      switch (_selectedScope) {
        case TransferScope.withinStore:
          _currentStep = 2;
          break;
        case TransferScope.withinCompany:
          _currentStep = 3;
          break;
        case TransferScope.betweenCompanies:
          _currentStep = 4;
          break;
        case null:
          break;
      }
    });
    debugPrint('[TransferSheet] ✅ After setState - _currentStep: $_currentStep');
  }

  // ==================== WITHIN COMPANY: TO STORE ====================

  Widget _buildToStoreSelectionWithinCompany() {
    final otherStores = _getOtherStoresInCompany();
    debugPrint('[TransferSheet] 🏬 _buildToStoreSelectionWithinCompany called');
    debugPrint('[TransferSheet] 📋 otherStores.length: ${otherStores.length}');
    debugPrint('[TransferSheet] 📋 _fromCompanyName: "$_fromCompanyName"');
    for (final store in otherStores) {
      debugPrint('[TransferSheet]   - ${store['store_name']} (${store['store_id']})');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        _buildFromSummary(),

        // Arrow
        _buildArrow(),

        Text(
          'To which store?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination store in ${_fromCompanyName}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        if (otherStores.isEmpty)
          Center(
            child: Text(
              'No other stores available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          )
        else
          ...otherStores.map((store) {
            final storeId = store['store_id'] as String? ?? '';
            final storeName = store['store_name'] as String? ?? 'Unknown Store';
            final isSelected = _toStoreId == storeId;
            return Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              child: _buildStoreCardReal(
                storeId: storeId,
                storeName: storeName,
                isSelected: isSelected,
                onTap: () => _onToStoreSelectedReal(storeId, storeName),
              ),
            );
          }),

        const SizedBox(height: TossSpacing.space2),
        _buildDebtTransactionNotice(),
      ],
    );
  }

  void _onToStoreSelectedReal(String storeId, String storeName) {
    final appState = ref.read(appStateProvider);
    debugPrint('[TransferSheet] 🏪 _onToStoreSelectedReal called');
    debugPrint('[TransferSheet] 📋 storeId: "$storeId"');
    debugPrint('[TransferSheet] 📋 storeName: "$storeName"');
    debugPrint('[TransferSheet] 📋 appState.companyChoosen: "${appState.companyChoosen}"');
    HapticFeedback.lightImpact();
    setState(() {
      _toStoreId = storeId;
      _toStoreName = storeName;
      _toCompanyId = appState.companyChoosen;
      _toCompanyName = appState.companyName;
      _toCashLocationId = null;
      _toCashLocationName = null;
      _currentStep++;
    });
    debugPrint('[TransferSheet] ✅ After setState - _toStoreId: "$_toStoreId", _currentStep: $_currentStep');
  }

  // ==================== BETWEEN COMPANIES: TO COMPANY ====================

  Widget _buildToCompanySelection() {
    final otherCompanies = _getOtherCompanies();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        _buildFromSummary(),

        // Arrow
        _buildArrow(),

        Text(
          'To which company?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination company',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        if (otherCompanies.isEmpty)
          Center(
            child: Text(
              'No other companies available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          )
        else
          ...otherCompanies.map((company) {
            final companyId = company['company_id'] as String? ?? '';
            final companyName = company['company_name'] as String? ?? 'Unknown Company';
            final stores = company['stores'] as List<dynamic>? ?? [];
            final isSelected = _toCompanyId == companyId;
            return Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              child: _buildCompanyCardReal(
                companyId: companyId,
                companyName: companyName,
                storeCount: stores.length,
                isSelected: isSelected,
                onTap: () => _onToCompanySelectedReal(companyId, companyName),
              ),
            );
          }),

        const SizedBox(height: TossSpacing.space2),
        _buildDebtTransactionNotice(),
      ],
    );
  }

  void _onToCompanySelectedReal(String companyId, String companyName) {
    HapticFeedback.lightImpact();
    setState(() {
      _toCompanyId = companyId;
      _toCompanyName = companyName;
      _toStoreId = null;
      _toStoreName = null;
      _toCashLocationId = null;
      _toCashLocationName = null;
      _currentStep++;
    });
  }

  // ==================== BETWEEN COMPANIES: TO STORE IN COMPANY ====================

  Widget _buildToStoreSelectionInCompany() {
    final targetStores = _toCompanyId != null
        ? _getStoresForCompany(_toCompanyId!)
        : <Map<String, dynamic>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        _buildFromSummary(),

        // Arrow
        _buildArrow(),

        // To company summary
        _buildSummaryCard(
          icon: Icons.business,
          label: 'TO Company',
          value: _toCompanyName ?? '',
          onEdit: () => setState(() => _currentStep = 1),
        ),

        const SizedBox(height: TossSpacing.space4),

        Text(
          'To which store?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination store in ${_toCompanyName}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        if (targetStores.isEmpty)
          Center(
            child: Text(
              'No stores available in this company',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          )
        else
          ...targetStores.map((store) {
            final storeId = store['store_id'] as String? ?? '';
            final storeName = store['store_name'] as String? ?? 'Unknown Store';
            final isSelected = _toStoreId == storeId;
            return Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              child: _buildStoreCardReal(
                storeId: storeId,
                storeName: storeName,
                isSelected: isSelected,
                onTap: () => _onToStoreSelectedForOtherCompany(storeId, storeName),
              ),
            );
          }),
      ],
    );
  }

  void _onToStoreSelectedForOtherCompany(String storeId, String storeName) {
    HapticFeedback.lightImpact();
    setState(() {
      _toStoreId = storeId;
      _toStoreName = storeName;
      _toCashLocationId = null;
      _toCashLocationName = null;
      _currentStep++;
    });
  }

  // ==================== TO CASH LOCATION (for inter-store/company) ====================

  Widget _buildToCashLocationSelection() {
    // Get the companyId for the target store
    // If between companies, use _toCompanyId, otherwise use current company
    final targetCompanyId = _selectedScope == TransferScope.betweenCompanies
        ? _toCompanyId ?? ''
        : ref.read(appStateProvider).companyChoosen;

    debugPrint('[TransferSheet] 🔍 _buildToCashLocationSelection called');
    debugPrint('[TransferSheet] 📋 _selectedScope: $_selectedScope');
    debugPrint('[TransferSheet] 📋 _toStoreId: "$_toStoreId"');
    debugPrint('[TransferSheet] 📋 _toStoreName: "$_toStoreName"');
    debugPrint('[TransferSheet] 📋 targetCompanyId: "$targetCompanyId"');
    debugPrint('[TransferSheet] 📋 _toCompanyId: "$_toCompanyId"');

    // Use provider to fetch cash locations for the target store
    final cashLocationsAsync = ref.watch(
      cashLocationsForStoreProvider((
        companyId: targetCompanyId,
        storeId: _toStoreId ?? '',
      )),
    );

    final asyncStr = cashLocationsAsync.toString();
    debugPrint('[TransferSheet] 📡 cashLocationsAsync state: ${asyncStr.length > 50 ? asyncStr.substring(0, 50) : asyncStr}...');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        _buildFromSummary(),

        // Arrow
        _buildArrow(),

        // To store summary
        _buildSummaryCard(
          icon: Icons.store,
          label: _selectedScope == TransferScope.betweenCompanies
              ? '$_toCompanyName'
              : 'TO Store',
          value: _toStoreName ?? '',
          onEdit: () => setState(() {
            _currentStep = _selectedScope == TransferScope.betweenCompanies ? 2 : 1;
          }),
        ),

        const SizedBox(height: TossSpacing.space4),

        Text(
          'Which Cash Location?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination in ${_toStoreName}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        cashLocationsAsync.when(
          data: (locations) {
            debugPrint('[TransferSheet] 📥 cashLocationsAsync.data received');
            debugPrint('[TransferSheet] 📥 locations.length: ${locations.length}');
            for (final loc in locations) {
              debugPrint('[TransferSheet]   - ${loc.locationName} (storeId: ${loc.storeId})');
            }
            if (locations.isEmpty) {
              debugPrint('[TransferSheet] ⚠️ No locations found for _toStoreId: "$_toStoreId"');
              return Center(
                child: Text(
                  'No cash locations available in this store',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              );
            }

            return Column(
              children: locations.map((location) {
                final isSelected = _toCashLocationId == location.cashLocationId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                  child: _buildSelectionCard(
                    title: location.locationName,
                    icon: Icons.account_balance_wallet,
                    isSelected: isSelected,
                    onTap: () => _onToCashLocationSelectedReal(location),
                  ),
                );
              }).toList(),
            );
          },
          loading: () {
            debugPrint('[TransferSheet] ⏳ cashLocationsAsync is loading...');
            return const Center(child: CircularProgressIndicator());
          },
          error: (error, stack) {
            debugPrint('[TransferSheet] ❌ cashLocationsAsync error: $error');
            debugPrint('[TransferSheet] ❌ stack: $stack');
            return Center(
              child: Text(
                'Error loading cash locations',
                style: TossTextStyles.body.copyWith(color: TossColors.gray500),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==================== AMOUNT INPUT ====================

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transfer summary (no top padding - header has enough)
        _buildTransferSummary(),

        // Debt transaction notice
        if (_selectedScope?.isDebtTransaction == true) ...[
          const SizedBox(height: TossSpacing.space2),
          _buildDebtTransactionNotice(),
        ],

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

  // ==================== HELPER WIDGETS ====================

  Widget _buildContextCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          const Icon(Icons.store, color: TossColors.gray600, size: 18),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fromStoreName ?? '',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _fromCompanyName ?? '',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: Icon(
          Icons.arrow_downward,
          color: TossColors.gray400,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildFromSummary() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
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
            child: const Center(
              child: Icon(
                Icons.logout,
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
                  'FROM',
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.fromCashLocationName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _currentStep = 1),
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

  Widget _buildStoreCardReal({
    required String storeId,
    required String storeName,
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
              child: const Center(
                child: Icon(
                  Icons.store,
                  color: TossColors.gray600,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                storeName,
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

  Widget _buildCompanyCardReal({
    required String companyId,
    required String companyName,
    required int storeCount,
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
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: const Center(
                child: Icon(
                  Icons.business,
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
                    companyName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                  ),
                  Text(
                    '$storeCount store${storeCount > 1 ? 's' : ''}',
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

  Widget _buildDebtTransactionNotice() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: TossColors.gray600,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'This will create A/R & A/P entries for proper tracking.',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
        ],
      ),
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
      child: Column(
        children: [
          // From
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: TossColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout,
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
                      'FROM',
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedScope != TransferScope.withinStore)
                      Text(
                        '$_fromStoreName',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    Text(
                      widget.fromCashLocationName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Arrow
          const Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Icon(
              Icons.arrow_downward,
              color: TossColors.gray400,
              size: 20,
            ),
          ),

          // To
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: TossColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.login,
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
                      'TO',
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedScope == TransferScope.betweenCompanies)
                      Text(
                        '$_toCompanyName',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    if (_selectedScope != TransferScope.withinStore)
                      Text(
                        '$_toStoreName',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    Text(
                      _toCashLocationName ?? '',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
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
}
