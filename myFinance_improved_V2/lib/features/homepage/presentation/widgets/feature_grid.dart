import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/category_with_features.dart';
import 'package:myfinance_improved/core/domain/entities/feature.dart';
import 'package:go_router/go_router.dart';

class FeatureGrid extends ConsumerWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);

    return categoriesAsync.when(
      data: (categories) {
        // Filter out categories with no features
        final categoriesWithFeatures = categories
            .where((category) => category.features.isNotEmpty)
            .toList();

        if (categoriesWithFeatures.isEmpty) {
          return const _EmptyFeatures();
        }

        return Container(
          color: TossColors.gray100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'All Features',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),

                // Categories (only with features)
                ...categoriesWithFeatures.map((category) => _CategorySection(
                      category: category,
                    )),

                const SizedBox(height: TossSpacing.space10),
              ],
            ),
          ),
        );
      },
      loading: () => const _LoadingFeatures(),
      error: (error, stack) => _ErrorFeatures(error: error.toString()),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
  });

  final CategoryWithFeatures category;

  /// Features to hide from display (not delete)
  static const List<String> _hiddenFeatures = [
    'Account Mapping',
    'Delete Transaction',
    'Export Reports',
    'Cash Balance',
    'Income Statement',
    'Manager Transaction Template',
    'Bank Vault Ending',
    'Cash Control',
  ];

  @override
  Widget build(BuildContext context) {
    // Filter out hidden features
    final visibleFeatures = category.features
        .where((feature) => !_hiddenFeatures.contains(feature.featureName))
        .toList();

    // If all features are hidden, don't show the category
    if (visibleFeatures.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
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
          // Category Header
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
                category.categoryName,
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Features List (only visible features)
          ...visibleFeatures.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            final isLast = index == visibleFeatures.length - 1;

            return Column(
              children: [
                _FeatureListItem(feature: feature),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space2,
                    ),
                    height: 0.5,
                    color: TossColors.borderLight,
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _FeatureListItem extends StatelessWidget {
  const _FeatureListItem({
    required this.feature,
  });

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          final route = feature.featureRoute.startsWith('/')
              ? feature.featureRoute
              : '/${feature.featureRoute}';
          context.push(route);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withOpacity(0.08),
        highlightColor: TossColors.primary.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space3,
          ),
          child: Row(
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
                  iconKey: feature.iconKey,
                  featureName: feature.featureName,
                  size: 20,
                  color: TossColors.gray700,
                  useDefaultColor: false,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Feature Name
              Expanded(
                child: Text(
                  feature.featureName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: -0.4,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Arrow
              Icon(
                Icons.chevron_right,
                color: TossColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingFeatures extends StatelessWidget {
  const _LoadingFeatures();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Features',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: TossSpacing.space6),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFeatures extends StatelessWidget {
  const _EmptyFeatures();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space8),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            border: Border.all(
              color: TossColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.sync,
                size: 48,
                color: TossColors.textTertiary,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Setting up your workspace...',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Please wait while we load your features',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorFeatures extends StatelessWidget {
  const _ErrorFeatures({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            border: Border.all(
              color: TossColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: 24,
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  'Unable to load features',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
