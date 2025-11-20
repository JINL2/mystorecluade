import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Animated Tab Bar
///
/// A custom animated tab bar with smooth transitions and haptic feedback.
/// Used in Time Table Manage page for switching between Manage and Schedule tabs.
class AnimatedTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const AnimatedTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.background,
      child: Container(
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
                  alignment: controller.index == 1
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
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
                    for (int i = 0; i < tabs.length; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (controller.index != i) {
                              controller.animateTo(i);
                              HapticFeedback.lightImpact();
                            }
                          },
                          child: Container(
                            color: TossColors.transparent,
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: controller.index == i
                                    ? TossColors.gray900
                                    : TossColors.gray600,
                                  fontWeight: controller.index == i
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                ),
                                child: Text(tabs[i]),
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
      ),
    );
  }
}
