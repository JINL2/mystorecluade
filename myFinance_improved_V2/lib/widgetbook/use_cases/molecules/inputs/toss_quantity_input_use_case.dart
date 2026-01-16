import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_input.dart';

final tossQuantityInputComponent = WidgetbookComponent(
  name: 'TossQuantityInput',
  useCases: [
    WidgetbookUseCase(
      name: 'Compact (Default)',
      builder: (context) => const _CompactDemo(),
    ),
    WidgetbookUseCase(
      name: 'Stepper (Dialog)',
      builder: (context) => const _StepperDemo(),
    ),
  ],
);

class _CompactDemo extends StatefulWidget {
  const _CompactDemo();
  @override
  State<_CompactDemo> createState() => _CompactDemoState();
}

class _CompactDemoState extends State<_CompactDemo> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TossQuantityInput()', style: TossTextStyles.h4),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Compact horizontal layout for inline use',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space6),
            TossQuantityInput(
              value: _qty,
              onChanged: (v) => setState(() => _qty = v),
              minValue: 0,
              maxValue: 100,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text('Current: $_qty', style: TossTextStyles.body),
          ],
        ),
      ),
    );
  }
}

class _StepperDemo extends StatefulWidget {
  const _StepperDemo();
  @override
  State<_StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<_StepperDemo> {
  int _qty = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TossQuantityInput.stepper()', style: TossTextStyles.h4),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Full-width layout for dialogs with stock indicator',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space6),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(color: TossColors.gray200),
              ),
              child: TossQuantityInput.stepper(
                value: _qty,
                onChanged: (v) => setState(() => _qty = v),
                previousValue: 10,
                stockChangeMode: StockChangeMode.add,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Stock: 10 → ${10 + _qty}',
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
