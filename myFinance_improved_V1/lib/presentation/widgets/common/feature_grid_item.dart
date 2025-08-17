import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../toss/toss_card.dart';

/// Grid item widget for displaying features with icons
class FeatureGridItem extends ConsumerWidget {
  final Map<String, dynamic> feature;
  final VoidCallback? onTap;

  const FeatureGridItem({
    super.key,
    required this.feature,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = feature['name'] as String? ?? 'Unknown';
    final route = feature['route'] as String?;
    final iconKey = feature['icon_key'] as String?;
    final iconUrl = feature['icon_url'] as String?;
    final isActive = feature['is_active'] as bool? ?? true;
    
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: TossCard(
        onTap: isActive 
          ? (onTap ?? () {
              if (route != null) {
                context.push(route);
              }
            })
          : null,
        padding: EdgeInsets.all(TossSpacing.space3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: AppIcons.getIcon(
                  iconKey,
                  iconUrl: iconUrl,
                  size: 32,
                  color: TossColors.primary,
                ),
              ),
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Feature name
            Text(
              name,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Optional: Show status badge
            if (!isActive) ...[
              SizedBox(height: TossSpacing.space1),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Coming Soon',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// List tile version for features with icons
class FeatureListTile extends ConsumerWidget {
  final Map<String, dynamic> feature;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FeatureListTile({
    super.key,
    required this.feature,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = feature['name'] as String? ?? 'Unknown';
    final description = feature['description'] as String?;
    final route = feature['route'] as String?;
    final iconKey = feature['icon_key'] as String?;
    final iconUrl = feature['icon_url'] as String?;
    final isActive = feature['is_active'] as bool? ?? true;
    
    return Opacity(
      opacity: isActive ? 1.0 : 0.6,
      child: ListTile(
        onTap: isActive 
          ? (onTap ?? () {
              if (route != null) {
                context.push(route);
              }
            })
          : null,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: TossColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AppIcons.getIcon(
              iconKey,
              iconUrl: iconUrl,
              size: 24,
              color: isActive ? TossColors.primary : TossColors.gray400,
            ),
          ),
        ),
        title: Text(
          name,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? TossColors.gray900 : TossColors.gray500,
          ),
        ),
        subtitle: description != null
          ? Text(
              description,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
        trailing: trailing ?? (isActive 
          ? Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Soon',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontSize: 10,
                ),
              ),
            )),
      ),
    );
  }
}