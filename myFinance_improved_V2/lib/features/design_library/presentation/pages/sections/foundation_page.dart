import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Foundation Page - Colors, Typography, Spacing, Border Radius
class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        _buildSectionHeader('Colors'),
        _ColorsSection(),
        const SizedBox(height: TossSpacing.space8),

        _buildSectionHeader('Typography'),
        _TypographySection(),
        const SizedBox(height: TossSpacing.space8),

        _buildSectionHeader('Spacing'),
        _SpacingSection(),
        const SizedBox(height: TossSpacing.space8),

        _buildSectionHeader('Border Radius'),
        _BorderRadiusSection(),
        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Text(
        title,
        style: TossTextStyles.h2.copyWith(
          color: TossColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ColorsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorGroup(title: 'Brand', colors: [
          _ColorItem('Primary', TossColors.primary),
          _ColorItem('Primary Surface', TossColors.primarySurface),
        ]),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(title: 'Grayscale', colors: [
          _ColorItem('White', TossColors.white),
          _ColorItem('Gray 50', TossColors.gray50),
          _ColorItem('Gray 100', TossColors.gray100),
          _ColorItem('Gray 200', TossColors.gray200),
          _ColorItem('Gray 300', TossColors.gray300),
          _ColorItem('Gray 400', TossColors.gray400),
          _ColorItem('Gray 500', TossColors.gray500),
          _ColorItem('Gray 600', TossColors.gray600),
          _ColorItem('Gray 700', TossColors.gray700),
          _ColorItem('Gray 800', TossColors.gray800),
          _ColorItem('Gray 900', TossColors.gray900),
        ]),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(title: 'Semantic', colors: [
          _ColorItem('Success', TossColors.success),
          _ColorItem('Error', TossColors.error),
          _ColorItem('Warning', TossColors.warning),
          _ColorItem('Info', TossColors.info),
        ]),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(title: 'Financial', colors: [
          _ColorItem('Profit', TossColors.profit),
          _ColorItem('Loss', TossColors.loss),
        ]),
      ],
    );
  }
}

class _ColorGroup extends StatelessWidget {
  final String title;
  final List<Widget> colors;

  const _ColorGroup({required this.title, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(spacing: TossSpacing.space2, runSpacing: TossSpacing.space2, children: colors),
      ],
    );
  }
}

class _ColorItem extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorItem(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.5;
    return Container(
      width: 90,
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Container(height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 4),
          Text(name, style: TossTextStyles.caption.copyWith(color: isLight ? TossColors.gray900 : TossColors.white, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _TypographySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypographyItem('Display', 'Display Text', TossTextStyles.display),
          _TypographyItem('H1', 'Page Title', TossTextStyles.h1),
          _TypographyItem('H2', 'Section Header', TossTextStyles.h2),
          _TypographyItem('H3', 'Subsection', TossTextStyles.h3),
          _TypographyItem('H4', 'Card Title', TossTextStyles.h4),
          _TypographyItem('Title Large', 'People, Money', TossTextStyles.titleLarge),
          _TypographyItem('Title Medium', 'Today Revenue', TossTextStyles.titleMedium),
          _TypographyItem('Body Large', 'Body descriptions', TossTextStyles.bodyLarge),
          _TypographyItem('Body', 'Default body text', TossTextStyles.body),
          _TypographyItem('Body Small', '-3.2% vs Yesterday', TossTextStyles.bodySmall),
          _TypographyItem('Caption', 'Helper text', TossTextStyles.caption),
          _TypographyItem('Small', 'Tiny text', TossTextStyles.small),
          _TypographyItem('Amount', '₫1,234,567', TossTextStyles.amount),
        ],
      ),
    );
  }
}

class _TypographyItem extends StatelessWidget {
  final String name;
  final String sample;
  final TextStyle style;

  const _TypographyItem(this.name, this.sample, this.style);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(width: 100, child: Text(name, style: TossTextStyles.caption.copyWith(color: TossColors.textTertiary))),
          Expanded(child: Text(sample, style: style)),
        ],
      ),
    );
  }
}

class _SpacingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        children: [
          _SpacingItem('space1 (4px)', TossSpacing.space1),
          _SpacingItem('space2 (8px)', TossSpacing.space2),
          _SpacingItem('space3 (12px)', TossSpacing.space3),
          _SpacingItem('space4 (16px)', TossSpacing.space4),
          _SpacingItem('space5 (20px)', TossSpacing.space5),
          _SpacingItem('space6 (24px)', TossSpacing.space6),
          _SpacingItem('space8 (32px)', TossSpacing.space8),
          _SpacingItem('space10 (40px)', TossSpacing.space10),
        ],
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  final String name;
  final double value;

  const _SpacingItem(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(name, style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
          Container(
            width: value,
            height: 20,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: TossColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BorderRadiusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Wrap(
        spacing: TossSpacing.space3,
        runSpacing: TossSpacing.space3,
        children: [
          _BorderRadiusItem('xs (4px)', TossBorderRadius.xs),
          _BorderRadiusItem('sm (6px)', TossBorderRadius.sm),
          _BorderRadiusItem('md (8px)', TossBorderRadius.md),
          _BorderRadiusItem('lg (12px)', TossBorderRadius.lg),
          _BorderRadiusItem('xl (16px)', TossBorderRadius.xl),
          _BorderRadiusItem('xxl (20px)', TossBorderRadius.xxl),
        ],
      ),
    );
  }
}

class _BorderRadiusItem extends StatelessWidget {
  final String name;
  final double radius;

  const _BorderRadiusItem(this.name, this.radius);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: TossColors.primarySurface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: TossColors.primary, width: 2),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
