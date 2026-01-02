import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/account_mapping.dart';
import '../../providers/account_mapping_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Account Mapping Form Sheet
///
/// Bottom sheet for creating/editing account mappings.
class AccountMappingFormSheet extends ConsumerStatefulWidget {
  final String counterpartyId;
  final String counterpartyName;
  final AccountMapping? accountMapping;

  const AccountMappingFormSheet({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
    this.accountMapping,
  });

  @override
  ConsumerState<AccountMappingFormSheet> createState() =>
      _AccountMappingFormSheetState();
}

class _AccountMappingFormSheetState
    extends ConsumerState<AccountMappingFormSheet> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedMyAccountId;
  String? _selectedLinkedAccountId;
  String _selectedDirection = 'receivable';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.accountMapping != null) {
      _selectedMyAccountId = widget.accountMapping!.myAccountId;
      _selectedLinkedAccountId = widget.accountMapping!.linkedAccountId;
      _selectedDirection = widget.accountMapping!.direction;
    }
  }

  Future<void> _saveMapping() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMyAccountId == null || _selectedLinkedAccountId == null) {
      _showError('Please select both accounts');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = ref.read(appStateProvider);
      final myCompanyId = appState.companyChoosen;

      if (myCompanyId.isEmpty) {
        throw Exception('No company selected');
      }

      await ref.read(
        createAccountMappingProvider(CreateAccountMappingParams(
          myCompanyId: myCompanyId,
          myAccountId: _selectedMyAccountId!,
          counterpartyId: widget.counterpartyId,
          linkedAccountId: _selectedLinkedAccountId!,
          direction: _selectedDirection,
          createdBy: appState.user['user_id'] as String?,
        )).future,
      );

      if (mounted) {
        context.pop();
        _showSuccess('Account mapping created successfully');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to create mapping: ${e.toString()}');
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => TossDialog.error(
        title: 'Error',
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () => context.pop(),
      ),
    );
  }

  void _showSuccess(String message) {
    TossToast.success(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final myCompanyId = appState.companyChoosen;

    final availableAccountsAsync =
        ref.watch(availableAccountsProvider(myCompanyId));

    // Get linked company info
    final linkedCompanyInfoAsync =
        ref.watch(linkedCompanyInfoProvider(widget.counterpartyId));

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.accountMapping == null
                          ? 'New Account Mapping'
                          : 'Edit Account Mapping',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.counterpartyName,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Form Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Direction selector
                    Text(
                      'Direction',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDirectionOption('receivable', 'Receivable'),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: _buildDirectionOption('payable', 'Payable'),
                        ),
                      ],
                    ),

                    const SizedBox(height: TossSpacing.space4),

                    // My Account selector
                    availableAccountsAsync.when(
                      data: (accounts) => TossDropdown<String>(
                        label: 'My Account',
                        value: _selectedMyAccountId,
                        hint: 'Select your account',
                        items: accounts.map((account) {
                          return TossDropdownItem<String>(
                            value: account['account_id'] as String,
                            label: account['account_name'] as String,
                            subtitle: account['account_code'] != null
                                ? '${account['account_code']} - ${account['account_type']}'
                                : account['account_type'] as String?,
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedMyAccountId = value),
                      ),
                      loading: () => const TossDropdown<String>(
                        label: 'My Account',
                        items: [],
                        isLoading: true,
                        hint: 'Loading accounts...',
                      ),
                      error: (error, _) => TossDropdown<String>(
                        label: 'My Account',
                        items: const [],
                        errorText: 'Failed to load accounts',
                        hint: 'Unable to load',
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space4),

                    // Linked Account selector (uses same shared accounts)
                    linkedCompanyInfoAsync.when(
                      data: (linkedCompanyInfo) {
                        if (linkedCompanyInfo == null ||
                            linkedCompanyInfo['linked_company_id'] == null) {
                          return _buildNoLinkedCompanyMessage();
                        }

                        // Use the same shared accounts from availableAccountsAsync
                        return availableAccountsAsync.when(
                          data: (accounts) => TossDropdown<String>(
                            label: 'Their Account',
                            value: _selectedLinkedAccountId,
                            hint: 'Select their account',
                            items: accounts.map((account) {
                              return TossDropdownItem<String>(
                                value: account['account_id'] as String,
                                label: account['account_name'] as String,
                                subtitle: account['account_code'] != null
                                    ? '${account['account_code']} - ${account['account_type']}'
                                    : account['account_type'] as String?,
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedLinkedAccountId = value),
                          ),
                          loading: () => const TossDropdown<String>(
                            label: 'Their Account',
                            items: [],
                            isLoading: true,
                            hint: 'Loading accounts...',
                          ),
                          error: (error, _) => TossDropdown<String>(
                            label: 'Their Account',
                            items: const [],
                            errorText: 'Failed to load accounts',
                            hint: 'Unable to load',
                          ),
                        );
                      },
                      loading: () => const TossDropdown<String>(
                        label: 'Their Account',
                        items: [],
                        isLoading: true,
                        hint: 'Loading linked company...',
                      ),
                      error: (error, _) => _buildNoLinkedCompanyMessage(),
                    ),

                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: TossColors.gray200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TossButton.secondary(
                    text: 'Cancel',
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  flex: 2,
                  child: TossButton.primary(
                    text: widget.accountMapping == null ? 'Create' : 'Save',
                    onPressed: _isLoading ? null : _saveMapping,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionOption(String value, String label) {
    final isSelected = _selectedDirection == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedDirection = value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? TossColors.primary.withValues(alpha: 0.1)
              : TossColors.gray50,
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Center(
          child: Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.primary : TossColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoLinkedCompanyMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Their Account',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: TossColors.info,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'This counterparty is not linked to an internal company. Please set up the linked company first.',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
