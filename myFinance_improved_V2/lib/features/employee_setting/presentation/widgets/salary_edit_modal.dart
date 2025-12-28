import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';

import '../../../store_shift/presentation/providers/store_shift_providers.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/employee_salary.dart';
import '../providers/employee_providers.dart';
class SalaryEditModal extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final void Function(double, String, String, String, String) onSave;

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
  String? _selectedTemplateId;
  bool _isSaving = false;

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
    // Initialize template selection from current employee data
    _selectedTemplateId = widget.employee.workScheduleTemplateId;
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final currencies = ref.watch(currencyTypesProvider);
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
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
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Salary Display
                    _buildCurrentSalaryCard(),
                    
                    const SizedBox(height: TossSpacing.space6),
                    
                    // New Amount Input
                    Text(
                      'New Amount',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter new salary amount',
                        prefixIcon: const Icon(Icons.attach_money, color: TossColors.gray600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          borderSide: const BorderSide(color: TossColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: TossColors.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 0) {
                          return 'Please enter a valid amount (0 or positive)';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: TossSpacing.space5),
                    
                    // Payment Type Selection
                    Text(
                      'Payment Type',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
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
                        const SizedBox(width: TossSpacing.space3),
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
                    
                    const SizedBox(height: TossSpacing.space5),

                    // Work Schedule Template Selection (only for monthly)
                    if (_selectedPaymentType == 'monthly')
                      _buildTemplateSelection(),

                    // Currency Selection
                    Text(
                      'Currency',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
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
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (_, __) => const Text('Failed to load currencies'),
                    ),
                    
                    const SizedBox(height: TossSpacing.space5),
                    
                    // Effective Date
                    Text(
                      'Effective Date',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.gray200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: TossColors.gray600,
                              size: 20,
                            ),
                            const SizedBox(width: TossSpacing.space3),
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
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: const BoxDecoration(
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
                const SizedBox(height: TossSpacing.space1),
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
            icon: const Icon(Icons.close, color: TossColors.gray600),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentSalaryCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
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
          const SizedBox(height: TossSpacing.space2),
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
  
  Widget _buildTemplateSelection() {
    final templatesAsync = ref.watch(workScheduleTemplatesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Work Schedule Template',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            // Link to create template if none exist
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to Staff & Store Settings > Schedule tab
                context.push('/store-shift');
              },
              icon: const Icon(LucideIcons.settings, size: 14),
              label: const Text('Manage'),
              style: TextButton.styleFrom(
                foregroundColor: TossColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: TossTextStyles.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        templatesAsync.when(
          data: (templates) {
            if (templates.isEmpty) {
              return _buildNoTemplatesCard();
            }

            return TossDropdown<String>(
              label: 'Work Schedule',
              value: _selectedTemplateId,
              items: [
                const TossDropdownItem(
                  value: '',
                  label: 'No template assigned',
                ),
                ...templates.map((template) {
                  return TossDropdownItem(
                    value: template.templateId,
                    label: '${template.templateName} (${template.timeRangeText})',
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTemplateId = value?.isEmpty == true ? null : value;
                });
              },
              hint: 'Select work schedule template',
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => _buildNoTemplatesCard(),
        ),
        const SizedBox(height: TossSpacing.space5),
      ],
    );
  }

  Widget _buildNoTemplatesCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.alertTriangle,
                color: TossColors.warning,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'No work schedule templates',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Create a template to define working hours for monthly employees.',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to Staff & Store Settings > Schedule tab
                context.push('/store-shift');
              },
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Create Template'),
              style: OutlinedButton.styleFrom(
                foregroundColor: TossColors.primary,
                side: const BorderSide(color: TossColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(List<CurrencyType> currencies) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.background,
        border: const Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TossButton1.secondary(
                text: 'Cancel',
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                fullWidth: true,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              flex: 2,
              child: TossButton1.primary(
                text: 'Save Changes',
                isLoading: _isSaving,
                onPressed: _isSaving ? null : () => _saveChanges(currencies),
                fullWidth: true,
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
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
        await TossDialogs.showValidationError(
          context: context,
          title: 'Cannot Update Salary',
          message: 'Missing salary ID',
        );
        return;
      }

      final amount = double.parse(_amountController.text);
      final selectedCurrency = currencies.firstWhere(
        (c) => (c.currencyId == _selectedCurrencyId) || (c.currencyCode == _selectedCurrencyId),
        orElse: () => currencies.first,
      );

      HapticFeedback.mediumImpact();

      // Set loading state
      setState(() => _isSaving = true);

      try {
        // ✅ Use Notifier instead of calling repository directly
        final success = await ref.read(employeeProvider.notifier).updateEmployeeSalary(
          salaryId: widget.employee.salaryId!,
          salaryAmount: amount,
          salaryType: _selectedPaymentType,
          currencyId: _selectedCurrencyId,
          changeReason: 'Salary updated via mobile app',
        );

        if (!success) {
          throw Exception('Failed to update salary');
        }

        // If monthly and template changed, update template assignment
        if (_selectedPaymentType == 'monthly') {
          final originalTemplateId = widget.employee.workScheduleTemplateId;
          if (_selectedTemplateId != originalTemplateId) {
            final templateResult = await ref.read(assignWorkScheduleTemplateProvider)(
              userId: widget.employee.userId,
              templateId: _selectedTemplateId,
            );

            if (templateResult['success'] != true) {
              // Template assignment failed, but salary was updated
              // Show warning but don't fail the entire operation
              debugPrint('Template assignment warning: ${templateResult['message']}');
            }
          }
        }

        // Call the original callback to update local state with new values
        widget.onSave(
          amount,
          _selectedPaymentType,
          _selectedCurrencyId,
          selectedCurrency.currencyName,
          selectedCurrency.symbol,
        );

        // Close modal
        if (mounted) Navigator.pop(context);

        // Show success dialog
        if (mounted) {
          await TossDialogs.showCashEndingSaved(
            context: context,
            message: 'Salary updated successfully',
          );
        }
      } catch (e) {
        // Reset loading state
        if (mounted) setState(() => _isSaving = false);

        // Show error dialog
        if (mounted) {
          await TossDialogs.showValidationError(
            context: context,
            title: 'Failed to Update Salary',
            message: e.toString().replaceAll('Exception:', '').trim(),
          );
        }
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
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
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