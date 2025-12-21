import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import 'package:myfinance_improved/core/domain/entities/feature.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/category_with_features.dart';
import 'package:myfinance_improved/features/homepage/domain/providers/repository_providers.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

class FeatureGrid extends ConsumerWidget {
  const FeatureGrid({super.key});

  /// Extract permitted feature IDs from appState for current company
  List<String> _getPermittedFeatureIds(AppState appState) {
    try {
      final companies = appState.user['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) {
        return [];
      }

      // Find current selected company
      final currentCompanyId = appState.companyChoosen;
      if (currentCompanyId.isEmpty) {
        return [];
      }

      Map<String, dynamic>? currentCompany;
      try {
        currentCompany = companies.firstWhere(
          (c) => c['company_id'] == currentCompanyId,
        ) as Map<String, dynamic>?;
      } catch (e) {
        return [];
      }

      if (currentCompany == null) {
        return [];
      }

      // Get role permissions
      final role = currentCompany['role'] as Map<String, dynamic>?;
      if (role == null) {
        return [];
      }

      final permissions = role['permissions'] as List<dynamic>?;
      if (permissions == null || permissions.isEmpty) {
        return [];
      }

      // Convert to List<String>
      final permittedIds = permissions.map((p) => p.toString()).toList();
      return permittedIds;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    final appState = ref.watch(appStateProvider);

    return categoriesAsync.when(
      data: (categories) {
        // Get user's permitted feature IDs from current company
        final List<String> permittedFeatureIds = _getPermittedFeatureIds(appState);

        // Filter features based on user permissions AND isShowMain flag
        // If no permissions found, show all features (fallback for safety)
        final categoriesWithFeatures = permittedFeatureIds.isEmpty
            ? categories
                .map((category) {
                  // Filter features by isShowMain flag only (no permission check)
                  final visibleFeatures = category.features
                      .where((feature) => feature.isShowMain)
                      .toList();
                  return CategoryWithFeatures(
                    categoryId: category.categoryId,
                    categoryName: category.categoryName,
                    features: visibleFeatures,
                  );
                })
                .where((category) => category.features.isNotEmpty)
                .toList()
            : categories
                .map((category) {
                  // Filter features by permission AND isShowMain flag
                  final permittedFeatures = category.features
                      .where((feature) =>
                          permittedFeatureIds.contains(feature.featureId) &&
                          feature.isShowMain)
                      .toList();

                  return CategoryWithFeatures(
                    categoryId: category.categoryId,
                    categoryName: category.categoryName,
                    features: permittedFeatures,
                  );
                })
                .where((category) => category.features.isNotEmpty)
                .toList();

        if (categoriesWithFeatures.isEmpty) {
          return const _EmptyFeatures();
        }

        // Sort categories: Setting should be at the bottom, others alphabetically
        categoriesWithFeatures.sort((a, b) {
          if (a.categoryName == 'Setting') return 1;
          if (b.categoryName == 'Setting') return -1;
          return a.categoryName.compareTo(b.categoryName);
        });

        // Sort features within each category alphabetically
        for (final category in categoriesWithFeatures) {
          category.features.sort((a, b) => a.featureName.compareTo(b.featureName));
        }

        return Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Manual Library Card (always visible)
              const _LibraryCard(),

              // Categories (only with features)
              ...categoriesWithFeatures.map((category) => _CategorySection(
                    category: category,
                  ),),

              const SizedBox(height: TossSpacing.space10),
            ],
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

  @override
  Widget build(BuildContext context) {
    // Features are already filtered by isShowMain in FeatureGrid build method
    // No need for additional filtering here
    final visibleFeatures = category.features;

    // If no features, don't show the category
    if (visibleFeatures.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Text(
            category.categoryName,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Features List (only visible features)
          ...visibleFeatures.map((feature) {
            return _FeatureListItem(
              feature: feature,
              categoryId: category.categoryId,
            );
          }),
        ],
      ),
    );
  }
}

class _FeatureListItem extends ConsumerWidget {
  const _FeatureListItem({
    required this.feature,
    required this.categoryId,
  });

  final Feature feature;
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () async {
          // Get current company ID from app state
          final appState = ref.read(appStateProvider);
          final companyId = appState.companyChoosen;

          // Log feature click for analytics (non-blocking)
          if (companyId.isNotEmpty) {
            final repository = ref.read(homepageRepositoryProvider);
            // Fire and forget - don't await
            repository.logFeatureClick(
              featureId: feature.featureId,
              featureName: feature.featureName,
              companyId: companyId,
              categoryId: categoryId,
            );
          }

          // Navigate to feature route
          final route = feature.featureRoute.startsWith('/')
              ? feature.featureRoute
              : '/${feature.featureRoute}';
          context.push(route, extra: feature);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withOpacity(0.08),
        highlightColor: TossColors.primary.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space3,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: TossColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: DynamicIcon(
                    iconKey: feature.iconKey,
                    featureName: feature.featureName,
                    size: 20,
                    color: TossColors.gray700,
                    useDefaultColor: false,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Feature Name and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    if (feature.featureDescription != null &&
                        feature.featureDescription!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        feature.featureDescription!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontSize: 13,
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              const Icon(
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
              const Icon(
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
              const Icon(
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

/// Library Card - Manual card for Design Library
class _LibraryCard extends StatelessWidget {
  const _LibraryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Text(
            'Design System',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Library Feature Item
          Material(
            color: TossColors.transparent,
            child: InkWell(
              onTap: () {
                context.push('/library');
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              splashColor: TossColors.primary.withOpacity(0.08),
              highlightColor: TossColors.primary.withOpacity(0.04),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: TossSpacing.space3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: TossColors.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.palette_outlined,
                          size: 20,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),

                    // Feature Name
                    Expanded(
                      child: Text(
                        'Design Library',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: -0.4,
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),

                    // Arrow
                    const Icon(
                      Icons.chevron_right,
                      color: TossColors.textTertiary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
