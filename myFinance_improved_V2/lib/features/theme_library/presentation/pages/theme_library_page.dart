import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';

/// Theme Library Page
/// Visual showcase of all design system components
class ThemeLibraryPage extends StatelessWidget {
  const ThemeLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Design Library'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        children: const [
          _SectionHeader(title: 'Colors'),
          _ColorsSection(),
          SizedBox(height: TossSpacing.space8),

          _SectionHeader(title: 'Typography'),
          _TypographySection(),
          SizedBox(height: TossSpacing.space8),

          _SectionHeader(title: 'Spacing'),
          _SpacingSection(),
          SizedBox(height: TossSpacing.space8),

          _SectionHeader(title: 'Border Radius'),
          _BorderRadiusSection(),
          SizedBox(height: TossSpacing.space8),

          _SectionHeader(title: 'Buttons'),
          _ButtonsSection(),
          SizedBox(height: TossSpacing.space8),

          _SectionHeader(title: 'Cards'),
          _CardsSection(),
          SizedBox(height: TossSpacing.space8),

          _SectionHeader(title: 'Input Fields'),
          _InputFieldsSection(),
          SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }
}

/// Section Header Widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
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

/// Colors Section
class _ColorsSection extends StatelessWidget {
  const _ColorsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorGroup(
          title: 'Brand Colors',
          colors: [
            _ColorItem('Primary', TossColors.primary),
            _ColorItem('Primary Surface', TossColors.primarySurface),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Grayscale',
          colors: [
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
            _ColorItem('Black', TossColors.black),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Semantic Colors',
          colors: [
            _ColorItem('Success', TossColors.success),
            _ColorItem('Success Light', TossColors.successLight),
            _ColorItem('Error', TossColors.error),
            _ColorItem('Error Light', TossColors.errorLight),
            _ColorItem('Warning', TossColors.warning),
            _ColorItem('Warning Light', TossColors.warningLight),
            _ColorItem('Info', TossColors.info),
            _ColorItem('Info Light', TossColors.infoLight),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Financial Colors',
          colors: [
            _ColorItem('Profit', TossColors.profit),
            _ColorItem('Loss', TossColors.loss),
          ],
        ),
      ],
    );
  }
}

class _ColorGroup extends StatelessWidget {
  const _ColorGroup({
    required this.title,
    required this.colors,
  });

  final String title;
  final List<Widget> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: colors,
        ),
      ],
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.5;

    return Container(
      width: 100,
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            name,
            style: TossTextStyles.caption.copyWith(
              color: isLight ? TossColors.textPrimary : TossColors.white,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Typography Section
class _TypographySection extends StatelessWidget {
  const _TypographySection();

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
          _TypographyItem('Display - 32px/ExtraBold', 'Display Text', TossTextStyles.display),
          _TypographyItem('Headline Large - 28px/Bold', '\$12,480.32', TossTextStyles.headlineLarge),
          _TypographyItem('H1 - 28px/Bold', 'Page Title', TossTextStyles.h1),
          _TypographyItem('H2 - 24px/Bold', 'Section Header', TossTextStyles.h2),
          _TypographyItem('H3 - 20px/Semibold', 'Subsection', TossTextStyles.h3),
          _TypographyItem('H4 - 18px/Semibold', 'Card Title', TossTextStyles.h4),
          _TypographyItem('Title Large - 17px/Bold', 'People, Money', TossTextStyles.titleLarge),
          _TypographyItem('Title Medium - 15px/Bold', 'Today Revenue', TossTextStyles.titleMedium),
          _TypographyItem('Body Large - 14px/Regular', 'Body text, descriptions', TossTextStyles.bodyLarge),
          _TypographyItem('Body Medium - 14px/Semibold', 'Cash Ending', TossTextStyles.bodyMedium),
          _TypographyItem('Body - 14px/Regular', 'Default body text', TossTextStyles.body),
          _TypographyItem('Body Small - 13px/Semibold', '-3.2% vs Yesterday', TossTextStyles.bodySmall),
          _TypographyItem('Button - 14px/Semibold', 'Button Text', TossTextStyles.button),
          _TypographyItem('Label Large - 14px/Medium', 'Form Label', TossTextStyles.labelLarge),
          _TypographyItem('Label Medium - 12px/Semibold', 'Reconcile drawer', TossTextStyles.labelMedium),
          _TypographyItem('Label - 12px/Medium', 'UI Label', TossTextStyles.label),
          _TypographyItem('Label Small - 11px/Semibold', 'Attendance', TossTextStyles.labelSmall),
          _TypographyItem('Caption - 12px/Regular', 'Helper text', TossTextStyles.caption),
          _TypographyItem('Small - 11px/Regular', 'Tiny text', TossTextStyles.small),
          _TypographyItem('Amount - 20px/Semibold (Mono)', '₫1,234,567', TossTextStyles.amount),
        ],
      ),
    );
  }
}

/// Typography Item Helper Widget
class _TypographyItem extends StatelessWidget {
  const _TypographyItem(this.name, this.sample, this.style);

  final String name;
  final String sample;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(sample, style: style),
        ],
      ),
    );
  }
}

/// Spacing Section
class _SpacingSection extends StatelessWidget {
  const _SpacingSection();

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
          _SpacingItem('space0', TossSpacing.space0),
          _SpacingItem('space1 (4px)', TossSpacing.space1),
          _SpacingItem('space2 (8px)', TossSpacing.space2),
          _SpacingItem('space3 (12px)', TossSpacing.space3),
          _SpacingItem('space4 (16px)', TossSpacing.space4),
          _SpacingItem('space5 (20px)', TossSpacing.space5),
          _SpacingItem('space6 (24px)', TossSpacing.space6),
          _SpacingItem('space8 (32px)', TossSpacing.space8),
          _SpacingItem('space10 (40px)', TossSpacing.space10),
          _SpacingItem('space12 (48px)', TossSpacing.space12),
        ],
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  const _SpacingItem(this.name, this.value);

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              name,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: value,
            height: 24,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              border: Border.all(color: TossColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Border Radius Section
class _BorderRadiusSection extends StatelessWidget {
  const _BorderRadiusSection();

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
          _BorderRadiusItem('none', TossBorderRadius.none),
          _BorderRadiusItem('xs (4px)', TossBorderRadius.xs),
          _BorderRadiusItem('sm (6px)', TossBorderRadius.sm),
          _BorderRadiusItem('md (8px)', TossBorderRadius.md),
          _BorderRadiusItem('lg (12px)', TossBorderRadius.lg),
          _BorderRadiusItem('xl (16px)', TossBorderRadius.xl),
          _BorderRadiusItem('xxl (20px)', TossBorderRadius.xxl),
          _BorderRadiusItem('xxxl (24px)', TossBorderRadius.xxxl),
        ],
      ),
    );
  }
}

class _BorderRadiusItem extends StatelessWidget {
  const _BorderRadiusItem(this.name, this.radius);

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: TossColors.primarySurface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: TossColors.primary, width: 2),
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          name,
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Buttons Section
class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Elevated Button'),
          ),
          const SizedBox(height: TossSpacing.space2),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: TossSpacing.space2),
          TextButton(
            onPressed: () {},
            child: const Text('Text Button'),
          ),
          const SizedBox(height: TossSpacing.space2),
          ElevatedButton(
            onPressed: null,
            child: const Text('Disabled Button'),
          ),
        ],
      ),
    );
  }
}

/// Cards Section
class _CardsSection extends StatelessWidget {
  const _CardsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'This is a standard card with border and no elevation. Perfect for clean, modern interfaces.',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: TossColors.primarySurface,
            borderRadius: BorderRadius.circular(TossBorderRadius.card),
            border: Border.all(color: TossColors.primary, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highlighted Card',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'A card with colored background for emphasis.',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Input Fields Section
class _InputFieldsSection extends StatelessWidget {
  const _InputFieldsSection();

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Default Input',
              hintText: 'Enter text here',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input with Helper',
              hintText: 'Enter text',
              helperText: 'This is helper text',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input with Error',
              hintText: 'Enter text',
              errorText: 'This field is required',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Disabled Input',
              hintText: 'Cannot edit',
            ),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
