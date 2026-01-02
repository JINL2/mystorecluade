import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      child: _buildSquareAvatar(ref),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        companyName,
                                        style: TossTextStyles.bodyLarge.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: TossColors.textPrimary,
                                          height: 1.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    SubscriptionBadge.fromPlanType(
                                      appState.planType,
                                      compact: true,
                                    ),
                                  ],
                                ),
                                Text(
                                  storeName,
                                  style: TossTextStyles.caption.copyWith(
                                    fontSize: 13,
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
                            padding: const EdgeInsets.only(left: 5),
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
            const SizedBox(width: 13),
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
                const SizedBox(width: 13),
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

  Widget _buildSquareAvatar(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final profileImage = appState.user['profile_image'] as String? ?? '';

    if (profileImage.isNotEmpty) {
      return Image.network(
        profileImage,
        width: 33,
        height: 33,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildAvatarFallback(ref);
        },
      );
    }

    return _buildAvatarFallback(ref);
  }

  Widget _buildAvatarFallback(WidgetRef ref) {
    return Container(
      width: 33,
      height: 33,
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Center(
        child: Text(
          _getUserInitials(ref),
          style: TossTextStyles.caption.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getUserInitials(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final firstName = appState.user['user_first_name'] as String? ?? '';
    final lastName = appState.user['user_last_name'] as String? ?? '';

    if (firstName.isEmpty && lastName.isEmpty) return 'U';

    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';

    if (firstInitial.isNotEmpty && lastInitial.isNotEmpty) {
      return '$firstInitial$lastInitial';
    } else if (firstInitial.isNotEmpty) {
      return firstInitial;
    } else if (lastInitial.isNotEmpty) {
      return lastInitial;
    }

    return 'U';
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
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    badgeCount.toString(),
                    style: TossTextStyles.caption.copyWith(
                      fontSize: 9,
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
