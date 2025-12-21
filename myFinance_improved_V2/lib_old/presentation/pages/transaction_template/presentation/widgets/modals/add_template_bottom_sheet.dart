import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/presentation/widgets/toss/modal_keyboard_patterns.dart';
import 'package:myfinance_improved/presentation/providers/entities/account_provider.dart';
import '../wizard/step_indicator.dart';
import '../wizard/template_basic_info_form.dart';
import '../wizard/account_selector_card.dart';
import '../wizard/permissions_form.dart';
import '../../../business/validators/template_form_validator.dart';
import '../../../business/use_cases/create_template_use_case.dart';
import '../../../core/models/template_creation_data.dart';
import '../dialogs/template_creation_dialogs.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class AddTemplateBottomSheet extends ConsumerStatefulWidget {
  const AddTemplateBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      // Prevent the modal from resizing when keyboard appears
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => Padding(
        // This padding prevents the modal from being pushed up by keyboard
        // We use zero padding to override the default keyboard avoidance
        padding: EdgeInsets.only(bottom: 0),
        child: const AddTemplateBottomSheet(),
      ),
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
  
  // Account selection state
  String? _selectedDebitAccountId;
  String? _selectedCreditAccountId;
  String? _selectedDebitCounterpartyId;
  Map<String, dynamic>? _selectedDebitCounterpartyData;
  String? _selectedCreditCounterpartyId;
  Map<String, dynamic>? _selectedCreditCounterpartyData;
  String? _selectedDebitStoreId;
  String? _selectedDebitCashLocationId;
  String? _selectedCreditStoreId;
  String? _selectedCreditCashLocationId;
  String? _selectedDebitMyCashLocationId;
  String? _selectedCreditMyCashLocationId;
  
  // Permissions
  String _selectedVisibility = 'Public';
  String _selectedPermission = 'Common';
  
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
    return TemplateFormValidator.validateStep3(
      selectedVisibility: _selectedVisibility,
      selectedPermission: _selectedPermission,
    ).isValid;
  }
  
  Future<void> _createTemplate() async {
    setState(() => _isCreating = true);
    
    try {
      final templateData = TemplateCreationData(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        selectedDebitAccountId: _selectedDebitAccountId,
        selectedCreditAccountId: _selectedCreditAccountId,
        selectedDebitCounterpartyId: _selectedDebitCounterpartyId,
        selectedDebitCounterpartyData: _selectedDebitCounterpartyData,
        selectedCreditCounterpartyId: _selectedCreditCounterpartyId,
        selectedCreditCounterpartyData: _selectedCreditCounterpartyData,
        selectedDebitStoreId: _selectedDebitStoreId,
        selectedDebitCashLocationId: _selectedDebitCashLocationId,
        selectedCreditStoreId: _selectedCreditStoreId,
        selectedCreditCashLocationId: _selectedCreditCashLocationId,
        selectedDebitMyCashLocationId: _selectedDebitMyCashLocationId,
        selectedCreditMyCashLocationId: _selectedCreditMyCashLocationId,
        visibilityLevel: _selectedVisibility,
        permission: _selectedPermission,
      );
      
      final result = await CreateTemplateUseCase.execute(
        ref: ref,
        templateData: templateData,
      );
      
      if (mounted) {
        if (result.isSuccess) {
          await TemplateCreationDialogs.showSuccess(context);
        } else {
          await TemplateCreationDialogs.showError(context, result.error!);
        }
      }
    } catch (e) {
      if (mounted) {
        await TemplateCreationDialogs.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  bool _isStep2Valid(bool debitRequiresCounterparty, bool creditRequiresCounterparty, 
                     bool debitIsCashAccount, bool creditIsCashAccount) {
    return TemplateFormValidator.canProceedFromStep2(
      selectedDebitAccountId: _selectedDebitAccountId,
      selectedCreditAccountId: _selectedCreditAccountId,
      debitRequiresCounterparty: debitRequiresCounterparty,
      creditRequiresCounterparty: creditRequiresCounterparty,
      debitIsCashAccount: debitIsCashAccount,
      creditIsCashAccount: creditIsCashAccount,
      selectedDebitCounterpartyId: _selectedDebitCounterpartyId,
      selectedDebitCounterpartyData: _selectedDebitCounterpartyData,
      selectedCreditCounterpartyId: _selectedCreditCounterpartyId,
      selectedCreditCounterpartyData: _selectedCreditCounterpartyData,
      selectedDebitStoreId: _selectedDebitStoreId,
      selectedCreditStoreId: _selectedCreditStoreId,
      selectedDebitCashLocationId: _selectedDebitCashLocationId,
      selectedCreditCashLocationId: _selectedCreditCashLocationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine current action buttons based on step
    Widget? currentActionButtons = _getCurrentActionButtons();
    
    // CRITICAL FIX: Prevent keyboard from pushing modal upward
    // Problem: Default showModalBottomSheet behavior pushes entire modal up when keyboard appears
    // Solution: Use Scaffold with resizeToAvoidBottomInset: false to lock modal position
    // Result: Modal stays fixed, only content scrolls, Next button hides when typing
    return Material(
      color: TossColors.transparent,
      child: Scaffold(
        backgroundColor: TossColors.transparent,
        // THIS IS THE KEY: Prevent scaffold from resizing when keyboard appears
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: WizardModalWrapper(
            maxHeightFactor: 0.9,
            hideActionsOnKeyboard: true, // Hide Next button when keyboard is visible
        header: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Header
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_currentStep > 1)
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: TossColors.gray700),
                          onPressed: _previousStep,
                        )
                      else
                        SizedBox(width: 48),
                      Expanded(
                        child: Text(
                          'New Transaction Template',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
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
                  StepIndicator(
                    currentStep: _currentStep,
                    totalSteps: _totalSteps,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            TemplateBasicInfoForm(
              nameController: _nameController,
              descriptionController: _descriptionController,
              onChanged: () => setState(() {}),
            ),
            _buildStep2Content(ref),
            PermissionsForm(
              selectedVisibility: _selectedVisibility,
              selectedPermission: _selectedPermission,
              onVisibilityChanged: (value) {
                setState(() {
                  _selectedVisibility = value ?? 'Public';
                });
              },
              onPermissionChanged: (value) {
                setState(() {
                  _selectedPermission = value ?? 'Common';
                });
              },
            ),
          ],
        ),
            actionButtons: currentActionButtons,
          ),
        ),
      ),
    );
  }
  
  // Get action buttons for current step
  Widget? _getCurrentActionButtons() {
    switch (_currentStep) {
      case 1:
        return SizedBox(
          width: double.infinity,
          child: TossPrimaryButton(
            text: 'Next',
            onPressed: _nameController.text.isNotEmpty ? _nextStep : null,
            isEnabled: _nameController.text.isNotEmpty,
          ),
        );
      case 2:
        // Need StatefulBuilder to handle reactive state
        return StatefulBuilder(
          builder: (context, setState) {
            final debitAccountAsync = ref.watch(accountByIdProvider(_selectedDebitAccountId ?? ''));
            final creditAccountAsync = ref.watch(accountByIdProvider(_selectedCreditAccountId ?? ''));
            
            final debitRequiresCounterparty = debitAccountAsync.maybeWhen(
              data: (account) => account?.categoryTag == 'payable' || account?.categoryTag == 'receivable',
              orElse: () => false,
            );
            
            final creditRequiresCounterparty = creditAccountAsync.maybeWhen(
              data: (account) => account?.categoryTag == 'payable' || account?.categoryTag == 'receivable',
              orElse: () => false,
            );
            
            final debitIsCashAccount = debitAccountAsync.maybeWhen(
              data: (account) => account?.categoryTag == 'cash',
              orElse: () => false,
            );
            
            final creditIsCashAccount = creditAccountAsync.maybeWhen(
              data: (account) => account?.categoryTag == 'cash',
              orElse: () => false,
            );
            
            return Row(
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
            );
          },
        );
      case 3:
        return Row(
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
                onPressed: _isCreating ? null : (_isStep3Valid() ? _createTemplate : null),
                isEnabled: !_isCreating && _isStep3Valid(),
              ),
            ),
          ],
        );
      default:
        return null;
    }
  }


  Widget _buildStep2Content(WidgetRef ref) {
    final debitAccountAsync = ref.watch(accountByIdProvider(_selectedDebitAccountId ?? ''));
    final creditAccountAsync = ref.watch(accountByIdProvider(_selectedCreditAccountId ?? ''));
    
    final debitRequiresCounterparty = debitAccountAsync.maybeWhen(
      data: (account) => account?.categoryTag == 'payable' || account?.categoryTag == 'receivable',
      orElse: () => false,
    );
    final creditRequiresCounterparty = creditAccountAsync.maybeWhen(
      data: (account) => account?.categoryTag == 'payable' || account?.categoryTag == 'receivable',
      orElse: () => false,
    );
    final debitIsCashAccount = debitAccountAsync.maybeWhen(
      data: (account) => account?.categoryTag == 'cash',
      orElse: () => false,
    );
    final creditIsCashAccount = creditAccountAsync.maybeWhen(
      data: (account) => account?.categoryTag == 'cash',
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
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debit Account Card
                  AccountSelectorCard(
                    type: AccountType.debit,
                    selectedAccountId: _selectedDebitAccountId,
                    selectedCounterpartyId: _selectedDebitCounterpartyId,
                    selectedCounterpartyData: _selectedDebitCounterpartyData,
                    selectedStoreId: _selectedDebitStoreId,
                    selectedCashLocationId: _selectedDebitCashLocationId,
                    selectedMyCashLocationId: _selectedDebitMyCashLocationId,
                    otherAccountIsCash: creditIsCashAccount,
                    otherAccountRequiresCounterparty: creditRequiresCounterparty,
                    onAccountChanged: (accountId) {
                      setState(() {
                        _selectedDebitAccountId = accountId;
                        _selectedDebitCounterpartyId = null;
                        _selectedDebitCounterpartyData = null;
                        _selectedDebitMyCashLocationId = null;
                        _selectedDebitStoreId = null;
                        _selectedDebitCashLocationId = null;
                      });
                    },
                    onCounterpartyChanged: (counterpartyId) {
                      setState(() {
                        _selectedDebitCounterpartyId = counterpartyId;
                        _selectedDebitCounterpartyData = null;
                        _selectedDebitStoreId = null;
                        _selectedDebitCashLocationId = null;
                      });
                    },
                    onStoreChanged: (storeId, storeName) {
                      setState(() {
                        _selectedDebitStoreId = storeId;
                        _selectedDebitCashLocationId = null;
                      });
                    },
                    onCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedDebitCashLocationId = locationId;
                      });
                    },
                    onMyCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedDebitMyCashLocationId = locationId;
                      });
                    },
                    onCounterpartyDataChanged: (data) {
                      setState(() {
                        _selectedDebitCounterpartyData = data;
                      });
                    },
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // Credit Account Card
                  AccountSelectorCard(
                    type: AccountType.credit,
                    selectedAccountId: _selectedCreditAccountId,
                    selectedCounterpartyId: _selectedCreditCounterpartyId,
                    selectedCounterpartyData: _selectedCreditCounterpartyData,
                    selectedStoreId: _selectedCreditStoreId,
                    selectedCashLocationId: _selectedCreditCashLocationId,
                    selectedMyCashLocationId: _selectedCreditMyCashLocationId,
                    otherAccountIsCash: debitIsCashAccount,
                    otherAccountRequiresCounterparty: debitRequiresCounterparty,
                    onAccountChanged: (accountId) {
                      setState(() {
                        _selectedCreditAccountId = accountId;
                        _selectedCreditCounterpartyId = null;
                        _selectedCreditCounterpartyData = null;
                        _selectedCreditMyCashLocationId = null;
                        _selectedCreditStoreId = null;
                        _selectedCreditCashLocationId = null;
                      });
                    },
                    onCounterpartyChanged: (counterpartyId) {
                      setState(() {
                        _selectedCreditCounterpartyId = counterpartyId;
                        _selectedCreditCounterpartyData = null;
                        _selectedCreditStoreId = null;
                        _selectedCreditCashLocationId = null;
                      });
                    },
                    onStoreChanged: (storeId, storeName) {
                      setState(() {
                        _selectedCreditStoreId = storeId;
                        _selectedCreditCashLocationId = null;
                      });
                    },
                    onCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedCreditCashLocationId = locationId;
                      });
                    },
                    onMyCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedCreditMyCashLocationId = locationId;
                      });
                    },
                    onCounterpartyDataChanged: (data) {
                      setState(() {
                        _selectedCreditCounterpartyData = data;
                      });
                    },
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
        ],
      ),
    );
  }


}