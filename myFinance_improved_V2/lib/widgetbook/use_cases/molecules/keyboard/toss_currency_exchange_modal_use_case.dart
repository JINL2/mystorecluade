import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_currency_exchange_modal.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossCurrencyExchangeModalComponent = WidgetbookComponent(
  name: 'TossCurrencyExchangeModal',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossCurrencyExchangeModal.show(
                context: context,
                title: context.knobs.string(
                  label: 'Title',
                  initialValue: 'Enter Amount',
                ),
                currency: context.knobs.stringOrNull(
                  label: 'Currency',
                  initialValue: '₩',
                ),
                allowDecimal: context.knobs.boolean(
                  label: 'Allow Decimal',
                  initialValue: true,
                ),
                onConfirm: (value) {},
              );
            },
            child: const Text('Open Modal'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Initial Value',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossCurrencyExchangeModal.show(
                context: context,
                title: 'Edit Amount',
                initialValue: '50000',
                currency: '₩',
                onConfirm: (value) {},
              );
            },
            child: const Text('Open with Initial Value'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'No Currency Symbol',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossCurrencyExchangeModal.show(
                context: context,
                title: 'Enter Percentage',
                currency: null, // No currency symbol
                allowDecimal: true,
                maxDecimalPlaces: 1,
                onConfirm: (value) {},
              );
            },
            child: const Text('Open Percentage Modal'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Max Amount',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossCurrencyExchangeModal.show(
                context: context,
                title: 'Enter Amount (Max: 1,000,000)',
                currency: '₩',
                maxAmount: 1000000,
                onConfirm: (value) {},
              );
            },
            child: const Text('Open with Max Amount'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Integer Only',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossCurrencyExchangeModal.show(
                context: context,
                title: 'Enter Quantity',
                currency: null,
                allowDecimal: false,
                onConfirm: (value) {},
              );
            },
            child: const Text('Open Integer Modal'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Different Currencies',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  TossCurrencyExchangeModal.show(
                    context: context,
                    title: 'Amount in USD',
                    currency: '\$',
                    onConfirm: (value) {},
                  );
                },
                child: const Text('USD'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  TossCurrencyExchangeModal.show(
                    context: context,
                    title: 'Amount in EUR',
                    currency: '€',
                    onConfirm: (value) {},
                  );
                },
                child: const Text('EUR'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  TossCurrencyExchangeModal.show(
                    context: context,
                    title: 'Amount in VND',
                    currency: '₫',
                    allowDecimal: false,
                    onConfirm: (value) {},
                  );
                },
                child: const Text('VND'),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);
