import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';

import '../../domain/entities/transfer_scope.dart';
import '../formatters/cash_transaction_ui_extensions.dart';
import '../providers/cash_transaction_providers.dart';
import '../widgets/transaction_confirm_dialog.dart';
import '../widgets/transfer_entry/transfer_entry_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

const _tag = '[TransferEntrySheet]';

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
  String? _fromCompanyName;
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
      setState(() {
        _fromCompanyName = 'Current Company'; // Would come from company provider
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
        TossToast.success(context, 'Transfer completed!');

        // Wait a moment for user to see success feedback
        await Future<void>.delayed(TossAnimations.slow);

        if (mounted) {
          widget.onSuccess();
        }
      }
    } catch (e) {
      debugPrint('$_tag ❌ Transfer FAILED: $e');
      if (mounted) {
        TossToast.error(context, 'Error: $e');
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
      duration: TossAnimations.normal,
      curve: TossAnimations.decelerate,
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
            TransferEntryHeader(
              selectedScope: _selectedScope,
              currentStep: _currentStep,
              onBack: () => setState(() => _currentStep--),
              onClose: () => Navigator.pop(context),
            ),

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

  // ==================== STEP 0: SCOPE SELECTION ====================

  Widget _buildScopeSelection() {
    return ScopeSelectionSection(
      selectedScope: _selectedScope,
      isScopeAvailable: _isScopeAvailable,
      onScopeSelected: _onScopeSelected,
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

  // ==================== WITHIN STORE: TO CASH LOCATION ====================

  Widget _buildToCashLocationSelectionWithinStore() {
    final appState = ref.watch(appStateProvider);
    return WithinStoreCashLocationSection(
      fromCashLocationId: widget.fromCashLocationId,
      fromCashLocationName: widget.fromCashLocationName,
      fromStoreName: _fromStoreName,
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen,
      selectedCashLocationId: _toCashLocationId,
      onLocationSelected: _onToCashLocationSelectedReal,
      onChangeFromPressed: () => setState(() => _currentStep = 1),
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
    return WithinCompanyStoreSection(
      fromCashLocationName: widget.fromCashLocationName,
      fromCompanyName: _fromCompanyName,
      otherStores: _getOtherStoresInCompany(),
      selectedStoreId: _toStoreId,
      onStoreSelected: _onToStoreSelectedReal,
      onChangeFromPressed: () => setState(() => _currentStep = 1),
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
    return BetweenCompaniesCompanySection(
      fromCashLocationName: widget.fromCashLocationName,
      otherCompanies: _getOtherCompanies(),
      selectedCompanyId: _toCompanyId,
      onCompanySelected: _onToCompanySelectedReal,
      onChangeFromPressed: () => setState(() => _currentStep = 1),
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
    return BetweenCompaniesStoreSection(
      fromCashLocationName: widget.fromCashLocationName,
      toCompanyName: _toCompanyName,
      targetStores: _toCompanyId != null
          ? _getStoresForCompany(_toCompanyId!)
          : <Map<String, dynamic>>[],
      selectedStoreId: _toStoreId,
      onStoreSelected: _onToStoreSelectedForOtherCompany,
      onChangeFromPressed: () => setState(() => _currentStep = 1),
      onChangeCompanyPressed: () => setState(() => _currentStep = 1),
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
    final targetCompanyId = _selectedScope == TransferScope.betweenCompanies
        ? _toCompanyId ?? ''
        : ref.read(appStateProvider).companyChoosen;

    return InterEntityCashLocationSection(
      selectedScope: _selectedScope!,
      fromCashLocationName: widget.fromCashLocationName,
      targetCompanyId: targetCompanyId,
      targetStoreId: _toStoreId ?? '',
      targetStoreName: _toStoreName,
      targetCompanyName: _toCompanyName,
      selectedCashLocationId: _toCashLocationId,
      onLocationSelected: _onToCashLocationSelectedReal,
      onChangeFromPressed: () => setState(() => _currentStep = 1),
      onChangeStorePressed: () => setState(() {
        _currentStep = _selectedScope == TransferScope.betweenCompanies ? 2 : 1;
      }),
    );
  }

  // ==================== AMOUNT INPUT ====================

  Widget _buildAmountInput() {
    return AmountInputSection(
      selectedScope: _selectedScope,
      fromStoreName: _fromStoreName ?? '',
      fromCashLocationName: widget.fromCashLocationName,
      toCompanyName: _toCompanyName,
      toStoreName: _toStoreName,
      toCashLocationName: _toCashLocationName,
      amount: _amount,
      onAmountChanged: _onAmountChanged,
    );
  }

}
