import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry_model.dart';
import '../providers/journal_input_providers.dart';
import '../../../providers/app_state_provider.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../widgets/toss/toss_enhanced_text_field.dart';
import '../../../widgets/toss/keyboard/toss_numberpad_modal.dart';
import '../../../widgets/specific/selectors/enhanced_account_selector.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/specific/selectors/autonomous_counterparty_selector.dart';
import '../../../widgets/specific/selectors/autonomous_cash_location_selector.dart';
import '../../../widgets/common/toss_loading_view.dart';
import '../../../providers/entities/counterparty_provider.dart';
import 'package:myfinance_improved/core/themes/index.dart';
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
  String? _selectedCounterpartyName;
  String? _selectedCounterpartyStoreId;
  String? _selectedCounterpartyStoreName;
  String? _selectedCashLocationId;
  String? _selectedCounterpartyCashLocationId;
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
  
  final List<String> _debtCategories = ['note', 'account', 'loan', 'other'];
  
  @override
  void initState() {
    super.initState();
    
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
      final counterparties = await ref.read(journalCounterpartiesProvider.future);
      final counterparty = counterparties.firstWhere(
        (c) => c['counterparty_id'] == _selectedCounterpartyId,
        orElse: () => {},
      );
      
      if (counterparty.isNotEmpty) {
        setState(() {
          _linkedCompanyId = counterparty['linked_company_id']?.toString();
          _isInternal = counterparty['is_internal'] == true;
        });
      }
    } catch (e) {
      // Silently handle error loading counterparty details
    }
  }
  
  Future<void> _checkAccountMapping() async {
    if (_selectedAccountId == null || 
        _selectedCounterpartyId == null || 
        !_isInternal ||
        (_selectedCategoryTag != 'payable' && _selectedCategoryTag != 'receivable')) {
      setState(() {
        _accountMapping = null;
        _mappingError = null;
      });
      return;
    }
    
    setState(() {
      _mappingError = null;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final checkMapping = ref.read(checkAccountMappingProvider);
      final mapping = await checkMapping(
        appState.companyChoosen,
        _selectedCounterpartyId!,
        _selectedAccountId!,
      );
      
      setState(() {
        _accountMapping = mapping;
        if (mapping == null) {
          _mappingError = 'Account mapping required for internal transactions';
          _showMappingRequiredDialog();
        }
      });
    } catch (e) {
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
            padding: EdgeInsets.all(TossSpacing.space6),
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
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: TossColors.warning,
                    size: 36,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Account Mapping Required',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: TossSpacing.space3),
                Text(
                  'This internal counterparty requires an account mapping to be set up first.',
                  style: TossTextStyles.body.copyWith(
                    fontSize: 15,
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
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
                      padding: EdgeInsets.symmetric(vertical: 14),
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
    TossNumberpadModal.show(
      context: context,
      title: 'Enter Amount',
      initialValue: _amountController.text.isEmpty ? null : _amountController.text.replaceAll(',', ''),
      allowDecimal: true,
      onConfirm: (result) {
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
      backgroundColor: TossColors.transparent,
      useRootNavigator: true,
      isDismissible: true,  // Allow dismissing by tapping outside
      enableDrag: true,     // Allow dragging to dismiss
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) => ExchangeRateCalculator(
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
      ),
    );
  }

  void _saveTransaction() {
    // Remove commas before parsing
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0;
    
    if (_selectedAccountId == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an account and enter a valid amount'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    // Check if mapping is required but not found
    if (_isInternal && 
        (_selectedCategoryTag == 'payable' || _selectedCategoryTag == 'receivable') &&
        _accountMapping == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account mapping is required for this internal transaction'),
          backgroundColor: TossColors.error,
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
      cashLocationName: null, // Managed by AutonomousCashLocationSelector
      cashLocationType: null, // Managed by AutonomousCashLocationSelector
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
        SizedBox(height: TossSpacing.space2),
        Container(
          padding: EdgeInsets.all(TossSpacing.space4),
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
              Icon(Icons.info_outline, size: 20, color: TossColors.gray500),
              SizedBox(width: TossSpacing.space3),
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
        TossDropdownItem(
          value: null,
          label: 'No store selected',
        ),
        ...stores.map((store) => TossDropdownItem(
          value: store['store_id'] as String,
          label: (store['store_name'] ?? 'Unknown Store') as String,
        )),
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
        decoration: BoxDecoration(
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
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
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
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: TossColors.gray200),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space5).copyWith(
                bottom: TossSpacing.space5 + MediaQuery.of(context).viewInsets.bottom,
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Type Toggle
                    _buildSectionTitle('Transaction Type'),
                    SizedBox(height: TossSpacing.space2),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      padding: EdgeInsets.all(TossSpacing.space1),
                      child: Stack(
                        children: [
                          // Animated selection indicator
                          AnimatedAlign(
                            alignment: _isDebit 
                              ? Alignment.centerLeft 
                              : Alignment.centerRight,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
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
                                      offset: Offset(0, 2),
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
                    
                    SizedBox(height: 20),
                    
                    // Account Selection - Using AutonomousAccountSelector
                    Consumer(
                      builder: (context, ref, child) {
                        final accountsAsync = ref.watch(journalAccountsProvider);
                        
                        return EnhancedAccountSelector(
                          selectedAccountId: _selectedAccountId,
                          contextType: 'journal_entry', // Enable usage tracking
                          onChanged: (selectedId) {
                            if (selectedId != null) {
                              // Find the selected account from the list to get details
                              accountsAsync.whenData((accounts) {
                                final account = accounts.firstWhere(
                                  (a) => a['account_id'] == selectedId,
                                  orElse: () => {},
                                );
                                if (account.isNotEmpty) {
                                  setState(() {
                                    _selectedAccountId = selectedId;
                                    _selectedAccountName = account['account_name'] as String?;
                                    _selectedCategoryTag = account['category_tag'] as String?;
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
                                }
                              });
                            }
                          },
                          label: 'Account',
                          hint: 'Select account',
                          showSearch: true,
                          showTransactionCount: false,
                          showQuickAccess: true, // Enable "Frequently Used" section
                          maxQuickItems: 5, // Show top 5 frequently used accounts
                        );
                      }
                    ),
                    
                    // Cash Location Selection - Using AutonomousCashLocationSelector
                    if (_selectedCategoryTag == 'cash') ...[
                      SizedBox(height: 20),
                      AutonomousCashLocationSelector(
                        selectedLocationId: _selectedCashLocationId,
                        onChanged: (locationId) {
                          setState(() {
                            _selectedCashLocationId = locationId;
                            // Find the selected location to get name and type
                            // This will be handled by the widget's internal state
                          });
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
                      SizedBox(height: 20),
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
                      SizedBox(height: TossSpacing.space2),
                      Consumer(
                        builder: (context, ref, child) {
                          return AutonomousCounterpartySelector(
                            selectedCounterpartyId: _selectedCounterpartyId,
                            onChanged: (counterpartyId) async {
                              if (counterpartyId != null) {
                                // Get counterparty details from the provider
                                try {
                                  final counterpartyAsync = await ref.read(
                                    counterpartyByIdProvider(counterpartyId).future
                                  );
                                  
                                  if (counterpartyAsync != null) {
                                    setState(() {
                                      _selectedCounterpartyId = counterpartyId;
                                      _selectedCounterpartyName = counterpartyAsync.name;
                                      _isInternal = counterpartyAsync.isInternal;
                                      // Check if there's a linked company ID in additionalData
                                      _linkedCompanyId = counterpartyAsync.additionalData?['linked_company_id'] as String?;
                                    });
                                    
                                    // Check account mapping after setting counterparty
                                    _checkAccountMapping();
                                  }
                                } catch (e) {
                                  // Fallback to old method if new provider fails
                                  setState(() {
                                    _selectedCounterpartyId = counterpartyId;
                                    _selectedCounterpartyName = null;
                                    _isInternal = false;
                                  });
                                  await _loadCounterpartyDetails();
                                  _checkAccountMapping();
                                }
                              } else {
                                setState(() {
                                  _selectedCounterpartyId = null;
                                  _selectedCounterpartyName = null;
                                  _isInternal = false;
                                  _linkedCompanyId = null;
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
                        SizedBox(height: 20),
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
                                      SizedBox(height: TossSpacing.space2),
                                      Container(
                                        padding: EdgeInsets.all(TossSpacing.space4),
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
                                            Icon(Icons.info_outline, size: 20, color: TossColors.gray500),
                                            SizedBox(width: TossSpacing.space3),
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
                                    SizedBox(height: TossSpacing.space2),
                                    GestureDetector(
                                      onTap: () {
                                        _showStoreSelectionBottomSheet(context, stores);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                                            SizedBox(width: TossSpacing.space3),
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
                                  SizedBox(height: TossSpacing.space2),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
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
                                  SizedBox(height: TossSpacing.space2),
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
                        SizedBox(height: 20),
                        AutonomousCashLocationSelector(
                          companyId: _linkedCompanyId, // Use the counterparty's company ID
                          storeId: _selectedCounterpartyStoreId, // Use the counterparty's store ID if available
                          selectedLocationId: _selectedCounterpartyCashLocationId,
                          onChanged: (locationId) {
                            setState(() {
                              _selectedCounterpartyCashLocationId = locationId;
                            });
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
                        SizedBox(height: TossSpacing.space4),
                        Container(
                          padding: EdgeInsets.all(TossSpacing.space3),
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
                              Icon(Icons.check_circle, color: TossColors.success, size: 20),
                              SizedBox(width: TossSpacing.space2),
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
                        SizedBox(height: TossSpacing.space4),
                        Container(
                          padding: EdgeInsets.all(TossSpacing.space3),
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
                              Icon(Icons.warning, color: TossColors.error, size: 20),
                              SizedBox(width: TossSpacing.space2),
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
                      SizedBox(height: 20),
                      TossDropdown<String>(
                        label: 'Debt Category',
                        value: _debtCategory,
                        hint: 'Select debt category',
                        items: _debtCategories.map((category) => TossDropdownItem<String>(
                          value: category,
                          label: category[0].toUpperCase() + category.substring(1),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _debtCategory = value;
                          });
                        },
                      ),
                      
                      SizedBox(height: TossSpacing.space4),
                      _buildSectionTitle('Interest Rate'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _interestRateController,
                        hint: 'Enter interest rate',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        focusNode: _interestRateFocusNode,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _amountFocusNode.requestFocus();
                        },
                      ),
                      
                      SizedBox(height: TossSpacing.space4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Issue Date'),
                                SizedBox(height: TossSpacing.space2),
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
                          SizedBox(width: TossSpacing.space4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Due Date'),
                                SizedBox(height: TossSpacing.space2),
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
                    SizedBox(height: 20),
                    _buildSectionTitle('Amount *'),
                    SizedBox(height: TossSpacing.space2),
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
                        SizedBox(width: TossSpacing.space2),
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.primary,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: TossColors.primary.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: TossColors.transparent,
                            child: InkWell(
                              onTap: _showExchangeRateCalculator,
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              child: Container(
                                padding: EdgeInsets.all(TossSpacing.space3),
                                child: Icon(
                                  Icons.calculate_outlined,
                                  color: TossColors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Description
                    SizedBox(height: 20),
                    _buildSectionTitle('Description (Optional)'),
                    SizedBox(height: TossSpacing.space2),
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
                decoration: BoxDecoration(
                  color: TossColors.white,
                  border: Border(
                    top: BorderSide(color: TossColors.gray200, width: 1),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.all(TossSpacing.space5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TossSecondaryButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.of(context).pop(),
                            fullWidth: true,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space3),
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
            duration: Duration(milliseconds: 200),
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Icon(Icons.calendar_today, size: 18, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space2),
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
        decoration: BoxDecoration(
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
              margin: EdgeInsets.only(top: TossSpacing.space3),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Store', style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: Icon(Icons.close, color: TossColors.gray500),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: TossSpacing.space3),
                      child: Row(
                        children: [
                          Icon(Icons.store, size: 20, color: TossColors.gray500),
                          SizedBox(width: TossSpacing.space3),
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