import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/constants/icon_mapper.dart';
import '../models/homepage_models.dart';
import '../../../widgets/toss/toss_card.dart';
import '../providers/homepage_providers.dart';

class QuickAccessSection extends ConsumerWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topFeaturesAsync = ref.watch(topFeaturesByUserProvider);

    return topFeaturesAsync.when(
      data: (topFeatures) {
        if (topFeatures.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(
                children: [
                  Text(
                    'Quick Actions',
                    style: TossTextStyles.h3,
                  ),
                  const Spacer(),
                  if (topFeatures.length > 6)
                    TextButton(
                      onPressed: () => _showAllFeaturesBottomSheet(context, ref),
                      child: Text(
                        'More ›',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              
              // Grid layout for features (2 rows, 3 columns)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: TossSpacing.space3,
                  mainAxisSpacing: TossSpacing.space3,
                ),
                itemCount: topFeatures.length > 6 ? 6 : topFeatures.length, // Limit to 6 items
                itemBuilder: (context, index) {
                  final feature = topFeatures[index];
                  return QuickAccessFeatureCard(
                    feature: feature,
                    onTap: () => _navigateToFeature(context, feature.route, ref),
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(), // Don't show loading for quick access
      error: (error, stackTrace) => const SizedBox.shrink(), // Fail silently
    );
  }

  void _navigateToFeature(BuildContext context, String route, WidgetRef ref) {
    // Navigate to feature
    // The route from the database should match the route defined in app_router.dart
    // For example: "attendance", "timetableManage", "cashEnding", etc.
    context.push('/$route');
    
    // TODO: Track feature click here if needed
    // final user = ref.read(authStateProvider);
    // if (user != null) {
    //   ref.read(featureRepositoryProvider).trackFeatureClick(
    //     userId: user.id,
    //     featureId: feature.featureId,
    //   );
    // }
  }

  void _showAllFeaturesBottomSheet(BuildContext context, WidgetRef ref) {
    final topFeatures = ref.read(topFeaturesByUserProvider).valueOrNull ?? [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Text(
                    'All Quick Access Features',
                    style: TossTextStyles.h3,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Feature list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(TossSpacing.space4),
                itemCount: topFeatures.length,
                separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space2),
                itemBuilder: (context, index) {
                  final feature = topFeatures[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: feature.icon,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 40,
                          height: 40,
                          color: TossColors.gray100,
                          child: const Icon(Icons.apps, color: TossColors.gray500),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 40,
                          height: 40,
                          color: TossColors.gray100,
                          child: const Icon(Icons.apps, color: TossColors.gray500),
                        ),
                      ),
                    ),
                    title: Text(
                      feature.featureName,
                      style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Used ${feature.clickCount} times',
                      style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: TossColors.gray400),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToFeature(context, feature.route, ref);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessFeatureCard extends StatelessWidget {
  final TopFeature feature;
  final VoidCallback onTap;
  
  const QuickAccessFeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature icon from database - Using Toss blue theme
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TossColors.primary.withAlpha(26),  // Light blue background (10% opacity)
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                IconMapper.getIcon(feature.iconKey),
                size: 26,
                color: TossColors.primary,  // Toss Blue #0064FF
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          
          // Feature name
          Text(
            feature.featureName,
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray900,  // Use proper text color from theme
              fontSize: 13,  // Slightly larger for better readability
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}