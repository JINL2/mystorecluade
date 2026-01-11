import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/check_indicator.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final checkIndicatorComponent = WidgetbookComponent(
  name: 'CheckIndicator',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: CheckIndicator(
          isVisible: context.knobs.boolean(
            label: 'Visible',
            initialValue: true,
          ),
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 20,
            min: 12,
            max: 32,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Color',
      builder: (context) => Center(
        child: CheckIndicator(
          isVisible: true,
          color: context.knobs.list(
            label: 'Color',
            options: [TossColors.primary, TossColors.success, TossColors.error, TossColors.warning],
            initialOption: TossColors.primary,
            labelBuilder: (color) {
              if (color == TossColors.primary) return 'Primary';
              if (color == TossColors.success) return 'Success';
              if (color == TossColors.error) return 'Error';
              return 'Warning';
            },
          ),
          size: 24,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Icon',
      builder: (context) => Center(
        child: CheckIndicator(
          isVisible: true,
          icon: context.knobs.list(
            label: 'Icon',
            options: [LucideIcons.check, LucideIcons.checkCircle, LucideIcons.checkSquare],
            initialOption: LucideIcons.check,
            labelBuilder: (icon) {
              if (icon == LucideIcons.check) return 'Check';
              if (icon == LucideIcons.checkCircle) return 'Check Circle';
              return 'Check Square';
            },
          ),
          size: 24,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Animation Demo',
      builder: (context) => const _AnimationDemo(),
    ),
  ],
);

class _AnimationDemo extends StatefulWidget {
  const _AnimationDemo();

  @override
  State<_AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<_AnimationDemo> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckIndicator(isVisible: _isVisible, size: 32),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _isVisible = !_isVisible),
            child: Text(_isVisible ? 'Hide' : 'Show'),
          ),
        ],
      ),
    );
  }
}
