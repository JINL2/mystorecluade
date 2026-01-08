import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../notifications/presentation/providers/notification_provider.dart';
import '../company_store_selector.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Homepage header widget with company/store selector and actions
///
/// Displays:
/// - User avatar
/// - Company/Store names with subscription badge
/// - Notification bell with unread count
/// - Profile menu
class HomepageHeader extends ConsumerWidget {
  final VoidCallback onProfileMenuTap;
  final Future<void> Function() onLogout;

  const HomepageHeader({
    super.key,
    required this.onProfileMenuTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    final companyName = appState.companyName.isNotEmpty
        ? appState.companyName
        : 'Select Company';
    final storeName = appState.storeName.isNotEmpty
        ? appState.storeName
        : 'Select Store';

    return SliverToBoxAdapter(
      child: Container(
        height: 83,
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border(
            bottom: BorderSide(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left: Avatar + Company/Store selector
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showCompanyStoreDrawer(context),
                child: Row(
                  children: [
                    EmployeeProfileAvatar(
                      imageUrl: appState.user['profile_image'] as String?,
                      name: '${appState.user['user_first_name'] ?? ''} ${appState.user['user_last_name'] ?? ''}'.trim(),
                      size: 33,
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  companyName,
                                  style: TossTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: TossColors.textPrimary,
                                    height: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  storeName,
                                  style: TossTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: TossColors.textSecondary,
                                    height: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: TossSpacing.space1 + 1),
                            child: Icon(
                              Icons.keyboard_arrow_up_rounded,
                              size: 20,
                              color: TossColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            // Right: Notification + Menu
            Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
                    final unreadCount = unreadCountAsync.when(
                      data: (count) => count,
                      loading: () => 0,
                      error: (_, __) => 0,
                    );

                    return _IconGhost(
                      icon: Icons.notifications_none_rounded,
                      showBadge: unreadCount > 0,
                      badgeCount: unreadCount,
                      onTap: () => context.push('/notifications'),
                    );
                  },
                ),
                const SizedBox(width: TossSpacing.space3),
                _IconGhost(
                  icon: Icons.more_horiz_rounded,
                  showBadge: false,
                  onTap: onProfileMenuTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompanyStoreDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const CompanyStoreSelector(),
    );
  }
}

/// Icon button with optional badge
class _IconGhost extends StatelessWidget {
  final IconData icon;
  final bool showBadge;
  final int badgeCount;
  final VoidCallback onTap;

  const _IconGhost({
    required this.icon,
    required this.showBadge,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 24,
              color: TossColors.textPrimary,
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                constraints: const BoxConstraints(minWidth: 15),
                height: 15,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1 - 1),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: TossTextStyles.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
