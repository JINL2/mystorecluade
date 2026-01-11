import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_amount_keypad.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossAmountKeypadComponent = WidgetbookComponent(
  name: 'TossAmountKeypad',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.white,
        padding: const EdgeInsets.all(16),
        child: TossAmountKeypad(
          currencySymbol: context.knobs.string(
            label: 'Currency Symbol',
            initialValue: '₩',
          ),
          showSubmitButton: context.knobs.boolean(
            label: 'Show Submit Button',
            initialValue: true,
          ),
          submitButtonText: context.knobs.string(
            label: 'Submit Text',
            initialValue: 'Confirm',
          ),
          onAmountChanged: (amount) {},
          onSubmit: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Initial Amount',
      builder: (context) => Container(
        color: TossColors.white,
        padding: const EdgeInsets.all(16),
        child: TossAmountKeypad(
          initialAmount: 50000,
          currencySymbol: '₩',
          onAmountChanged: (amount) {},
          onSubmit: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Exchange Rate Button',
      builder: (context) => Container(
        color: TossColors.white,
        padding: const EdgeInsets.all(16),
        child: TossAmountKeypad(
          currencySymbol: '\$',
          onAmountChanged: (amount) {},
          onSubmit: () {},
          onExchangeRateTap: () {
            // This would open the exchange rate calculator
          },
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Different Currencies',
      builder: (context) => Container(
        color: TossColors.white,
        padding: const EdgeInsets.all(16),
        child: TossAmountKeypad(
          currencySymbol: context.knobs.list(
            label: 'Currency',
            options: ['₩', '\$', '€', '¥', '£'],
            initialOption: '₩',
          ),
          onAmountChanged: (amount) {},
          onSubmit: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Without Submit Button',
      builder: (context) => Container(
        color: TossColors.white,
        padding: const EdgeInsets.all(16),
        child: TossAmountKeypad(
          currencySymbol: '₩',
          showSubmitButton: false,
          onAmountChanged: (amount) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Interactive Demo',
      builder: (context) => const _AmountKeypadDemo(),
    ),
  ],
);

class _AmountKeypadDemo extends StatefulWidget {
  const _AmountKeypadDemo();

  @override
  State<_AmountKeypadDemo> createState() => _AmountKeypadDemoState();
}

class _AmountKeypadDemoState extends State<_AmountKeypadDemo> {
  double _amount = 0;
  String _lastAction = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Current Amount: ₩${_amount.toStringAsFixed(0)}',
                  style: TossTextStyles.h3,
                ),
                if (_lastAction.isNotEmpty)
                  Text(
                    _lastAction,
                    style: TossTextStyles.caption.copyWith(color: TossColors.success),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TossAmountKeypad(
              currencySymbol: '₩',
              onAmountChanged: (amount) => setState(() => _amount = amount),
              onSubmit: () => setState(() => _lastAction = 'Submitted!'),
            ),
          ),
        ],
      ),
    );
  }
}
