import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/sheet_header.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final sheetHeaderComponent = WidgetbookComponent(
  name: 'SheetHeader',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.white,
        child: SheetHeader(
          title: context.knobs.string(
            label: 'Title',
            initialValue: 'Select Account',
          ),
          showCloseButton: context.knobs.boolean(
            label: 'Show Close Button',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Close Button',
      builder: (context) => Container(
        color: TossColors.white,
        child: SheetHeader(
          title: 'Settings',
          showCloseButton: true,
          onClose: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Various Titles',
      builder: (context) => Container(
        color: TossColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHeader(title: 'Select Store'),
            const Divider(height: 1),
            const SheetHeader(title: 'Choose Category'),
            const Divider(height: 1),
            SheetHeader(title: 'Filter Options', showCloseButton: true, onClose: () {}),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Title Style',
      builder: (context) => Container(
        color: TossColors.white,
        child: SheetHeader(
          title: 'Premium Feature',
          titleStyle: TossTextStyles.h2.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'In Bottom Sheet Context',
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(
              title: 'Select Payment Method',
              showCloseButton: true,
              onClose: () {},
            ),
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Bottom sheet content goes here...'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  ],
);
