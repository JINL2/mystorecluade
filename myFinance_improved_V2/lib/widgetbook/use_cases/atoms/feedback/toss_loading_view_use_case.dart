import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';

final tossLoadingViewComponent = WidgetbookComponent(
  name: 'TossLoadingView',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => SizedBox(
        height: 200,
        child: TossLoadingView(
          message: context.knobs.string(
            label: 'Message',
            initialValue: 'Loading...',
          ),
        ),
      ),
    ),
  ],
);
