import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/account_provider.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/modal_keyboard_patterns.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';

import '../../../journal_input/presentation/providers/journal_input_providers.dart';
import '../../domain/enums/template_constants.dart';
import '../../domain/factories/template_line_factory.dart';
import '../../domain/usecases/create_template_usecase.dart';
import '../dialogs/template_creation_dialogs.dart';
import '../providers/template_provider.dart';
import '../widgets/add_template/add_template_widgets.dart';
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

  // Account mapping validation state
  Map<String, dynamic>? _debitAccountMapping;
  Map<String, dynamic>? _creditAccountMapping;
  String? _debitMappingError;
  String? _creditMappingError;
  bool _isCheckingDebitMapping = false;
  bool _isCheckingCreditMapping = false;

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
      // Get account data for data structure building
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
      final debitAccountCode = debitAccountAsync.maybeWhen(
        data: (account) => account?.accountCode,
        orElse: () => null,
      );
      final creditAccountCode = creditAccountAsync.maybeWhen(
        data: (account) => account?.accountCode,
        orElse: () => null,
      );

      // Get counterparty names
      final debitCounterpartyName = _selectedDebitCounterpartyData?['name'] as String?;
      final creditCounterpartyName = _selectedCreditCounterpartyData?['name'] as String?;

      // Create transaction lines using Domain Factory
      final data = TemplateLineFactory.createLines(
        templateName: _nameController.text,
        debitAccountId: _selectedDebitAccountId,
        debitAccountName: debitAccountName,
        debitCategoryTag: debitAccountCategoryTag,
        debitAccountCode: debitAccountCode,
        debitCashLocationId: _selectedDebitMyCashLocationId,
        debitCashLocationName: _selectedDebitMyCashLocationName,
        debitCounterpartyId: _selectedDebitCounterpartyId,
        debitCounterpartyName: debitCounterpartyName,
        debitCounterpartyCashLocationId: _selectedDebitCashLocationId,
        debitCounterpartyCashLocationName: _selectedDebitCashLocationName,
        creditAccountId: _selectedCreditAccountId,
        creditAccountName: creditAccountName,
        creditCategoryTag: creditAccountCategoryTag,
        creditAccountCode: creditAccountCode,
        creditCashLocationId: _selectedCreditMyCashLocationId,
        creditCashLocationName: _selectedCreditMyCashLocationName,
        creditCounterpartyId: _selectedCreditCounterpartyId,
        creditCounterpartyName: creditCounterpartyName,
        creditCounterpartyCashLocationId: _selectedCreditCashLocationId,
        creditCounterpartyCashLocationName: _selectedCreditCashLocationName,
      );

      // Build tags for categorization
      final tags = _buildTemplateTags(
        debitAccountCategoryTag: debitAccountCategoryTag,
        creditAccountCategoryTag: creditAccountCategoryTag,
        debitCounterpartyName: debitCounterpartyName,
        creditCounterpartyName: creditCounterpartyName,
      );

      // Create command
      final command = CreateTemplateCommand(
        name: _nameController.text,
        templateDescription: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        data: data,
        tags: tags,
        visibilityLevel: _selectedVisibility,
        permission: TemplateConstants.getPermissionUUID(_selectedPermission),
        counterpartyId: _selectedDebitCounterpartyId ?? _selectedCreditCounterpartyId,
        counterpartyCashLocationId: _selectedDebitCashLocationId ?? _selectedCreditCashLocationId,
        companyId: ref.read(appStateProvider).companyChoosen.toString(),
        storeId: ref.read(appStateProvider).storeChoosen.toString(),
        createdBy: ref.read(userDisplayDataProvider)['user_id']?.toString(),
        requiredAttachment: _requiredAttachment,
      );

      // Execute use case
      final result = await ref.read(createTemplateUseCaseProvider).execute(command);

      if (mounted) {
        if (result.isSuccess) {
          await ref.read(templateNotifierProvider.notifier).loadTemplates(
            companyId: command.companyId,
            storeId: command.storeId,
          );
          await TemplateCreationDialogs.showSuccess(context);
        } else {
          await TemplateCreationDialogs.showError(context, result.error ?? 'Unknown error');
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

  /// Build template tags for categorization
  Map<String, dynamic> _buildTemplateTags({
    String? debitAccountCategoryTag,
    String? creditAccountCategoryTag,
    String? debitCounterpartyName,
    String? creditCounterpartyName,
  }) {
    final accountIds = <String>[
      if (_selectedDebitAccountId != null) _selectedDebitAccountId!,
      if (_selectedCreditAccountId != null) _selectedCreditAccountId!,
    ];

    final categories = <String>{
      if (debitAccountCategoryTag != null) debitAccountCategoryTag,
      if (creditAccountCategoryTag != null) creditAccountCategoryTag,
    }.toList();

    final cashLocationIds = <String>[
      if (_selectedDebitMyCashLocationId != null) _selectedDebitMyCashLocationId!,
      if (_selectedCreditMyCashLocationId != null) _selectedCreditMyCashLocationId!,
    ];

    final tags = <String, dynamic>{
      'accounts': accountIds,
      'categories': categories,
      'cash_locations': cashLocationIds,
    };

    // Add counterparty store info
    if (_selectedDebitStoreId != null) {
      tags['counterparty_store_id'] = _selectedDebitStoreId;
      tags['counterparty_store_name'] = _selectedDebitStoreName;
    } else if (_selectedCreditStoreId != null) {
      tags['counterparty_store_id'] = _selectedCreditStoreId;
      tags['counterparty_store_name'] = _selectedCreditStoreName;
    }

    // Add counterparty name for legacy compatibility
    if (debitCounterpartyName != null) {
      tags['counterparty_name'] = debitCounterpartyName;
    } else if (creditCounterpartyName != null) {
      tags['counterparty_name'] = creditCounterpartyName;
    }

    return tags;
  }

  /// Check account mapping for internal counterparty
  Future<void> _checkAccountMapping({
    required String counterpartyId,
    required String accountId,
    required bool isDebit,
  }) async {
    if (counterpartyId.isEmpty || accountId.isEmpty) return;

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) return;

    setState(() {
      if (isDebit) {
        _isCheckingDebitMapping = true;
        _debitMappingError = null;
        _debitAccountMapping = null;
      } else {
        _isCheckingCreditMapping = true;
        _creditMappingError = null;
        _creditAccountMapping = null;
      }
    });

    try {
      final mapping = await ref.read(journalActionsNotifierProvider.notifier).checkAccountMapping(
        companyId: companyId,
        counterpartyId: counterpartyId,
        accountId: accountId,
      );

      if (mounted) {
        setState(() {
          if (isDebit) {
            _isCheckingDebitMapping = false;
            _debitAccountMapping = mapping;
            if (mapping == null) {
              _debitMappingError = 'Account mapping required for internal transactions';
            }
          } else {
            _isCheckingCreditMapping = false;
            _creditAccountMapping = mapping;
            if (mapping == null) {
              _creditMappingError = 'Account mapping required for internal transactions';
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (isDebit) {
            _isCheckingDebitMapping = false;
            _debitMappingError = 'Error checking account mapping';
          } else {
            _isCheckingCreditMapping = false;
            _creditMappingError = 'Error checking account mapping';
          }
        });
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
    // 3. Account mapping must exist for internal counterparty with payable/receivable

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
      // ✅ Account mapping MUST exist for internal counterparty with payable/receivable
      if (_isCheckingDebitMapping) {
        return false; // Still checking
      }
      if (_debitAccountMapping == null) {
        return false; // No mapping found
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
      // ✅ Account mapping MUST exist for internal counterparty with payable/receivable
      if (_isCheckingCreditMapping) {
        return false; // Still checking
      }
      if (_creditAccountMapping == null) {
        return false; // No mapping found
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
            _buildStep2ContentWidget(ref),
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


  /// Build Step 2 content using extracted Step2Content widget
  Widget _buildStep2ContentWidget(WidgetRef ref) {
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

    return Step2Content(
      // Debit account state
      selectedDebitAccountId: _selectedDebitAccountId,
      selectedDebitAccountCategoryTag: _selectedDebitAccountCategoryTag,
      selectedDebitCounterpartyId: _selectedDebitCounterpartyId,
      selectedDebitCounterpartyData: _selectedDebitCounterpartyData,
      selectedDebitStoreId: _selectedDebitStoreId,
      selectedDebitCashLocationId: _selectedDebitCashLocationId,
      selectedDebitMyCashLocationId: _selectedDebitMyCashLocationId,
      // Credit account state
      selectedCreditAccountId: _selectedCreditAccountId,
      selectedCreditAccountCategoryTag: _selectedCreditAccountCategoryTag,
      selectedCreditCounterpartyId: _selectedCreditCounterpartyId,
      selectedCreditCounterpartyData: _selectedCreditCounterpartyData,
      selectedCreditStoreId: _selectedCreditStoreId,
      selectedCreditCashLocationId: _selectedCreditCashLocationId,
      selectedCreditMyCashLocationId: _selectedCreditMyCashLocationId,
      // Account type flags
      debitIsCashAccount: debitIsCashAccount,
      creditIsCashAccount: creditIsCashAccount,
      debitRequiresCounterparty: debitRequiresCounterparty,
      creditRequiresCounterparty: creditRequiresCounterparty,
      // Account mapping state
      isCheckingDebitMapping: _isCheckingDebitMapping,
      isCheckingCreditMapping: _isCheckingCreditMapping,
      debitMappingError: _debitMappingError,
      creditMappingError: _creditMappingError,
      debitAccountMapping: _debitAccountMapping,
      creditAccountMapping: _creditAccountMapping,
      // Debit callbacks
      onDebitAccountChanged: (accountId) {
        setState(() => _selectedDebitAccountId = accountId);
      },
      onDebitAccountChangedWithData: (accountId, accountName, categoryTag) {
        setState(() {
          _selectedDebitAccountId = accountId;
          _selectedDebitAccountName = accountName;
          _selectedDebitAccountCategoryTag = categoryTag;
          _selectedDebitCounterpartyId = null;
          _selectedDebitCounterpartyData = null;
          _selectedDebitMyCashLocationId = null;
          _selectedDebitStoreId = null;
          _selectedDebitCashLocationId = null;
          _debitAccountMapping = null;
          _debitMappingError = null;
        });
      },
      onDebitCounterpartyChanged: (counterpartyId) {
        setState(() {
          _selectedDebitCounterpartyId = counterpartyId;
          _selectedDebitCounterpartyData = null;
          _selectedDebitStoreId = null;
          _selectedDebitCashLocationId = null;
        });
      },
      onDebitStoreChanged: (storeId, storeName) {
        setState(() {
          _selectedDebitStoreId = storeId;
          _selectedDebitStoreName = storeName;
          _selectedDebitCashLocationId = null;
        });
      },
      onDebitCashLocationChanged: (locationId) {
        setState(() => _selectedDebitCashLocationId = locationId);
      },
      onDebitCashLocationChangedWithName: (locationId, locationName) {
        setState(() {
          _selectedDebitCashLocationId = locationId;
          _selectedDebitCashLocationName = locationName;
        });
      },
      onDebitMyCashLocationChanged: (locationId) {
        setState(() => _selectedDebitMyCashLocationId = locationId);
      },
      onDebitMyCashLocationChangedWithName: (locationId, locationName) {
        setState(() {
          _selectedDebitMyCashLocationId = locationId;
          _selectedDebitMyCashLocationName = locationName;
        });
      },
      onDebitCounterpartyDataChanged: (data) {
        setState(() {
          _selectedDebitCounterpartyData = data;
          _debitAccountMapping = null;
          _debitMappingError = null;
        });
        if (data != null &&
            data['is_internal'] == true &&
            _selectedDebitAccountId != null &&
            _selectedDebitCounterpartyId != null) {
          _checkAccountMapping(
            counterpartyId: _selectedDebitCounterpartyId!,
            accountId: _selectedDebitAccountId!,
            isDebit: true,
          );
        }
      },
      // Credit callbacks
      onCreditAccountChanged: (accountId) {
        setState(() => _selectedCreditAccountId = accountId);
      },
      onCreditAccountChangedWithData: (accountId, accountName, categoryTag) {
        setState(() {
          _selectedCreditAccountId = accountId;
          _selectedCreditAccountName = accountName;
          _selectedCreditAccountCategoryTag = categoryTag;
          _selectedCreditCounterpartyId = null;
          _selectedCreditCounterpartyData = null;
          _selectedCreditMyCashLocationId = null;
          _selectedCreditStoreId = null;
          _selectedCreditCashLocationId = null;
          _creditAccountMapping = null;
          _creditMappingError = null;
        });
      },
      onCreditCounterpartyChanged: (counterpartyId) {
        setState(() {
          _selectedCreditCounterpartyId = counterpartyId;
          _selectedCreditCounterpartyData = null;
          _selectedCreditStoreId = null;
          _selectedCreditCashLocationId = null;
        });
      },
      onCreditStoreChanged: (storeId, storeName) {
        setState(() {
          _selectedCreditStoreId = storeId;
          _selectedCreditStoreName = storeName;
          _selectedCreditCashLocationId = null;
        });
      },
      onCreditCashLocationChanged: (locationId) {
        setState(() => _selectedCreditCashLocationId = locationId);
      },
      onCreditCashLocationChangedWithName: (locationId, locationName) {
        setState(() {
          _selectedCreditCashLocationId = locationId;
          _selectedCreditCashLocationName = locationName;
        });
      },
      onCreditMyCashLocationChanged: (locationId) {
        setState(() => _selectedCreditMyCashLocationId = locationId);
      },
      onCreditMyCashLocationChangedWithName: (locationId, locationName) {
        setState(() {
          _selectedCreditMyCashLocationId = locationId;
          _selectedCreditMyCashLocationName = locationName;
        });
      },
      onCreditCounterpartyDataChanged: (data) {
        setState(() {
          _selectedCreditCounterpartyData = data;
          _creditAccountMapping = null;
          _creditMappingError = null;
        });
        if (data != null &&
            data['is_internal'] == true &&
            _selectedCreditAccountId != null &&
            _selectedCreditCounterpartyId != null) {
          _checkAccountMapping(
            counterpartyId: _selectedCreditCounterpartyId!,
            accountId: _selectedCreditAccountId!,
            isDebit: false,
          );
        }
      },
      // Navigation callback
      onNavigateToSettings: _navigateToAccountSettings,
    );
  }

  /// Navigate to Account Settings page for the counterparty
  void _navigateToAccountSettings(String counterpartyId, String counterpartyName) {
    Navigator.of(context).pop();
    context.pushNamed(
      'debtAccountSettings',
      pathParameters: {
        'counterpartyId': counterpartyId,
        'name': counterpartyName,
      },
    );
  }
}