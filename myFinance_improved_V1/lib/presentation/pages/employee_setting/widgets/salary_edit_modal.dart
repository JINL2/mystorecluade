import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/common/toss_loading_view.dart';
import '../models/employee_salary.dart';
import '../models/currency_type.dart';
import '../models/salary_update_request.dart';
import '../providers/employee_setting_providers.dart';

class SalaryEditModal extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final Function(double, String, String, String, String) onSave;

  const SalaryEditModal({
    super.key,
    required this.employee,
    required this.onSave,
  });

  @override
  ConsumerState<SalaryEditModal> createState() => _SalaryEditModalState();
}

class _SalaryEditModalState extends ConsumerState<SalaryEditModal> {
  late TextEditingController _amountController;
  late String _selectedPaymentType;
  late String _selectedCurrencyId;
  late DateTime _effectiveDate;
  
  final _formKey = GlobalKey<FormState>();
  final _numberFormat = NumberFormat('#,##0');
  
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.employee.salaryAmount.toStringAsFixed(0),
    );
    _selectedPaymentType = widget.employee.salaryType;
    // Use currency code as fallback if currencyId is not available
    _selectedCurrencyId = widget.employee.currencyId.isNotEmpty 
        ? widget.employee.currencyId 
        : widget.employee.currencyName;
    _effectiveDate = DateTime.now();
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final currencies = ref.watch(currencyTypesProvider);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Salary Display
                    _buildCurrentSalaryCard(),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // New Amount Input
                    Text(
                      'New Amount',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter new salary amount',
                        prefixIcon: Icon(Icons.attach_money, color: TossColors.gray600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: TossColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: TossColors.gray300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: TossColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: TossColors.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: TossSpacing.space5),
                    
                    // Payment Type Selection
                    Text(
                      'Payment Type',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Expanded(
                          child: _PaymentTypeChip(
                            label: 'Monthly',
                            isSelected: _selectedPaymentType == 'monthly',
                            onTap: () {
                              setState(() {
                                _selectedPaymentType = 'monthly';
                              });
                            },
                          ),
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: _PaymentTypeChip(
                            label: 'Hourly',
                            isSelected: _selectedPaymentType == 'hourly',
                            onTap: () {
                              setState(() {
                                _selectedPaymentType = 'hourly';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space5),
                    
                    // Currency Selection
                    Text(
                      'Currency',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    currencies.when(
                      data: (currencyList) => TossDropdown<String>(
                        label: 'Currency',
                        value: _selectedCurrencyId,
                        items: currencyList.map((currency) {
                          return TossDropdownItem(
                            value: currency.currencyId ?? currency.currencyCode,
                            label: '${currency.currencyName} (${currency.symbol})',
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCurrencyId = value;
                            });
                          }
                        },
                        hint: 'Select currency',
                      ),
                      loading: () => TossLoadingView(),
                      error: (_, __) => Text('Failed to load currencies'),
                    ),
                    
                    SizedBox(height: TossSpacing.space5),
                    
                    // Effective Date
                    Text(
                      'Effective Date',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TossColors.gray200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: TossColors.gray600,
                              size: 20,
                            ),
                            SizedBox(width: TossSpacing.space3),
                            Text(
                              DateFormat('MMMM d, yyyy').format(_effectiveDate),
                              style: TossTextStyles.body,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Actions
          _buildBottomActions(currencies.valueOrNull ?? []),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Salary',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  'Update salary information for ${widget.employee.fullName}',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: TossColors.gray600),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentSalaryCard() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.gray100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Salary',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                widget.employee.symbol,
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              Text(
                _numberFormat.format(widget.employee.salaryAmount),
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              Text(
                widget.employee.salaryType == 'hourly' ? '/hr' : '/month',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomActions(List<CurrencyType> currencies) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.background,
        border: Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TossSecondaryButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              flex: 2,
              child: TossPrimaryButton(
                text: 'Save Changes',
                onPressed: () => _saveChanges(currencies),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.background,
              surface: TossColors.background,
              onSurface: TossColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _effectiveDate) {
      setState(() {
        _effectiveDate = picked;
      });
    }
  }
  
  void _saveChanges(List<CurrencyType> currencies) async {
    if (_formKey.currentState!.validate()) {
      if (widget.employee.salaryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot update salary: Missing salary ID'),
            backgroundColor: TossColors.error,
          ),
        );
        return;
      }

      final amount = double.parse(_amountController.text);
      final selectedCurrency = currencies.firstWhere(
        (c) => (c.currencyId == _selectedCurrencyId) || (c.currencyCode == _selectedCurrencyId),
        orElse: () => currencies.first,
      );
      
      HapticFeedback.mediumImpact();
      
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing loading dialogs
        builder: (context) => Center(
          child: TossLoadingView(),
        ),
      );
      
      try {
        // Call the salary service to update in database
        final service = ref.read(salaryServiceProvider);
        final request = SalaryUpdateRequest(
          salaryId: widget.employee.salaryId!,
          salaryAmount: amount,
          salaryType: _selectedPaymentType,
          currencyId: _selectedCurrencyId,
          changeReason: 'Salary updated via mobile app',
        );
        
        await service.updateSalary(request);
        
        // Close loading dialog
        Navigator.pop(context);
        
        // Call the original callback to update local state with new values
        widget.onSave(
          amount,
          _selectedPaymentType,
          _selectedCurrencyId,
          selectedCurrency.currencyName,
          selectedCurrency.symbol,
        );
        
        // Refresh the employee list to get updated data from database
        await refreshEmployees(ref);
        
        // Close modal
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Salary updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      } catch (e) {
        // Close loading dialog
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update salary: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}

class _PaymentTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: isSelected ? TossColors.background : TossColors.gray700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}