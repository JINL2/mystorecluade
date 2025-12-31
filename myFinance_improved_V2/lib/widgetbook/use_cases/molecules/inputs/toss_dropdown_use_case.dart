import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_dropdown.dart';

final tossDropdownComponent = WidgetbookComponent(
  name: 'TossDropdown',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossDropdown<String>(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Select Category',
          ),
          value: 'food',
          items: const [
            TossDropdownItem(value: 'food', label: 'Food'),
            TossDropdownItem(value: 'transport', label: 'Transport'),
            TossDropdownItem(value: 'shopping', label: 'Shopping'),
            TossDropdownItem(value: 'entertainment', label: 'Entertainment'),
          ],
          onChanged: (value) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Hint',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossDropdown<String>(
          label: 'Select an option',
          hint: 'Please select',
          items: const [
            TossDropdownItem(value: 'a', label: 'Option A'),
            TossDropdownItem(value: 'b', label: 'Option B'),
            TossDropdownItem(value: 'c', label: 'Option C'),
          ],
          onChanged: (value) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icons',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossDropdown<String>(
          label: 'Payment Method',
          value: 'card',
          items: const [
            TossDropdownItem(value: 'card', label: 'Credit Card', icon: Icons.credit_card),
            TossDropdownItem(value: 'cash', label: 'Cash', icon: Icons.money),
            TossDropdownItem(value: 'bank', label: 'Bank Transfer', icon: Icons.account_balance),
          ],
          onChanged: (value) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Required with Error',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossDropdown<String>(
          label: 'Category',
          isRequired: true,
          errorText: context.knobs.boolean(
            label: 'Show Error',
            initialValue: true,
          )
              ? 'Please select a category'
              : null,
          items: const [
            TossDropdownItem(value: 'a', label: 'Option A'),
            TossDropdownItem(value: 'b', label: 'Option B'),
          ],
          onChanged: (value) {},
        ),
      ),
    ),
  ],
);
