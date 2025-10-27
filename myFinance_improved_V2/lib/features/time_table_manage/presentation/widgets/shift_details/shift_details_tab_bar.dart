import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

class ShiftDetailsTabBar extends StatelessWidget {
  final TabController controller;

  const ShiftDetailsTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      height: 44,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      padding: const EdgeInsets.all(2),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated selection indicator
              AnimatedAlign(
                alignment: controller.index == 0
                  ? Alignment.centerLeft
                  : controller.index == 1
                    ? Alignment.center
                    : Alignment.centerRight,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: FractionallySizedBox(
                  widthFactor: 1/3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: TossColors.white,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                      boxShadow: [
                        BoxShadow(
                          color: TossColors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Tab buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.index != 0) {
                          controller.animateTo(0);
                          HapticFeedback.lightImpact();
                        }
                      },
                      child: Container(
                        color: TossColors.transparent,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TossTextStyles.bodySmall.copyWith(
                              color: controller.index == 0
                                ? TossColors.gray900
                                : TossColors.gray600,
                              fontWeight: controller.index == 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                            ),
                            child: const Text('Info'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.index != 1) {
                          controller.animateTo(1);
                          HapticFeedback.lightImpact();
                        }
                      },
                      child: Container(
                        color: TossColors.transparent,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TossTextStyles.bodySmall.copyWith(
                              color: controller.index == 1
                                ? TossColors.gray900
                                : TossColors.gray600,
                              fontWeight: controller.index == 1
                                ? FontWeight.w700
                                : FontWeight.w500,
                            ),
                            child: const Text('Manage'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.index != 2) {
                          controller.animateTo(2);
                          HapticFeedback.lightImpact();
                        }
                      },
                      child: Container(
                        color: TossColors.transparent,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TossTextStyles.bodySmall.copyWith(
                              color: controller.index == 2
                                ? TossColors.gray900
                                : TossColors.gray600,
                              fontWeight: controller.index == 2
                                ? FontWeight.w700
                                : FontWeight.w500,
                            ),
                            child: const Text('Bonus'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
