/// Edit Template Modal - Modify existing transaction templates
///
/// Purpose: Allows authorized users to edit template properties and entry configurations.
/// - Template level: name, description, required_attachment, visibility_level
/// - Entry level: description, cash_location_id (if cash/bank), counterparty_id (if payable/receivable)
/// - Non-editable: account_id, account_name, category_tag, type, amounts
///
/// Clean Architecture: PRESENTATION LAYER
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Import journal_input providers for counterparty store and account mapping
import '../../../journal_input/presentation/providers/journal_input_providers.dart';
// Import account provider for account_code lookup
import 'package:myfinance_improved/app/providers/account_provider.dart';

import '../../domain/enums/template_constants.dart';
import '../../domain/usecases/update_template_usecase.dart';
import '../providers/template_provider.dart';
import '../widgets/edit_template/edit_template_widgets.dart';

/// Edit Template Bottom Sheet - Modal for editing template properties
class EditTemplateBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  final ValueNotifier<bool>? formValidityNotifier;

  const EditTemplateBottomSheet({
    super.key,
    required this.template,
    this.formValidityNotifier,
  });

  /// Shows the edit template modal
  static Future<bool?> show(
      BuildContext context, Map<String, dynamic> template) {
    final GlobalKey<_EditTemplateBottomSheetState> formKey = GlobalKey();
    final buttonStateNotifier = ValueNotifier<bool>(false);
    final formValidityNotifier = ValueNotifier<bool>(false);

    final templateName = template['name']?.toString() ?? 'Edit Template';

    return TossTextFieldKeyboardModal.show<bool>(
      context: context,
      title: 'Edit: $templateName',
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space3,
      ),
      content: EditTemplateBottomSheet(
        key: formKey,
        template: template,
        formValidityNotifier: formValidityNotifier,
      ),
      actionButtons: [
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: buttonStateNotifier,
            builder: (context, isSubmitting, _) {
              return TossSecondaryButton(
                text: 'Cancel',
                fullWidth: true,
                isEnabled: !isSubmitting,
                onPressed: isSubmitting ? null : () => context.pop(false),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: ValueListenableBuilder<bool>(
            valueListenable: buttonStateNotifier,
            builder: (context, isSubmitting, _) {
              return ValueListenableBuilder<bool>(
                valueListenable: formValidityNotifier,
                builder: (context, isFormValid, _) {
                  final isButtonEnabled = isFormValid && !isSubmitting;

                  return TossPrimaryButton(
                    text: isSubmitting ? 'Saving...' : 'Save Changes',
                    fullWidth: true,
                    isEnabled: isButtonEnabled,
                    onPressed: !isButtonEnabled
                        ? null
                        : () async {
                            final state = formKey.currentState;
                            if (state != null && !state._isSubmitting) {
                              buttonStateNotifier.value = true;
                              final success = await state._handleSubmit();
                              buttonStateNotifier.value = false;
                              if (success && context.mounted) {
                                context.pop(true);
                              }
                            }
                          },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  ConsumerState<EditTemplateBottomSheet> createState() =>
      _EditTemplateBottomSheetState();
}

class _EditTemplateBottomSheetState
    extends ConsumerState<EditTemplateBottomSheet> {
  // Template level controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _requiredAttachment;
  late String _permission;

  // Entry level state
  final Map<int, EntryEditState> _entryStates = {};

  bool _isSubmitting = false;
  String? _nameError;

  // Original values for change detection
  late final String _originalName;
  late final String _originalDescription;
  late final bool _originalRequiredAttachment;
  late final String _originalPermission;
  late final Map<int, EntryOriginalState> _originalEntryStates;

  @override
  void initState() {
    super.initState();
    _initializeFromTemplate();
  }

  void _initializeFromTemplate() {
    // Template level fields
    _nameController = TextEditingController(
      text: widget.template['name']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.template['template_description']?.toString() ?? '',
    );
    _requiredAttachment = widget.template['required_attachment'] == true;
    _permission = widget.template['permission']?.toString() ??
        TemplateConstants.commonPermissionUUID;

    // Store original values
    _originalName = widget.template['name']?.toString() ?? '';
    _originalDescription =
        widget.template['template_description']?.toString() ?? '';
    _originalRequiredAttachment =
        widget.template['required_attachment'] == true;
    _originalPermission = widget.template['permission']?.toString() ??
        TemplateConstants.commonPermissionUUID;
    _originalEntryStates = {};

    // Entry level fields
    final data = widget.template['data'] as List? ?? [];
    for (int i = 0; i < data.length; i++) {
      final entry = data[i] as Map<String, dynamic>;
      _entryStates[i] = EntryEditState.fromEntry(entry);
      _originalEntryStates[i] = EntryOriginalState.fromEntry(entry);
      _entryStates[i]!.descriptionController.addListener(_updateFormValidity);
    }

    _nameController.addListener(_validateName);
    _descriptionController.addListener(_updateFormValidity);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMissingCounterpartyData();
      _loadMissingAccountCodes();
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    widget.formValidityNotifier?.value = _isFormValid && _hasChanges;
  }

  bool get _hasChanges {
    if (_nameController.text.trim() != _originalName) return true;
    if (_descriptionController.text.trim() != _originalDescription) return true;
    if (_requiredAttachment != _originalRequiredAttachment) return true;
    if (_permission != _originalPermission) return true;

    for (final entry in _entryStates.entries) {
      final current = entry.value;
      final original = _originalEntryStates[entry.key];
      if (original == null) continue;

      if (current.descriptionController.text.trim() != original.description) {
        return true;
      }
      if (current.cashLocationId != original.cashLocationId) return true;
      if (current.counterpartyStoreId != original.counterpartyStoreId) {
        return true;
      }
      if (current.counterpartyCashLocationId !=
          original.counterpartyCashLocationId) return true;
    }

    return false;
  }

  Future<void> _loadMissingCounterpartyData() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) return;

    final entriesNeedingData = _entryStates.entries.where((e) {
      final state = e.value;
      return state.counterpartyId != null &&
          state.counterpartyId!.isNotEmpty &&
          state.counterpartyId != 'null' &&
          state.linkedCompanyId == null;
    }).toList();

    if (entriesNeedingData.isEmpty) return;

    try {
      final counterparties =
          await ref.read(journalCounterpartiesProvider(companyId).future);

      for (final entry in entriesNeedingData) {
        final state = entry.value;
        final counterparty = counterparties.firstWhere(
          (c) => c['counterparty_id'] == state.counterpartyId,
          orElse: () => <String, dynamic>{},
        );

        if (counterparty.isNotEmpty) {
          final linkedCompanyId = counterparty['linked_company_id']?.toString();
          final hasLinkedCompany = linkedCompanyId != null &&
              linkedCompanyId.isNotEmpty &&
              linkedCompanyId != 'null';

          state.linkedCompanyId = hasLinkedCompany ? linkedCompanyId : null;
          state.isCounterpartyInternal =
              counterparty['is_internal'] == true || hasLinkedCompany;
          state.counterpartyName =
              counterparty['name']?.toString() ?? state.counterpartyName;
        }
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading counterparty data: $e');
    }
  }

  Future<void> _loadMissingAccountCodes() async {
    final entriesNeedingAccountCode = _entryStates.entries.where((e) {
      final state = e.value;
      return state.accountId != null &&
          state.accountId!.isNotEmpty &&
          (state.accountCode == null || state.accountCode!.isEmpty);
    }).toList();

    if (entriesNeedingAccountCode.isEmpty) return;

    try {
      final accountsAsync = ref.read(currentAccountsProvider);
      final accounts = accountsAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <dynamic>[],
      );

      if (accounts.isEmpty) return;

      for (final entry in entriesNeedingAccountCode) {
        final state = entry.value;
        final account = accounts.firstWhere(
          (a) => a.id == state.accountId,
          orElse: () => null,
        );

        if (account != null && account.accountCode != null) {
          state.accountCode = account.accountCode.toString();
        }
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading account codes: $e');
    }
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Template name is required';
      } else {
        _nameError = null;
      }
    });
    _updateFormValidity();
  }

  bool get _isFormValid {
    if (_nameController.text.trim().isEmpty) return false;

    for (final entry in _entryStates.entries) {
      final state = entry.value;

      if (state.isCounterpartyInternal &&
          state.linkedCompanyId != null &&
          (state.categoryTag == 'payable' || state.categoryTag == 'receivable')) {
        if (state.counterpartyCashLocationId == null ||
            state.counterpartyCashLocationId!.isEmpty) {
          return false;
        }
        if (state.accountMapping == null) {
          return false;
        }
      }

      if (state.categoryTag == 'cash' || state.categoryTag == 'bank') {
        if (state.cashLocationId == null || state.cashLocationId!.isEmpty) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final state in _entryStates.values) {
      state.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final storeId = appState.storeChoosen;
    final canChangeToAdmin = ref.watch(canDeleteTemplatesProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template info section
              TemplateInfoSection(template: widget.template),

              const SizedBox(height: TossSpacing.space4),

              // Template level editable fields
              TemplateFieldsSection(
                nameController: _nameController,
                descriptionController: _descriptionController,
                nameError: _nameError,
                requiredAttachment: _requiredAttachment,
                permission: _permission,
                canChangeToAdmin: canChangeToAdmin,
                onRequiredAttachmentChanged: (value) {
                  setState(() => _requiredAttachment = value);
                  _updateFormValidity();
                },
                onPermissionChanged: (value) {
                  setState(() => _permission = value);
                  _updateFormValidity();
                },
              ),

              const SizedBox(height: TossSpacing.space4),

              // Entry level editable fields
              _buildEntryFieldsSection(storeId),
            ],
          ),
        ),

        // Loading overlay
        if (_isSubmitting) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildEntryFieldsSection(String storeId) {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.list_alt, color: TossColors.gray700, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Entry Details',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        ...data.asMap().entries.map((entry) {
          final entryState = _entryStates[entry.key];
          if (entryState == null) return const SizedBox.shrink();

          return EntryCard(
            index: entry.key,
            entry: entry.value as Map<String, dynamic>,
            entryState: entryState,
            storeId: storeId,
            onStateChanged: () {
              setState(() {});
              _updateFormValidity();
            },
            onCheckAccountMapping: _checkAccountMapping,
            onNavigateToAccountSettings: _navigateToAccountSettings,
          );
        }),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Saving changes...',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAccountSettings(String counterpartyId, String counterpartyName) {
    context.pop();
    context.pushNamed(
      'debtAccountSettings',
      pathParameters: {
        'counterpartyId': counterpartyId,
        'name': counterpartyName,
      },
    );
  }

  Future<void> _checkAccountMapping(int index, EntryEditState entryState) async {
    if (entryState.accountId == null ||
        entryState.counterpartyId == null ||
        !entryState.isCounterpartyInternal) {
      return;
    }

    try {
      final appState = ref.read(appStateProvider);

      final mapping = await ref
          .read(journalActionsNotifierProvider.notifier)
          .checkAccountMapping(
            companyId: appState.companyChoosen,
            counterpartyId: entryState.counterpartyId!,
            accountId: entryState.accountId!,
          );

      if (mounted) {
        setState(() {
          entryState.accountMapping = mapping;
          if (mapping == null) {
            entryState.mappingError =
                'Account mapping required for internal transactions';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          entryState.mappingError = 'Error checking account mapping';
        });
      }
    }
  }

  Future<bool> _handleSubmit() async {
    if (_isSubmitting) return false;

    if (!_isFormValid) {
      _validateName();
      return false;
    }

    try {
      setState(() => _isSubmitting = true);

      final updatedData = _buildUpdatedData();

      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final command = UpdateTemplateCommand(
        templateId: widget.template['template_id']?.toString() ?? '',
        name: _nameController.text.trim(),
        templateDescription: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        requiredAttachment: _requiredAttachment,
        permission: _permission,
        data: updatedData,
        updatedBy: user.id,
      );

      final success =
          await ref.read(templateNotifierProvider.notifier).updateTemplate(command);

      if (mounted) {
        setState(() => _isSubmitting = false);

        if (success) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Template Updated!',
              message: 'Your changes have been saved.',
              primaryButtonText: 'Done',
              onPrimaryPressed: () => context.pop(),
            ),
          );
          return true;
        } else {
          final errorMessage =
              ref.read(templateNotifierProvider).errorMessage ??
                  'Failed to update template';
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Update Failed',
              message: errorMessage,
              primaryButtonText: 'OK',
              onPrimaryPressed: () => context.pop(),
            ),
          );
          return false;
        }
      }

      return false;
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);

        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to update template: ${e.toString()}',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
      return false;
    }
  }

  List<Map<String, dynamic>> _buildUpdatedData() {
    final originalData = widget.template['data'] as List? ?? [];
    final updatedData = <Map<String, dynamic>>[];

    for (int i = 0; i < originalData.length; i++) {
      final original =
          Map<String, dynamic>.from(originalData[i] as Map<String, dynamic>);
      final entryState = _entryStates[i];

      if (entryState != null) {
        original['description'] =
            entryState.descriptionController.text.trim().isEmpty
                ? null
                : entryState.descriptionController.text.trim();

        original['cash_location_id'] = entryState.cashLocationId;

        if (entryState.accountCode != null &&
            entryState.accountCode!.isNotEmpty) {
          original['account_code'] = entryState.accountCode;
        }

        original['counterparty_id'] = entryState.counterpartyId;
        original['counterparty_name'] = entryState.counterpartyName;
        original['linked_company_id'] = entryState.linkedCompanyId;

        if (entryState.isCounterpartyInternal &&
            entryState.linkedCompanyId != null) {
          original['counterparty_store_id'] = entryState.counterpartyStoreId;
          original['counterparty_store_name'] = entryState.counterpartyStoreName;
          original['counterparty_cash_location_id'] =
              entryState.counterpartyCashLocationId;
          original['counterparty_cash_location_name'] =
              entryState.counterpartyCashLocationName;
        } else {
          original['counterparty_store_id'] = null;
          original['counterparty_store_name'] = null;
          original['counterparty_cash_location_id'] = null;
          original['counterparty_cash_location_name'] = null;
        }
      }

      updatedData.add(original);
    }

    return updatedData;
  }
}
