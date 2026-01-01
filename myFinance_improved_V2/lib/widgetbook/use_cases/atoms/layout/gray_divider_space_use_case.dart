import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/gray_divider_space.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final grayDividerSpaceComponent = WidgetbookComponent(
  name: 'GrayDividerSpace',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Content above', style: TossTextStyles.caption),
            const GrayDividerSpace(),
            Text('Content below', style: TossTextStyles.caption),
          ],
        ),
      ),
    ),
  ],
);
