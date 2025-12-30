import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Typography Section - Showcases TossTextStyles
class TypographySection extends StatelessWidget {
  const TypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypographyItem('Display - 32px/ExtraBold', 'Display Text', TossTextStyles.display),
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
