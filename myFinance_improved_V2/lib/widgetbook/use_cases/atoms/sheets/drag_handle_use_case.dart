import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/drag_handle.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final dragHandleComponent = WidgetbookComponent(
  name: 'DragHandle',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DragHandle(
            width: context.knobs.double.slider(
              label: 'Width',
              initialValue: 36,
              min: 20,
              max: 60,
            ),
            height: context.knobs.double.slider(
              label: 'Height',
              initialValue: 4,
              min: 2,
              max: 8,
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Color',
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DragHandle(
            color: context.knobs.list(
              label: 'Color',
              options: [TossColors.gray300, TossColors.gray400, TossColors.gray500, TossColors.primary],
              initialOption: TossColors.gray300,
              labelBuilder: (color) {
                if (color == TossColors.gray300) return 'Gray 300';
                if (color == TossColors.gray400) return 'Gray 400';
                if (color == TossColors.gray500) return 'Gray 500';
                return 'Primary';
              },
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'In Bottom Sheet Context',
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            DragHandle(),
            SizedBox(height: 16),
            Text(
              'Bottom Sheet Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    ),
  ],
);
