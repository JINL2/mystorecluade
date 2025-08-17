import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import 'models/transaction_template_model.dart';
import 'providers/transaction_template_providers.dart';

class TemplateUsageBottomSheet extends ConsumerStatefulWidget {
  final TransactionTemplate template;
  
  const TemplateUsageBottomSheet({
    super.key,
    required this.template,
  });
  
  @override
  ConsumerState<TemplateUsageBottomSheet> createState() => _TemplateUsageBottomSheetState();
}

class _TemplateUsageBottomSheetState extends ConsumerState<TemplateUsageBottomSheet> 
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isProcessing = false;
  String _previousText = '';
  
  // Debt-related fields
  final TextEditingController _interestRateController = TextEditingController(text: '0');
  final TextEditingController _debtDescriptionController = TextEditingController();
  String? _selectedDebtCategory;
  DateTime? _issueDate;
  DateTime? _dueDate;
  final List<String> _debtCategories = ['note', 'account', 'loan', 'other'];
  bool _hasPayableOrReceivable = false;
  String? _selectedCounterpartyCashLocationId;
  String? _counterpartyLinkedCompanyId;
  Map<String, dynamic>? _payableReceivableTransaction;
  
  // Account mapping fields for internal counterparties
  Map<String, dynamic>? _accountMapping;
  bool _isCheckingAccountMapping = false;
  String? _accountMappingError;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    
    // Check if template has payable or receivable accounts and get counterparty info
    final transactions = widget.template.data as List;
    for (var transaction in transactions) {
      final categoryTag = transaction['category_tag']?.toString().toLowerCase() ?? '';
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        _hasPayableOrReceivable = true;
        _payableReceivableTransaction = transaction;
        
        // Check if there's a counterparty and if it's internal (has linked_company_id)
        if (transaction['counterparty_id'] != null) {
          // We need to fetch the counterparty details to get linked_company_id
          _fetchCounterpartyDetails(transaction['counterparty_id']);
        }
        break;
      }
    }
    
    // Auto-focus the amount field when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _amountFocusNode.requestFocus();
    });
    
    _amountController.addListener(_formatAmount);
  }
  
  void _formatAmount() {
    final text = _amountController.text;
    if (text != _previousText) {
      // Remove all non-digit characters except decimal point
      String cleanText = text.replaceAll(RegExp(r'[^0-9.]'), '');
      
      // Handle decimal point
      final parts = cleanText.split('.');
      String wholePart = parts[0];
      String decimalPart = parts.length > 1 ? '.${parts[1].substring(0, parts[1].length > 2 ? 2 : parts[1].length)}' : '';
      
      // Add thousand separators to whole part
      if (wholePart.isNotEmpty) {
        final wholeNumber = int.tryParse(wholePart) ?? 0;
        wholePart = _addThousandSeparators(wholeNumber.toString());
      }
      
      final formattedText = '$wholePart$decimalPart';
      
      if (formattedText != text) {
        _previousText = formattedText;
        final selection = _amountController.selection;
        _amountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      } else {
        _previousText = text;
      }
      setState(() {});
    }
  }
  
  String _addThousandSeparators(String number) {
    String result = '';
    int count = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = ',$result';
        count = 0;
      }
      result = number[i] + result;
      count++;
    }
    return result;
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _animationController.dispose();
    _interestRateController.dispose();
    _debtDescriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _fetchCounterpartyDetails(String counterpartyId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('counterparties')
          .select('linked_company_id, is_internal')
          .eq('counterparty_id', counterpartyId)
          .single();
      
      if (response != null) {
        setState(() {
          _counterpartyLinkedCompanyId = response['linked_company_id'];
        });
        
        // If counterparty is internal, check account mappings
        if (response['is_internal'] == true && _payableReceivableTransaction != null) {
          await _checkAccountMapping(counterpartyId);
        }
      }
    } catch (e) {
      print('Error fetching counterparty details: $e');
    }
  }
  
  Future<void> _checkAccountMapping(String counterpartyId) async {
    setState(() {
      _isCheckingAccountMapping = true;
      _accountMappingError = null;
      _accountMapping = null;
    });
    
    try {
      final supabase = Supabase.instance.client;
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      // Get the account ID from the payable/receivable transaction
      final accountId = _payableReceivableTransaction?['account_id'];
      
      if (accountId == null) {
        setState(() {
          _accountMappingError = 'No account found for mapping check';
          _isCheckingAccountMapping = false;
        });
        return;
      }
      
      // Query account_mappings table
      final response = await supabase
          .from('account_mappings')
          .select('my_account_id, linked_account_id, direction')
          .eq('my_company_id', companyId)
          .eq('counterparty_id', counterpartyId)
          .eq('my_account_id', accountId)
          .maybeSingle();
      
      if (response != null) {
        setState(() {
          _accountMapping = {
            'my_account_id': response['my_account_id'],
            'linked_account_id': response['linked_account_id'],
            'direction': response['direction'],
          };
          _accountMappingError = null;
        });
        print('Account mapping found: $_accountMapping');
      } else {
        setState(() {
          _accountMappingError = 'No account mapping found for this internal counterparty and account combination';
        });
        
        // Show popup dialog when no mapping is found
        if (mounted) {
          await _showNoMappingDialog();
        }
        
        // Reset the counterparty selection
        setState(() {
          if (_payableReceivableTransaction != null) {
            _payableReceivableTransaction!['counterparty_id'] = null;
          }
          _selectedCounterpartyCashLocationId = null;
          _counterpartyLinkedCompanyId = null;
        });
      }
    } catch (e) {
      print('Error checking account mapping: $e');
      setState(() {
        _accountMappingError = 'Error checking account mapping: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isCheckingAccountMapping = false;
      });
    }
  }
  
  Future<void> _showNoMappingDialog() async {
    await showDialog(
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
                // Warning Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: TossColors.warning,
                    size: 36,
                  ),
                ),
                SizedBox(height: 20),
                
                // Title
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
                
                // Message
                Text(
                  'This internal counterparty requires an account mapping to be set up first.',
                  style: TextStyle(
                    fontSize: 15,
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Please configure the account mapping in the settings before using this counterparty.',
                  style: TextStyle(
                    fontSize: 14,
                    color: TossColors.gray500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
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
  
  String _formatCurrency(double amount) {
    // Format with thousand separators
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';
    
    // Add thousand separators
    final wholeFormatted = wholePart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    
    return '$wholeFormatted.$decimalPart';
  }
  
  bool _isCounterpartyCashLocationValid() {
    // If there's no internal counterparty with payable/receivable, it's valid
    if (!_hasPayableOrReceivable || _counterpartyLinkedCompanyId == null) {
      return true;
    }
    
    // If template has a preset counterparty cash location (locked), it's valid
    if (widget.template.counterpartyCashLocationId != null && 
        widget.template.counterpartyCashLocationId!.isNotEmpty) {
      return true;
    }
    
    // Otherwise, check if user has selected a valid cash location (not null and not "None")
    return _selectedCounterpartyCashLocationId != null && 
           _selectedCounterpartyCashLocationId!.isNotEmpty &&
           _selectedCounterpartyCashLocationId != 'null';
  }
  
  Future<void> _handleConfirm() async {
    // Get the amount and remove formatting
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);
    
    if (amount == null || amount <= 0) {
      return;
    }
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      // Haptic feedback for button press
      HapticFeedback.lightImpact();
      
      // Prepare debt information if applicable
      Map<String, dynamic>? debtInfo;
      if (_hasPayableOrReceivable) {
        debtInfo = {
          'category': _selectedDebtCategory,
          'interest_rate': double.tryParse(_interestRateController.text) ?? 0.0,
          'issue_date': _issueDate != null ? DateFormat('yyyy-MM-dd').format(_issueDate!) : null,
          'due_date': _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : null,
          'description': _debtDescriptionController.text.isNotEmpty ? _debtDescriptionController.text : null,
          'counterparty_cash_location_id': _selectedCounterpartyCashLocationId,
        };
        
        // Add account mapping information if available
        if (_accountMapping != null) {
          debtInfo['account_mapping'] = _accountMapping;
        }
      }
      
      // Execute the template to create transactions
      final executeTemplate = ref.read(executeTransactionTemplateProvider);
      await executeTemplate(widget.template, amount, debtInfo: debtInfo);
      
      // Success haptic feedback
      HapticFeedback.mediumImpact();
      
      // First close the bottom sheet
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        
        // Then show success message after a brief delay to ensure it appears on the main screen
        await Future.delayed(Duration(milliseconds: 100));
        
        if (mounted) {
          // Show success dialog or snackbar on the main screen
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              // Auto-dismiss after 2 seconds
              Future.delayed(Duration(seconds: 2), () {
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              });
              
              return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: TossColors.success,
                          size: 36,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Transaction Created Successfully',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Amount: ${_formatCurrency(amount)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: TossColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();
      
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        // Show error dialog
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: TossColors.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        color: TossColors.error,
                        size: 36,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Transaction Failed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      e.toString().replaceAll('Exception: ', ''),
                      style: TextStyle(
                        fontSize: 14,
                        color: TossColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: TossColors.error.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: TossColors.error,
                          fontWeight: FontWeight.w600,
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
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Parse template data
    final transactions = widget.template.data as List;
    final debitTransaction = transactions.isNotEmpty ? transactions[0] : null;
    final creditTransaction = transactions.length > 1 ? transactions[1] : null;
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.xxl),
                topRight: Radius.circular(TossBorderRadius.xxl),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toss-style handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(top: 12, bottom: 20),
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                ),
                
                // Header - Cleaner design
                Container(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.template.name,
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close, size: 24),
                            color: TossColors.gray500,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                        ],
                      ),
                      if (widget.template.description.isNotEmpty) ...[
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          widget.template.description,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(height: TossSpacing.space5),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction Details Header - NOW AT THE TOP
                        Text(
                          'Transaction Details',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        SizedBox(height: TossSpacing.space3),
                        
                        // Transaction Cards - Clean minimal style
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          padding: EdgeInsets.all(TossSpacing.space2),
                          child: Column(
                            children: [
                              // Debit Section
                              if (debitTransaction != null) ...[
                                _buildTransactionItem(
                                  context: context,
                                  type: 'DEBIT',
                                  color: TossColors.primary,
                                  transaction: debitTransaction,
                                  isFirst: true,
                                ),
                              ],
                              
                              // Spacing between cards
                              if (debitTransaction != null && creditTransaction != null)
                                SizedBox(height: TossSpacing.space2),
                              
                              // Credit Section
                              if (creditTransaction != null) ...[
                                _buildTransactionItem(
                                  context: context,
                                  type: 'CREDIT',
                                  color: TossColors.success,
                                  transaction: creditTransaction,
                                  isFirst: false,
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        SizedBox(height: TossSpacing.space6),
                        
                        // Amount Section - Simple clean style like Create Template
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space3),
                            Container(
                              decoration: BoxDecoration(
                                color: TossColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                              ),
                              child: TextField(
                                controller: _amountController,
                                focusNode: _amountFocusNode,
                                enabled: !_isProcessing,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                style: TextStyle(
                                  color: TossColors.gray900,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter amount',
                                  hintStyle: TextStyle(
                                    color: TossColors.gray400,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Counterparty Cash Location (only if internal counterparty with payable/receivable)
                        if (_hasPayableOrReceivable && _counterpartyLinkedCompanyId != null) ...[
                          SizedBox(height: TossSpacing.space6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Counterparty Cash Location',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray700,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Consumer(
                                builder: (context, ref, child) {
                                  // Check if template has a pre-set counterparty cash location
                                  final hasPresetLocation = widget.template.counterpartyCashLocationId != null;
                                  
                                  final counterpartyCashLocationsAsync = ref.watch(
                                    counterpartyCashLocationsProvider(_counterpartyLinkedCompanyId),
                                  );
                                  return counterpartyCashLocationsAsync.when(
                                    data: (locations) {
                                      // If template has preset location, use it
                                      if (hasPresetLocation) {
                                        _selectedCounterpartyCashLocationId = widget.template.counterpartyCashLocationId;
                                      }
                                      
                                      // Find the location name for display
                                      String? locationName;
                                      if (hasPresetLocation) {
                                        final location = locations.firstWhere(
                                          (loc) => loc['cash_location_id']?.toString() == widget.template.counterpartyCashLocationId,
                                          orElse: () => {'location_name': 'Unknown Location'},
                                        );
                                        locationName = location['location_name'];
                                      }
                                      
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: hasPresetLocation ? TossColors.gray100 : TossColors.gray50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 0,
                                          ),
                                        ),
                                        child: hasPresetLocation 
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    locationName ?? 'None',
                                                    style: TextStyle(
                                                      color: TossColors.gray700,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.lock_outline,
                                                    size: 18,
                                                    color: TossColors.gray500,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : DropdownButtonFormField<String>(
                                              value: _selectedCounterpartyCashLocationId,
                                              decoration: InputDecoration(
                                                hintText: 'Select location',
                                                hintStyle: TextStyle(
                                                  color: TossColors.gray400,
                                                  fontSize: 16,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 10,
                                                ),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: Icon(Icons.arrow_drop_down, color: TossColors.gray600),
                                              itemHeight: null, // Allow dynamic height for items
                                              selectedItemBuilder: (BuildContext context) {
                                                // This shows only the location name when selected
                                                return locations.map<Widget>((location) {
                                                  return Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      location['location_name'] ?? 'None',
                                                      style: TextStyle(
                                                        color: TossColors.gray900,
                                                        fontSize: 16,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              items: locations.map((location) {
                                                return DropdownMenuItem<String>(
                                                  value: location['cash_location_id']?.toString(),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        location['location_name'] ?? 'None',
                                                        style: TextStyle(
                                                          color: TossColors.gray900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      if (location['location_type'] != null && location['location_type'] != 'none') ...[
                                                        SizedBox(height: 2),
                                                        Text(
                                                          location['location_type'].toString().toUpperCase(),
                                                          style: TextStyle(
                                                            color: TossColors.gray500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: !_isProcessing ? (value) {
                                                setState(() {
                                                  _selectedCounterpartyCashLocationId = value;
                                                });
                                              } : null,
                                            ),
                                      );
                                    },
                                    loading: () => Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: TossColors.gray50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: TossColors.primary,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Loading locations...',
                                            style: TextStyle(
                                              color: TossColors.gray600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    error: (_, __) => Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: TossColors.gray50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Error loading locations',
                                        style: TextStyle(
                                          color: TossColors.error,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                        
                        // Account Mapping Status (for internal counterparties)
                        if (_counterpartyLinkedCompanyId != null && _hasPayableOrReceivable) ...[
                          SizedBox(height: TossSpacing.space4),
                          
                          // Account Mapping Status Card
                          Container(
                            padding: EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: _accountMapping != null 
                                  ? TossColors.success.withOpacity(0.1)
                                  : _accountMappingError != null 
                                      ? TossColors.error.withOpacity(0.1)
                                      : TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _accountMapping != null 
                                    ? TossColors.success.withOpacity(0.2)
                                    : _accountMappingError != null 
                                        ? TossColors.error.withOpacity(0.2)
                                        : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (_isCheckingAccountMapping)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: TossColors.primary,
                                    ),
                                  )
                                else if (_accountMapping != null)
                                  Icon(
                                    Icons.check_circle,
                                    color: TossColors.success,
                                    size: 20,
                                  )
                                else if (_accountMappingError != null)
                                  Icon(
                                    Icons.warning,
                                    color: TossColors.error,
                                    size: 20,
                                  ),
                                SizedBox(width: TossSpacing.space2),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isCheckingAccountMapping 
                                            ? 'Checking account mapping...'
                                            : _accountMapping != null 
                                                ? 'Account mapping verified'
                                                : 'Account mapping status',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _accountMapping != null 
                                              ? TossColors.success
                                              : _accountMappingError != null 
                                                  ? TossColors.error
                                                  : TossColors.gray700,
                                        ),
                                      ),
                                      if (_accountMappingError != null) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          _accountMappingError!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: TossColors.error,
                                          ),
                                        ),
                                      ],
                                      if (_accountMapping != null) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          'Direction: ${_accountMapping!['direction']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: TossColors.gray600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Debt Information Section (only if payable/receivable)
                        if (_hasPayableOrReceivable) ...[
                          SizedBox(height: TossSpacing.space6),
                          
                          // Debt Information Header
                          Text(
                            'Debt Information',
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                          SizedBox(height: TossSpacing.space3),
                          
                          // Interest Rate Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interest Rate (%)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray700,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Container(
                                decoration: BoxDecoration(
                                  color: TossColors.gray50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: TextField(
                                  controller: _interestRateController,
                                  enabled: !_isProcessing,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  style: TextStyle(
                                    color: TossColors.gray900,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      color: TossColors.gray400,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: TossSpacing.space4),
                          
                          // Debt Category Dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Debt Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray700,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Container(
                                decoration: BoxDecoration(
                                  color: TossColors.gray50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedDebtCategory,
                                  decoration: InputDecoration(
                                    hintText: 'Select category',
                                    hintStyle: TextStyle(
                                      color: TossColors.gray400,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down, color: TossColors.gray600),
                                  items: _debtCategories.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category[0].toUpperCase() + category.substring(1),
                                        style: TextStyle(
                                          color: TossColors.gray900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: !_isProcessing ? (value) {
                                    setState(() {
                                      _selectedDebtCategory = value;
                                    });
                                  } : null,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: TossSpacing.space4),
                          
                          // Date Pickers Row
                          Row(
                            children: [
                              // Issue Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Issue Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: TossColors.gray700,
                                      ),
                                    ),
                                    SizedBox(height: TossSpacing.space2),
                                    GestureDetector(
                                      onTap: !_isProcessing ? () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: _issueDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (date != null) {
                                          setState(() {
                                            _issueDate = date;
                                          });
                                        }
                                      } : null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: TossColors.gray50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _issueDate != null
                                                  ? DateFormat('yyyy-MM-dd').format(_issueDate!)
                                                  : 'Select date',
                                              style: TextStyle(
                                                color: _issueDate != null
                                                    ? TossColors.gray900
                                                    : TossColors.gray400,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              Icons.calendar_today,
                                              size: 18,
                                              color: TossColors.gray600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(width: TossSpacing.space3),
                              
                              // Due Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Due Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: TossColors.gray700,
                                      ),
                                    ),
                                    SizedBox(height: TossSpacing.space2),
                                    GestureDetector(
                                      onTap: !_isProcessing ? () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: _dueDate ?? DateTime.now().add(Duration(days: 30)),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (date != null) {
                                          setState(() {
                                            _dueDate = date;
                                          });
                                        }
                                      } : null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: TossColors.gray50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _dueDate != null
                                                  ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                                                  : 'Select date',
                                              style: TextStyle(
                                                color: _dueDate != null
                                                    ? TossColors.gray900
                                                    : TossColors.gray400,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              Icons.calendar_today,
                                              size: 18,
                                              color: TossColors.gray600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: TossSpacing.space4),
                          
                          // Debt Description Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray700,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Container(
                                decoration: BoxDecoration(
                                  color: TossColors.gray50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: TextField(
                                  controller: _debtDescriptionController,
                                  enabled: !_isProcessing,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: TossColors.gray900,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter debt description...',
                                    hintStyle: TextStyle(
                                      color: TossColors.gray400,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        
                        SizedBox(height: TossSpacing.space5),
                      ],
                    ),
                  ),
                ),
                
                // Bottom button with safe area
                Container(
                  padding: EdgeInsets.all(TossSpacing.space5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: TossPrimaryButton(
                      text: _isProcessing ? 'Processing...' : 'Confirm Transaction',
                      leadingIcon: _isProcessing ? null : Icon(Icons.check_circle_outline, size: 20),
                      isEnabled: !_isProcessing && 
                                 _amountController.text.isNotEmpty && 
                                 double.tryParse(_amountController.text.replaceAll(',', '')) != null &&
                                 double.parse(_amountController.text.replaceAll(',', '')) > 0 &&
                                 _isCounterpartyCashLocationValid(),
                      isLoading: _isProcessing,
                      onPressed: _handleConfirm,
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
  
  Widget _buildTransactionItem({
    required BuildContext context,
    required String type,
    required Color color,
    required Map<String, dynamic> transaction,
    required bool isFirst,
  }) {
    return Container(
      width: double.infinity,  // Force full width
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type indicator - TRULY FIXED SIZE
          Container(
            width: 85.0,  // Make it wide enough for CREDIT
            height: 26.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                type,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          // Account name
          Text(
            transaction['account_name'] ?? '',
            style: TextStyle(
              color: TossColors.gray900,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // Additional info - simplified
          if (transaction['cash_location_name'] != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 16,
                  color: TossColors.gray500,
                ),
                SizedBox(width: 6),
                Text(
                  transaction['cash_location_name'],
                  style: TextStyle(
                    color: TossColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
          
          if (transaction['counterparty_name'] != null) ...[
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: TossColors.gray500,
                ),
                SizedBox(width: 6),
                Text(
                  transaction['counterparty_name'],
                  style: TextStyle(
                    color: TossColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
}