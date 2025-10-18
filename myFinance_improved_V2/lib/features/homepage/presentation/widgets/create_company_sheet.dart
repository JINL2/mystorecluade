import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/company_providers.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/company_state.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';

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
    print('🟡 [CreateCompany] Button pressed');
    print('🟡 [CreateCompany] _isFormValid: $_isFormValid');
    print('🟡 [CreateCompany] Name: "${_nameController.text.trim()}"');
    print('🟡 [CreateCompany] CompanyTypeId: $_selectedCompanyTypeId');
    print('🟡 [CreateCompany] CurrencyId: $_selectedCurrencyId');

    if (!_isFormValid) {
      print('🔴 [CreateCompany] Form is invalid, showing alert');

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
              const SizedBox(width: 12),
              const Text('Required Fields'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please fill in the following required fields:'),
              const SizedBox(height: 12),
              ...missingFields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      field,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    print('✅ [CreateCompany] Calling createCompany...');
    ref.read(companyNotifierProvider.notifier).createCompany(
          companyName: _nameController.text.trim(),
          companyTypeId: _selectedCompanyTypeId!,
          baseCurrencyId: _selectedCurrencyId!,
        );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code "$text" copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to company state changes
    ref.listen<CompanyState>(companyNotifierProvider, (previous, next) {
      print('🟣 [CreateCompanySheet] State changed: ${next.runtimeType}');

      if (next is CompanyLoading) {
        print('🟣 [CreateCompanySheet] Showing loading SnackBar');
        // Show loading snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Creating company...'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 30),
          ),
        );
      } else if (next is CompanyError) {
        print('🟣 [CreateCompanySheet] Showing error SnackBar: ${next.message}');
        // Hide loading, show error
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(next.message)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _createCompany,
            ),
          ),
        );
      } else if (next is CompanyCreated) {
        print('🟣 [CreateCompanySheet] Company created successfully: ${next.company.name}');
        // Hide loading
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Close bottom sheet and return company
        Navigator.of(context).pop(next.company);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Company "${next.company.name}" created successfully!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: next.company.code.isNotEmpty
                ? SnackBarAction(
                    label: 'Share Code',
                    textColor: Colors.white,
                    onPressed: () => _copyToClipboard(next.company.code),
                  )
                : null,
          ),
        );
      }
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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(
                top: TossSpacing.space2,
                bottom: TossSpacing.paddingXL,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                    onPressed: () => Navigator.of(context).pop(),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Name',
                          style: TossTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space1),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter company name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            ),
                          ),
                          autofocus: true,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
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
                                    ))
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
                          error: (_, __) => TossDropdown<String>(
                            label: 'Company Type',
                            items: const [],
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
                                    ))
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
                          error: (_, __) => TossDropdown<String>(
                            label: 'Base Currency',
                            items: const [],
                            errorText: 'Failed to load currencies',
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: TossSpacing.space8),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: TossPrimaryButton(
                        text: 'Create Company',
                        onPressed: state is! CompanyLoading ? _createCompany : null,
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
