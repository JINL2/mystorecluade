import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../models/employee_salary.dart';
import '../models/salary_update_request.dart';
import '../providers/employee_setting_providers.dart';

class SalaryEditSheet extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final Function(double amount, String type, String currencyId, String currencyName, String symbol)? onSalaryUpdated;

  const SalaryEditSheet({
    super.key,
    required this.employee,
    this.onSalaryUpdated,
  });

  @override
  ConsumerState<SalaryEditSheet> createState() => _SalaryEditSheetState();
}

class _SalaryEditSheetState extends ConsumerState<SalaryEditSheet> {
  late TextEditingController _amountController;
  late String _selectedType;
  late String _selectedCurrency;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.employee.salaryAmount.toStringAsFixed(2),
    );
    _selectedType = widget.employee.salaryType;
    // Initialize with a default, we'll set the correct value when currencies load
    _selectedCurrency = 'USD'; // Default fallback
    print('=== SALARY EDIT SHEET INIT ===');
    print('Initial currency ID from employee: ${widget.employee.currencyId}');
    print('Initial currency name: ${widget.employee.currencyName}');
    print('Initial symbol: ${widget.employee.symbol}');
    
    // Set the correct currency code after currencies load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCurrency();
    });
  }

  void _initializeCurrency() {
    final currenciesAsync = ref.read(currencyTypesProvider);
    currenciesAsync.whenData((currencies) {
      // Find currency by name or symbol since the employee might have UUID in currencyId
      final matchingCurrency = currencies.firstWhere(
        (currency) => currency.currencyName.toLowerCase() == widget.employee.currencyName.toLowerCase(),
        orElse: () => currencies.firstWhere(
          (currency) => currency.symbol == widget.employee.symbol,
          orElse: () => currencies.first,
        ),
      );
      
      if (mounted) {
        setState(() {
          _selectedCurrency = matchingCurrency.currencyCode;
        });
        print('Initialized currency to: ${matchingCurrency.currencyName} (${matchingCurrency.currencyCode})');
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _updateSalary() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    ref.read(isUpdatingSalaryProvider.notifier).state = true;

    try {
      final service = ref.read(salaryServiceProvider);
      print('=== SALARY UPDATE DEBUG ===');
      print('Employee salary ID: ${widget.employee.salaryId}');
      print('Amount to update: $amount');
      print('Selected type: $_selectedType');
      print('Selected currency: $_selectedCurrency');
      
      final request = SalaryUpdateRequest(
        salaryId: widget.employee.salaryId!,
        salaryAmount: amount,
        salaryType: _selectedType,
        currencyId: _selectedCurrency,
      );
      
      print('Request created: ${request.toJson()}');
      await service.updateSalary(request);
      print('Update service call completed');
      
      if (mounted) {
        // Get currency information from the dropdown for the callback
        final currenciesAsync = ref.read(currencyTypesProvider);
        String updatedCurrencyName = widget.employee.currencyName;
        String updatedSymbol = widget.employee.symbol;
        
        await currenciesAsync.when(
          data: (currencies) async {
            final selectedCurrency = currencies.firstWhere(
              (curr) => curr.currencyCode == _selectedCurrency,
              orElse: () => currencies.first,
            );
            updatedCurrencyName = selectedCurrency.currencyName;
            updatedSymbol = selectedCurrency.symbol;
            print('=== CURRENCY UPDATE CALLBACK ===');
            print('Selected currency code: $_selectedCurrency');
            print('Found currency: ${selectedCurrency.currencyName}');
            print('Symbol: ${selectedCurrency.symbol}');
          },
          loading: () async {},
          error: (_, __) async {},
        );
        
        // Call the callback with updated values
        if (widget.onSalaryUpdated != null) {
          print('=== CALLING CALLBACK ===');
          print('Amount: $amount');
          print('Type: $_selectedType');
          print('Currency ID: $_selectedCurrency');
          print('Currency Name: $updatedCurrencyName');
          print('Symbol: $updatedSymbol');
          
          widget.onSalaryUpdated!(
            amount,
            _selectedType,
            _selectedCurrency,
            updatedCurrencyName,
            updatedSymbol,
          );
        }
        
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Salary updated to ${_amountController.text} successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update salary: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      ref.read(isUpdatingSalaryProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currencyTypesProvider);
    final isUpdating = ref.watch(isUpdatingSalaryProvider);

    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(
              top: TossSpacing.space2,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update Salary',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      widget.employee.fullName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Form
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                children: [
                  // Salary Type Dropdown
                  TossDropdown<String>(
                    label: 'Salary Type',
                    value: _selectedType,
                    items: const [
                      TossDropdownItem(
                        value: 'monthly',
                        label: 'Monthly',
                        subtitle: 'Fixed monthly salary',
                      ),
                      TossDropdownItem(
                        value: 'hourly',
                        label: 'Hourly',
                        subtitle: 'Hourly rate',
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // Currency Dropdown
                  currenciesAsync.when(
                    data: (currencies) {
                      print('=== CURRENCY DROPDOWN DATA ===');
                      for (var currency in currencies) {
                        print('Currency: ${currency.currencyName} (${currency.currencyCode}) -> ID: ${currency.currencyId}');
                      }
                      print('Current selected: $_selectedCurrency');
                      
                      return TossDropdown<String>(
                        label: 'Currency',
                        value: _selectedCurrency,
                        items: currencies.map((currency) => TossDropdownItem(
                          value: currency.currencyCode, // Use currency_code (VND, USD, etc.)
                          label: currency.currencyName,
                          subtitle: currency.symbol,
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCurrency = value;
                            });
                          }
                        },
                      );
                    },
                    loading: () => const TossDropdown<String>(
                      label: 'Currency',
                      items: [],
                      isLoading: true,
                    ),
                    error: (_, __) => const TossDropdown<String>(
                      label: 'Currency',
                      items: [],
                      errorText: 'Failed to load currencies',
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // Amount Field
                  TossTextField(
                    controller: _amountController,
                    label: 'Salary Amount',
                    hintText: 'Enter amount',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter salary amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: TossSpacing.space6),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TossSecondaryButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: TossPrimaryButton(
                          text: 'Update',
                          onPressed: isUpdating ? null : _updateSalary,
                          isLoading: isUpdating,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + TossSpacing.space6,
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