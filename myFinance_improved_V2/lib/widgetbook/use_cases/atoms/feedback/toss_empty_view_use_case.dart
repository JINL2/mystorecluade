import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_empty_view.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

final tossEmptyViewComponent = WidgetbookComponent(
  name: 'TossEmptyView',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => TossEmptyView(
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'No data available',
        ),
        description: context.knobs.string(
          label: 'Description',
          initialValue: 'Try adding some items',
        icon: Icon(
          Icons.inbox_outlined,
          size: 48,
          color: TossColors.gray400,
      ),
    ),
      name: 'With Action',
        title: 'No transactions yet',
        description: 'Start by adding your first transaction',
          Icons.receipt_long_outlined,
        action: TossButton.primary(
          text: 'Add Transaction',
          onPressed: () {},
      name: 'Compact',
        title: 'No results',
        compact: true,
          Icons.search_off,
          size: 32,
  ],
);
