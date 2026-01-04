import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../domain/entities/debt_category.dart';
import 'form_date_picker.dart';
import 'section_title.dart';

/// Debt information section for payable/receivable transactions
///
/// Contains debt category dropdown, interest rate field, and date pickers.
class DebtInformationSection extends StatelessWidget {
  final String? selectedDebtCategory;
  final TextEditingController interestRateController;
  final FocusNode interestRateFocusNode;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final ValueChanged<String?> onDebtCategoryChanged;
  final ValueChanged<DateTime> onIssueDateChanged;
  final ValueChanged<DateTime> onDueDateChanged;
  final VoidCallback? onInterestRateSubmitted;

  const DebtInformationSection({
    super.key,
    required this.selectedDebtCategory,
    required this.interestRateController,
    required this.interestRateFocusNode,
    required this.issueDate,
    required this.dueDate,
    required this.onDebtCategoryChanged,
    required this.onIssueDateChanged,
    required this.onDueDateChanged,
    this.onInterestRateSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Debt Category Dropdown
        TossDropdown<String>(
          label: 'Debt Category',
          value: selectedDebtCategory,
          hint: 'Select debt category',
          items: DebtCategory.values.map((category) => TossDropdownItem<String>(
            value: category.value,
            label: category.displayName,
          )).toList(),
          onChanged: onDebtCategoryChanged,
        ),

        // Interest Rate Field
        const SizedBox(height: TossSpacing.space4),
        const SectionTitle(title: 'Interest Rate'),
        const SizedBox(height: TossSpacing.space2),
        TossEnhancedTextField(
          controller: interestRateController,
          hintText: 'Enter interest rate',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          focusNode: interestRateFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            onInterestRateSubmitted?.call();
          },
          showKeyboardToolbar: true,
          keyboardDoneText: 'Next',
          enableTapDismiss: false,
        ),

        // Date Pickers Row
        const SizedBox(height: TossSpacing.space4),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Issue Date'),
                  const SizedBox(height: TossSpacing.space2),
                  FormDatePicker(
                    date: issueDate,
                    onChanged: onIssueDateChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Due Date'),
                  const SizedBox(height: TossSpacing.space2),
                  FormDatePicker(
                    date: dueDate,
                    onChanged: onDueDateChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
