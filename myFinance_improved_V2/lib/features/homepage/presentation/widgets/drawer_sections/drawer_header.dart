import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Header section of the modern bottom drawer
class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, 0, TossSpacing.paddingXL, TossSpacing.paddingXL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Profile Section - Clickable to navigate to My Page
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close drawer first
                context.push('/myPage');
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                child: Row(
                  children: [
                    // ✅ Profile Image (type-safe)
                    CircleAvatar(
                      radius: TossSpacing.paddingXL,
                      backgroundImage: userData?['profile_image'] != null && (userData!['profile_image'] as String).isNotEmpty
                          ? NetworkImage(userData!['profile_image'] as String)
                          : null,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: userData?['profile_image'] == null || (userData!['profile_image'] as String).isEmpty
                          ? Text(
                              userData?['user_first_name'] != null && (userData!['user_first_name'] as String).isNotEmpty
                                ? (userData!['user_first_name'] as String)[0]
                                : 'U',
                              style: TossTextStyles.h3.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: TossSpacing.space4),

                    // ✅ User Info (type-safe)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userData != null
                                  ? '${userData!['user_first_name'] ?? ''} ${userData!['user_last_name'] ?? ''}'.trim()
                                  : 'User',
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Icon(
                                Icons.chevron_right,
                                size: TossSpacing.iconXS,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space1/2),
                          Text(
                            'View profile • ${(userData?['companies'] as List?)?.length ?? 0} companies',
                            style: TossTextStyles.caption.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Close Button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
