import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/top_feature.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

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

        // Limit to 4 items to match target design
        final displayFeatures = topFeatures.take(4).toList();

        return Container(
          color: TossColors.surface,
          padding: const EdgeInsets.only(
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            top: 0,
            bottom: TossSpacing.space3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row of circular buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displayFeatures.map((feature) {
                  return _QuickAccessItem(feature: feature);
                }).toList(),
              ),
            ],
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
    required this.feature,
  });

  final TopFeature feature;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final fullRoute = feature.route.startsWith('/') ? feature.route : '/${feature.route}';
        context.push(fullRoute, extra: feature);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular icon button
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: TossColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: DynamicIcon(
                iconKey: feature.iconKey,
                featureName: feature.featureName,
                size: 20,
                color: TossColors.white,
                useDefaultColor: false,
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          // Text
          SizedBox(
            width: 80,
            child: Text(
              feature.featureName,
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
    );
  }
}

class _LoadingQuickAccess extends StatelessWidget {
  const _LoadingQuickAccess();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: TossColors.gray200,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
