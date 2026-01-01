import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossEmptyViewComponent = WidgetbookComponent(
  name: 'TossEmptyView',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => TossEmptyView(
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'No items found',
        ),
        description: context.knobs.string(
          label: 'Description',
          initialValue: 'Try adding some items',
        ),
        icon: const Icon(
          Icons.inbox_outlined,
          size: 48,
          color: TossColors.gray400,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Action',
      builder: (context) => TossEmptyView(
        title: 'No items found',
        description: 'Try adding some items',
        icon: const Icon(
          Icons.inbox_outlined,
          size: 48,
          color: TossColors.gray400,
        ),
        action: TossButton.primary(
          text: 'Add Item',
          onPressed: () {},
        ),
      ),
    ),
  ],
);
