import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
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

    return Scaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        backgroundColor: TossColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: TossColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          unreadCountAsync.when(
            data: (count) => count > 0
                ? TextButton(
                    onPressed: _markAllAsRead,
                    child: Text(
                      'Mark all read',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: TossColors.surface,
            child: TabBar(
              controller: _tabController,
              indicatorColor: TossColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: TossColors.primary,
              unselectedLabelColor: TossColors.textSecondary,
              labelStyle: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                const Tab(text: 'All'),
                Tab(
                  child: unreadCountAsync.when(
                    data: (count) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Unread'),
                        if (count > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            constraints: const BoxConstraints(minWidth: 18),
                            height: 18,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Center(
                              child: Text(
                                count > 99 ? '99+' : count.toString(),
                                style: TossTextStyles.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: TossColors.white,
                                  height: 1,
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
            ),
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
                child: OutlinedButton.icon(
                  onPressed: _markAllAsRead,
                  icon: const Icon(
                    Icons.done_all_rounded,
                    size: 18,
                  ),
                  label: const Text('Mark all as read'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TossColors.primary,
                    side: const BorderSide(color: TossColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                  ),
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
      loading: () => const Center(
        child: CircularProgressIndicator(color: TossColors.primary),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                ),
                child: const Icon(
                  Icons.notifications_off_outlined,
                  size: 36,
                  color: TossColors.error,
                ),
              ),
              const SizedBox(height: TossSpacing.space5),
              Text(
                'Failed to load notifications',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
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
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: Icon(
                isUnreadTab
                  ? Icons.check_circle_outline
                  : Icons.notifications_none_rounded,
                size: 48,
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
                fontWeight: FontWeight.w700,
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
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this notification?',
              style: TossTextStyles.body,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TossTextStyles.button.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: TossTextStyles.button.copyWith(
                    color: TossColors.error,
                  ),
                ),
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
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              'Delete',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: isRead ? TossColors.borderLight : TossColors.primary.withOpacity(0.3),
                width: isRead ? 1 : 2,
              ),
              boxShadow: isRead
                ? null
                : [
                    BoxShadow(
                      color: TossColors.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
            ),
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category icon with badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getCategoryColor(notification.category).withOpacity(0.15),
                            _getCategoryColor(notification.category).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      child: Icon(
                        _getCategoryIcon(notification.category),
                        size: 24,
                        color: _getCategoryColor(notification.category),
                      ),
                    ),
                    // Unread badge
                    if (!isRead)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: TossColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TossColors.surface,
                              width: 2,
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
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                                color: TossColors.textPrimary,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Body text
                      Text(
                        notification.body ?? '',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Time and category badge
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: TossColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeText,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                              fontSize: 11,
                            ),
                          ),
                          if (notification.category != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(notification.category).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getCategoryLabel(notification.category),
                                style: TossTextStyles.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
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
        return const Color(0xFF8B5CF6); // Purple
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
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              ),
              const SizedBox(width: 12),
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (success) {
        // Refresh data
        ref.invalidate(notificationsProvider(_filter));
        ref.invalidate(unreadNotificationCountProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: TossColors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text('All notifications marked as read'),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to mark all as read'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
        );
      }
    }
  }
}
