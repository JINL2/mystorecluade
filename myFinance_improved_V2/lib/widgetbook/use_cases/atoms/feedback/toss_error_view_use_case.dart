import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';

final tossErrorViewComponent = WidgetbookComponent(
  name: 'TossErrorView',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => TossErrorView(
        error: Exception(context.knobs.string(
          label: 'Error Message',
          initialValue: 'Network connection failed',
        )),
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'Connection Error',
        ),
        onRetry: () {},
      ),
    ),
  ],
);
