import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Colors Section - Showcases the TossColors palette
class ColorsSection extends StatelessWidget {
  const ColorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorGroup(
          title: 'Brand Colors',
          colors: const [
            _ColorData('Primary', TossColors.primary),
            _ColorData('Primary Surface', TossColors.primarySurface),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Grayscale',
          colors: const [
            _ColorData('White', TossColors.white),
            _ColorData('Gray 50', TossColors.gray50),
            _ColorData('Gray 100', TossColors.gray100),
            _ColorData('Gray 200', TossColors.gray200),
            _ColorData('Gray 300', TossColors.gray300),
            _ColorData('Gray 400', TossColors.gray400),
            _ColorData('Gray 500', TossColors.gray500),
            _ColorData('Gray 600', TossColors.gray600),
            _ColorData('Gray 700', TossColors.gray700),
            _ColorData('Gray 800', TossColors.gray800),
            _ColorData('Gray 900', TossColors.gray900),
            _ColorData('Black', TossColors.black),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Semantic Colors',
          colors: const [
            _ColorData('Success', TossColors.success),
            _ColorData('Success Light', TossColors.successLight),
            _ColorData('Error', TossColors.error),
            _ColorData('Error Light', TossColors.errorLight),
            _ColorData('Warning', TossColors.warning),
            _ColorData('Warning Light', TossColors.warningLight),
            _ColorData('Info', TossColors.info),
            _ColorData('Info Light', TossColors.infoLight),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Financial Colors',
          colors: const [
            _ColorData('Profit', TossColors.profit),
            _ColorData('Loss', TossColors.loss),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Text Colors',
          colors: const [
            _ColorData('Text Primary', TossColors.textPrimary),
            _ColorData('Text Secondary', TossColors.textSecondary),
            _ColorData('Text Tertiary', TossColors.textTertiary),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        _ColorGroup(
          title: 'Background Colors',
          colors: const [
            _ColorData('Background', TossColors.background),
            _ColorData('Surface', TossColors.surface),
            _ColorData('Gray 100', TossColors.gray100),
          ],
        ),
      ],
    );
  }
}

class _ColorData {
  const _ColorData(this.name, this.color);
  final String name;
  final Color color;
}

class _ColorGroup extends StatelessWidget {
  const _ColorGroup({
    required this.title,
    required this.colors,
  });

  final String title;
  final List<_ColorData> colors;

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
          children: colors.map((c) => _ColorItem(c.name, c.color)).toList(),
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
            height: 18,
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
