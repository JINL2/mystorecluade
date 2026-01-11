import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/search_field.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final sheetSearchFieldComponent = WidgetbookComponent(
  name: 'SheetSearchField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.white,
        child: SheetSearchField(
          hintText: context.knobs.string(
            label: 'Hint Text',
            initialValue: 'Search...',
          ),
          onChanged: (value) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Hints',
      builder: (context) => Container(
        color: TossColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetSearchField(
              hintText: 'Search accounts...',
              onChanged: null,
            ),
            const SizedBox(height: 8),
            const SheetSearchField(
              hintText: 'Search stores...',
              onChanged: null,
            ),
            const SizedBox(height: 8),
            const SheetSearchField(
              hintText: 'Search categories...',
              onChanged: null,
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Interactive',
      builder: (context) => const _InteractiveSearchDemo(),
    ),
  ],
);

class _InteractiveSearchDemo extends StatefulWidget {
  const _InteractiveSearchDemo();

  @override
  State<_InteractiveSearchDemo> createState() => _InteractiveSearchDemoState();
}

class _InteractiveSearchDemoState extends State<_InteractiveSearchDemo> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetSearchField(
            hintText: 'Type something...',
            onChanged: (value) => setState(() => _searchText = value),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Search text: $_searchText',
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
          ),
        ],
      ),
    );
  }
}
