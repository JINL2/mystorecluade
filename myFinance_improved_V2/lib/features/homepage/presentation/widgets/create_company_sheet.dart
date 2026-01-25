import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../core/homepage_logger.dart';
import '../providers/company_providers.dart';
import '../providers/notifier_providers.dart';

/// Create Company Bottom Sheet Widget
/// Uses Riverpod StateNotifier for state management
/// Matches legacy UI from modern_bottom_drawer.dart lines 1281-1493
class CreateCompanySheet extends ConsumerStatefulWidget {
  const CreateCompanySheet({super.key});

  @override
  ConsumerState<CreateCompanySheet> createState() => _CreateCompanySheetState();
}

class _CreateCompanySheetState extends ConsumerState<CreateCompanySheet> {
  final _nameController = TextEditingController();
  String? _selectedCompanyTypeId;
  String? _selectedCurrencyId;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Reset state when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyNotifierProvider.notifier).reset();
    });
  }

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _selectedCompanyTypeId != null &&
      _selectedCurrencyId != null;

  void _createCompany() {
    homepageLogger.d('Button pressed - isFormValid: $_isFormValid, Name: "${_nameController.text.trim()}", CompanyTypeId: $_selectedCompanyTypeId, CurrencyId: $_selectedCurrencyId');

    if (!_isFormValid) {
      homepageLogger.w('Form is invalid, showing alert');

      // Build list of missing fields
      final missingFields = <String>[];
      if (_nameController.text.trim().isEmpty) {
        missingFields.add('• Company Name');
      }
      if (_selectedCompanyTypeId == null) {
        missingFields.add('• Company Type');
      }
      if (_selectedCurrencyId == null) {
        missingFields.add('• Base Currency');
      }

      // Show alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: TossSpacing.space3),
              const Text('Required Fields'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please fill in the following required fields:'),
              SizedBox(height: TossSpacing.space3),
              ...missingFields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: TossSpacing.space1),
                    child: Text(
                      field,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),),
            ],
          ),
          actions: [
            TossButton.primary(
              text: 'OK',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    homepageLogger.i('Calling createCompany...');
    ref.read(companyNotifierProvider.notifier).createCompany(
          companyName: _nameController.text.trim(),
          companyTypeId: _selectedCompanyTypeId!,
          baseCurrencyId: _selectedCurrencyId!,
        );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    TossToast.success(context, 'Code "$text" copied to clipboard!');
  }

  @override
  Widget build(BuildContext context) {
    // Listen to company state changes
    ref.listen<CompanyState>(companyNotifierProvider, (previous, next) {
      homepageLogger.d('State changed: ${next.runtimeType}');

      next.when(
        initial: () {
          // Do nothing
        },
        loading: () {
          homepageLogger.d('Showing loading SnackBar');
          SnackBarHelper.showLoading(context, 'Creating company...');
        },
        error: (message, errorCode) {
          homepageLogger.e('Showing error SnackBar: $message');
          SnackBarHelper.hideAndShowError(
            context,
            message,
            onRetry: _createCompany,
          );
        },
        created: (company) {
          homepageLogger.i('Company created successfully: ${company.name}');

          // 1. AppState 즉시 업데이트 (UI 반영)
          final appStateNotifier = ref.read(appStateProvider.notifier);
          appStateNotifier.addNewCompanyToUser(
            companyId: company.id,
            companyName: company.name,
            companyCode: company.code,
            role: {'role_name': 'Owner', 'permissions': <String>[]},
          );

          // 2. 새로 생성한 회사를 선택
          appStateNotifier.selectCompany(
            company.id,
            companyName: company.name,
          );

          // 3. Close bottom sheet and return company
          Navigator.of(context).pop(company);

          // 4. Show success message
          SnackBarHelper.hideAndShowSuccess(
            context,
            'Company "${company.name}" created successfully!',
            action: company.code.isNotEmpty
                ? SnackBarAction(
                    label: 'Share Code',
                    textColor: TossColors.white,
                    onPressed: () => _copyToClipboard(company.code),
                  )
                : null,
          );
        },
      );
    });

    final state = ref.watch(companyNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossSpacing.iconXL,
              height: 4,
              margin: const EdgeInsets.only(
                top: TossSpacing.space2,
                bottom: TossSpacing.paddingXL,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Company',
                        style: TossTextStyles.h3.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Enter company details',
                        style: TossTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TossSpacing.space8),

            // Form
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    // Company Name Input
                    TossTextField.filled(
                      label: 'Company Name',
                      controller: _nameController,
                      hintText: 'Enter company name',
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Company Type Dropdown
                    Consumer(
                      builder: (context, ref, child) {
                        final companyTypesAsync = ref.watch(companyTypesProvider);

                        return companyTypesAsync.when(
                          data: (companyTypes) => TossDropdown<String>(
                            label: 'Company Type',
                            value: _selectedCompanyTypeId,
                            hint: 'Select company type',
                            items: companyTypes
                                .map((type) => TossDropdownItem(
                                      value: type.id,
                                      label: type.typeName,
                                    ),)
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedCompanyTypeId = value);
                            },
                          ),
                          loading: () => const TossDropdown<String>(
                            label: 'Company Type',
                            items: [],
                            isLoading: true,
                          ),
                          error: (_, __) => const TossDropdown<String>(
                            label: 'Company Type',
                            items: [],
                            errorText: 'Failed to load company types',
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Currency Dropdown
                    Consumer(
                      builder: (context, ref, child) {
                        final currenciesAsync = ref.watch(currenciesProvider);

                        return currenciesAsync.when(
                          data: (currencies) => TossDropdown<String>(
                            label: 'Base Currency',
                            value: _selectedCurrencyId,
                            hint: 'Select base currency',
                            items: currencies
                                .map((currency) => TossDropdownItem(
                                      value: currency.id,
                                      label: '${currency.name} (${currency.code})',
                                      subtitle: currency.symbol,
                                    ),)
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedCurrencyId = value);
                            },
                          ),
                          loading: () => const TossDropdown<String>(
                            label: 'Base Currency',
                            items: [],
                            isLoading: true,
                          ),
                          error: (_, __) => const TossDropdown<String>(
                            label: 'Base Currency',
                            items: [],
                            errorText: 'Failed to load currencies',
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: TossSpacing.space8),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: TossButton.primary(
                        text: 'Create Company',
                        onPressed: state.maybeWhen(
                          loading: () => null,
                          orElse: () => _createCompany,
                        ),
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
