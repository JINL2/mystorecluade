import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';

/// Social proof section with ratings and testimonials
class SocialProof extends StatelessWidget {
  const SocialProof({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  Icons.star_rounded,
                  color: TossColors.warning,
                  size: TossSpacing.iconSM,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                '4.9',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                ' (2,847 reviews)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Testimonial
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            child: Column(
              children: [
                Text(
                  '"Pro has saved us hours of bookkeeping every week. The AI reports are incredibly accurate."',
                  textAlign: TextAlign.center,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: TossSpacing.space8,
                      height: TossSpacing.space8,
                      decoration: BoxDecoration(
                        color: TossColors.primary,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Center(
                        child: Text(
                          'JK',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.white,
                            fontWeight: TossFontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'James Kim',
                          style: TossTextStyles.small.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.gray900,
                          ),
                        ),
                        Text(
                          'Owner, Seoul Cafe',
                          style: TossTextStyles.micro.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
