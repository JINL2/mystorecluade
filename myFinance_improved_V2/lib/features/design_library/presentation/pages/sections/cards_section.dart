import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Cards Section - Showcases card components
class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
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
          padding: const EdgeInsets.all(TossSpacing.space4),
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
