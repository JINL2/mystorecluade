import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/templates/toss_scaffold.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final templatesDirectory = WidgetbookCategory(
  name: 'Templates (1)',
  children: [
    WidgetbookComponent(
      name: 'TossScaffold',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) => TossScaffold(
            appBar: AppBar(
              title: Text(
                context.knobs.string(
                  label: 'Title',
                  initialValue: 'Page Title',
                ),
              ),
            ),
            body: Center(
              child: Text(
                'Content goes here',
                style: TossTextStyles.body,
              ),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'With FAB',
          builder: (context) => TossScaffold(
            appBar: AppBar(
              title: const Text('With FAB'),
            ),
            body: Center(
              child: Text(
                'Content goes here',
                style: TossTextStyles.body,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    ),
  ],
);
