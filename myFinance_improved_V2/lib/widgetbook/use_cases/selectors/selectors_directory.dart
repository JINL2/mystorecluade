import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Note: Selector widgets require Riverpod providers and complex state management.
// They are shown here as placeholder components to demonstrate the widget catalog structure.
// For full functionality, run the actual app with proper provider setup.

final selectorsDirectory = WidgetbookCategory(
  name: 'Selectors (18)',
  children: [
    WidgetbookFolder(
      name: 'Account (6)',
      children: [
        _placeholderComponent('AccountSelector', 'account/account_selector.dart'),
        _placeholderComponent('AccountSelectorSheet', 'account/account_selector_sheet.dart'),
        _placeholderComponent('AccountSelectorList', 'account/account_selector_list.dart'),
        _placeholderComponent('AccountSelectorItem', 'account/account_selector_item.dart'),
        _placeholderComponent('AccountMultiSelect', 'account/account_multi_select.dart'),
        _placeholderComponent('AccountQuickAccess', 'account/account_quick_access.dart'),
      ],
    ),
    WidgetbookFolder(
      name: 'Cash Location (5)',
      children: [
        _placeholderComponent('CashLocationSelector', 'cash_location/cash_location_selector.dart'),
        _placeholderComponent('CashLocationSelectorSheet', 'cash_location/cash_location_selector_sheet.dart'),
        _placeholderComponent('CashLocationSelectorList', 'cash_location/cash_location_selector_list.dart'),
        _placeholderComponent('CashLocationSelectorItem', 'cash_location/cash_location_selector_item.dart'),
        _placeholderComponent('CashLocationTabs', 'cash_location/cash_location_tabs.dart'),
      ],
    ),
    WidgetbookFolder(
      name: 'Counterparty (1)',
      children: [
        _placeholderComponent('CounterpartySelector', 'counterparty/counterparty_selector.dart'),
      ],
    ),
    WidgetbookFolder(
      name: 'Base (2)',
      children: [
        _placeholderComponent('SingleSelector', 'base/single_selector.dart'),
        _placeholderComponent('MultiSelector', 'base/multi_selector.dart'),
      ],
    ),
    WidgetbookFolder(
      name: 'Autonomous (3)',
      children: [
        _placeholderComponent('AutonomousCashLocationSelector', 'autonomous_cash_location_selector.dart'),
        _placeholderComponent('AutonomousCounterpartySelector', 'autonomous_counterparty_selector.dart'),
        _placeholderComponent('EnhancedAccountSelector', 'enhanced_account_selector.dart'),
      ],
    ),
    WidgetbookFolder(
      name: 'Exchange Rate (1)',
      children: [
        _placeholderComponent('ExchangeRateCalculator', 'exchange_rate/exchange_rate_calculator.dart'),
      ],
    ),
  ],
);

WidgetbookComponent _placeholderComponent(String name, String path) {
  return WidgetbookComponent(
    name: name,
    useCases: [
      WidgetbookUseCase(
        name: 'Info',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.widgets, size: 48, color: TossColors.gray400),
              const SizedBox(height: 16),
              Text(
                name,
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'lib/shared/widgets/selectors/$path',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TossColors.warningLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: TossColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'This selector requires Riverpod providers.\nTest in the actual app.',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.warning,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
