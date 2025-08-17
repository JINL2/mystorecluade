import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import '../models/account_mapping_models.dart';
import '../providers/account_mapping_providers.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';

class AccountMappingForm extends ConsumerStatefulWidget {
  final String counterpartyId;
  final String counterpartyName;
  final AccountMapping? accountMapping;

  const AccountMappingForm({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
    this.accountMapping,
  });

  @override
  ConsumerState<AccountMappingForm> createState() => _AccountMappingFormState();
}

class _AccountMappingFormState extends ConsumerState<AccountMappingForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMyAccountId;
  String? _selectedLinkedCompanyId;
  String? _selectedLinkedAccountId;
  bool _isLoading = false;
  Map<String, String> _validationErrors = {};
  bool _hasAvailableCompanies = true;

  @override
  void initState() {
    super.initState();
    // Initialize form data if editing
    if (widget.accountMapping != null) {
      _selectedMyAccountId = widget.accountMapping!.myAccountId;
      _selectedLinkedCompanyId = widget.accountMapping!.linkedCompanyId;
      _selectedLinkedAccountId = widget.accountMapping!.linkedAccountId;
    }
  }

  Future<void> _submitForm() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _validationErrors.clear();
    });

    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany == null) {
      setState(() {
        _isLoading = false;
        _validationErrors['general'] = 'No company selected';
      });
      return;
    }

    final formData = AccountMappingFormData(
      mappingId: widget.accountMapping?.mappingId,
      myCompanyId: selectedCompany['company_id'],
      myAccountId: _selectedMyAccountId,
      counterpartyId: widget.counterpartyId,
      linkedCompanyId: _selectedLinkedCompanyId,
      linkedAccountId: _selectedLinkedAccountId,
      isActive: true,
    );

    try {
      final response = widget.accountMapping == null
          ? await ref.read(createAccountMappingProvider(formData).future)
          : await ref.read(updateAccountMappingProvider(formData).future);

      if (mounted) {
        response.when(
          success: (mapping, message) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message ?? 'Account mapping saved'),
                backgroundColor: TossColors.success,
                behavior: SnackBarBehavior.floating,
                duration: TossAnimations.normal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
              ),
            );
          },
          error: (message, code) {
            setState(() {
              _validationErrors['general'] = message;
            });
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _validationErrors['general'] = 'Failed to save mapping';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool get _isFormValid {
    return _hasAvailableCompanies &&
        _selectedMyAccountId != null &&
        _selectedLinkedCompanyId != null &&
        _selectedLinkedAccountId != null;
  }

  @override
  Widget build(BuildContext context) {
    final availableAccountsAsync = ref.watch(availableAccountsProvider);
    final internalCompaniesAsync = ref.watch(availableInternalCompaniesProvider);
    final linkedAccountsAsync = _selectedLinkedCompanyId != null
        ? ref.watch(linkedCompanyAccountsProvider(_selectedLinkedCompanyId!))
        : null;

    return Container(
      decoration: BoxDecoration(
        color: TossColors.textInverse,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toss-style handle and header
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space4),
                width: TossSpacing.space12,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300, // Restore grey handle bar (red circle should remain)
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
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
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          'Link debt accounts between companies',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: TossColors.gray600),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: TossSpacing.space10, minHeight: TossSpacing.space10),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Form Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info card similar to counter party form
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: Border.all(
                          color: TossColors.primary.withOpacity(0.3),
                          width: TossSpacing.space0 + 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(TossSpacing.space2),
                            decoration: BoxDecoration(
                              color: TossColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.sync,
                              color: TossColors.primary,
                              size: TossSpacing.iconMD,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Automatic Debt Synchronization',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: TossSpacing.space1),
                                Text(
                                  'Create mapping for ${widget.counterpartyName}. When you record Account Receivable, they\'ll automatically record Account Payable.',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: TossSpacing.space6),

                    // Your Debt Account
                    availableAccountsAsync.when(
                      data: (accounts) {
                        if (accounts.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Debt Account',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Container(
                                padding: EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: TossColors.info.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                  border: Border.all(
                                    color: TossColors.info.withOpacity(0.3),
                                    width: TossSpacing.space0 + 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: TossColors.info,
                                      size: TossSpacing.iconSM,
                                    ),
                                    SizedBox(width: TossSpacing.space2),
                                    Expanded(
                                      child: Text(
                                        'No debt accounts available. Please create Account Payable or Account Receivable accounts first.',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.info,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        
                        return TossDropdown<String>(
                          label: 'Your Debt Account',
                          value: _selectedMyAccountId,
                          items: accounts.map((account) => TossDropdownItem(
                            value: account.accountId,
                            label: account.accountName,
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMyAccountId = value;
                            });
                          },
                          hint: 'Select your debt account',
                        );
                      },
                      loading: () => TossDropdown<String>(
                        label: 'Your Debt Account',
                        value: null,
                        items: const [],
                        hint: 'Loading...',
                        isLoading: true,
                        onChanged: null,
                      ),
                      error: (_, __) => _buildErrorDropdown('Failed to load accounts'),
                    ),

                    SizedBox(height: TossSpacing.space5),

                    // Linked Company
                    internalCompaniesAsync.when(
                      data: (companies) {
                        // Update the flag based on available companies
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_hasAvailableCompanies != companies.isNotEmpty) {
                            setState(() {
                              _hasAvailableCompanies = companies.isNotEmpty;
                            });
                          }
                        });
                        
                        if (companies.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Linked Company',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Container(
                                padding: EdgeInsets.all(TossSpacing.space4),
                                decoration: BoxDecoration(
                                  color: TossColors.warning.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                  border: Border.all(
                                    color: TossColors.warning.withOpacity(0.3),
                                    width: TossSpacing.space0 + 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(TossSpacing.space2),
                                      decoration: BoxDecoration(
                                        color: TossColors.warning.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.business_outlined,
                                        color: TossColors.warning,
                                        size: TossSpacing.iconMD,
                                      ),
                                    ),
                                    SizedBox(width: TossSpacing.space3),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'No Linked Companies Available',
                                            style: TossTextStyles.body.copyWith(
                                              color: TossColors.gray900,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: TossSpacing.space1),
                                          Text(
                                            'You need to have access to at least one other company to create account mappings. Please contact your administrator.',
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        
                        return TossDropdown<String>(
                          label: 'Linked Company',
                          value: _selectedLinkedCompanyId,
                          items: companies.map((company) => TossDropdownItem(
                            value: company.companyId,
                            label: company.companyName,
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLinkedCompanyId = value;
                              _selectedLinkedAccountId = null;
                            });
                          },
                          hint: 'Select linked company',
                        );
                      },
                      loading: () => TossDropdown<String>(
                        label: 'Linked Company',
                        value: null,
                        items: const [],
                        hint: 'Loading...',
                        isLoading: true,
                        onChanged: null,
                      ),
                      error: (_, __) => _buildErrorDropdown('Failed to load companies'),
                    ),

                    SizedBox(height: TossSpacing.space5),

                    // Their Debt Account
                    if (_selectedLinkedCompanyId == null)
                      TossDropdown<String>(
                        label: 'Their Debt Account',
                        value: null,
                        items: const [],
                        hint: 'Select a linked company first',
                        isLoading: false,
                        onChanged: null,
                      )
                    else
                      linkedAccountsAsync?.when(
                        data: (accounts) => TossDropdown<String>(
                          label: 'Their Debt Account',
                          value: _selectedLinkedAccountId,
                          items: accounts.map((account) => TossDropdownItem(
                            value: account.accountId,
                            label: account.accountName,
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLinkedAccountId = value;
                            });
                          },
                          hint: 'Select their debt account',
                        ),
                        loading: () => TossDropdown<String>(
                          label: 'Their Debt Account',
                          value: null,
                          items: const [],
                          hint: 'Loading...',
                          isLoading: true,
                          onChanged: null,
                        ),
                        error: (_, __) => _buildErrorDropdown('Failed to load accounts'),
                      ) ?? SizedBox.shrink(),

                    // Error message
                    if (_validationErrors.containsKey('general')) ...[
                      SizedBox(height: TossSpacing.space3),
                      Container(
                        padding: EdgeInsets.all(TossSpacing.space3),
                        decoration: BoxDecoration(
                          color: TossColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: TossColors.error,
                              size: TossSpacing.iconSM,
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Expanded(
                              child: Text(
                                _validationErrors['general']!,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            ),
          ),

          // Bottom buttons - using common Toss button components
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.textInverse,
              border: Border(
                top: BorderSide(color: TossColors.gray100, width: TossSpacing.space0 + 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Cancel button using TossSecondaryButton
                  Expanded(
                    child: TossSecondaryButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      isEnabled: !_isLoading,
                      fullWidth: true,
                    ),
                  ),
                  
                  SizedBox(width: TossSpacing.space3),
                  
                  // Create/Update button using TossPrimaryButton
                  Expanded(
                    flex: 2,
                    child: TossPrimaryButton(
                      text: widget.accountMapping == null ? 'Create' : 'Update',
                      onPressed: _submitForm,
                      isLoading: _isLoading,
                      isEnabled: _isFormValid,
                      leadingIcon: Icon(
                        Icons.check,
                        size: TossSpacing.iconSM,
                      ),
                      fullWidth: true,
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

  Widget _buildErrorDropdown(String message) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: TossSpacing.iconSM, color: TossColors.error),
          SizedBox(width: TossSpacing.space2),
          Text(
            message,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ),
    );
  }
}