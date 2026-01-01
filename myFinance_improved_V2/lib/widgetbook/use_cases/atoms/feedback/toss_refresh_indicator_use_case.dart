import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_refresh_indicator.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossRefreshIndicatorComponent = WidgetbookComponent(
  name: 'TossRefreshIndicator',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => SizedBox(
        height: 200,
        child: TossRefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Pull down to refresh',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);
