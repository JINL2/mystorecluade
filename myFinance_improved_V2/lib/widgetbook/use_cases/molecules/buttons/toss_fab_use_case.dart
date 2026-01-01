import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_fab.dart';

final tossFabComponent = WidgetbookComponent(
  name: 'TossFAB',
  useCases: [
    WidgetbookUseCase(
      name: 'Simple',
      builder: (context) => Scaffold(
        body: const Center(child: Text('Floating Action Button Demo')),
        floatingActionButton: TossFAB(
          icon: Icons.add,
          onPressed: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Expandable',
      builder: (context) => Scaffold(
        body: const Center(child: Text('Expandable FAB Demo')),
        floatingActionButton: TossFAB.expandable(
          actions: [
            TossFABAction(
              icon: Icons.edit,
              label: 'Edit',
              onPressed: () {},
            ),
            TossFABAction(
              icon: Icons.delete,
              label: 'Delete',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  ],
);
