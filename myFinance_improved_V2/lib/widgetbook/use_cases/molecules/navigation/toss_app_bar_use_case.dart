import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar_1.dart';

final tossAppBarComponent = WidgetbookComponent(
  name: 'TossAppBar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Scaffold(
        appBar: TossAppBar1(
          title: context.knobs.string(
            label: 'Title',
            initialValue: 'Home',
          ),
          centerTitle: context.knobs.boolean(
            label: 'Center Title',
            initialValue: true,
          ),
        ),
        body: const Center(
          child: Text('Page Content'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Actions',
      builder: (context) => Scaffold(
        appBar: TossAppBar1(
          title: 'Products',
          primaryActionText: 'Add',
          primaryActionIcon: Icons.add,
          onPrimaryAction: () {},
          secondaryActionIcon: Icons.search,
          onSecondaryAction: () {},
        ),
        body: const Center(
          child: Text('Page Content'),
        ),
      ),
    ),
  ],
);
