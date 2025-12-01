import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
// Use feature-level providers (Clean Architecture compliant)
import '../providers/journal_input_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/selectors/autonomous_cash_location_selector.dart';
import '../../../../shared/widgets/selectors/autonomous_counterparty_selector.dart';
import '../../../../shared/widgets/selectors/enhanced_account_selector.dart';
import '../../../../shared/widgets/toss/keyboard/toss_numberpad_modal.dart';
import '../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../shared/widgets/toss/toss_enhanced_text_field.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_secondary_button.dart';
import '../../domain/entities/debt_category.dart';
import '../../domain/entities/transaction_line.dart';
import 'exchange_rate_calculator.dart';



class AddTransactionDialog extends ConsumerStatefulWidget {
  final TransactionLine? existingLine;
  final bool? initialIsDebit;
  final double? suggestedAmount;
  final Set<String>? blockedCashLocationIds;
  
  const AddTransactionDialog({
    super.key,
    this.existingLine,
    this.initialIsDebit,
    this.suggestedAmount,
    this.blockedCashLocationIds,
  });
  
  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  late bool _isDebit;
  String? _selectedAccountId;
  String? _selectedAccountName;
  String? _selectedCategoryTag;
  String? _selectedCounterpartyId;
  bool _hasMultipleCurrencies = false;  // Track if multiple currencies exist
  String? _selectedCounterpartyName;
  String? _selectedCounterpartyStoreId;
  String? _selectedCounterpartyStoreName;
  String? _selectedCashLocationId;
  String? _selectedCashLocationName;  // ✅ NEW: Cash location name
  String? _selectedCashLocationType;  // ✅ NEW: Cash location type
  String? _selectedCounterpartyCashLocationId;
  String? _selectedCounterpartyCashLocationName;  // ✅ NEW: Counterparty cash location name
  String? _linkedCompanyId;
  bool _isInternal = false;
  
  // Debt fields
  String? _debtCategory;
  final _interestRateController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _dueDate;
  final _debtDescriptionController = TextEditingController();
  
  // Fixed asset fields
  final _fixedAssetNameController = TextEditingController();
  final _salvageValueController = TextEditingController();
  DateTime? _acquisitionDate;
  final _usefulLifeController = TextEditingController();
  
  // Common fields
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Focus nodes for keyboard navigation
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _interestRateFocusNode = FocusNode();
  
  // Account mapping
  Map<String, dynamic>? _accountMapping;
  String? _mappingError;
  
  @override
  void initState() {
    super.initState();
    
    // Check for multiple currencies
    _checkForMultipleCurrencies();
    
    // Initialize with existing line data if editing
    if (widget.existingLine != null) {
      final line = widget.existingLine!;
      _isDebit = line.isDebit;
      _selectedAccountId = line.accountId;
      _selectedAccountName = line.accountName;
      _selectedCategoryTag = line.categoryTag;
      _selectedCounterpartyId = line.counterpartyId;
      _selectedCounterpartyName = line.counterpartyName;
      _selectedCounterpartyStoreId = line.counterpartyStoreId;
      _selectedCounterpartyStoreName = line.counterpartyStoreName;
      _selectedCashLocationId = line.cashLocationId;
      _selectedCashLocationName = line.cashLocationName; // ✅ Load cash location name
      _selectedCashLocationType = line.cashLocationType; // ✅ Load cash location type
      _selectedCounterpartyCashLocationId = line.counterpartyCashLocationId; // Load existing counterparty cash location
      // Format amount with thousand separators
      final formatter = NumberFormat('#,##0.##', 'en_US');
      _amountController.text = formatter.format(line.amount);
      _descriptionController.text = line.description ?? '';
      
      // Check if counterparty exists and get its details to set _isInternal and _linkedCompanyId
      if (_selectedCounterpartyId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _loadCounterpartyDetails();
        });
      }
      
      // Debt fields
      _debtCategory = line.debtCategory;
      _interestRateController.text = (line.interestRate ?? 0).toString();
      _issueDate = line.issueDate;
      _dueDate = line.dueDate;
      _debtDescriptionController.text = line.debtDescription ?? '';
      
      // Fixed asset fields
      _fixedAssetNameController.text = line.fixedAssetName ?? '';
      _salvageValueController.text = (line.salvageValue ?? 0).toString();
      _acquisitionDate = line.acquisitionDate;
      _usefulLifeController.text = (line.usefulLife ?? 5).toString();
      
      _accountMapping = line.accountMapping;
    } else {
      _isDebit = widget.initialIsDebit ?? true;
      _issueDate = DateTime.now();
      _dueDate = null; // Default to null for due date
      _acquisitionDate = DateTime.now();
      _interestRateController.text = '0'; // Default interest rate to 0
      
      // Pre-fill amount if suggested
      if (widget.suggestedAmount != null) {
        final formatter = NumberFormat('#,##0.##', 'en_US');
        _amountController.text = formatter.format(widget.suggestedAmount);
      }
    }
  }
  
  Future<void> _checkForMultipleCurrencies() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      setState(() {
        _hasMultipleCurrencies = false;
      });
      return;
    }
    
    try {
      // Use the existing provider to get exchange rates
      final exchangeRatesData = await ref.read(exchangeRatesProvider(companyId).future);
      
      final exchangeRates = exchangeRatesData['exchange_rates'] as List? ?? [];
      // Show calculator only if there are multiple currencies (more than just base currency)
      setState(() {
        _hasMultipleCurrencies = exchangeRates.length > 1;
      });
        } catch (e) {
      // If there's an error, hide the calculator button
      setState(() {
        _hasMultipleCurrencies = false;
      });
    }
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _interestRateController.dispose();
    _debtDescriptionController.dispose();
    _fixedAssetNameController.dispose();
    _salvageValueController.dispose();
    _usefulLifeController.dispose();
    _amountFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _interestRateFocusNode.dispose();
    super.dispose();
  }
  
  Future<void> _loadCounterpartyDetails() async {
    if (_selectedCounterpartyId == null) return;

    try {
      final appState = ref.read(appStateProvider);
      final counterparties = await ref.read(journalCounterpartiesProvider(appState.companyChoosen).future);
      final counterparty = counterparties.firstWhere(
        (Map<String, dynamic> c) => c['counterparty_id'] == _selectedCounterpartyId,
        orElse: () => <String, dynamic>{},
      );

      if (counterparty.isNotEmpty) {
        setState(() {
          _linkedCompanyId = counterparty['linked_company_id']?.toString();
          _isInternal = counterparty['is_internal'] == true;
        });
      }
    } catch (e, stackTrace) {
      // Log error for debugging
      debugPrint('Error loading counterparty details: $e');
      debugPrint('StackTrace: $stackTrace');

      // Optional: Show user-friendly error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load counterparty details'),
            backgroundColor: TossColors.error,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  Future<void> _checkAccountMapping() async {
    debugPrint('🔍 _checkAccountMapping START: accountId=$_selectedAccountId, counterpartyId=$_selectedCounterpartyId, isInternal=$_isInternal, categoryTag=$_selectedCategoryTag');

    if (_selectedAccountId == null ||
        _selectedCounterpartyId == null ||
        !_isInternal ||
        (_selectedCategoryTag != 'payable' && _selectedCategoryTag != 'receivable')) {
      debugPrint('⚠️ _checkAccountMapping SKIPPED - conditions not met');
      setState(() {
        _accountMapping = null;
        _mappingError = null;
      });
      return;
    }

    debugPrint('✅ _checkAccountMapping - conditions met, proceeding...');
    setState(() {
      _mappingError = null;
    });

    try {
      final appState = ref.read(appStateProvider);
      final checkMapping = ref.read(checkAccountMappingProvider);
      debugPrint('🔍 Checking mapping: company=${appState.companyChoosen}, counterparty=$_selectedCounterpartyId, account=$_selectedAccountId');
      final mapping = await checkMapping(
        appState.companyChoosen,
        _selectedCounterpartyId!,
        _selectedAccountId!,
      );

      debugPrint('🔍 Mapping result: $mapping');
      setState(() {
        _accountMapping = mapping;
        if (mapping == null) {
          _mappingError = 'Account mapping required for internal transactions';
          _showMappingRequiredDialog();
        }
      });
    } catch (e, stackTrace) {
      debugPrint('❌ _checkAccountMapping ERROR: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _mappingError = 'Error checking account mapping';
      });
    }
  }
  
  void _showMappingRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow tap-outside-to-dismiss for error dialogs
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space6),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: TossColors.warning,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Account Mapping Required',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  'This internal counterparty requires an account mapping to be set up first.',
                  style: TossTextStyles.body.copyWith(
                    fontSize: 15,
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      // Reset counterparty selection
                      setState(() {
                        _selectedCounterpartyId = null;
                        _selectedCounterpartyName = null;
                        _selectedCounterpartyStoreId = null;
                        _selectedCounterpartyStoreName = null;
                        _linkedCompanyId = null;
                        _isInternal = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      foregroundColor: TossColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  
  void _showNumberpadModal() {
    if (!mounted) return;

    TossNumberpadModal.show(
      context: context,
      title: 'Enter Amount',
      initialValue: _amountController.text.isEmpty
        ? null
        : _amountController.text.replaceAll(',', ''),
      allowDecimal: true,
      onConfirm: (result) {
        // Check mounted before updating state
        if (!mounted) return;

        // Format the result with thousand separators
        final formatter = NumberFormat('#,##0.##', 'en_US');
        final numericValue = double.tryParse(result) ?? 0;
        _amountController.text = formatter.format(numericValue);
      },
    );
  }
  
  void _showExchangeRateCalculator() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),  // Visible backdrop
      isDismissible: true,  // Allow dismissing by tapping outside
      enableDrag: true,     // Allow dragging to dismiss
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,  // Fixed height
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExchangeRateCalculator(
          initialAmount: _amountController.text.replaceAll(',', ''),
          onAmountSelected: (amount) {
            // Format the result with thousand separators
            final formatter = NumberFormat('#,##0.##', 'en_US');
            final numericValue = double.tryParse(amount) ?? 0;
            setState(() {
              _amountController.text = formatter.format(numericValue);
            });
          },
        ),
      ),
    );
  }

  void _saveTransaction() {
    // Remove commas before parsing
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0;

    if (_selectedAccountId == null || amount <= 0) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Invalid Input',
          message: 'Please select an account and enter a valid amount',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    // Check if mapping is required but not found
    if (_isInternal &&
        (_selectedCategoryTag == 'payable' || _selectedCategoryTag == 'receivable') &&
        _accountMapping == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Mapping Required',
          message: 'Account mapping is required for this internal transaction',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }
    
    final transactionLine = TransactionLine(
      accountId: _selectedAccountId,
      accountName: _selectedAccountName,
      categoryTag: _selectedCategoryTag,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      amount: amount,
      isDebit: _isDebit,
      counterpartyId: _selectedCounterpartyId,
      counterpartyName: _selectedCounterpartyName,
      counterpartyStoreId: _selectedCounterpartyStoreId,
      counterpartyStoreName: _selectedCounterpartyStoreName,
      cashLocationId: _selectedCashLocationId,
      cashLocationName: _selectedCashLocationName, // ✅ Use data from callback
      cashLocationType: _selectedCashLocationType, // ✅ Use data from callback
      linkedCompanyId: _linkedCompanyId,
      counterpartyCashLocationId: _selectedCounterpartyCashLocationId, // Add counterparty cash location
      debtCategory: _debtCategory,
      interestRate: double.tryParse(_interestRateController.text),
      issueDate: _issueDate,
      dueDate: _dueDate,
      debtDescription: _debtDescriptionController.text.isNotEmpty ? _debtDescriptionController.text : null,
      fixedAssetName: _fixedAssetNameController.text.isNotEmpty ? _fixedAssetNameController.text : null,
      salvageValue: double.tryParse(_salvageValueController.text),
      acquisitionDate: _acquisitionDate,
      usefulLife: int.tryParse(_usefulLifeController.text),
      accountMapping: _accountMapping,
    );
    
    Navigator.of(context).pop(transactionLine);
  }
  
  Widget _buildNoStoresInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Counterparty Store',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 20, color: TossColors.gray500),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  'This counterparty has no stores configured',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStoreDropdown(List<Map<String, dynamic>> stores) {
    return TossDropdown<String?>(
      label: 'Counterparty Store',
      value: _selectedCounterpartyStoreId,
      hint: 'Select counterparty store (optional)',
      items: [
        const TossDropdownItem(
          value: null,
          label: 'No store selected',
        ),
        ...stores.map((store) => TossDropdownItem(
          value: store['store_id'] as String,
          label: (store['store_name'] ?? 'Unknown Store') as String,
        ),),
      ],
      onChanged: (storeId) {
        setState(() {
          _selectedCounterpartyStoreId = storeId;
          if (storeId != null) {
            final store = stores.firstWhere((s) => s['store_id'] == storeId);
            _selectedCounterpartyStoreName = store['store_name'] as String?;
          } else {
            _selectedCounterpartyStoreName = null;
          }
          // Clear cash location when store changes
          _selectedCashLocationId = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        // No padding needed since footer is conditionally hidden
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.8,
          ),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingLine != null ? 'Edit Transaction' : 'Add Transaction',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: TossColors.gray200),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TossSpacing.space5).copyWith(
                bottom: TossSpacing.space5 + MediaQuery.of(context).viewInsets.bottom,
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Type Toggle
                    _buildSectionTitle('Transaction Type'),
                    const SizedBox(height: TossSpacing.space2),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      padding: const EdgeInsets.all(TossSpacing.space1),
                      child: Stack(
                        children: [
                          // Animated selection indicator
                          AnimatedAlign(
                            alignment: _isDebit 
                              ? Alignment.centerLeft 
                              : Alignment.centerRight,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: _isDebit 
                                    ? TossColors.primary 
                                    : TossColors.success,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isDebit 
                                        ? TossColors.primary 
                                        : TossColors.success).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildAnimatedTypeButton('Debit', true),
                              ),
                              Expanded(
                                child: _buildAnimatedTypeButton('Credit', false),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Account Selection - Enhanced with Type-safe callback
                    Consumer(
                      builder: (context, ref, child) {
                        return EnhancedAccountSelector(
                          selectedAccountId: _selectedAccountId,
                          contextType: 'journal_entry',
                          // ✅ NEW: Type-safe callback
                          onAccountSelected: (account) {
                            setState(() {
                              _selectedAccountId = account.id;
                              _selectedAccountName = account.name;
                              _selectedCategoryTag = account.categoryTag;
                              // Reset all dependent fields when account changes
                              _selectedCashLocationId = null;
                              _selectedCounterpartyId = null;
                              _selectedCounterpartyName = null;
                              _selectedCounterpartyStoreId = null;
                              _selectedCounterpartyStoreName = null;
                              _linkedCompanyId = null;
                              _isInternal = false;
                              _accountMapping = null;
                              _mappingError = null;
                            });
                          },
                          label: 'Account',
                          hint: 'Select account',
                          showSearch: true,
                          showTransactionCount: false,
                          showQuickAccess: true,
                          maxQuickItems: 5,
                        );
                      },
                    ),
                    
                    // Cash Location Selection - Using AutonomousCashLocationSelector
                    if (_selectedCategoryTag == 'cash') ...[
                      const SizedBox(height: 20),
                      AutonomousCashLocationSelector(
                        selectedLocationId: _selectedCashLocationId,
                        // ✅ NEW: Type-safe callback - No Provider re-fetch needed!
                        onCashLocationSelected: (cashLocation) {
                          debugPrint('🎯 Cash location selected: ${cashLocation.name} (${cashLocation.id})');

                          setState(() {
                            _selectedCashLocationId = cashLocation.id;
                            _selectedCashLocationName = cashLocation.name;
                            _selectedCashLocationType = cashLocation.type;
                          });
                        },
                        // ✅ Legacy callback for null case
                        onChanged: (locationId) {
                          if (locationId == null) {
                            setState(() {
                              _selectedCashLocationId = null;
                              _selectedCashLocationName = null;
                              _selectedCashLocationType = null;
                            });
                          }
                        },
                        label: 'Cash Location',
                        hint: 'Select cash location',
                        showSearch: true,
                        showTransactionCount: false,
                        blockedLocationIds: widget.blockedCashLocationIds,
                      ),
                    ],
                    
                    // Payable/Receivable specific fields
                    if (_selectedCategoryTag != null && (_selectedCategoryTag!.toLowerCase() == 'payable' || _selectedCategoryTag!.toLowerCase() == 'receivable')) ...[
                      const SizedBox(height: 20),
                      Text(
                        _selectedCategoryTag == 'payable' 
                            ? 'Counterparty (Supplier/Vendor)' 
                            : _selectedCategoryTag == 'receivable'
                                ? 'Counterparty (Customer)'
                                : 'Counterparty',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Consumer(
                        builder: (context, ref, child) {
                          return AutonomousCounterpartySelector(
                            selectedCounterpartyId: _selectedCounterpartyId,
                            // ✅ NEW: Type-safe callback - No async/await needed!
                            onCounterpartySelected: (counterparty) {
                              debugPrint('🎯 Counterparty selected: ${counterparty.name} (${counterparty.id})');

                              setState(() {
                                _selectedCounterpartyId = counterparty.id;
                                _selectedCounterpartyName = counterparty.name;
                                _isInternal = counterparty.isInternal;
                                // ✅ Type-safe accessor
                                _linkedCompanyId = counterparty.linkedCompanyId;

                                // Reset dependent fields
                                _selectedCounterpartyStoreId = null;
                                _selectedCounterpartyStoreName = null;
                                _selectedCounterpartyCashLocationId = null;
                              });

                              debugPrint('🔍 Calling _checkAccountMapping...');
                              _checkAccountMapping();
                            },
                            // ✅ Legacy callback for null case
                            onChanged: (counterpartyId) {
                              if (counterpartyId == null) {
                                setState(() {
                                  _selectedCounterpartyId = null;
                                  _selectedCounterpartyName = null;
                                  _isInternal = false;
                                  _linkedCompanyId = null;
                                  _selectedCounterpartyStoreId = null;
                                  _selectedCounterpartyStoreName = null;
                                  _selectedCounterpartyCashLocationId = null;
                                });
                              }
                            },
                            label: _selectedCategoryTag == 'payable' 
                                ? 'Select Supplier/Vendor' 
                                : _selectedCategoryTag == 'receivable'
                                    ? 'Select Customer'
                                    : 'Select Counterparty',
                            hint: 'Search all counterparties',
                            showSearch: true,
                            showTransactionCount: false,
                          );
                        },
                      ),
                      
                      // Enhanced Counterparty Store Selection
                      if (_linkedCompanyId != null) ...[
                        const SizedBox(height: 20),
                        Consumer(
                          builder: (context, ref, child) {
                            final storesAsync = ref.watch(journalCounterpartyStoresProvider(_linkedCompanyId));
                            return storesAsync.when(
                              data: (stores) {
                                if (stores.isEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Counterparty Store',
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: TossSpacing.space2),
                                      Container(
                                        padding: const EdgeInsets.all(TossSpacing.space4),
                                        decoration: BoxDecoration(
                                          color: TossColors.gray50,
                                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                          border: Border.all(
                                            color: TossColors.gray200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.info_outline, size: 20, color: TossColors.gray500),
                                            const SizedBox(width: TossSpacing.space3),
                                            Expanded(
                                              child: Text(
                                                'This counterparty has no stores configured',
                                                style: TossTextStyles.body.copyWith(
                                                  color: TossColors.gray600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Counterparty Store',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    GestureDetector(
                                      onTap: () {
                                        _showStoreSelectionBottomSheet(context, stores);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: TossColors.white,
                                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                          border: Border.all(
                                            color: TossColors.gray200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.store,
                                              size: 20,
                                              color: _selectedCounterpartyStoreId != null
                                                ? TossColors.primary
                                                : TossColors.gray400,
                                            ),
                                            const SizedBox(width: TossSpacing.space3),
                                            Expanded(
                                              child: _selectedCounterpartyStoreName != null
                                                ? Text(
                                                    _selectedCounterpartyStoreName!,
                                                    style: TossTextStyles.body.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                : Text(
                                                    'Select counterparty store (optional)',
                                                    style: TossTextStyles.body.copyWith(
                                                      color: TossColors.gray400,
                                                    ),
                                                  ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: _selectedCounterpartyStoreId != null
                                                ? TossColors.primary
                                                : TossColors.gray400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Counterparty Store',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: const Center(
                                      child: TossLoadingView(),
                                    ),
                                  ),
                                ],
                              ),
                              error: (_, __) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Counterparty Store',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space2),
                                  Text(
                                    'Error loading stores',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      
                      // Counterparty Cash Location Selection - Using AutonomousCashLocationSelector with counterparty's company/store
                      if (_linkedCompanyId != null) ...[
                        const SizedBox(height: 20),
                        AutonomousCashLocationSelector(
                          companyId: _linkedCompanyId, // Use the counterparty's company ID
                          storeId: _selectedCounterpartyStoreId, // Use the counterparty's store ID if available
                          selectedLocationId: _selectedCounterpartyCashLocationId,
                          // ✅ NEW: Type-safe callback
                          onCashLocationSelected: (cashLocation) {
                            debugPrint('🎯 Counterparty cash location selected: ${cashLocation.name} (${cashLocation.id})');

                            setState(() {
                              _selectedCounterpartyCashLocationId = cashLocation.id;
                              _selectedCounterpartyCashLocationName = cashLocation.name;
                            });
                          },
                          // ✅ Legacy callback for null case
                          onChanged: (locationId) {
                            if (locationId == null) {
                              setState(() {
                                _selectedCounterpartyCashLocationId = null;
                                _selectedCounterpartyCashLocationName = null;
                              });
                            }
                          },
                          label: 'Counterparty Cash Location',
                          hint: 'Select counterparty cash location',
                          showSearch: true,
                          showTransactionCount: false,
                          showScopeTabs: _selectedCounterpartyStoreId != null, // Show tabs only if store is available
                          blockedLocationIds: widget.blockedCashLocationIds,
                        ),
                      ],
                      
                      // Account Mapping Status
                      if (_isInternal && _accountMapping != null) ...[
                        const SizedBox(height: TossSpacing.space4),
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: TossColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            border: Border.all(
                              color: TossColors.success.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: TossColors.success, size: 20),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Account mapping verified',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      if (_mappingError != null) ...[
                        const SizedBox(height: TossSpacing.space4),
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: TossColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            border: Border.all(
                              color: TossColors.error.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, color: TossColors.error, size: 20),
                              const SizedBox(width: TossSpacing.space2),
                              Expanded(
                                child: Text(
                                  _mappingError!,
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      // Debt Information
                      const SizedBox(height: 20),
                      TossDropdown<String>(
                        label: 'Debt Category',
                        value: _debtCategory,
                        hint: 'Select debt category',
                        items: DebtCategory.values.map((category) => TossDropdownItem<String>(
                          value: category.value,
                          label: category.displayName,
                        ),).toList(),
                        onChanged: (value) {
                          setState(() {
                            _debtCategory = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: TossSpacing.space4),
                      _buildSectionTitle('Interest Rate'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _interestRateController,
                        hint: 'Enter interest rate',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        focusNode: _interestRateFocusNode,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _amountFocusNode.requestFocus();
                        },
                      ),
                      
                      const SizedBox(height: TossSpacing.space4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Issue Date'),
                                const SizedBox(height: TossSpacing.space2),
                                _buildDatePicker(
                                  date: _issueDate,
                                  onChanged: (date) {
                                    setState(() {
                                      _issueDate = date;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Due Date'),
                                const SizedBox(height: TossSpacing.space2),
                                _buildDatePicker(
                                  date: _dueDate,
                                  onChanged: (date) {
                                    setState(() {
                                      _dueDate = date;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Amount
                    const SizedBox(height: 20),
                    _buildSectionTitle('Amount *'),
                    const SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showNumberpadModal(),
                            child: AbsorbPointer(
                              child: _buildTextField(
                                controller: _amountController,
                                hint: 'Enter amount',
                                keyboardType: TextInputType.none,
                                focusNode: _amountFocusNode,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) {
                                  _descriptionFocusNode.requestFocus();
                                },
                              ),
                            ),
                          ),
                        ),
                        if (_hasMultipleCurrencies) ...[
                          const SizedBox(width: TossSpacing.space2),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              boxShadow: [
                                BoxShadow(
                                  color: TossColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: TossColors.transparent,
                              child: InkWell(
                                onTap: _showExchangeRateCalculator,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                child: Container(
                                  padding: const EdgeInsets.all(TossSpacing.space3),
                                  child: const Icon(
                                    Icons.calculate_outlined,
                                    color: TossColors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    // Description
                    const SizedBox(height: 20),
                    _buildSectionTitle('Description (Optional)'),
                    const SizedBox(height: TossSpacing.space2),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: 'Enter description',
                      maxLines: 2,
                      focusNode: _descriptionFocusNode,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer with SafeArea - Hide when keyboard is visible
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Container(
                decoration: const BoxDecoration(
                  color: TossColors.white,
                  border: Border(
                    top: BorderSide(color: TossColors.gray200, width: 1),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(TossSpacing.space5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TossSecondaryButton(
                            text: 'Cancel',
                            onPressed: () => context.pop(),
                            fullWidth: true,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: TossPrimaryButton(
                            text: widget.existingLine != null ? 'Update' : 'Add',
                            onPressed: _saveTransaction,
                            fullWidth: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TossTextStyles.body.copyWith(
        color: TossColors.gray700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  Widget _buildAnimatedTypeButton(String label, bool isDebit) {
    final isSelected = _isDebit == isDebit;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            _isDebit = isDebit;
          });
          // Add haptic feedback for better user experience
          HapticFeedback.lightImpact();
        }
      },
      child: Container(
        color: TossColors.transparent,
        child: Center(
          child: // TODO: Review AnimatedDefaultTextStyle for TossTextStyles usage
AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TossTextStyles.body.copyWith(
              color: isSelected ? TossColors.white : TossColors.gray600,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
  
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
  }) {
    return TossEnhancedTextField(
      controller: controller,
      hintText: hint,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      showKeyboardToolbar: true,
      keyboardDoneText: textInputAction == TextInputAction.next ? 'Next' : 'Done',
      onKeyboardDone: textInputAction == TextInputAction.done 
          ? () => FocusScope.of(context).unfocus()
          : null,
      enableTapDismiss: false,
    );
  }
  
  Widget _buildDatePicker({
    required DateTime? date,
    required ValueChanged<DateTime> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: TossColors.gray600),
            const SizedBox(width: TossSpacing.space2),
            Text(
              date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Select date',
              style: TossTextStyles.body.copyWith(
                color: date != null ? TossColors.gray900 : TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoreSelectionBottomSheet(BuildContext context, List<Map<String, dynamic>> stores) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xxl),
            topRight: Radius.circular(TossBorderRadius.xxl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Store', style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.close, color: TossColors.gray500),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                itemCount: stores.length,
                separatorBuilder: (context, index) => Container(height: 1, color: TossColors.gray100),
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final storeId = store['store_id'] as String?;
                  final storeName = store['store_name'] as String? ?? 'Unknown Store';
                  
                  return InkWell(
                    onTap: () {
                      if (storeId != null) {
                        setState(() {
                          _selectedCounterpartyStoreId = storeId;
                          _selectedCounterpartyStoreName = storeName;
                          _selectedCounterpartyCashLocationId = null;
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: TossSpacing.space3),
                      child: Row(
                        children: [
                          const Icon(Icons.store, size: 20, color: TossColors.gray500),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Text(storeName, style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

}