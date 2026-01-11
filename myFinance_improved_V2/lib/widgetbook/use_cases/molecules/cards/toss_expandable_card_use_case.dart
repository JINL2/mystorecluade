import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_expandable_card.dart';
import 'package:widgetbook/widgetbook.dart';

final tossExpandableCardComponent = WidgetbookComponent(
  name: 'TossExpandableCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const _DefaultUseCase(),
    ),
    WidgetbookUseCase(
      name: 'With Custom Header',
      builder: (context) => const _CustomHeaderUseCase(),
    ),
    WidgetbookUseCase(
      name: 'With Footer',
      builder: (context) => const _WithFooterUseCase(),
    ),
    WidgetbookUseCase(
      name: 'Always Show Divider',
      builder: (context) => const _AlwaysShowDividerUseCase(),
    ),
    WidgetbookUseCase(
      name: 'Animated Version',
      builder: (context) => const _AnimatedUseCase(),
    ),
  ],
);

class _DefaultUseCase extends StatefulWidget {
  const _DefaultUseCase();

  @override
  State<_DefaultUseCase> createState() => _DefaultUseCaseState();
}

class _DefaultUseCaseState extends State<_DefaultUseCase> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: TossExpandableCard(
          title: 'Payment Details',
          isExpanded: _isExpanded,
          onToggle: () => setState(() => _isExpanded = !_isExpanded),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: \$100.00', style: TossTextStyles.body),
              const SizedBox(height: TossSpacing.space2),
              Text('Date: 2024-01-15', style: TossTextStyles.body),
              const SizedBox(height: TossSpacing.space2),
              Text('Status: Completed', style: TossTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomHeaderUseCase extends StatefulWidget {
  const _CustomHeaderUseCase();

  @override
  State<_CustomHeaderUseCase> createState() => _CustomHeaderUseCaseState();
}

class _CustomHeaderUseCaseState extends State<_CustomHeaderUseCase> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: TossExpandableCard(
          headerWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'VND • Vietnamese Dong',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                '1 VND = ₫24,500',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          isExpanded: _isExpanded,
          onToggle: () => setState(() => _isExpanded = !_isExpanded),
          backgroundColor: TossColors.white,
          dividerColor: TossColors.gray200,
          content: Column(
            children: [
              _buildDenominationRow('₫500,000', '2', '₫1,000,000'),
              _buildDenominationRow('₫200,000', '3', '₫600,000'),
              _buildDenominationRow('₫100,000', '5', '₫500,000'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDenominationRow(String denom, String qty, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$denom × $qty', style: TossTextStyles.caption),
          Text(total, style: TossTextStyles.caption),
        ],
      ),
    );
  }
}

class _WithFooterUseCase extends StatefulWidget {
  const _WithFooterUseCase();

  @override
  State<_WithFooterUseCase> createState() => _WithFooterUseCaseState();
}

class _WithFooterUseCaseState extends State<_WithFooterUseCase> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: TossExpandableCard(
          title: 'VND • Vietnamese Dong',
          titleStyle: TossTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
          isExpanded: _isExpanded,
          onToggle: () => setState(() => _isExpanded = !_isExpanded),
          backgroundColor: TossColors.white,
          alwaysShowDivider: true,
          dividerColor: TossColors.gray200,
          content: Column(
            children: [
              _buildDenominationRow('₫500,000', '2', '₫1,000,000'),
              _buildDenominationRow('₫200,000', '3', '₫600,000'),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal (VND)',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                '₫1,600,000',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDenominationRow(String denom, String qty, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$denom × $qty', style: TossTextStyles.caption),
          Text(total, style: TossTextStyles.caption),
        ],
      ),
    );
  }
}

class _AlwaysShowDividerUseCase extends StatefulWidget {
  const _AlwaysShowDividerUseCase();

  @override
  State<_AlwaysShowDividerUseCase> createState() =>
      _AlwaysShowDividerUseCaseState();
}

class _AlwaysShowDividerUseCaseState extends State<_AlwaysShowDividerUseCase> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            Text(
              'Divider is always visible even when collapsed',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space4),
            TossExpandableCard(
              title: 'Settings',
              isExpanded: _isExpanded,
              onToggle: () => setState(() => _isExpanded = !_isExpanded),
              backgroundColor: TossColors.white,
              alwaysShowDivider: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Option 1: Enabled', style: TossTextStyles.body),
                  const SizedBox(height: TossSpacing.space2),
                  Text('Option 2: Disabled', style: TossTextStyles.body),
                ],
              ),
              footer: Text(
                'Last updated: Today',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedUseCase extends StatefulWidget {
  const _AnimatedUseCase();

  @override
  State<_AnimatedUseCase> createState() => _AnimatedUseCaseState();
}

class _AnimatedUseCaseState extends State<_AnimatedUseCase> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            Text(
              'TossExpandableCardAnimated with smooth animation',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space4),
            TossExpandableCardAnimated(
              title: 'Animated Card',
              isExpanded: _isExpanded,
              onToggle: () => setState(() => _isExpanded = !_isExpanded),
              backgroundColor: TossColors.white,
              alwaysShowDivider: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('This content animates smoothly', style: TossTextStyles.body),
                  const SizedBox(height: TossSpacing.space2),
                  Text('Using SizeTransition', style: TossTextStyles.body),
                  const SizedBox(height: TossSpacing.space2),
                  Text('Try toggling!', style: TossTextStyles.body),
                ],
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Footer', style: TossTextStyles.body),
                  Text(
                    'Always visible',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
