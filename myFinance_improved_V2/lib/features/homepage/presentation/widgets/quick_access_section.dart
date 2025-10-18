import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:go_router/go_router.dart';

class QuickAccessSection extends ConsumerWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topFeaturesAsync = ref.watch(quickAccessFeaturesProvider);

    return topFeaturesAsync.when(
      data: (topFeatures) {
        if (topFeatures.isEmpty) {
          return const SizedBox.shrink();
        }

        // Limit to 6 items
        final displayFeatures = topFeatures.take(6).toList();

        return Container(
          color: TossColors.gray100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Actions container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  decoration: BoxDecoration(
                    color: TossColors.surface,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    border: Border.all(
                      color: TossColors.borderLight,
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TossColors.textPrimary.withOpacity(0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: TossColors.primary,
                                  borderRadius:
                                      BorderRadius.circular(TossBorderRadius.xs),
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Text(
                                'Quick Actions',
                                style: TossTextStyles.h3.copyWith(
                                  color: TossColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Most Used',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space4),

                      // Grid
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: TossSpacing.space3,
                          mainAxisSpacing: TossSpacing.space3,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: displayFeatures.length,
                        itemBuilder: (context, index) {
                          final feature = displayFeatures[index];
                          return _QuickAccessItem(
                            featureName: feature.featureName,
                            iconKey: feature.iconKey,
                            route: feature.route,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space6),
              ],
            ),
          ),
        );
      },
      loading: () => const _LoadingQuickAccess(),
      error: (error, stack) => const SizedBox.shrink(), // Fail silently
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  const _QuickAccessItem({
    required this.featureName,
    required this.iconKey,
    required this.route,
  });

  final String featureName;
  final String? iconKey;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          final fullRoute = route.startsWith('/') ? route : '/$route';
          context.push(fullRoute);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withOpacity(0.1),
        highlightColor: TossColors.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
          decoration: BoxDecoration(
            color: TossColors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: DynamicIcon(
                  iconKey: iconKey,
                  featureName: featureName,
                  size: 20,
                  color: TossColors.gray700,
                  useDefaultColor: false,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              // Text
              Flexible(
                child: Text(
                  featureName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.2,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingQuickAccess extends StatelessWidget {
  const _LoadingQuickAccess();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                border: Border.all(
                  color: TossColors.borderLight,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: TossColors.primary,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Text(
                        'Quick Actions',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  // Loading skeletons
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: TossSpacing.space3,
                      mainAxisSpacing: TossSpacing.space3,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: TossSpacing.space1,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius:
                                    BorderRadius.circular(TossBorderRadius.lg),
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Container(
                              width: 60,
                              height: 10,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius:
                                    BorderRadius.circular(TossBorderRadius.xs),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }
}
