import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/notifications/models/notification_db_model.dart';
import '../../../core/notifications/services/notification_service.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/toss_scaffold.dart';

/// Main notifications page for the app
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationDbModel> _notifications = [];
  Map<String, dynamic> _stats = {};
  int _unreadCount = 0;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadNotificationData();
  }
  
  Future<void> _loadNotificationData() async {
    setState(() => _isLoading = true);
    
    try {
      // Loading notification data...
      final notifications = await _notificationService.getUserNotifications(limit: 50);
      // Loaded ${notifications.length} notifications
      
      final stats = await _notificationService.getNotificationStats();
      // Stats loaded
      
      final unreadCount = await _notificationService.getUnreadNotificationCount();
      // Unread count loaded
      
      setState(() {
        _notifications = notifications;
        _stats = stats;
        _unreadCount = unreadCount;
      });
    } catch (e) {
      // Error loading notification data: $e
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Notifications',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_unreadCount > 0) ...[
              SizedBox(width: TossSpacing.space2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: TossColors.surface,
        foregroundColor: TossColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadNotificationData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotificationData,
        color: TossColors.primary,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // Database Stats Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: _buildDatabaseStatsCard(),
                    ),
                  ),
                  
                  // Notifications List
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      child: _buildNotificationsList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildDatabaseStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.xl)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.micro),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  'Statistics',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Total', _stats['total']?.toString() ?? '0', TossColors.primary),
                ),
                Expanded(
                  child: _buildStatItem('Unread', _stats['unread']?.toString() ?? '0', Colors.red),
                ),
                Expanded(
                  child: _buildStatItem('Today', _stats['today']?.toString() ?? '0', Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TossTextStyles.h2.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildNotificationsList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.xl)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.micro),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  'Recent Notifications',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space4),
            if (_notifications.isEmpty)
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: TossColors.textSecondary),
                    SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        'No notifications yet. Your notifications will appear here.',
                        style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _notifications.map((notification) => _buildNotificationItem(notification)).toList(),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationItem(NotificationDbModel notification) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: notification.isRead ? TossColors.gray50 : TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: notification.isRead ? TossColors.borderLight : TossColors.primary.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: notification.isRead ? null : () => _markAsRead(notification.id ?? ''),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title ?? 'Notification',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                          color: TossColors.textPrimary,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: TossColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  notification.body ?? '',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                Row(
                  children: [
                    if (notification.category != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Text(
                          notification.category!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                    ],
                    Text(
                      _formatDateTime(notification.createdAt ?? DateTime.now()),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (!notification.isRead)
                      Text(
                        'Tap to mark as read',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> _markAsRead(String notificationId) async {
    final success = await _notificationService.markNotificationAsRead(notificationId);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('📖 Notification marked as read'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
        ),
      );
      _loadNotificationData(); // Refresh the list
      // Also refresh the unread count provider for the homepage badge
      ref.invalidate(unreadNotificationCountProvider);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('❌ Failed to mark as read'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
        ),
      );
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now(); // Local device time
    
    // Simple approach: treat database UTC time as if it's in the same timezone
    final dbAsLocal = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
    
    final difference = now.difference(dbAsLocal);
    
    // Handle time formatting
    if (difference.isNegative) {
      return 'Just now';
    } else if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}