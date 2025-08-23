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

// Custom formatter for thousand separators
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all commas and non-numeric characters except decimal point
    String newText = newValue.text.replaceAll(',', '');
    
    // Check if it's a valid number format
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(newText)) {
      return oldValue;
    }
    
    // Split by decimal point
    List<String> parts = newText.split('.');
    
    // Format the integer part with commas
    String integerPart = parts[0];
    String formattedInteger = '';
    
    if (integerPart.isNotEmpty) {
      // Add thousand separators
      int digitCount = 0;
      for (int i = integerPart.length - 1; i >= 0; i--) {
        if (digitCount > 0 && digitCount % 3 == 0) {
          formattedInteger = ',' + formattedInteger;
        }
        formattedInteger = integerPart[i] + formattedInteger;
        digitCount++;
      }
    }
    
    // Combine integer and decimal parts
    String formattedText = formattedInteger;
    if (parts.length > 1) {
      // Limit decimal places to 2
      String decimalPart = parts[1];
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      formattedText = '$formattedInteger.$decimalPart';
    }
    
    // Calculate new cursor position
    int cursorPosition = formattedText.length;
    
    // If cursor was in the middle, try to maintain relative position
    if (newValue.selection.baseOffset < newValue.text.length) {
      int originalCursorPos = newValue.selection.baseOffset;
      int commasBeforeCursor = 0;
      for (int i = 0; i < originalCursorPos && i < formattedText.length; i++) {
        if (formattedText[i] == ',') {
          commasBeforeCursor++;
        }
      }
      cursorPosition = originalCursorPos + commasBeforeCursor;
      if (cursorPosition > formattedText.length) {
        cursorPosition = formattedText.length;
      }
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class AddTransactionDialog extends ConsumerStatefulWidget {
  final TransactionLine? existingLine;
  final bool? initialIsDebit;
  final double? suggestedAmount;
  
  const AddTransactionDialog({
    super.key,
    this.existingLine,
    this.initialIsDebit,
    this.suggestedAmount,
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
  String? _selectedCashLocationName;
  String? _selectedCashLocationType;
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
      _selectedCashLocationName = line.cashLocationName;
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
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'This internal counterparty requires an account mapping to be set up first.',
                  style: TextStyle(
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
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
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
      cashLocationName: _selectedCashLocationName,
      cashLocationType: _selectedCashLocationType,
      linkedCompanyId: _linkedCompanyId,
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
  
  void _showAccountSearchDialog(List<dynamic> accounts) {
    String searchQuery = '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filteredAccounts = accounts.where((account) {
            final name = (account['account_name'] as String).toLowerCase();
            final tag = (account['category_tag'] as String?)?.toLowerCase() ?? '';
            final query = searchQuery.toLowerCase();
            return name.contains(query) || tag.contains(query);
          }).toList();

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: 400,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Search
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: TossColors.gray200, width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Account',
                              style: TossTextStyles.h3.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(Icons.close, size: 24),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Search Field
                        TextField(
                          onChanged: (value) {
                            setDialogState(() {
                              searchQuery = value;
                            });
                          },
                          style: TossTextStyles.body,
                          decoration: InputDecoration(
                            hintText: 'Search accounts...',
                            hintStyle: TossTextStyles.body.copyWith(
                              color: TossColors.gray400,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: TossColors.gray500,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: TossColors.gray50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Account List
                  Expanded(
                    child: filteredAccounts.isEmpty
                      ? Center(
                          child: Text(
                            'No accounts found',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredAccounts.length,
                          itemBuilder: (context, index) {
                            final account = filteredAccounts[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedAccountId = account['account_id'];
                                  _selectedAccountName = account['account_name'];
                                  _selectedCategoryTag = account['category_tag'];
                                  // Reset related fields
                                  _selectedCashLocationId = null;
                                  _selectedCashLocationName = null;
                                  _selectedCounterpartyId = null;
                                  _selectedCounterpartyName = null;
                                  _selectedCounterpartyStoreId = null;
                                  _selectedCounterpartyStoreName = null;
                                  _linkedCompanyId = null;
                                  _isInternal = false;
                                  _accountMapping = null;
                                  _mappingError = null;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: TossColors.gray100,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        account['account_name'] as String,
                                        style: TossTextStyles.body,
                                      ),
                                    ),
                                    if (account['category_tag'] != null) ...[
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: TossColors.gray100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          account['category_tag'] as String,
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.gray600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(journalAccountsProvider);
    // Use filtered counterparties provider based on selected account category
    final counterpartiesAsync = ref.watch(journalFilteredCounterpartiesProvider(_selectedCategoryTag));
    final cashLocationsAsync = ref.watch(journalCashLocationsProvider);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
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
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: EdgeInsets.all(20),
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
              padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Type Toggle
                    _buildSectionTitle('Transaction Type'),
                    SizedBox(height: 8),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      padding: EdgeInsets.all(4),
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
                    
                    // Account Selection
                    _buildSectionTitle('Account'),
                    SizedBox(height: 8),
                    accountsAsync.when(
                      data: (accounts) => InkWell(
                        onTap: () => _showAccountSearchDialog(accounts),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            border: Border.all(
                              color: _selectedAccountId != null 
                                ? TossColors.primary.withValues(alpha: 0.3)
                                : TossColors.gray300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _selectedAccountName != null
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _selectedAccountName!,
                                            style: TossTextStyles.body,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (_selectedCategoryTag != null) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: TossColors.gray100,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _selectedCategoryTag!,
                                              style: TossTextStyles.caption.copyWith(
                                                color: TossColors.gray600,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    )
                                  : Text(
                                      'Select account',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray400,
                                      ),
                                    ),
                              ),
                              Icon(
                                Icons.search,
                                size: 20,
                                color: TossColors.gray600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      loading: () => CircularProgressIndicator(),
                      error: (_, __) => Text('Error loading accounts'),
                    ),
                    
                    // Conditional fields based on account type
                    if (_selectedCategoryTag == 'cash') ...[
                      SizedBox(height: 20),
                      _buildSectionTitle('Cash Location'),
                      SizedBox(height: 8),
                      cashLocationsAsync.when(
                        data: (locations) => _buildDropdown(
                          value: _selectedCashLocationId,
                          hint: 'Select cash location',
                          items: locations.map((location) => DropdownMenuItem(
                            value: location['cash_location_id'] as String,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    location['location_name'] as String,
                                    style: TossTextStyles.body,
                                  ),
                                ),
                                if (location['location_type'] != null) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: _getLocationTypeColor(location['location_type']).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: _getLocationTypeColor(location['location_type']).withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      location['location_type'] as String,
                                      style: TossTextStyles.caption.copyWith(
                                        color: _getLocationTypeColor(location['location_type']),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )).toList(),
                          onChanged: (value) {
                            final location = locations.firstWhere((l) => l['cash_location_id'] == value);
                            setState(() {
                              _selectedCashLocationId = value;
                              _selectedCashLocationName = location['location_name'];
                              _selectedCashLocationType = location['location_type'];
                            });
                          },
                        ),
                        loading: () => CircularProgressIndicator(),
                        error: (_, __) => Text('Error loading cash locations'),
                      ),
                      // Display selected location type
                      if (_selectedCashLocationType != null) ...[
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _getLocationTypeColor(_selectedCashLocationType!).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            border: Border.all(
                              color: _getLocationTypeColor(_selectedCashLocationType!).withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getLocationTypeIcon(_selectedCashLocationType!),
                                size: 16,
                                color: _getLocationTypeColor(_selectedCashLocationType!),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Location Type: ${_selectedCashLocationType}',
                                style: TossTextStyles.caption.copyWith(
                                  color: _getLocationTypeColor(_selectedCashLocationType!),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    
                    // Payable/Receivable specific fields
                    if (_selectedCategoryTag != null && (_selectedCategoryTag!.toLowerCase() == 'payable' || _selectedCategoryTag!.toLowerCase() == 'receivable')) ...[
                      SizedBox(height: 20),
                      _buildSectionTitle('Counterparty'),
                      SizedBox(height: 8),
                      counterpartiesAsync.when(
                        data: (counterparties) => _buildDropdown(
                          value: _selectedCounterpartyId,
                          hint: 'Select counterparty',
                          items: counterparties.map((counterparty) => DropdownMenuItem(
                            value: counterparty['counterparty_id'] as String,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      counterparty['name'] as String,
                                      style: TossTextStyles.body,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (counterparty['is_internal'] == true) ...[
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: TossColors.info.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Internal',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.info,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )).toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            
                            final counterparty = counterparties.firstWhere((c) => c['counterparty_id'] == value);
                            
                            setState(() {
                              _selectedCounterpartyId = value;
                              _selectedCounterpartyName = counterparty['name']?.toString();
                              
                              // Set linked_company_id - it should be present for all counterparties
                              final linkedCompanyValue = counterparty['linked_company_id'];
                              if (linkedCompanyValue != null && linkedCompanyValue.toString().isNotEmpty) {
                                _linkedCompanyId = linkedCompanyValue.toString();
                              } else {
                                _linkedCompanyId = null;
                              }
                              
                              // Handle is_internal flag
                              final isInternalValue = counterparty['is_internal'];
                              if (isInternalValue is bool) {
                                _isInternal = isInternalValue;
                              } else if (isInternalValue is String) {
                                _isInternal = isInternalValue.toLowerCase() == 'true';
                              } else if (isInternalValue == 1 || isInternalValue == '1') {
                                _isInternal = true;
                              } else {
                                _isInternal = false;
                              }
                              
                              // Reset store selection
                              _selectedCounterpartyStoreId = null;
                              _selectedCounterpartyStoreName = null;
                            });
                            
                            print('=============================================');
                            print('STATE AFTER UPDATE');
                            print('_selectedCounterpartyId: $_selectedCounterpartyId');
                            print('_isInternal: $_isInternal');
                            print('_linkedCompanyId: $_linkedCompanyId');
                            print('Should show store dropdown: ${_selectedCounterpartyId != null && _linkedCompanyId != null && _linkedCompanyId!.isNotEmpty}');
                            print('=============================================');
                            
                            // Check account mapping if internal
                            if (_isInternal && _linkedCompanyId != null) {
                              await _checkAccountMapping();
                            }
                          },
                        ),
                        loading: () => CircularProgressIndicator(),
                        error: (_, __) => Text('Error loading counterparties'),
                      ),
                      
                      // Counterparty Store - ALWAYS show when payable/receivable
                      if (_linkedCompanyId != null) ...[
                        SizedBox(height: 20),
                        _buildSectionTitle('Counterparty Store'),
                        SizedBox(height: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            final storesAsync = ref.watch(journalCounterpartyStoresProvider(_linkedCompanyId));
                            return storesAsync.when(
                              data: (stores) {
                                if (stores.isEmpty) {
                                  return Container(
                                    padding: EdgeInsets.all(12),
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
                                        Icon(Icons.info_outline, size: 16, color: TossColors.gray500),
                                        SizedBox(width: 8),
                                        Text(
                                          'This counterparty has no stores',
                                          style: TossTextStyles.bodySmall.copyWith(
                                            color: TossColors.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return _buildDropdown(
                                  value: _selectedCounterpartyStoreId,
                                  hint: 'Select counterparty store',
                                  items: stores.map((store) => DropdownMenuItem(
                                    value: store['store_id'] as String,
                                    child: Text(
                                      store['store_name'] as String,
                                      style: TossTextStyles.body,
                                    ),
                                  )).toList(),
                                  onChanged: (value) {
                                    final store = stores.firstWhere((s) => s['store_id'] == value);
                                    setState(() {
                                      _selectedCounterpartyStoreId = value;
                                      _selectedCounterpartyStoreName = store['store_name'];
                                      // Reset cash location when store changes
                                      _selectedCashLocationId = null;
                                      _selectedCashLocationName = null;
                                    });
                                  },
                                );
                              },
                              loading: () => Center(child: CircularProgressIndicator()),
                              error: (_, __) => Text('Error loading stores'),
                            );
                          },
                        ),
                      ],
                      
                      // Counterparty Cash Location - based on selected store or company
                      if (_linkedCompanyId != null) ...[
                        SizedBox(height: 20),
                        _buildSectionTitle('Counterparty Cash Location'),
                        SizedBox(height: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            print('=============================================');
                            print('CASH LOCATION SELECTION DEBUG');
                            print('Store ID: $_selectedCounterpartyStoreId');
                            print('Linked Company ID: $_linkedCompanyId');
                            print('Using provider: ${_selectedCounterpartyStoreId != null ? "Store-based" : "Company-based"}');
                            print('=============================================');
                            
                            // If store is selected, use store-based provider, otherwise use company-based
                            final cashLocsAsync = _selectedCounterpartyStoreId != null
                                ? ref.watch(journalCounterpartyStoreCashLocationsProvider(_selectedCounterpartyStoreId))
                                : ref.watch(journalCounterpartyCashLocationsProvider(_linkedCompanyId));
                            return cashLocsAsync.when(
                              data: (locations) => _buildDropdown(
                                value: _selectedCashLocationId,
                                hint: 'Select cash location',
                                items: locations.map((location) => DropdownMenuItem(
                                  value: location['cash_location_id'] as String,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          location['location_name'] as String,
                                          style: TossTextStyles.body,
                                        ),
                                      ),
                                      if (location['location_type'] != null) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: _getLocationTypeColor(location['location_type']).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: _getLocationTypeColor(location['location_type']).withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            location['location_type'] as String,
                                            style: TossTextStyles.caption.copyWith(
                                              color: _getLocationTypeColor(location['location_type']),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                )).toList(),
                                onChanged: (value) {
                                  final location = locations.firstWhere((l) => l['cash_location_id'] == value);
                                  setState(() {
                                    _selectedCashLocationId = value;
                                    _selectedCashLocationName = location['location_name'];
                                    _selectedCashLocationType = location['location_type'];
                                  });
                                },
                              ),
                              loading: () => CircularProgressIndicator(),
                              error: (_, __) => Text('Error loading cash locations'),
                            );
                          },
                        ),
                      ],
                      
                      // Account Mapping Status
                      if (_isInternal && _accountMapping != null) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
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
                              SizedBox(width: 8),
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
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
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
                              SizedBox(width: 8),
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
                      _buildSectionTitle('Debt Category'),
                      SizedBox(height: 8),
                      _buildDropdown(
                        value: _debtCategory,
                        hint: 'Select debt category',
                        items: _debtCategories.map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category[0].toUpperCase() + category.substring(1)),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _debtCategory = value;
                          });
                        },
                      ),
                      
                      SizedBox(height: 16),
                      _buildSectionTitle('Interest Rate'),
                      SizedBox(height: 8),
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
                      
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Issue Date'),
                                SizedBox(height: 8),
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
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Due Date'),
                                SizedBox(height: 8),
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
                    SizedBox(height: 8),
                    _buildTextField(
                      controller: _amountController,
                      hint: 'Enter amount',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        ThousandsSeparatorInputFormatter(),
                      ],
                      focusNode: _amountFocusNode,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        _descriptionFocusNode.requestFocus();
                      },
                    ),
                    
                    // Description
                    SizedBox(height: 20),
                    _buildSectionTitle('Description (Optional)'),
                    SizedBox(height: 8),
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
            
            // Footer with SafeArea
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: TossColors.gray200, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TossColors.gray600,
                            side: BorderSide(color: TossColors.gray300, width: 1),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveTransaction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            elevation: 0,
                          ),
                          child: Text(widget.existingLine != null ? 'Update' : 'Add'),
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
        color: Colors.transparent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TossTextStyles.body.copyWith(
              color: isSelected ? Colors.white : TossColors.gray600,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.gray400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: TossColors.gray600),
        isExpanded: true,
        items: items,
        onChanged: onChanged,
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
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: TossTextStyles.body,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TossTextStyles.body.copyWith(
          color: TossColors.gray400,
        ),
        filled: true,
        fillColor: TossColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(
            color: TossColors.primary,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
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
            SizedBox(width: 8),
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
  
  Color _getLocationTypeColor(String locationType) {
    switch (locationType.toLowerCase()) {
      case 'cash register':
        return TossColors.primary;
      case 'safe':
        return TossColors.success;
      case 'bank':
        return TossColors.info;
      case 'petty cash':
        return TossColors.warning;
      case 'vault':
        return TossColors.primary;
      default:
        return TossColors.gray600;
    }
  }
  
  IconData _getLocationTypeIcon(String locationType) {
    switch (locationType.toLowerCase()) {
      case 'cash register':
        return Icons.point_of_sale;
      case 'safe':
        return Icons.lock;
      case 'bank':
        return Icons.account_balance;
      case 'petty cash':
        return Icons.account_balance_wallet;
      case 'vault':
        return Icons.security;
      default:
        return Icons.payments;
    }
  }
}