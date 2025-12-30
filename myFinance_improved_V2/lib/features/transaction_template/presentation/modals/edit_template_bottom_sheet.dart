/// Edit Template Modal - Modify existing transaction templates
///
/// Purpose: Allows authorized users to edit template properties and entry configurations.
/// - Template level: name, description, required_attachment, visibility_level
/// - Entry level: description, cash_location_id (if cash/bank), counterparty_id (if payable/receivable)
/// - Non-editable: account_id, account_name, category_tag, type, amounts
///
/// Clean Architecture: PRESENTATION LAYER
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/app/providers/cash_location_provider.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_textfield_keyboard_modal.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

// Import journal_input providers for counterparty store and account mapping
import '../../../journal_input/presentation/providers/journal_input_providers.dart';
// Import account provider for account_code lookup
import 'package:myfinance_improved/app/providers/account_provider.dart';

import '../../domain/enums/template_constants.dart';
import '../../domain/usecases/update_template_usecase.dart';
import '../providers/template_provider.dart';

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
  static Future<bool?> show(BuildContext context, Map<String, dynamic> template) {
    final GlobalKey<_EditTemplateBottomSheetState> formKey = GlobalKey();
    final buttonStateNotifier = ValueNotifier<bool>(false);
    final formValidityNotifier = ValueNotifier<bool>(false); // Start as false until form is initialized

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
                    onPressed: !isButtonEnabled ? null : () async {
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
  ConsumerState<EditTemplateBottomSheet> createState() => _EditTemplateBottomSheetState();
}

class _EditTemplateBottomSheetState extends ConsumerState<EditTemplateBottomSheet> {
  // Template level controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _requiredAttachment;
  late String _permission; // Admin or General permission UUID

  // Entry level state - map of entry index to editable fields
  final Map<int, _EntryEditState> _entryStates = {};

  bool _isSubmitting = false;
  bool _isLoadingCounterpartyData = false;
  String? _nameError;

  // Original values for change detection
  late final String _originalName;
  late final String _originalDescription;
  late final bool _originalRequiredAttachment;
  late final String _originalPermission;
  late final Map<int, _EntryOriginalState> _originalEntryStates;

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
    _permission = widget.template['permission']?.toString() ?? TemplateConstants.commonPermissionUUID;

    // Store original values for change detection
    _originalName = widget.template['name']?.toString() ?? '';
    _originalDescription = widget.template['template_description']?.toString() ?? '';
    _originalRequiredAttachment = widget.template['required_attachment'] == true;
    _originalPermission = widget.template['permission']?.toString() ?? TemplateConstants.commonPermissionUUID;
    _originalEntryStates = {};

    // Entry level fields
    final data = widget.template['data'] as List? ?? [];
    for (int i = 0; i < data.length; i++) {
      final entry = data[i] as Map<String, dynamic>;
      _entryStates[i] = _EntryEditState.fromEntry(entry);
      // Store original entry state for change detection
      _originalEntryStates[i] = _EntryOriginalState.fromEntry(entry);
      // Add listener for entry description changes
      _entryStates[i]!.descriptionController.addListener(_updateFormValidity);
    }

    // Add name validation listener
    _nameController.addListener(_validateName);

    // Add description listener for form validity
    _descriptionController.addListener(_updateFormValidity);

    // Load counterparty details for entries that have counterparty but missing linked_company_id
    // Also load missing account_codes for legacy templates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMissingCounterpartyData();
      _loadMissingAccountCodes();
      _updateFormValidity();
    });
  }

  /// Update form validity notifier when state changes
  /// Button is enabled only when: form is valid AND there are changes
  void _updateFormValidity() {
    widget.formValidityNotifier?.value = _isFormValid && _hasChanges;
  }

  /// Check if any value has changed from original
  bool get _hasChanges {
    // Check template level changes
    if (_nameController.text.trim() != _originalName) return true;
    if (_descriptionController.text.trim() != _originalDescription) return true;
    if (_requiredAttachment != _originalRequiredAttachment) return true;
    if (_permission != _originalPermission) return true;

    // Check entry level changes
    for (final entry in _entryStates.entries) {
      final current = entry.value;
      final original = _originalEntryStates[entry.key];
      if (original == null) continue;

      if (current.descriptionController.text.trim() != original.description) return true;
      if (current.cashLocationId != original.cashLocationId) return true;
      if (current.counterpartyStoreId != original.counterpartyStoreId) return true;
      if (current.counterpartyCashLocationId != original.counterpartyCashLocationId) return true;
    }

    return false;
  }

  /// Load counterparty data from database for entries missing linked_company_id
  Future<void> _loadMissingCounterpartyData() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) return;

    // Find entries with counterparty but missing linked_company_id
    final entriesNeedingData = _entryStates.entries.where((e) {
      final state = e.value;
      return state.counterpartyId != null &&
             state.counterpartyId!.isNotEmpty &&
             state.counterpartyId != 'null' &&
             state.linkedCompanyId == null;
    }).toList();

    if (entriesNeedingData.isEmpty) return;

    setState(() {
      _isLoadingCounterpartyData = true;
    });

    try {
      // Fetch all counterparties for the company
      final counterparties = await ref.read(journalCounterpartiesProvider(companyId).future);

      // Update entry states with counterparty data
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
          state.isCounterpartyInternal = counterparty['is_internal'] == true || hasLinkedCompany;
          state.counterpartyName = counterparty['name']?.toString() ?? state.counterpartyName;
        }
      }

      if (mounted) {
        setState(() {
          _isLoadingCounterpartyData = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading counterparty data: $e');
      if (mounted) {
        setState(() {
          _isLoadingCounterpartyData = false;
        });
      }
    }
  }

  /// Load account_code for entries missing it (legacy templates)
  /// This ensures expense account detection works for older templates
  Future<void> _loadMissingAccountCodes() async {
    // Find entries with accountId but missing accountCode
    final entriesNeedingAccountCode = _entryStates.entries.where((e) {
      final state = e.value;
      return state.accountId != null &&
             state.accountId!.isNotEmpty &&
             (state.accountCode == null || state.accountCode!.isEmpty);
    }).toList();

    if (entriesNeedingAccountCode.isEmpty) return;

    try {
      // Get all accounts for lookup
      final accountsAsync = ref.read(currentAccountsProvider);
      final accounts = accountsAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <dynamic>[],
      );

      if (accounts.isEmpty) return;

      // Update entry states with account codes
      for (final entry in entriesNeedingAccountCode) {
        final state = entry.value;
        final account = accounts.firstWhere(
          (a) => a.id == state.accountId,
          orElse: () => null,
        );

        if (account != null && account.accountCode != null) {
          state.accountCode = account.accountCode as String?;
          debugPrint('📝 Loaded account_code ${account.accountCode} for account ${state.accountId}');
        }
      }

      if (mounted) {
        setState(() {});
      }
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
    // Check template name
    if (_nameController.text.trim().isEmpty) return false;

    // Check all entries have required data
    for (final entry in _entryStates.entries) {
      final state = entry.value;

      // For internal counterparty with payable/receivable, cash location AND account mapping are required
      if (state.isCounterpartyInternal &&
          state.linkedCompanyId != null &&
          (state.categoryTag == 'payable' || state.categoryTag == 'receivable')) {
        // Counterparty cash location is required for internal transfers
        if (state.counterpartyCashLocationId == null ||
            state.counterpartyCashLocationId!.isEmpty) {
          return false;
        }
        // ✅ Account mapping MUST exist for internal counterparty with payable/receivable
        if (state.accountMapping == null) {
          return false; // No mapping found - block save
        }
      }

      // For cash/bank accounts, cash location is required
      if (state.categoryTag == 'cash' || state.categoryTag == 'bank') {
        if (state.cashLocationId == null || state.cashLocationId!.isEmpty) {
          return false;
        }
      }
    }

    return true;
  }

  /// Get list of validation errors for display
  List<String> get _validationErrors {
    final errors = <String>[];

    if (_nameController.text.trim().isEmpty) {
      errors.add('Template name is required');
    }

    for (final entry in _entryStates.entries) {
      final state = entry.value;
      final accountName = state.descriptionController.text.isNotEmpty
          ? state.descriptionController.text
          : 'Entry ${entry.key + 1}';

      if (state.isCounterpartyInternal &&
          state.linkedCompanyId != null &&
          (state.categoryTag == 'payable' || state.categoryTag == 'receivable')) {
        if (state.counterpartyCashLocationId == null ||
            state.counterpartyCashLocationId!.isEmpty) {
          errors.add('Cash location required for internal counterparty "${state.counterpartyName ?? accountName}"');
        }
        // ✅ Account mapping error
        if (state.accountMapping == null) {
          errors.add('Account mapping required for internal counterparty "${state.counterpartyName ?? accountName}"');
        }
      }

      if (state.categoryTag == 'cash' || state.categoryTag == 'bank') {
        if (state.cashLocationId == null || state.cashLocationId!.isEmpty) {
          errors.add('Cash location required for $accountName');
        }
      }
    }

    return errors;
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template info section
              _buildTemplateInfoSection(),

              const SizedBox(height: TossSpacing.space4),

              // Template level editable fields
              _buildTemplateFieldsSection(),

              const SizedBox(height: TossSpacing.space4),

              // Entry level editable fields
              _buildEntryFieldsSection(),
            ],
          ),
        ),

        // Loading overlay
        if (_isSubmitting)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
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
          ),
      ],
    );
  }

  /// Template info card showing non-editable info
  Widget _buildTemplateInfoSection() {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    final debit = data.firstWhere(
      (e) => e['type'] == 'debit',
      orElse: () => <String, dynamic>{},
    );
    final credit = data.firstWhere(
      (e) => e['type'] == 'credit',
      orElse: () => <String, dynamic>{},
    );

    final debitAccount = debit['account_name']?.toString() ?? '';
    final creditAccount = credit['account_name']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: const Icon(
              Icons.edit_note,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editing Template',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                if (debitAccount.isNotEmpty && creditAccount.isNotEmpty)
                  Text(
                    '$debitAccount → $creditAccount',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Template level editable fields section
  Widget _buildTemplateFieldsSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: TossColors.primary.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              const Icon(
                Icons.settings,
                color: TossColors.primary,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Template Settings',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Template name
          TossTextField(
            controller: _nameController,
            label: 'Template Name',
            isRequired: true,
            hintText: 'Enter template name',
          ),
          if (_nameError != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              _nameError!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.error,
              ),
            ),
          ],

          const SizedBox(height: TossSpacing.space3),

          // Template description
          TossTextField(
            controller: _descriptionController,
            label: 'Description',
            hintText: 'Add a description (optional)',
            maxLines: 2,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Required attachment toggle
          _buildToggleRow(
            label: 'Require Attachment',
            description: 'Require receipt or document when using this template',
            value: _requiredAttachment,
            onChanged: (value) {
              setState(() {
                _requiredAttachment = value;
              });
              _updateFormValidity();
            },
          ),

          const SizedBox(height: TossSpacing.space3),

          // Permission selector (Admin/General)
          _buildPermissionSelector(),
        ],
      ),
    );
  }

  /// Toggle row widget
  Widget _buildToggleRow({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: TossColors.primary,
        ),
      ],
    );
  }

  /// Permission selector (Admin/General)
  Widget _buildPermissionSelector() {
    final isAdmin = _permission == TemplateConstants.adminPermissionUUID;
    // Only show if user has admin permission
    final canChangeToAdmin = ref.watch(canDeleteTemplatesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Access Level',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Tooltip(
              message: 'Admin: Only visible in Admin tab\nGeneral: Visible in General tab',
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          children: [
            _buildPermissionChip(
              TemplateConstants.commonPermissionUUID,
              'General',
              Icons.people_outline,
            ),
            if (canChangeToAdmin)
              _buildPermissionChip(
                TemplateConstants.adminPermissionUUID,
                'Admin',
                Icons.admin_panel_settings_outlined,
              ),
          ],
        ),
        if (!canChangeToAdmin && isAdmin)
          Padding(
            padding: const EdgeInsets.only(top: TossSpacing.space2),
            child: Text(
              'Only admins can change access level',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPermissionChip(String value, String label, IconData icon) {
    final isSelected = _permission == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _permission = value;
        });
        _updateFormValidity();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : TossColors.gray700,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              label,
              style: TossTextStyles.label.copyWith(
                color: isSelected ? Colors.white : TossColors.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Entry level editable fields section
  Widget _buildEntryFieldsSection() {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const Icon(
              Icons.list_alt,
              color: TossColors.gray700,
              size: 20,
            ),
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

        // Entry cards
        ...data.asMap().entries.map((entry) {
          return _buildEntryCard(entry.key, entry.value as Map<String, dynamic>);
        }),
      ],
    );
  }

  /// Individual entry card
  Widget _buildEntryCard(int index, Map<String, dynamic> entry) {
    final type = entry['type']?.toString() ?? '';
    final categoryTag = entry['category_tag']?.toString().toLowerCase() ?? '';
    final accountName = entry['account_name']?.toString() ?? 'Unknown';
    final entryState = _entryStates[index];

    if (entryState == null) return const SizedBox.shrink();

    final showCashLocationSelector = categoryTag == 'cash' || categoryTag == 'bank';
    final showCounterpartySelector = categoryTag == 'payable' || categoryTag == 'receivable';

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray300),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entry header (non-editable)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: type == 'debit'
                      ? TossColors.primary.withOpacity(0.1)
                      : TossColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  type.toUpperCase(),
                  style: TossTextStyles.caption.copyWith(
                    color: type == 'debit' ? TossColors.primary : TossColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  accountName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Entry description (editable)
          TossTextField(
            controller: entryState.descriptionController,
            label: 'Entry Note',
            hintText: 'Add a note for this entry (optional)',
          ),

          // Cash location selector (conditional)
          if (showCashLocationSelector) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildEntryCashLocationSelector(index, entryState),
          ],

          // Counterparty selector placeholder (conditional)
          if (showCounterpartySelector) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildEntryCounterpartySelector(index, entryState),
          ],
        ],
      ),
    );
  }

  /// Cash location selector for entry
  Widget _buildEntryCashLocationSelector(int index, _EntryEditState entryState) {
    final appState = ref.watch(appStateProvider);
    final storeId = appState.storeChoosen;
    final cashLocationsAsync = ref.watch(companyCashLocationsProvider);

    return TossDropdown<String>(
      label: 'Cash Location',
      hint: 'Select cash location',
      value: entryState.cashLocationId,
      isLoading: cashLocationsAsync.isLoading,
      items: cashLocationsAsync.maybeWhen(
        data: (locations) => locations
            .where((l) => storeId.isEmpty || l.storeId == storeId || l.isCompanyWide)
            .map((l) => TossDropdownItem(
                  value: l.id,
                  label: l.name,
                  subtitle: l.type,
                ))
            .toList(),
        orElse: () => [],
      ),
      onChanged: (cashLocationId) {
        setState(() {
          entryState.cashLocationId = cashLocationId;
        });
        _updateFormValidity();
      },
    );
  }

  /// Counterparty display and cash location selector for entry
  /// NOTE: Counterparty itself is NOT editable (internal/external affects data structure)
  /// Only Counterparty Store and Cash Location can be changed for internal counterparties
  Widget _buildEntryCounterpartySelector(int index, _EntryEditState entryState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counterparty display (read-only)
        Text(
          'Counterparty',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray300),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            color: TossColors.gray50,
          ),
          child: Row(
            children: [
              Icon(
                entryState.isCounterpartyInternal
                    ? Icons.business
                    : Icons.person_outline,
                color: TossColors.gray600,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entryState.counterpartyName ?? 'Unknown',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (entryState.isCounterpartyInternal)
                      Text(
                        'Internal',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.lock_outline,
                color: TossColors.gray400,
                size: 16,
              ),
            ],
          ),
        ),

        // Counterparty Store selector (only for INTERNAL counterparty)
        if (entryState.counterpartyId != null &&
            entryState.isCounterpartyInternal &&
            entryState.linkedCompanyId != null) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartyStoreSelector(index, entryState),
        ],

        // Counterparty Cash Location selector (only for INTERNAL counterparty)
        if (entryState.counterpartyId != null &&
            entryState.isCounterpartyInternal &&
            entryState.linkedCompanyId != null) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartyCashLocationSelector(index, entryState),
        ],

        // Account Mapping Status (for internal + payable/receivable)
        if (entryState.isCounterpartyInternal &&
            (entryState.categoryTag == 'payable' || entryState.categoryTag == 'receivable')) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildAccountMappingStatus(index, entryState),
        ],
      ],
    );
  }

  /// Counterparty Store selector for entry (only for internal counterparty)
  Widget _buildCounterpartyStoreSelector(int index, _EntryEditState entryState) {
    final storesAsync = ref.watch(journalCounterpartyStoresProvider(entryState.linkedCompanyId));

    return storesAsync.when(
      data: (stores) {
        if (stores.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: TossColors.gray500),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'No stores configured for this counterparty',
                  style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Counterparty Store',
              style: TossTextStyles.label.copyWith(color: TossColors.gray700),
            ),
            const SizedBox(height: TossSpacing.space2),
            GestureDetector(
              onTap: () => _showStoreSelectionBottomSheet(context, stores, index, entryState),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  border: Border.all(color: TossColors.gray300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      size: 20,
                      color: entryState.counterpartyStoreId != null
                          ? TossColors.primary
                          : TossColors.gray400,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        entryState.counterpartyStoreName ?? 'Select store (optional)',
                        style: TossTextStyles.body.copyWith(
                          color: entryState.counterpartyStoreId != null
                              ? TossColors.gray900
                              : TossColors.gray400,
                          fontWeight: entryState.counterpartyStoreId != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: entryState.counterpartyStoreId != null
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
            style: TossTextStyles.label.copyWith(color: TossColors.gray700),
          ),
          const SizedBox(height: TossSpacing.space2),
          const Center(child: TossLoadingView()),
        ],
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          'Error loading stores',
          style: TossTextStyles.bodySmall.copyWith(color: TossColors.error),
        ),
      ),
    );
  }

  /// Show store selection bottom sheet
  void _showStoreSelectionBottomSheet(
    BuildContext context,
    List<Map<String, dynamic>> stores,
    int index,
    _EntryEditState entryState,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            // Clear selection option
            ListTile(
              leading: const Icon(Icons.clear, color: TossColors.gray500),
              title: Text('No store selected', style: TossTextStyles.body.copyWith(color: TossColors.gray600)),
              onTap: () {
                setState(() {
                  entryState.counterpartyStoreId = null;
                  entryState.counterpartyStoreName = null;
                  entryState.counterpartyCashLocationId = null;
                  entryState.counterpartyCashLocationName = null;
                });
                _updateFormValidity();
                Navigator.pop(ctx);
              },
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                itemCount: stores.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: TossColors.gray100),
                itemBuilder: (_, i) {
                  final store = stores[i];
                  final storeId = store['store_id'] as String?;
                  final storeName = store['store_name'] as String? ?? 'Unknown Store';
                  final isSelected = entryState.counterpartyStoreId == storeId;

                  return ListTile(
                    leading: Icon(
                      Icons.store,
                      color: isSelected ? TossColors.primary : TossColors.gray500,
                    ),
                    title: Text(
                      storeName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? TossColors.primary : TossColors.gray900,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: TossColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        entryState.counterpartyStoreId = storeId;
                        entryState.counterpartyStoreName = storeName;
                        // Clear cash location when store changes
                        entryState.counterpartyCashLocationId = null;
                        entryState.counterpartyCashLocationName = null;
                      });
                      _updateFormValidity();
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  /// Counterparty Cash Location selector for entry (only for internal counterparty)
  Widget _buildCounterpartyCashLocationSelector(int index, _EntryEditState entryState) {
    // Use counterparty's linked company and store for cash location lookup
    if (entryState.linkedCompanyId == null) {
      return const SizedBox.shrink();
    }

    final counterpartyCashLocationsAsync = ref.watch(
      counterpartyCompanyCashLocationsProvider(entryState.linkedCompanyId!),
    );

    return TossDropdown<String>(
      label: 'Counterparty Cash Location *',
      hint: 'Select counterparty cash location',
      value: entryState.counterpartyCashLocationId,
      isLoading: counterpartyCashLocationsAsync.isLoading,
      items: counterpartyCashLocationsAsync.maybeWhen(
        data: (locations) => locations
            .where((l) =>
                entryState.counterpartyStoreId == null ||
                l.storeId == entryState.counterpartyStoreId ||
                l.isCompanyWide)
            .map((l) => TossDropdownItem(
                  value: l.id,
                  label: l.name,
                  subtitle: l.type,
                ))
            .toList(),
        orElse: () => [],
      ),
      onChanged: (cashLocationId) {
        setState(() {
          entryState.counterpartyCashLocationId = cashLocationId;
        });
        _updateFormValidity();
      },
    );
  }

  /// Account Mapping status display and check
  Widget _buildAccountMappingStatus(int index, _EntryEditState entryState) {
    // Check account mapping on first build
    if (entryState.accountMapping == null && entryState.mappingError == null) {
      _checkAccountMapping(index, entryState);
    }

    if (entryState.accountMapping != null) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.success.withOpacity(0.3)),
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
      );
    }

    if (entryState.mappingError != null) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: TossColors.error, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                entryState.mappingError!,
                style: TossTextStyles.bodySmall.copyWith(color: TossColors.error),
              ),
            ),
            // "Set Up" button to navigate to Account Settings
            if (entryState.counterpartyId != null && entryState.counterpartyName != null)
              GestureDetector(
                onTap: () => _navigateToAccountSettings(
                  entryState.counterpartyId!,
                  entryState.counterpartyName!,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    'Set Up',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Loading state
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Checking account mapping...',
            style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
          ),
        ],
      ),
    );
  }

  /// Navigate to Account Settings page for the counterparty
  void _navigateToAccountSettings(String counterpartyId, String counterpartyName) {
    // Close the current modal first
    context.pop();
    // Navigate to debt account settings page
    context.pushNamed(
      'debtAccountSettings',
      pathParameters: {
        'counterpartyId': counterpartyId,
        'name': counterpartyName,
      },
    );
  }

  /// Check account mapping for internal counterparty
  Future<void> _checkAccountMapping(int index, _EntryEditState entryState) async {
    if (entryState.accountId == null ||
        entryState.counterpartyId == null ||
        !entryState.isCounterpartyInternal) {
      return;
    }

    try {
      final appState = ref.read(appStateProvider);

      final mapping = await ref.read(journalActionsNotifierProvider.notifier).checkAccountMapping(
        companyId: appState.companyChoosen,
        counterpartyId: entryState.counterpartyId!,
        accountId: entryState.accountId!,
      );

      if (mounted) {
        setState(() {
          entryState.accountMapping = mapping;
          if (mapping == null) {
            entryState.mappingError = 'Account mapping required for internal transactions';
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

  /// Handle form submission
  Future<bool> _handleSubmit() async {
    if (_isSubmitting) return false;

    // Validate
    if (!_isFormValid) {
      _validateName();
      return false;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });

      // Build updated data array
      final updatedData = _buildUpdatedData();

      // Get current user
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create update command
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

      // Execute update
      final success = await ref.read(templateNotifierProvider.notifier).updateTemplate(command);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

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
          final errorMessage = ref.read(templateNotifierProvider).errorMessage ?? 'Failed to update template';
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
        setState(() {
          _isSubmitting = false;
        });

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

  /// Build updated data array from entry states
  List<Map<String, dynamic>> _buildUpdatedData() {
    final originalData = widget.template['data'] as List? ?? [];
    final updatedData = <Map<String, dynamic>>[];

    for (int i = 0; i < originalData.length; i++) {
      final original = Map<String, dynamic>.from(originalData[i] as Map<String, dynamic>);
      final entryState = _entryStates[i];

      if (entryState != null) {
        // Update editable fields
        original['description'] = entryState.descriptionController.text.trim().isEmpty
            ? null
            : entryState.descriptionController.text.trim();

        // Update cash location
        original['cash_location_id'] = entryState.cashLocationId;

        // Update account_code (preserve existing or use from entryState)
        // This ensures account_code is maintained for expense account detection
        if (entryState.accountCode != null && entryState.accountCode!.isNotEmpty) {
          original['account_code'] = entryState.accountCode;
        }

        // Update counterparty fields
        original['counterparty_id'] = entryState.counterpartyId;
        original['counterparty_name'] = entryState.counterpartyName;
        original['linked_company_id'] = entryState.linkedCompanyId;

        // Only save counterparty store and cash location for internal counterparties
        if (entryState.isCounterpartyInternal && entryState.linkedCompanyId != null) {
          original['counterparty_store_id'] = entryState.counterpartyStoreId;
          original['counterparty_store_name'] = entryState.counterpartyStoreName;
          original['counterparty_cash_location_id'] = entryState.counterpartyCashLocationId;
          original['counterparty_cash_location_name'] = entryState.counterpartyCashLocationName;
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

/// Entry edit state helper class
class _EntryEditState {
  final TextEditingController descriptionController;
  String? cashLocationId;
  String? counterpartyId;
  String? counterpartyName;
  bool isCounterpartyInternal;
  String? linkedCompanyId; // For internal counterparty's company
  String? counterpartyStoreId; // Counterparty's selected store
  String? counterpartyStoreName;
  String? counterpartyCashLocationId;
  String? counterpartyCashLocationName;
  String? categoryTag; // To check if payable/receivable
  String? accountId; // For account mapping check
  String? accountCode; // Account code for expense detection (5000-9999)
  Map<String, dynamic>? accountMapping; // Account mapping result
  String? mappingError; // Account mapping error

  _EntryEditState({
    required this.descriptionController,
    this.cashLocationId,
    this.counterpartyId,
    this.counterpartyName,
    this.isCounterpartyInternal = false,
    this.linkedCompanyId,
    this.counterpartyStoreId,
    this.counterpartyStoreName,
    this.counterpartyCashLocationId,
    this.counterpartyCashLocationName,
    this.categoryTag,
    this.accountId,
    this.accountCode,
    this.accountMapping,
    this.mappingError,
  });

  factory _EntryEditState.fromEntry(Map<String, dynamic> entry) {
    // Check if counterparty is internal by looking for linked_company_id
    final linkedCompanyIdRaw = entry['linked_company_id'];
    final linkedCompanyId = linkedCompanyIdRaw?.toString();
    final hasLinkedCompany = linkedCompanyId != null &&
                              linkedCompanyId.isNotEmpty &&
                              linkedCompanyId != 'null';

    // Get counterparty store info
    final counterpartyStoreIdRaw = entry['counterparty_store_id'];
    final counterpartyStoreId = counterpartyStoreIdRaw?.toString();
    final hasCounterpartyStore = counterpartyStoreId != null &&
                                  counterpartyStoreId.isNotEmpty &&
                                  counterpartyStoreId != 'null';

    return _EntryEditState(
      descriptionController: TextEditingController(
        text: entry['description']?.toString() ?? '',
      ),
      cashLocationId: entry['cash_location_id']?.toString(),
      counterpartyId: entry['counterparty_id']?.toString(),
      counterpartyName: entry['counterparty_name']?.toString(),
      isCounterpartyInternal: hasLinkedCompany,
      linkedCompanyId: hasLinkedCompany ? linkedCompanyId : null,
      counterpartyStoreId: hasCounterpartyStore ? counterpartyStoreId : null,
      counterpartyStoreName: entry['counterparty_store_name']?.toString(),
      counterpartyCashLocationId: entry['counterparty_cash_location_id']?.toString(),
      counterpartyCashLocationName: entry['counterparty_cash_location_name']?.toString(),
      categoryTag: entry['category_tag']?.toString(),
      accountId: entry['account_id']?.toString(),
      accountCode: entry['account_code']?.toString(), // For expense detection
    );
  }

  void dispose() {
    descriptionController.dispose();
  }
}

/// Original entry state for change detection (immutable snapshot)
class _EntryOriginalState {
  final String description;
  final String? cashLocationId;
  final String? counterpartyStoreId;
  final String? counterpartyCashLocationId;

  const _EntryOriginalState({
    required this.description,
    this.cashLocationId,
    this.counterpartyStoreId,
    this.counterpartyCashLocationId,
  });

  factory _EntryOriginalState.fromEntry(Map<String, dynamic> entry) {
    return _EntryOriginalState(
      description: entry['description']?.toString() ?? '',
      cashLocationId: entry['cash_location_id']?.toString(),
      counterpartyStoreId: entry['counterparty_store_id']?.toString(),
      counterpartyCashLocationId: entry['counterparty_cash_location_id']?.toString(),
    );
  }
}
