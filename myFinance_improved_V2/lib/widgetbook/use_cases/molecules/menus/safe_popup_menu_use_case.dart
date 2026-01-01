import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final safePopupMenuComponent = WidgetbookComponent(
  name: 'SafePopupMenu',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'SafePopupMenu\n(Safe area popup menu)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
