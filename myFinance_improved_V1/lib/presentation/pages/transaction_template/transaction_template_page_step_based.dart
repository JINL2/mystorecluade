import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import 'providers/transaction_template_providers.dart';

// Create Template Content with Step-based form
class CreateTemplateContent extends ConsumerStatefulWidget {
  const CreateTemplateContent({super.key});

  @override
  ConsumerState<CreateTemplateContent> createState() => _CreateTemplateContentState();
}

class _CreateTemplateContentState extends ConsumerState<CreateTemplateContent> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? selectedDebitAccountId;
  String? selectedCreditAccountId;
  String? selectedDebitCashLocationId;
  String? selectedCreditCashLocationId;
  String? selectedDebitCounterpartyId;
  String? selectedCreditCounterpartyId;
  Map<String, dynamic>? selectedDebitCounterparty;
  Map<String, dynamic>? selectedCreditCounterparty;
  String? selectedDebitCounterpartyCashLocationId;
  String? selectedCreditCounterpartyCashLocationId;
  String visibilityLevel = 'private';
  String permissionLevel = 'manager';
  bool _isLoading = false;
  
  // Account mapping fields for internal counterparties
  Map<String, dynamic>? _debitAccountMapping;
  Map<String, dynamic>? _creditAccountMapping;
  bool _isCheckingDebitMapping = false;
  bool _isCheckingCreditMapping = false;
  String? _debitMappingError;
  String? _creditMappingError;
  
  // Step management
  int _currentStep = 0;
  final int _totalSteps = 3;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List<String> _stepTitles = [
    'Basic Information',
    'Accounts Setup',
    'Settings'
  ];

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
    _slideAnimation = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    
    // Add listener to controllers for real-time validation
    _nameController.addListener(_updateButtonState);
    _descriptionController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    // Trigger rebuild to update button state
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _descriptionController.removeListener(_updateButtonState);
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _checkDebitAccountMapping(String counterpartyId, bool isInternal) async {
    if (!isInternal || selectedDebitAccountId == null) {
      setState(() {
        _debitAccountMapping = null;
        _debitMappingError = null;
      });
      return;
    }
    
    setState(() {
      _isCheckingDebitMapping = true;
      _debitMappingError = null;
      _debitAccountMapping = null;
    });
    
    try {
      final supabase = Supabase.instance.client;
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      // Query account_mappings table
      final response = await supabase
          .from('account_mappings')
          .select('my_account_id, linked_account_id, direction')
          .eq('my_company_id', companyId)
          .eq('counterparty_id', counterpartyId)
          .eq('my_account_id', selectedDebitAccountId!)
          .maybeSingle();
      
      if (response != null) {
        setState(() {
          _debitAccountMapping = {
            'my_account_id': response['my_account_id'],
            'linked_account_id': response['linked_account_id'],
            'direction': response['direction'],
          };
          _debitMappingError = null;
        });
      } else {
        setState(() {
          _debitMappingError = 'No account mapping found for this internal counterparty';
          // Reset the counterparty selection
          selectedDebitCounterpartyId = null;
          selectedDebitCounterparty = null;
          selectedDebitCounterpartyCashLocationId = null;
        });
        
        // Show popup dialog when no mapping is found
        if (mounted) {
          await _showNoMappingDialog('debit');
        }
      }
    } catch (e) {
      setState(() {
        _debitMappingError = 'Error checking account mapping';
      });
    } finally {
      setState(() {
        _isCheckingDebitMapping = false;
      });
    }
  }

  Future<void> _checkCreditAccountMapping(String counterpartyId, bool isInternal) async {
    if (!isInternal || selectedCreditAccountId == null) {
      setState(() {
        _creditAccountMapping = null;
        _creditMappingError = null;
      });
      return;
    }
    
    setState(() {
      _isCheckingCreditMapping = true;
      _creditMappingError = null;
      _creditAccountMapping = null;
    });
    
    try {
      final supabase = Supabase.instance.client;
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      // Query account_mappings table
      final response = await supabase
          .from('account_mappings')
          .select('my_account_id, linked_account_id, direction')
          .eq('my_company_id', companyId)
          .eq('counterparty_id', counterpartyId)
          .eq('my_account_id', selectedCreditAccountId!)
          .maybeSingle();
      
      if (response != null) {
        setState(() {
          _creditAccountMapping = {
            'my_account_id': response['my_account_id'],
            'linked_account_id': response['linked_account_id'],
            'direction': response['direction'],
          };
          _creditMappingError = null;
        });
      } else {
        setState(() {
          _creditMappingError = 'No account mapping found for this internal counterparty';
          // Reset the counterparty selection
          selectedCreditCounterpartyId = null;
          selectedCreditCounterparty = null;
          selectedCreditCounterpartyCashLocationId = null;
        });
        
        // Show popup dialog when no mapping is found
        if (mounted) {
          await _showNoMappingDialog('credit');
        }
      }
    } catch (e) {
      setState(() {
        _creditMappingError = 'Error checking account mapping';
      });
    } finally {
      setState(() {
        _isCheckingCreditMapping = false;
      });
    }
  }

  Future<void> _showNoMappingDialog(String side) async {
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
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
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
                  'The selected internal counterparty requires an account mapping for the ${side} account.',
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

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Validate current step before proceeding
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _animateStepTransition();
      }
    } else {
      _saveTemplate();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _animateStepTransition();
    }
  }

  void _animateStepTransition() {
    _animationController.reset();
    _animationController.forward();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        // Basic Information
        return _nameController.text.trim().isNotEmpty;
      case 1:
        // Accounts Setup
        return selectedDebitAccountId != null && selectedCreditAccountId != null;
      case 2:
        // Settings
        return true;
      default:
        return true;
    }
  }

  // Getter to check if current step is valid for button styling
  bool get _isCurrentStepValid => _validateCurrentStep();

  Future<void> _saveTemplate() async {
    if (!_validateCurrentStep()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get debit and credit account details
      final accounts = await ref.read(accountsProvider.future);
      final debitAccount = accounts.firstWhere((a) => a['account_id'] == selectedDebitAccountId);
      final creditAccount = accounts.firstWhere((a) => a['account_id'] == selectedCreditAccountId);
      
      // Get cash location names if selected
      String? debitCashLocationName;
      String? creditCashLocationName;
      
      if (selectedDebitCashLocationId != null) {
        final cashLocations = await ref.read(cashLocationsProvider.future);
        final location = cashLocations.firstWhere((l) => l['cash_location_id'] == selectedDebitCashLocationId);
        debitCashLocationName = location['location_name'];
      }
      
      if (selectedCreditCashLocationId != null) {
        final cashLocations = await ref.read(cashLocationsProvider.future);
        final location = cashLocations.firstWhere((l) => l['cash_location_id'] == selectedCreditCashLocationId);
        creditCashLocationName = location['location_name'];
      }
      
      // Map permission level to UUID
      final permissionUuid = permissionLevel == 'manager' 
          ? 'c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14'
          : 'cffb000f-498b-4296-af84-4ce9bbd8bed7';
      
      // Create JSON array structure for data
      final templateData = [
        {
          'account_id': selectedDebitAccountId,
          'account_name': debitAccount['account_name'],
          'category_tag': debitAccount['category_tag'],  // Add category_tag
          'type': 'debit',  // Add type
          'amount': '0',
          'debit': '0',
          'credit': '0',
          'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          'cash_location_id': selectedDebitCashLocationId,
          'cash_location_name': debitCashLocationName,
          'counterparty_id': selectedDebitCounterpartyId,
          'counterparty_name': selectedDebitCounterparty?['name'],
          'counterparty_cash_location_id': selectedDebitCounterpartyCashLocationId,
        },
        {
          'account_id': selectedCreditAccountId,
          'account_name': creditAccount['account_name'],
          'category_tag': creditAccount['category_tag'],  // Add category_tag
          'type': 'credit',  // Add type
          'amount': '0',
          'debit': '0',
          'credit': '0',
          'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          'cash_location_id': selectedCreditCashLocationId,
          'cash_location_name': creditCashLocationName,
          'counterparty_id': selectedCreditCounterpartyId,
          'counterparty_name': selectedCreditCounterparty?['name'],
          'counterparty_cash_location_id': selectedCreditCounterpartyCashLocationId,
        },
      ];
      
      // Create tags structure
      final tags = {
        'accounts': [selectedDebitAccountId, selectedCreditAccountId],
        'category': 'expense', // You might want to determine this based on account types
        'cash_locations': [
          if (selectedDebitCashLocationId != null) selectedDebitCashLocationId,
          if (selectedCreditCashLocationId != null) selectedCreditCashLocationId,
        ].where((id) => id != null).toList(),
      };
      
      // Determine which counterparty to use as the main one (prioritize debit side)
      final mainCounterpartyId = selectedDebitCounterpartyId ?? selectedCreditCounterpartyId;
      
      // Prepare the complete template data
      final template = {
        'name': _nameController.text,
        'data': templateData,
        'permission': permissionUuid,
        'tags': tags,
        'visibility_level': visibilityLevel,
        'counterparty_id': mainCounterpartyId, // Store the main counterparty ID
        'counterparty_cash_location_id': selectedDebitCounterpartyCashLocationId ?? selectedCreditCounterpartyCashLocationId,
      };
      
      // Create the template
      final createTemplate = ref.read(createTransactionTemplateProvider);
      await createTemplate(template);
      
      // Close the bottom sheet
      if (mounted) {
        Navigator.of(context).pop();
        _showSuccess('Template created successfully');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to create template: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps, (index) {
          return Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: index == _currentStep ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index <= _currentStep ? TossColors.primary : TossColors.gray300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (index < _totalSteps - 1)
                Container(
                  width: 16,
                  height: 1,
                  color: index < _currentStep ? TossColors.primary : TossColors.gray200,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2AccountsSetup();
      case 2:
        return _buildStep3Settings();
      default:
        return Container();
    }
  }

  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transaction Name field
        _buildModernTextField(
          controller: _nameController,
          label: 'Transaction Name',
          placeholder: 'e.g., Monthly Rent Payment',
          icon: Icons.receipt_outlined,
          required: true,
        ),
        
        SizedBox(height: 24),

        // Description field
        _buildModernTextField(
          controller: _descriptionController,
          label: 'Description',
          placeholder: 'Add a description for this template',
          icon: Icons.notes_outlined,
          maxLines: 3,
        ),

        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStep2AccountsSetup() {
    final accountsAsync = ref.watch(accountsProvider);
    final cashLocationsAsync = ref.watch(cashLocationsProvider);
    final counterpartiesAsync = ref.watch(counterpartiesProvider);
    
    return accountsAsync.when(
      data: (accounts) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DEBIT Section
            Container(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Text(
                    'DEBIT',
                    style: TossTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            // Debit Account Dropdown
            _buildAccountDropdown(
              label: 'Debit Account',
              value: selectedDebitAccountId,
              accounts: accounts,
              onChanged: (value) {
                setState(() {
                  selectedDebitAccountId = value;
                  // Reset related fields
                  selectedDebitCashLocationId = null;
                  selectedDebitCounterpartyId = null;
                  selectedDebitCounterpartyCashLocationId = null;
                });
              },
            ),
            
            // Show cash location if debit account is cash
            if (selectedDebitAccountId != null) ...[
              Builder(
                builder: (context) {
                  final debitAccount = accounts.firstWhere(
                    (a) => a['account_id'] == selectedDebitAccountId,
                    orElse: () => {},
                  );
                  if (debitAccount['category_tag'] == 'cash') {
                    return Column(
                      children: [
                        SizedBox(height: 16),
                        cashLocationsAsync.when(
                          data: (locations) => _buildCashLocationDropdown(
                            label: 'Cash Location',
                            value: selectedDebitCashLocationId,
                            locations: locations,
                            onChanged: (value) {
                              setState(() {
                                selectedDebitCashLocationId = value;
                              });
                            },
                          ),
                          loading: () => CircularProgressIndicator(),
                          error: (_, __) => Text('Error loading cash locations'),
                        ),
                      ],
                    );
                  } else if (debitAccount['category_tag'] == 'payable' || 
                             debitAccount['category_tag'] == 'receivable') {
                    return Column(
                      children: [
                        SizedBox(height: 16),
                        counterpartiesAsync.when(
                          data: (counterparties) => _buildCounterpartyDropdown(
                            label: 'Counterparty',
                            value: selectedDebitCounterpartyId,
                            counterparties: counterparties,
                            onChanged: (value) async {
                              setState(() {
                                selectedDebitCounterpartyId = value;
                                try {
                                  selectedDebitCounterparty = counterparties.firstWhere(
                                    (c) => c['counterparty_id'] == value,
                                  );
                                } catch (e) {
                                  selectedDebitCounterparty = null;
                                }
                                selectedDebitCounterpartyCashLocationId = null;
                              });
                              
                              // Check account mapping if counterparty is internal
                              if (selectedDebitCounterparty != null && value != null) {
                                final isInternal = selectedDebitCounterparty!['is_internal'] == true;
                                await _checkDebitAccountMapping(value, isInternal);
                              }
                            },
                          ),
                          loading: () => CircularProgressIndicator(),
                          error: (_, __) => Text('Error loading counterparties'),
                        ),
                        if (selectedDebitCounterparty?['linked_company_id'] != null) ...[
                          SizedBox(height: 16),
                          Consumer(
                            builder: (context, ref, child) {
                              final counterpartyCashLocationsAsync = ref.watch(
                                counterpartyCashLocationsProvider(
                                  selectedDebitCounterparty!['linked_company_id']
                                )
                              );
                              return counterpartyCashLocationsAsync.when(
                                data: (locations) => _buildCashLocationDropdown(
                                  label: 'Counterparty Cash Location',
                                  value: selectedDebitCounterpartyCashLocationId,
                                  locations: locations,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDebitCounterpartyCashLocationId = value;
                                    });
                                  },
                                ),
                                loading: () => CircularProgressIndicator(),
                                error: (_, __) => Text('Error loading cash locations'),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
            
            SizedBox(height: 24),
            
            // CREDIT Section
            Container(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Text(
                    'CREDIT',
                    style: TossTextStyles.caption.copyWith(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            // Credit Account Dropdown
            _buildAccountDropdown(
              label: 'Credit Account',
              value: selectedCreditAccountId,
              accounts: accounts,
              onChanged: (value) {
                setState(() {
                  selectedCreditAccountId = value;
                  // Reset related fields
                  selectedCreditCashLocationId = null;
                  selectedCreditCounterpartyId = null;
                  selectedCreditCounterpartyCashLocationId = null;
                });
              },
            ),
            
            // Show cash location if credit account is cash
            if (selectedCreditAccountId != null) ...[
              Builder(
                builder: (context) {
                  final creditAccount = accounts.firstWhere(
                    (a) => a['account_id'] == selectedCreditAccountId,
                    orElse: () => {},
                  );
                  if (creditAccount['category_tag'] == 'cash') {
                    return Column(
                      children: [
                        SizedBox(height: 16),
                        cashLocationsAsync.when(
                          data: (locations) => _buildCashLocationDropdown(
                            label: 'Cash Location',
                            value: selectedCreditCashLocationId,
                            locations: locations,
                            onChanged: (value) {
                              setState(() {
                                selectedCreditCashLocationId = value;
                              });
                            },
                          ),
                          loading: () => CircularProgressIndicator(),
                          error: (_, __) => Text('Error loading cash locations'),
                        ),
                      ],
                    );
                  } else if (creditAccount['category_tag'] == 'payable' || 
                             creditAccount['category_tag'] == 'receivable') {
                    return Column(
                      children: [
                        SizedBox(height: 16),
                        counterpartiesAsync.when(
                          data: (counterparties) => _buildCounterpartyDropdown(
                            label: 'Counterparty',
                            value: selectedCreditCounterpartyId,
                            counterparties: counterparties,
                            onChanged: (value) async {
                              setState(() {
                                selectedCreditCounterpartyId = value;
                                try {
                                  selectedCreditCounterparty = counterparties.firstWhere(
                                    (c) => c['counterparty_id'] == value,
                                  );
                                } catch (e) {
                                  selectedCreditCounterparty = null;
                                }
                                selectedCreditCounterpartyCashLocationId = null;
                              });
                              
                              // Check account mapping if counterparty is internal
                              if (selectedCreditCounterparty != null && value != null) {
                                final isInternal = selectedCreditCounterparty!['is_internal'] == true;
                                await _checkCreditAccountMapping(value, isInternal);
                              }
                            },
                          ),
                          loading: () => CircularProgressIndicator(),
                          error: (_, __) => Text('Error loading counterparties'),
                        ),
                        if (selectedCreditCounterparty?['linked_company_id'] != null) ...[
                          SizedBox(height: 16),
                          Consumer(
                            builder: (context, ref, child) {
                              final counterpartyCashLocationsAsync = ref.watch(
                                counterpartyCashLocationsProvider(
                                  selectedCreditCounterparty!['linked_company_id']
                                )
                              );
                              return counterpartyCashLocationsAsync.when(
                                data: (locations) => _buildCashLocationDropdown(
                                  label: 'Counterparty Cash Location',
                                  value: selectedCreditCounterpartyCashLocationId,
                                  locations: locations,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCreditCounterpartyCashLocationId = value;
                                    });
                                  },
                                ),
                                loading: () => CircularProgressIndicator(),
                                error: (_, __) => Text('Error loading cash locations'),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
            
            SizedBox(height: 16),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Error loading accounts: $error'),
    );
  }

  Widget _buildStep3Settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visibility Toggle
        GestureDetector(
          onTap: () => setState(() {
            visibilityLevel = visibilityLevel == 'private' ? 'public' : 'private';
          }),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: visibilityLevel == 'public' 
                  ? TossColors.primary.withOpacity(0.05) 
                  : TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: visibilityLevel == 'public' 
                    ? TossColors.primary.withOpacity(0.3) 
                    : TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: visibilityLevel == 'public' 
                        ? TossColors.primary.withOpacity(0.1) 
                        : TossColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    visibilityLevel == 'public' ? Icons.public : Icons.lock_outline,
                    size: 20,
                    color: visibilityLevel == 'public' 
                        ? TossColors.primary 
                        : TossColors.gray600,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visibility',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        visibilityLevel == 'public' 
                            ? 'Public - Everyone can see this template'
                            : 'Private - Only you can see this template',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: visibilityLevel == 'public',
                  onChanged: (value) {
                    setState(() {
                      visibilityLevel = value ? 'public' : 'private';
                    });
                  },
                  activeColor: TossColors.primary,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),

        // Permission Toggle
        GestureDetector(
          onTap: () => setState(() {
            permissionLevel = permissionLevel == 'manager' ? 'all' : 'manager';
          }),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: permissionLevel == 'all' 
                  ? TossColors.primary.withOpacity(0.05) 
                  : TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: permissionLevel == 'all' 
                    ? TossColors.primary.withOpacity(0.3) 
                    : TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: permissionLevel == 'all' 
                        ? TossColors.primary.withOpacity(0.1) 
                        : TossColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    permissionLevel == 'all' ? Icons.groups : Icons.admin_panel_settings,
                    size: 20,
                    color: permissionLevel == 'all' 
                        ? TossColors.primary 
                        : TossColors.gray600,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permission',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        permissionLevel == 'all' 
                            ? 'All - Everyone can use this template'
                            : 'Manager - Only managers can use this template',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: permissionLevel == 'all',
                  onChanged: (value) {
                    setState(() {
                      permissionLevel = value ? 'all' : 'manager';
                    });
                  },
                  activeColor: TossColors.primary,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStepNavigation() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            if (_currentStep > 0)
              Expanded(
                child: TextButton(
                  onPressed: _isLoading ? null : _previousStep,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: TossColors.gray50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 18, color: TossColors.gray600),
                      SizedBox(width: 6),
                      Text(
                        'Back',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            SizedBox(width: 12),

            // Next/Create button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading || !_isCurrentStepValid ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCurrentStepValid ? TossColors.primary : TossColors.gray300,
                  foregroundColor: _isCurrentStepValid ? Colors.white : TossColors.gray500,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  disabledBackgroundColor: TossColors.gray300,
                  disabledForegroundColor: TossColors.gray500,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStep < _totalSteps - 1 
                                ? 'Next' 
                                : 'Create',
                            style: TossTextStyles.body.copyWith(
                              color: _isCurrentStepValid ? Colors.white : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            _currentStep < _totalSteps - 1 
                                ? Icons.arrow_forward 
                                : Icons.check,
                            size: 18,
                            color: _isCurrentStepValid ? Colors.white : TossColors.gray500,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Toss-style handle and header
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 16),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Template',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _stepTitles[_currentStep],
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Close button
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: TossColors.gray600),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Step content with animation
          Flexible(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Form content first
                            _buildCurrentStep(),
                            
                            // Step progress indicator at bottom
                            SizedBox(height: 12),
                            _buildStepIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Step navigation buttons
          _buildStepNavigation(),
        ],
      ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required) ...[
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(color: TossColors.error),
              ),
            ],
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TossTextStyles.body.copyWith(color: TossColors.gray900),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(icon, size: 20, color: TossColors.gray500),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: TossColors.gray200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: TossColors.primary, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountDropdown({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> accounts,
    required void Function(String?) onChanged,
  }) {
    // Find the selected account name
    String selectedAccountName = 'Select an account';
    if (value != null) {
      final selectedAccount = accounts.firstWhere(
        (a) => a['account_id'] == value,
        orElse: () => {'account_name': 'Select an account'},
      );
      selectedAccountName = selectedAccount['account_name'] ?? 'Select an account';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            _showAccountSearchModal(
              context,
              accounts,
              label,
              (selectedId) {
                onChanged(selectedId);
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: TossColors.gray200, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedAccountName,
                    style: TossTextStyles.body.copyWith(
                      color: value != null ? TossColors.gray900 : TossColors.gray400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAccountSearchModal(
    BuildContext context,
    List<Map<String, dynamic>> accounts,
    String title,
    Function(String?) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _AccountSearchModal(
          accounts: accounts,
          title: title,
          onSelect: onSelect,
        );
      },
    );
  }

  Widget _buildCashLocationDropdown({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> locations,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TossColors.gray200, width: 1),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            hint: Text(
              'Select a cash location',
              style: TossTextStyles.body.copyWith(color: TossColors.gray400),
            ),
            itemHeight: null, // Allow dynamic height for items
            selectedItemBuilder: (BuildContext context) {
              // This shows only the location name when selected
              return locations.map<Widget>((location) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    location['location_name'] ?? '',
                    style: TossTextStyles.body,
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
                      location['location_name'] ?? '',
                      style: TossTextStyles.body,
                    ),
                    if (location['location_type'] != null && location['location_type'] != 'none') ...[
                      SizedBox(height: 2),
                      Text(
                        location['location_type'].toString().toUpperCase(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterpartyDropdown({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> counterparties,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TossColors.gray200, width: 1),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            hint: Text(
              'Select a counterparty',
              style: TossTextStyles.body.copyWith(color: TossColors.gray400),
            ),
            items: counterparties.map((counterparty) {
              return DropdownMenuItem<String>(
                value: counterparty['counterparty_id'],
                child: Text(
                  counterparty['name'],
                  style: TossTextStyles.body,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// Searchable Account Modal
class _AccountSearchModal extends StatefulWidget {
  final List<Map<String, dynamic>> accounts;
  final String title;
  final Function(String?) onSelect;

  const _AccountSearchModal({
    required this.accounts,
    required this.title,
    required this.onSelect,
  });

  @override
  _AccountSearchModalState createState() => _AccountSearchModalState();
}

class _AccountSearchModalState extends State<_AccountSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    _filteredAccounts = widget.accounts;
    _searchController.addListener(_filterAccounts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAccounts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterAccounts() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredAccounts = widget.accounts;
      } else {
        _filteredAccounts = widget.accounts.where((account) {
          final accountName = (account['account_name'] ?? '').toString().toLowerCase();
          return accountName.contains(_searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ],
            ),
          ),
          
          // Search field
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: TossTextStyles.body.copyWith(color: TossColors.gray900),
              decoration: InputDecoration(
                hintText: 'Search accounts...',
                hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: Icon(Icons.search, size: 20, color: TossColors.gray500),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                filled: true,
                fillColor: TossColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: TossColors.gray200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: TossColors.primary, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          // Account list
          Expanded(
            child: _filteredAccounts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: TossColors.gray400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No accounts found',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredAccounts.length,
                    itemBuilder: (context, index) {
                      final account = _filteredAccounts[index];
                      return InkWell(
                        onTap: () {
                          widget.onSelect(account['account_id']);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: TossColors.gray100,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    (account['account_name'] ?? 'A')[0].toUpperCase(),
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      account['account_name'] ?? '',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (account['category_tag'] != null) ...[
                                      SizedBox(height: 2),
                                      Text(
                                        account['category_tag'].toString().toUpperCase(),
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: TossColors.gray400,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}