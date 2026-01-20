import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_opacity.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../core/notifications/models/notification_db_model.dart';
import '../../../../core/notifications/repositories/notification_repository.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NotificationFilter _filter = const NotificationFilter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // All notifications
          if (_tabController.index == 0) {
            _filter = const NotificationFilter();
          }
          // Unread notifications
          else {
            _filter = const NotificationFilter(isRead: false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: 'Notifications',
        backgroundColor: TossColors.white,
        actions: [
          unreadCountAsync.when(
            data: (count) => count > 0
                ? TossButton.textButton(
                    text: 'Mark all read',
                    onPressed: _markAllAsRead,
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(TossDimensions.tabBarHeight),
          child: TossTabBar.custom(
            tabs: [
              const TossTab.text('All'),
              TossTab.custom(
                unreadCountAsync.when(
                  data: (count) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Unread'),
                      if (count > 0) ...[
                        const SizedBox(width: TossSpacing.space1_5),
                        Container(
                          constraints: const BoxConstraints(minWidth: TossDimensions.badgeMinWidth),
                          height: TossDimensions.badgeHeight,
                          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                          decoration: BoxDecoration(
                            color: TossColors.primary,
                            borderRadius: BorderRadius.circular(TossBorderRadius.full),
                          ),
                          child: Center(
                            child: Text(
                              count > 99 ? '99+' : count.toString(),
                              style: TossTextStyles.micro.copyWith(
                                fontWeight: TossFontWeight.bold,
                                color: TossColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  loading: () => const Text('Unread'),
                  error: (_, __) => const Text('Unread'),
                ),
              ),
            ],
            controller: _tabController,
          ),
        ),
      ),
      body: _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    final notificationsAsync = ref.watch(notificationsProvider(_filter));
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
    final isUnreadTab = _tabController.index == 1;

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Mark all as read button (only show in Unread tab)
            if (isUnreadTab && unreadCountAsync.maybeWhen(
              data: (count) => count > 0,
              orElse: () => false,
            ))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                color: TossColors.surface,
                child: TossButton.outlined(
                  text: 'Mark all as read',
                  onPressed: _markAllAsRead,
                  leadingIcon: const Icon(Icons.done_all_rounded, size: TossSpacing.iconSM),
                  fullWidth: true,
                ),
              ),

            // Notifications list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(notificationsProvider(_filter));
                },
                color: TossColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                      child: _buildNotificationCard(notification),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const TossLoadingView(),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: TossDimensions.errorIconSize,
                height: TossDimensions.errorIconSize,
                decoration: BoxDecoration(
                  color: TossColors.error.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                ),
                child: const Icon(
                  Icons.notifications_off_outlined,
                  size: TossSpacing.iconXL,
                  color: TossColors.error,
                ),
              ),
              const SizedBox(height: TossSpacing.space5),
              Text(
                'Failed to load notifications',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: TossFontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Please try again later',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isUnreadTab = _tabController.index == 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: TossSpacing.space24,
              height: TossSpacing.space24,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: Icon(
                isUnreadTab
                  ? Icons.check_circle_outline
                  : Icons.notifications_none_rounded,
                size: TossSpacing.iconXXL,
                color: TossColors.textTertiary,
              ),
            ),
            const SizedBox(height: TossSpacing.space5),
            Text(
              isUnreadTab
                ? 'All caught up!'
                : 'No notifications yet',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
                fontWeight: TossFontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              isUnreadTab
                ? 'You have no unread notifications'
                : 'You\'ll receive notifications here',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationDbModel notification) {
    final isRead = notification.isRead;
    final createdAt = notification.createdAt ?? DateTime.now();
    final timeText = _formatTime(createdAt);

    return Dismissible(
      key: Key(notification.id ?? ''),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            title: Text(
              'Delete notification',
              style: TossTextStyles.h4.copyWith(
                fontWeight: TossFontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this notification?',
              style: TossTextStyles.body,
            ),
            actions: [
              TossButton.textButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(false),
                textColor: TossColors.textSecondary,
              ),
              TossButton.textButton(
                text: 'Delete',
                onPressed: () => Navigator.of(context).pop(true),
                textColor: TossColors.error,
              ),
            ],
          ),
        ) ?? false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: TossSpacing.space5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline,
              color: TossColors.white,
              size: TossSpacing.iconLG,
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              'Delete',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.white,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => _handleNotificationTap(notification),
        child: TossCard(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: TossSpacing.iconXXL,
                    height: TossSpacing.iconXXL,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor(notification.category).withValues(alpha: TossOpacity.medium),
                          _getCategoryColor(notification.category).withValues(alpha: TossOpacity.subtle),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Icon(
                      _getCategoryIcon(notification.category),
                      size: TossSpacing.iconLG,
                      color: _getCategoryColor(notification.category),
                    ),
                  ),
                  // Unread badge
                  if (!isRead)
                    Positioned(
                      top: -TossSpacing.space1,
                      right: -TossSpacing.space1,
                      child: Container(
                        width: TossDimensions.statusDotMD,
                        height: TossDimensions.statusDotMD,
                        decoration: BoxDecoration(
                          color: TossColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: TossColors.surface,
                            width: TossDimensions.dividerThicknessBold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: TossSpacing.space3),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and time
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title ?? 'Notification',
                            style: TossTextStyles.bodyMedium.copyWith(
                              fontWeight: isRead ? TossFontWeight.semibold : TossFontWeight.bold,
                              color: TossColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space1_5),
                    // Body text
                    Text(
                      notification.body ?? '',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    // Time and category badge
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: TossSpacing.iconXS,
                          color: TossColors.textTertiary,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          timeText,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        if (notification.category != null) ...[
                          const SizedBox(width: TossSpacing.space2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space1_5,
                              vertical: TossSpacing.space0_5,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(notification.category).withValues(alpha: TossOpacity.light),
                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                            ),
                            child: Text(
                              _getCategoryLabel(notification.category),
                              style: TossTextStyles.micro.copyWith(
                                fontWeight: TossFontWeight.semibold,
                                color: _getCategoryColor(notification.category),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'transaction':
        return Icons.receipt_long_outlined;
      case 'shift_reminder':
        return Icons.schedule_outlined;
      case 'security':
        return Icons.shield_outlined;
      case 'system':
        return Icons.info_outlined;
      case 'announcement':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'transaction':
        return TossColors.success;
      case 'shift_reminder':
        return TossColors.warning;
      case 'security':
        return TossColors.error;
      case 'system':
        return TossColors.primary;
      case 'announcement':
        return TossColors.violet;
      default:
        return TossColors.textSecondary;
    }
  }

  String _getCategoryLabel(String? category) {
    switch (category) {
      case 'transaction':
        return 'Transaction';
      case 'shift_reminder':
        return 'Reminder';
      case 'security':
        return 'Security';
      case 'system':
        return 'System';
      case 'announcement':
        return 'News';
      default:
        return 'General';
    }
  }

  Future<void> _handleNotificationTap(NotificationDbModel notification) async {
    final repository = ref.read(notificationRepositoryProvider);

    // Mark as read if not already read
    if (!notification.isRead) {
      await repository.markAsRead(notification.id ?? '');
      // Invalidate providers to refresh UI
      ref.invalidate(notificationsProvider(_filter));
      ref.invalidate(unreadNotificationCountProvider);
    }

    // Handle action URL or navigation
    if (notification.actionUrl != null && notification.actionUrl!.isNotEmpty) {
      if (mounted) {
        context.push(notification.actionUrl!);
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final repository = ref.read(notificationRepositoryProvider);
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    // Show loading
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              TossLoadingView.inline(size: TossSpacing.iconSM2, color: TossColors.white),
              const SizedBox(width: TossSpacing.space3),
              const Text('Marking all as read...'),
            ],
          ),
          backgroundColor: TossColors.textPrimary,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    final success = await repository.markAllAsRead(userId);

    if (mounted) {
      TossToast.hide(context);

      if (success) {
        // Refresh data
        ref.invalidate(notificationsProvider(_filter));
        ref.invalidate(unreadNotificationCountProvider);

        TossToast.success(context, 'All notifications marked as read');
      } else {
        TossToast.error(context, 'Failed to mark all as read');
      }
    }
  }
}
