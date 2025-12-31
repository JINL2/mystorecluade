import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';

final tossErrorViewComponent = WidgetbookComponent(
  name: 'TossErrorView',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => TossErrorView(
        error: Exception(
          context.knobs.string(
            label: 'Error Message',
            initialValue: 'Network connection failed. Please try again.',
          ),
        ),
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'Something went wrong',
        ),
        retryButtonText: context.knobs.string(
          label: 'Button Text',
          initialValue: 'Try Again',
        ),
        showRetryButton: context.knobs.boolean(
          label: 'Show Button',
          initialValue: true,
        ),
        onRetry: () {},
      ),
    ),
    WidgetbookUseCase(
      name: 'No Button',
      builder: (context) => TossErrorView(
        error: Exception('Error occurred'),
        title: 'Error',
        showRetryButton: false,
      ),
    ),
  ],
);
