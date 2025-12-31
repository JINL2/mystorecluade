import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_fab.dart';

final tossFabComponent = WidgetbookComponent(
  name: 'TossFAB',
  useCases: [
    WidgetbookUseCase(
      name: 'Simple',
      builder: (context) => Scaffold(
        backgroundColor: Colors.grey[100],
        floatingActionButton: TossFAB(
          icon: Icons.add,
          onPressed: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Expandable',
      builder: (context) => Scaffold(
        backgroundColor: Colors.grey[100],
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
            TossFABAction(
              icon: Icons.share,
              label: 'Share',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  ],
);
