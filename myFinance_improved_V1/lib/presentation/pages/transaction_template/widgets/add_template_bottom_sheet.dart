import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_text_field.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/presentation/widgets/specific/selectors/autonomous_account_selector.dart';
import 'package:myfinance_improved/presentation/providers/entities/account_provider.dart';
import 'package:myfinance_improved/presentation/providers/entities/cash_location_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import 'package:myfinance_improved/data/services/transaction_template_service.dart';
import 'package:myfinance_improved/data/services/supabase_service.dart';
import '../providers/transaction_template_providers.dart';
import 'counterparty_selector.dart';
import 'store_selector.dart';
import 'cash_location_selector.dart';
import 'my_cash_location_selector.dart';

class AddTemplateBottomSheet extends ConsumerStatefulWidget {
  const AddTemplateBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const AddTemplateBottomSheet(),
    );
  }

  @override
  ConsumerState<AddTemplateBottomSheet> createState() => _AddTemplateBottomSheetState();
}

class _AddTemplateBottomSheetState extends ConsumerState<AddTemplateBottomSheet> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  int _currentStep = 1;
  final int _totalSteps = 3; // Will be expanded to include more steps
  
  // Selected account IDs for debit and credit
  String? _selectedDebitAccountId;
  String? _selectedCreditAccountId;
  
  // Selected counterparty IDs and data
  String? _selectedDebitCounterpartyId;
  Map<String, dynamic>? _selectedDebitCounterpartyData;
  String? _selectedCreditCounterpartyId;
  Map<String, dynamic>? _selectedCreditCounterpartyData;
  
  // Selected store and cash location for internal counterparties
  String? _selectedDebitStoreId;
  String? _selectedDebitStoreName;
  String? _selectedDebitCashLocationId;
  String? _selectedCreditStoreId;
  String? _selectedCreditStoreName;
  String? _selectedCreditCashLocationId;
  
  // Cash locations for cash accounts (my company's cash)
  String? _selectedDebitMyCashLocationId;
  String? _selectedCreditMyCashLocationId;
  
  // Step 3: Permissions
  String _selectedVisibility = 'Public'; // Default to Public
  String _selectedPermission = 'Common'; // Default to Common
  
  // Loading state
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  bool _isStep3Valid() {
    // Step 3 is always valid since we have default values
    // But we check that name and accounts are still filled (from previous steps)
    return _nameController.text.isNotEmpty && 
           _selectedDebitAccountId != null && 
           _selectedCreditAccountId != null;
  }
  
  Future<void> _createTemplate() async {
    // Set loading state
    setState(() {
      _isCreating = true;
    });
    
    try {
      // Get app state data
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      final userId = appState.user['user_id'] as String;
      
      // Get account details for building the data array
      final debitAccountAsync = await ref.read(accountByIdProvider(_selectedDebitAccountId!).future);
      final creditAccountAsync = await ref.read(accountByIdProvider(_selectedCreditAccountId!).future);
      
      // Get cash location names if selected
      String? debitCashLocationName;
      String? creditCashLocationName;
      
      if (_selectedDebitMyCashLocationId != null) {
        final cashLocationAsync = await ref.read(cashLocationByIdProvider(_selectedDebitMyCashLocationId!).future);
        debitCashLocationName = cashLocationAsync?.name;
      }
      
      if (_selectedCreditMyCashLocationId != null) {
        final cashLocationAsync = await ref.read(cashLocationByIdProvider(_selectedCreditMyCashLocationId!).future);
        creditCashLocationName = cashLocationAsync?.name;
      }
      
      // Build the data array
      final dataArray = [
        {
          "type": "debit",
          "debit": "0",
          "amount": "0",
          "credit": "0",
          "account_id": _selectedDebitAccountId,
          "description": null,
          "account_name": debitAccountAsync?.name,
          "category_tag": debitAccountAsync?.categoryTag,
          "counterparty_id": _selectedDebitCounterpartyId,
          "cash_location_id": _selectedDebitMyCashLocationId,
          "counterparty_name": _selectedDebitCounterpartyData?['name'],
          "cash_location_name": debitCashLocationName,
          "counterparty_cash_location_id": _selectedDebitCashLocationId,
        },
        {
          "type": "credit",
          "debit": "0",
          "amount": "0",
          "credit": "0",
          "account_id": _selectedCreditAccountId,
          "description": null,
          "account_name": creditAccountAsync?.name,
          "category_tag": creditAccountAsync?.categoryTag,
          "counterparty_id": _selectedCreditCounterpartyId,
          "cash_location_id": _selectedCreditMyCashLocationId,
          "counterparty_name": _selectedCreditCounterpartyData?['name'],
          "cash_location_name": creditCashLocationName,
          "counterparty_cash_location_id": _selectedCreditCashLocationId,
        },
      ];
      
      // Build tags
      final accountIds = [_selectedDebitAccountId!, _selectedCreditAccountId!];
      final cashLocationIds = <String>[];
      if (_selectedDebitMyCashLocationId != null) cashLocationIds.add(_selectedDebitMyCashLocationId!);
      if (_selectedCreditMyCashLocationId != null) cashLocationIds.add(_selectedCreditMyCashLocationId!);
      
      // Collect actual category_tags from both accounts
      final categories = <String>[];
      if (debitAccountAsync?.categoryTag != null) {
        categories.add(debitAccountAsync!.categoryTag!);
      }
      if (creditAccountAsync?.categoryTag != null) {
        categories.add(creditAccountAsync!.categoryTag!);
      }
      
      // Remove duplicates if both accounts have same category_tag
      final uniqueCategories = categories.toSet().toList();
      
      // Collect counterparty store IDs
      String? counterpartyStoreId;
      if (_selectedDebitStoreId != null) {
        counterpartyStoreId = _selectedDebitStoreId;
      } else if (_selectedCreditStoreId != null) {
        counterpartyStoreId = _selectedCreditStoreId;
      }
      
      final tags = {
        "accounts": accountIds,
        "categories": uniqueCategories,  // Array of actual category_tags
        "cash_locations": cashLocationIds,
        if (counterpartyStoreId != null) "counterparty_store_id": counterpartyStoreId,
      };
      
      // Determine counterparty info for template level
      String? templateCounterpartyId;
      String? templateCounterpartyCashLocationId;
      
      if (_selectedDebitCounterpartyId != null) {
        templateCounterpartyId = _selectedDebitCounterpartyId;
        templateCounterpartyCashLocationId = _selectedDebitCashLocationId;
      } else if (_selectedCreditCounterpartyId != null) {
        templateCounterpartyId = _selectedCreditCounterpartyId;
        templateCounterpartyCashLocationId = _selectedCreditCashLocationId;
      }
      
      // Create the template
      final templateService = TransactionTemplateService(ref.read(supabaseServiceProvider));
      
      await templateService.createTemplate(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        companyId: companyId,
        storeId: storeId,
        userId: userId,
        data: dataArray,
        tags: tags,
        visibilityLevel: _selectedVisibility,
        permission: _selectedPermission,
        counterpartyId: templateCounterpartyId,
        counterpartyCashLocationId: templateCounterpartyCashLocationId,
      );
      
      // Refresh the template list
      ref.invalidate(transactionTemplatesProvider);
      
      // Show success dialog
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TossColors.successLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: TossColors.success,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Success!',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Template created successfully',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TossTextStyles.button.copyWith(
                      color: TossColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show error dialog
      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TossColors.errorLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: TossColors.error,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to create template',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.toString(),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'OK',
                    style: TossTextStyles.button.copyWith(
                      color: TossColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  bool _isStep2Valid(bool debitRequiresCounterparty, bool creditRequiresCounterparty, 
                     bool debitIsCashAccount, bool creditIsCashAccount) {
    // Basic validation: both accounts must be selected
    if (_selectedDebitAccountId == null || _selectedCreditAccountId == null) {
      return false;
    }
    
    // Check if debit account requires counterparty
    if (debitRequiresCounterparty && _selectedDebitCounterpartyId == null) {
      return false;
    }
    
    // Check if credit account requires counterparty
    if (creditRequiresCounterparty && _selectedCreditCounterpartyId == null) {
      return false;
    }
    
    // Cash location is now optional since "None" is a valid choice
    // No validation needed for cash accounts
    
    // Check if debit internal counterparty requires store (cash location is optional)
    if (_selectedDebitCounterpartyData != null && 
        _selectedDebitCounterpartyData!['is_internal'] == true) {
      if (_selectedDebitStoreId == null) {
        return false;
      }
    }
    
    // Check if credit internal counterparty requires store (cash location is optional)
    if (_selectedCreditCounterpartyData != null && 
        _selectedCreditCounterpartyData!['is_internal'] == true) {
      if (_selectedCreditStoreId == null) {
        return false;
      }
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.9; // Use 90% of screen height max
    
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      duration: const Duration(milliseconds: 200),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
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
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 1)
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: TossColors.gray700),
                          onPressed: _previousStep,
                        )
                      else
                        SizedBox(width: 48),
                      Text(
                        'New Transaction Template',
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: TossColors.gray700),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space3),
                  // Step indicator
                  _buildStepIndicator(),
                ],
              ),
            ),
            
            // Content - Make it flexible to prevent overflow
            Flexible(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(ref),
                  _buildStep3(),
                ],
              ),
            ),
            
            // Safe area bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (index) {
        final isActive = index < _currentStep;
        final isCurrent = index == _currentStep - 1;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? TossColors.primary : TossColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Basic Information',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          
          // Name field
          TossTextField(
            label: 'Template Name',
            hintText: 'Enter template name',
            controller: _nameController,
            textInputAction: TextInputAction.next,
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Description field
          TossTextField(
            label: 'Description (Optional)',
            hintText: 'Enter template description',
            controller: _descriptionController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          
          Spacer(),
          
          // Next button
          SizedBox(
            width: double.infinity,
            child: TossPrimaryButton(
              text: 'Next',
              onPressed: _nameController.text.isNotEmpty ? _nextStep : null,
              isEnabled: _nameController.text.isNotEmpty,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(WidgetRef ref) {
    // Get account details to check category tags
    final debitAccountAsync = ref.watch(accountByIdProvider(_selectedDebitAccountId ?? ''));
    final creditAccountAsync = ref.watch(accountByIdProvider(_selectedCreditAccountId ?? ''));
    
    // Check if accounts require counterparty
    final debitRequiresCounterparty = debitAccountAsync.maybeWhen(
      data: (account) {
        if (account == null) return false;
        final categoryTag = account.categoryTag;
        return categoryTag == 'payable' || categoryTag == 'receivable';
      },
      orElse: () => false,
    );
    
    final creditRequiresCounterparty = creditAccountAsync.maybeWhen(
      data: (account) {
        if (account == null) return false;
        final categoryTag = account.categoryTag;
        return categoryTag == 'payable' || categoryTag == 'receivable';
      },
      orElse: () => false,
    );
    
    // Check if accounts are cash accounts
    final debitIsCashAccount = debitAccountAsync.maybeWhen(
      data: (account) {
        if (account == null) return false;
        return account.categoryTag == 'cash';
      },
      orElse: () => false,
    );
    
    final creditIsCashAccount = creditAccountAsync.maybeWhen(
      data: (account) {
        if (account == null) return false;
        return account.categoryTag == 'cash';
      },
      orElse: () => false,
    );
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Transaction Details',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          
          // Account selection content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debit Account Section with visual indicator
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.errorLight,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                'DEBIT',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.error,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Icon(
                              Icons.remove_circle_outline,
                              size: 16,
                              color: TossColors.error,
                            ),
                          ],
                        ),
                        SizedBox(height: TossSpacing.space3),
                        AutonomousAccountSelector(
                          selectedAccountId: _selectedDebitAccountId,
                          onChanged: (accountId) {
                            setState(() {
                              _selectedDebitAccountId = accountId;
                              // Reset counterparty and cash location when account changes
                              _selectedDebitCounterpartyId = null;
                              _selectedDebitCounterpartyData = null;
                              _selectedDebitMyCashLocationId = null;
                            });
                          },
                          label: 'Debit Account',
                          hint: 'Select account to debit',
                          showTransactionCount: false,
                        ),
                        
                        // Show counterparty selector if account requires it
                        if (debitRequiresCounterparty && _selectedDebitAccountId != null) ...[
                          SizedBox(height: TossSpacing.space3),
                          CounterpartySelector(
                            accountId: _selectedDebitAccountId,
                            selectedCounterpartyId: _selectedDebitCounterpartyId,
                            onChanged: (counterpartyId, counterpartyData) {
                              setState(() {
                                _selectedDebitCounterpartyId = counterpartyId;
                                _selectedDebitCounterpartyData = counterpartyData;
                                // Reset store and cash location when counterparty changes
                                _selectedDebitStoreId = null;
                                _selectedDebitStoreName = null;
                                _selectedDebitCashLocationId = null;
                              });
                            },
                            label: 'Counterparty',
                            hint: 'Select counterparty',
                          ),
                          
                          // Show store selector if internal counterparty is selected
                          if (_selectedDebitCounterpartyData != null && 
                              _selectedDebitCounterpartyData!['is_internal'] == true) ...[
                            SizedBox(height: TossSpacing.space3),
                            StoreSelector(
                              linkedCompanyId: _selectedDebitCounterpartyData!['linked_company_id'] as String?,
                              selectedStoreId: _selectedDebitStoreId,
                              onChanged: (storeId, storeName) {
                                setState(() {
                                  _selectedDebitStoreId = storeId;
                                  _selectedDebitStoreName = storeName;
                                  // Reset cash location when store changes
                                  _selectedDebitCashLocationId = null;
                                });
                              },
                              label: 'Counterparty Store',
                              hint: 'Select store',
                            ),
                            
                            // Show cash location selector if store is selected
                            if (_selectedDebitStoreId != null) ...[
                              SizedBox(height: TossSpacing.space3),
                              CashLocationSelector(
                                companyId: _selectedDebitCounterpartyData!['linked_company_id'] as String?,
                                storeId: _selectedDebitStoreId,
                                selectedCashLocationId: _selectedDebitCashLocationId,
                                onChanged: (cashLocationId) {
                                  setState(() {
                                    _selectedDebitCashLocationId = cashLocationId;
                                  });
                                },
                                label: 'Counterparty Cash Location',
                                hint: 'Select cash location',
                              ),
                            ],
                          ],
                        ],
                        
                        // Show my company's cash location selector if account is cash
                        if (debitIsCashAccount && _selectedDebitAccountId != null) ...[
                          SizedBox(height: TossSpacing.space3),
                          MyCashLocationSelector(
                            selectedLocationId: _selectedDebitMyCashLocationId,
                            onChanged: (cashLocationId) {
                              setState(() {
                                _selectedDebitMyCashLocationId = cashLocationId;
                              });
                            },
                            label: 'Cash Location',
                            hint: 'Select cash location',
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // Credit Account Section with visual indicator
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.successLight,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                'CREDIT',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.success,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Icon(
                              Icons.add_circle_outline,
                              size: 16,
                              color: TossColors.success,
                            ),
                          ],
                        ),
                        SizedBox(height: TossSpacing.space3),
                        AutonomousAccountSelector(
                          selectedAccountId: _selectedCreditAccountId,
                          onChanged: (accountId) {
                            setState(() {
                              _selectedCreditAccountId = accountId;
                              // Reset counterparty and cash location when account changes
                              _selectedCreditCounterpartyId = null;
                              _selectedCreditCounterpartyData = null;
                              _selectedCreditMyCashLocationId = null;
                            });
                          },
                          label: 'Credit Account',
                          hint: 'Select account to credit',
                          showTransactionCount: false,
                        ),
                        
                        // Show counterparty selector if account requires it
                        if (creditRequiresCounterparty && _selectedCreditAccountId != null) ...[
                          SizedBox(height: TossSpacing.space3),
                          CounterpartySelector(
                            accountId: _selectedCreditAccountId,
                            selectedCounterpartyId: _selectedCreditCounterpartyId,
                            onChanged: (counterpartyId, counterpartyData) {
                              setState(() {
                                _selectedCreditCounterpartyId = counterpartyId;
                                _selectedCreditCounterpartyData = counterpartyData;
                                // Reset store and cash location when counterparty changes
                                _selectedCreditStoreId = null;
                                _selectedCreditStoreName = null;
                                _selectedCreditCashLocationId = null;
                              });
                            },
                            label: 'Counterparty',
                            hint: 'Select counterparty',
                          ),
                          
                          // Show store selector if internal counterparty is selected
                          if (_selectedCreditCounterpartyData != null && 
                              _selectedCreditCounterpartyData!['is_internal'] == true) ...[
                            SizedBox(height: TossSpacing.space3),
                            StoreSelector(
                              linkedCompanyId: _selectedCreditCounterpartyData!['linked_company_id'] as String?,
                              selectedStoreId: _selectedCreditStoreId,
                              onChanged: (storeId, storeName) {
                                setState(() {
                                  _selectedCreditStoreId = storeId;
                                  _selectedCreditStoreName = storeName;
                                  // Reset cash location when store changes
                                  _selectedCreditCashLocationId = null;
                                });
                              },
                              label: 'Counterparty Store',
                              hint: 'Select store',
                            ),
                            
                            // Show cash location selector if store is selected
                            if (_selectedCreditStoreId != null) ...[
                              SizedBox(height: TossSpacing.space3),
                              CashLocationSelector(
                                companyId: _selectedCreditCounterpartyData!['linked_company_id'] as String?,
                                storeId: _selectedCreditStoreId,
                                selectedCashLocationId: _selectedCreditCashLocationId,
                                onChanged: (cashLocationId) {
                                  setState(() {
                                    _selectedCreditCashLocationId = cashLocationId;
                                  });
                                },
                                label: 'Counterparty Cash Location',
                                hint: 'Select cash location',
                              ),
                            ],
                          ],
                        ],
                        
                        // Show my company's cash location selector if account is cash
                        if (creditIsCashAccount && _selectedCreditAccountId != null) ...[
                          SizedBox(height: TossSpacing.space3),
                          MyCashLocationSelector(
                            selectedLocationId: _selectedCreditMyCashLocationId,
                            onChanged: (cashLocationId) {
                              setState(() {
                                _selectedCreditMyCashLocationId = cashLocationId;
                              });
                            },
                            label: 'Cash Location',
                            hint: 'Select cash location',
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space3),
                  
                  // Helpful explanation
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            'Debit increases assets/expenses, decreases liabilities/income.\nCredit increases liabilities/income, decreases assets/expenses.',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: TossSecondaryButton(
                  text: 'Back',
                  onPressed: _previousStep,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: TossPrimaryButton(
                  text: 'Next',
                  onPressed: _isStep2Valid(debitRequiresCounterparty, creditRequiresCounterparty,
                                          debitIsCashAccount, creditIsCashAccount) 
                      ? _nextStep 
                      : null,
                  isEnabled: _isStep2Valid(debitRequiresCounterparty, creditRequiresCounterparty,
                                          debitIsCashAccount, creditIsCashAccount),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3: Permissions & Tags',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          
          // Visibility Level Dropdown
          TossDropdown<String>(
            label: 'Visibility Level',
            value: _selectedVisibility,
            onChanged: (value) {
              setState(() {
                _selectedVisibility = value ?? 'Public';
              });
            },
            items: const [
              TossDropdownItem(
                value: 'Public',
                label: 'Public',
                subtitle: 'Visible to all users in the company',
              ),
              TossDropdownItem(
                value: 'Private',
                label: 'Private',
                subtitle: 'Only visible to you',
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Permission Level Dropdown
          TossDropdown<String>(
            label: 'Permission',
            value: _selectedPermission,
            onChanged: (value) {
              setState(() {
                _selectedPermission = value ?? 'Common';
              });
            },
            items: const [
              TossDropdownItem(
                value: 'Manager',
                label: 'Manager',
                subtitle: 'Only managers can use this template',
              ),
              TossDropdownItem(
                value: 'Common',
                label: 'Common',
                subtitle: 'All authorized users can use this template',
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Info box about permissions
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: TossColors.primarySurface,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Templates help standardize common transactions. Set visibility to control who can see this template, and permission to control who can use it.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Spacer(),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: TossSecondaryButton(
                  text: 'Back',
                  onPressed: _previousStep,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: TossPrimaryButton(
                  text: _isCreating ? 'Creating...' : 'Create',
                  onPressed: _isCreating ? null : (_isStep3Valid() ? () {
                    _createTemplate();
                  } : null),
                  isEnabled: !_isCreating && _isStep3Valid(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}