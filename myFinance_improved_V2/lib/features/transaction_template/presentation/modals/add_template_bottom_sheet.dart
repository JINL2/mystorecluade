import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/account_provider.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/modal_keyboard_patterns.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';

import '../../domain/enums/template_constants.dart';
import '../../domain/factories/template_line_factory.dart';
import '../../domain/usecases/create_template_usecase.dart';
import '../dialogs/template_creation_dialogs.dart';
import '../providers/template_provider.dart';
import '../widgets/wizard/account_selector_card.dart';
import '../widgets/wizard/permissions_form.dart';
import '../widgets/wizard/step_indicator.dart';
import '../widgets/wizard/template_basic_info_form.dart';

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
      builder: (context) => const Padding(
        // This padding prevents the modal from being pushed up by keyboard
        // We use zero padding to override the default keyboard avoidance
        padding: EdgeInsets.only(bottom: 0),
        child: AddTemplateBottomSheet(),
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
  String? _selectedDebitAccountName;
  String? _selectedDebitAccountCategoryTag;
  String? _selectedCreditAccountId;
  String? _selectedCreditAccountName;
  String? _selectedCreditAccountCategoryTag;
  String? _selectedDebitCounterpartyId;
  Map<String, dynamic>? _selectedDebitCounterpartyData;
  String? _selectedCreditCounterpartyId;
  Map<String, dynamic>? _selectedCreditCounterpartyData;
  String? _selectedDebitStoreId;
  String? _selectedDebitStoreName;
  String? _selectedDebitCashLocationId;
  String? _selectedDebitCashLocationName;
  String? _selectedCreditStoreId;
  String? _selectedCreditStoreName;
  String? _selectedCreditCashLocationId;
  String? _selectedCreditCashLocationName;
  String? _selectedDebitMyCashLocationId;
  String? _selectedDebitMyCashLocationName;
  String? _selectedCreditMyCashLocationId;
  String? _selectedCreditMyCashLocationName;
  
  // Permissions (lowercase to match validation)
  String _selectedVisibility = 'public';
  String _selectedPermission = 'common';

  // Required attachment toggle
  bool _requiredAttachment = false;

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
    // Simple validation for step 3 - permissions
    return _selectedVisibility.isNotEmpty && _selectedPermission.isNotEmpty;
  }
  
  Future<void> _createTemplate() async {
    setState(() => _isCreating = true);

    try {
      // 🔍 DEBUG: Log all selected values
      print('═══════════════════════════════════════════════════════════');
      print('🔍 TEMPLATE CREATION DEBUG LOG - START');
      print('═══════════════════════════════════════════════════════════');
      print('📝 Template Name: ${_nameController.text}');
      print('📄 Description: ${_descriptionController.text}');
      print('🔐 Visibility: $_selectedVisibility');
      print('🔒 Permission: $_selectedPermission');
      print('');

      // ✅ FIXED: Get account data for correct data structure building
      final debitAccountAsync = ref.read(accountByIdProvider(_selectedDebitAccountId ?? ''));
      final creditAccountAsync = ref.read(accountByIdProvider(_selectedCreditAccountId ?? ''));

      final debitAccountCategoryTag = debitAccountAsync.maybeWhen(
        data: (account) => account?.categoryTag,
        orElse: () => null,
      );
      final debitAccountName = debitAccountAsync.maybeWhen(
        data: (account) => account?.name,
        orElse: () => null,
      );

      final creditAccountCategoryTag = creditAccountAsync.maybeWhen(
        data: (account) => account?.categoryTag,
        orElse: () => null,
      );
      final creditAccountName = creditAccountAsync.maybeWhen(
        data: (account) => account?.name,
        orElse: () => null,
      );

      print('💳 DEBIT ACCOUNT:');
      print('  - ID: $_selectedDebitAccountId');
      print('  - Name: $debitAccountName');
      print('  - Category Tag: $debitAccountCategoryTag');
      print('  - My Cash Location ID: $_selectedDebitMyCashLocationId');
      print('  - My Cash Location Name: $_selectedDebitMyCashLocationName');
      print('  - Counterparty ID: $_selectedDebitCounterpartyId');
      print('  - Counterparty Data: $_selectedDebitCounterpartyData');
      print('  - Store ID: $_selectedDebitStoreId');
      print('  - Store Name: $_selectedDebitStoreName');
      print('  - Counterparty Cash Location ID: $_selectedDebitCashLocationId');
      print('  - Counterparty Cash Location Name: $_selectedDebitCashLocationName');
      print('');

      print('💳 CREDIT ACCOUNT:');
      print('  - ID: $_selectedCreditAccountId');
      print('  - Name: $creditAccountName');
      print('  - Category Tag: $creditAccountCategoryTag');
      print('  - My Cash Location ID: $_selectedCreditMyCashLocationId');
      print('  - My Cash Location Name: $_selectedCreditMyCashLocationName');
      print('  - Counterparty ID: $_selectedCreditCounterpartyId');
      print('  - Counterparty Data: $_selectedCreditCounterpartyData');
      print('  - Store ID: $_selectedCreditStoreId');
      print('  - Store Name: $_selectedCreditStoreName');
      print('  - Counterparty Cash Location ID: $_selectedCreditCashLocationId');
      print('  - Counterparty Cash Location Name: $_selectedCreditCashLocationName');
      print('');

      // Use cash location names from state (already received from selector callback)
      final debitCashLocationName = _selectedDebitMyCashLocationName;
      final creditCashLocationName = _selectedCreditMyCashLocationName;

      // Get counterparty names
      final debitCounterpartyName = _selectedDebitCounterpartyData?['name'] as String?;
      final creditCounterpartyName = _selectedCreditCounterpartyData?['name'] as String?;

      // Use counterparty cash location names from state (already received from selector callback)
      final debitCounterpartyCashLocationId = _selectedDebitCashLocationId;
      final debitCounterpartyCashLocationName = _selectedDebitCashLocationName;
      final creditCounterpartyCashLocationId = _selectedCreditCashLocationId;
      final creditCounterpartyCashLocationName = _selectedCreditCashLocationName;

      // ✅ CLEAN ARCHITECTURE: Use Domain Factory to create transaction lines with FLAT structure
      print('🏭 Creating transaction lines using TemplateLineFactory...');
      final data = TemplateLineFactory.createLines(
        templateName: _nameController.text,
        // Debit line parameters
        debitAccountId: _selectedDebitAccountId,
        debitAccountName: debitAccountName,
        debitCategoryTag: debitAccountCategoryTag,
        debitCashLocationId: _selectedDebitMyCashLocationId,
        debitCashLocationName: debitCashLocationName,
        debitCounterpartyId: _selectedDebitCounterpartyId,
        debitCounterpartyName: debitCounterpartyName,
        debitCounterpartyCashLocationId: debitCounterpartyCashLocationId,
        debitCounterpartyCashLocationName: debitCounterpartyCashLocationName,
        // Credit line parameters
        creditAccountId: _selectedCreditAccountId,
        creditAccountName: creditAccountName,
        creditCategoryTag: creditAccountCategoryTag,
        creditCashLocationId: _selectedCreditMyCashLocationId,
        creditCashLocationName: creditCashLocationName,
        creditCounterpartyId: _selectedCreditCounterpartyId,
        creditCounterpartyName: creditCounterpartyName,
        creditCounterpartyCashLocationId: creditCounterpartyCashLocationId,
        creditCounterpartyCashLocationName: creditCounterpartyCashLocationName,
      );

      print('✅ Generated transaction lines (data array):');
      for (int i = 0; i < data.length; i++) {
        print('  Line ${i + 1}: ${data[i]}');
      }
      print('');

      // Build tags object for categorization
      final accountIds = <String>[];
      if (_selectedDebitAccountId != null) accountIds.add(_selectedDebitAccountId!);
      if (_selectedCreditAccountId != null) accountIds.add(_selectedCreditAccountId!);

      final categories = <String>[];
      if (debitAccountCategoryTag != null) categories.add(debitAccountCategoryTag);
      if (creditAccountCategoryTag != null) categories.add(creditAccountCategoryTag);
      final uniqueCategories = categories.toSet().toList();

      final cashLocationIds = <String>[];
      if (_selectedDebitMyCashLocationId != null) cashLocationIds.add(_selectedDebitMyCashLocationId!);
      if (_selectedCreditMyCashLocationId != null) cashLocationIds.add(_selectedCreditMyCashLocationId!);

      final tags = <String, dynamic>{
        'accounts': accountIds,
        'categories': uniqueCategories,
        'cash_locations': cashLocationIds,
      };

      // Add counterparty store ID and name if internal transfer
      if (_selectedDebitStoreId != null) {
        tags['counterparty_store_id'] = _selectedDebitStoreId;
        tags['counterparty_store_name'] = _selectedDebitStoreName;
      } else if (_selectedCreditStoreId != null) {
        tags['counterparty_store_id'] = _selectedCreditStoreId;
        tags['counterparty_store_name'] = _selectedCreditStoreName;
      }

      // Add counterparty name to tags for compatibility with legacy templates
      if (debitCounterpartyName != null) {
        tags['counterparty_name'] = debitCounterpartyName;
      } else if (creditCounterpartyName != null) {
        tags['counterparty_name'] = creditCounterpartyName;
      }

      // Convert permission display name to UUID
      final permissionUUID = TemplateConstants.getPermissionUUID(_selectedPermission);

      print('📦 Creating CreateTemplateCommand...');
      final command = CreateTemplateCommand(
        name: _nameController.text,
        templateDescription: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        data: data, // Domain data structure with FLAT format
        tags: tags, // JSONB categorization tags
        visibilityLevel: _selectedVisibility, // 'public' or 'private'
        permission: permissionUUID, // UUID format
        counterpartyId: _selectedDebitCounterpartyId ?? _selectedCreditCounterpartyId,
        counterpartyCashLocationId: _selectedDebitCashLocationId ?? _selectedCreditCashLocationId,
        companyId: ref.read(appStateProvider).companyChoosen.toString(),
        storeId: ref.read(appStateProvider).storeChoosen.toString(),
        createdBy: ref.read(userDisplayDataProvider)['user_id']?.toString(), // ✅ Get user ID from app state
        requiredAttachment: _requiredAttachment, // ✅ Whether attachment is required when using template
      );

      print('📋 Command Details:');
      print('  - Name: ${command.name}');
      print('  - Description: ${command.templateDescription}');
      print('  - Visibility Level: ${command.visibilityLevel}');
      print('  - Permission UUID: ${command.permission}');
      print('  - Company ID: ${command.companyId}');
      print('  - Store ID: ${command.storeId}');
      print('  - Created By: ${command.createdBy}');
      print('  - Counterparty ID: ${command.counterpartyId}');
      print('  - Counterparty Cash Location ID: ${command.counterpartyCashLocationId}');
      print('  - Data Lines: ${command.data.length}');
      print('  - Tags: ${command.tags}');
      print('');

      print('🚀 Executing CreateTemplateUseCase...');
      final createUseCase = ref.read(createTemplateUseCaseProvider);
      final result = await createUseCase.execute(command);

      print('📊 Result: ${result.isSuccess ? "✅ SUCCESS" : "❌ FAILED"}');
      if (!result.isSuccess) {
        print('❌ Error: ${result.error}');
      }
      print('═══════════════════════════════════════════════════════════');
      print('🔍 TEMPLATE CREATION DEBUG LOG - END');
      print('═══════════════════════════════════════════════════════════');
      print('');

      if (mounted) {
        if (result.isSuccess) {
          // ✅ FIX: Reload templates to show the newly created template
          final appState = ref.read(appStateProvider);
          final notifier = ref.read(templateProvider.notifier);
          await notifier.loadTemplates(
            companyId: command.companyId,
            storeId: command.storeId,
          );

          await TemplateCreationDialogs.showSuccess(context);
        } else {
          await TemplateCreationDialogs.showError(context, result.error ?? 'Unknown error');
        }
      }
    } catch (e, stackTrace) {
      // 🔍 DEBUG: Log detailed error information
      print('═══════════════════════════════════════════════════════════');
      print('❌ TEMPLATE CREATION ERROR');
      print('═══════════════════════════════════════════════════════════');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('');
      print('Stack Trace:');
      print(stackTrace);
      print('═══════════════════════════════════════════════════════════');
      print('');

      // Extract detailed error information
      String errorMessage = e.toString();

      if (mounted) {
        await TemplateCreationDialogs.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  bool _isStep2Valid(bool debitRequiresCounterparty, bool creditRequiresCounterparty,
                     bool debitIsCashAccount, bool creditIsCashAccount,) {
    // Basic validation for step 2 - account selection
    if (_selectedDebitAccountId == null || _selectedCreditAccountId == null) {
      return false;
    }

    // Check counterparty requirements
    if (debitRequiresCounterparty && _selectedDebitCounterpartyId == null) {
      return false;
    }

    if (creditRequiresCounterparty && _selectedCreditCounterpartyId == null) {
      return false;
    }

    // Check cash location requirements
    if (debitIsCashAccount && _selectedDebitMyCashLocationId == null) {
      return false;
    }

    if (creditIsCashAccount && _selectedCreditMyCashLocationId == null) {
      return false;
    }

    // ✅ FIXED: Check internal counterparty cash location requirements
    // For internal counterparty transactions, we need:
    // 1. Store ID selected
    // 2. Cash location selected (if the OTHER account is a cash account)

    // Check debit counterparty + credit cash account
    if (debitRequiresCounterparty &&
        _selectedDebitCounterpartyData != null &&
        _selectedDebitCounterpartyData!['is_internal'] == true) {
      // Internal counterparty requires store selection
      if (_selectedDebitStoreId == null) {
        return false;
      }
      // If other account (credit) is cash, need counterparty cash location
      if (creditIsCashAccount && _selectedDebitCashLocationId == null) {
        return false;
      }
    }

    // Check credit counterparty + debit cash account
    if (creditRequiresCounterparty &&
        _selectedCreditCounterpartyData != null &&
        _selectedCreditCounterpartyData!['is_internal'] == true) {
      // Internal counterparty requires store selection
      if (_selectedCreditStoreId == null) {
        return false;
      }
      // If other account (debit) is cash, need counterparty cash location
      if (debitIsCashAccount && _selectedCreditCashLocationId == null) {
        return false;
      }
    }

    return true;
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
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_currentStep > 1)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: TossColors.gray700),
                          onPressed: _previousStep,
                        )
                      else
                        const SizedBox(width: 48),
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
                        icon: const Icon(Icons.close, color: TossColors.gray700),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space3),
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
          physics: const NeverScrollableScrollPhysics(),
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
              requiredAttachment: _requiredAttachment,
              onVisibilityChanged: (value) {
                setState(() {
                  _selectedVisibility = value ?? 'public';
                });
              },
              onPermissionChanged: (value) {
                setState(() {
                  _selectedPermission = value ?? 'common';
                });
              },
              onRequiredAttachmentChanged: (value) {
                setState(() {
                  _requiredAttachment = value;
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
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: TossPrimaryButton(
                    text: 'Next',
                    onPressed: _isStep2Valid(debitRequiresCounterparty, creditRequiresCounterparty,
                                            debitIsCashAccount, creditIsCashAccount,) 
                        ? _nextStep 
                        : null,
                    isEnabled: _isStep2Valid(debitRequiresCounterparty, creditRequiresCounterparty,
                                            debitIsCashAccount, creditIsCashAccount,),
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
            const SizedBox(width: TossSpacing.space3),
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
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
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
          const SizedBox(height: TossSpacing.space5),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debit Account Card
                  AccountSelectorCard(
                    type: AccountType.debit,
                    selectedAccountId: _selectedDebitAccountId,
                    selectedAccountCategoryTag: _selectedDebitAccountCategoryTag,  // ✅ NEW
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
                      });
                    },
                    // ✅ NEW: Type-safe callback receives all data
                    onAccountChangedWithData: (accountId, accountName, categoryTag) {
                      setState(() {
                        _selectedDebitAccountId = accountId;
                        _selectedDebitAccountName = accountName;
                        _selectedDebitAccountCategoryTag = categoryTag;
                        // Reset dependent selections
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
                        _selectedDebitStoreName = storeName;
                        _selectedDebitCashLocationId = null;
                      });
                    },
                    onCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedDebitCashLocationId = locationId;
                      });
                    },
                    onCashLocationChangedWithName: (locationId, locationName) {
                      setState(() {
                        _selectedDebitCashLocationId = locationId;
                        _selectedDebitCashLocationName = locationName;
                      });
                    },
                    onMyCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedDebitMyCashLocationId = locationId;
                      });
                    },
                    onMyCashLocationChangedWithName: (locationId, locationName) {
                      setState(() {
                        _selectedDebitMyCashLocationId = locationId;
                        _selectedDebitMyCashLocationName = locationName;
                      });
                    },
                    onCounterpartyDataChanged: (data) {
                      setState(() {
                        _selectedDebitCounterpartyData = data;
                      });
                    },
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Credit Account Card
                  AccountSelectorCard(
                    type: AccountType.credit,
                    selectedAccountId: _selectedCreditAccountId,
                    selectedAccountCategoryTag: _selectedCreditAccountCategoryTag,  // ✅ NEW
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
                      });
                    },
                    // ✅ NEW: Type-safe callback receives all data
                    onAccountChangedWithData: (accountId, accountName, categoryTag) {
                      setState(() {
                        _selectedCreditAccountId = accountId;
                        _selectedCreditAccountName = accountName;
                        _selectedCreditAccountCategoryTag = categoryTag;
                        // Reset dependent selections
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
                        _selectedCreditStoreName = storeName;
                        _selectedCreditCashLocationId = null;
                      });
                    },
                    onCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedCreditCashLocationId = locationId;
                      });
                    },
                    onCashLocationChangedWithName: (locationId, locationName) {
                      setState(() {
                        _selectedCreditCashLocationId = locationId;
                        _selectedCreditCashLocationName = locationName;
                      });
                    },
                    onMyCashLocationChanged: (locationId) {
                      setState(() {
                        _selectedCreditMyCashLocationId = locationId;
                      });
                    },
                    onMyCashLocationChangedWithName: (locationId, locationName) {
                      setState(() {
                        _selectedCreditMyCashLocationId = locationId;
                        _selectedCreditMyCashLocationName = locationName;
                      });
                    },
                    onCounterpartyDataChanged: (data) {
                      setState(() {
                        _selectedCreditCounterpartyData = data;
                      });
                    },
                  ),
                  
                  const SizedBox(height: TossSpacing.space3),
                  
                  // Helpful explanation
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: TossSpacing.space2),
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