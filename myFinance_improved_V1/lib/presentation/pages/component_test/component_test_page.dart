import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/notifications/models/notification_db_model.dart';
import '../../../core/notifications/services/notification_service.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/toss_scaffold.dart';

/// Debug page for testing and monitoring the notification system
class ComponentTestPage extends ConsumerStatefulWidget {
  const ComponentTestPage({super.key});

  @override
  ConsumerState<ComponentTestPage> createState() => _ComponentTestPageState();
}

class _ComponentTestPageState extends ConsumerState<ComponentTestPage> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationDbModel> _notifications = [];
  Map<String, dynamic> _stats = {};
  int _unreadCount = 0;
  bool _isLoadingHistory = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize notifications if not already done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(notificationProvider).isInitialized) {
        ref.read(notificationProvider.notifier).initialize();
      }
      _loadNotificationData();
    });
  }
  
  Future<void> _loadNotificationData() async {
    setState(() => _isLoadingHistory = true);
    
    try {
      // Loading notification data...
      final notifications = await _notificationService.getUserNotifications(limit: 10);
      // Loaded ${notifications.length} notifications
      
      final stats = await _notificationService.getNotificationStats();
      // Stats loaded
      
      final unreadCount = await _notificationService.getUnreadNotificationCount();
      // Unread count: $unreadCount
      
      setState(() {
        _notifications = notifications;
        _stats = stats;
        _unreadCount = unreadCount;
      });
    } catch (e) {
      // Error loading notification data: $e
    } finally {
      setState(() => _isLoadingHistory = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final notificationNotifier = ref.read(notificationProvider.notifier);
    
    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: const Text('🔔 Notification Test'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.black,
        elevation: 0,
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(notificationState),
                  SizedBox(height: TossSpacing.space4),
                  _buildTokensCard(notificationState),
                  SizedBox(height: TossSpacing.space4),
                  _buildDatabaseStatsCard(),
                  SizedBox(height: TossSpacing.space4),
                  _buildTestActionsCard(notificationNotifier),
                  SizedBox(height: TossSpacing.space4),
                  _buildNotificationHistoryCard(notificationState),
                  SizedBox(height: TossSpacing.space4),
                  _buildDebugInfoCard(notificationState),
                ],
              ),
            ),
    );
  }
  
  Widget _buildStatusCard(NotificationState state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  state.isInitialized ? Icons.check_circle : Icons.error,
                  color: state.isInitialized ? Colors.green : Colors.red,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'System Status',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            _buildStatusRow('Notification Service', state.isInitialized),
            _buildStatusRow('Firebase Connected', state.fcmToken != null),
            _buildStatusRow('Local Notifications', state.isInitialized),
            _buildStatusRow('Permissions Granted', state.isInitialized),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusRow(String label, bool status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TossTextStyles.body),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: status ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status ? 'Active' : 'Inactive',
              style: TossTextStyles.caption.copyWith(
                color: status ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTokensCard(NotificationState state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.token, color: TossColors.primary),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Device Tokens',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            if (state.fcmToken != null) ...[
              Text('FCM Token:', style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: TossSpacing.space1),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: state.fcmToken!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('FCM Token copied to clipboard')),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TossColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.fcmToken!.length > 50 
                            ? '${state.fcmToken!.substring(0, 50)}...' 
                            : state.fcmToken!,
                          style: TossTextStyles.caption.copyWith(fontFamily: 'monospace'),
                        ),
                      ),
                      Icon(Icons.copy, size: 16, color: TossColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        'No FCM token available. This is normal on iOS simulator.',
                        style: TossTextStyles.body.copyWith(color: Colors.orange[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestActionsCard(NotificationNotifier notifier) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.play_arrow, color: Colors.blue),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Test Actions',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _sendTestNotification(notifier),
                icon: const Icon(Icons.notifications),
                label: const Text('Send Test Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _sendScheduledNotification(notifier),
                icon: const Icon(Icons.schedule),
                label: const Text('Schedule Notification (5s)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _testPermissions(notifier),
                icon: const Icon(Icons.security),
                label: const Text('Test Permissions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loadNotificationData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Database'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationHistoryCard(NotificationState state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.purple),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Recent Notifications',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (_unreadCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_unreadCount',
                      style: TossTextStyles.caption.copyWith(color: Colors.white),
                    ),
                  ),
                SizedBox(width: TossSpacing.space2),
                IconButton(
                  onPressed: _loadNotificationData,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            if (_isLoadingHistory)
              const Center(child: CircularProgressIndicator())
            else if (_notifications.isEmpty)
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: TossColors.textSecondary),
                    SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        'No notifications found. Send a test notification to see it appear here.',
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
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: notification.isRead ? TossColors.gray50 : TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification.isRead ? TossColors.borderLight : TossColors.primary.withOpacity(0.2),
        ),
      ),
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
                  ),
                ),
              ),
              if (!notification.isRead)
                GestureDetector(
                  onTap: () => _markAsRead(notification.id ?? ''),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Mark Read',
                      style: TossTextStyles.small.copyWith(color: TossColors.white),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            notification.body ?? '',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Row(
            children: [
              if (notification.category != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    notification.category!,
                    style: TossTextStyles.small.copyWith(color: Colors.blue),
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
              ],
              Text(
                _formatDateTime(notification.createdAt ?? DateTime.now()),
                style: TossTextStyles.small.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDebugInfoCard(NotificationState state) {
    final debugInfo = _notificationService.getDebugInfo();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, color: Colors.red),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Debug Information',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            _buildDebugRow('Initialized', state.isInitialized.toString()),
            _buildDebugRow('Loading', state.isLoading.toString()),
            _buildDebugRow('Has FCM Token', (state.fcmToken != null).toString()),
            _buildDebugRow('Has APNs Token', (state.apnsToken != null).toString()),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Supabase Authentication:',
              style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            _buildDebugRow('Auth User Exists', debugInfo['auth_user_exists']?.toString() ?? 'false'),
            _buildDebugRow('User ID', debugInfo['user_id']?.toString() ?? 'null'),
            _buildDebugRow('User Email', debugInfo['user_email']?.toString() ?? 'null'),
            _buildDebugRow('Session Exists', debugInfo['auth_session_exists']?.toString() ?? 'false'),
            _buildDebugRow('Last Test Time', state.lastTestNotificationTime?.toString() ?? 'Never'),
            _buildDebugRow('Error Message', state.error ?? 'None'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDebugRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.caption.copyWith(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
  
  void _sendTestNotification(NotificationNotifier notifier) async {
    try {
      await notifier.sendTestNotification();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Test notification sent and stored in database!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Refresh notification data after sending
      Future.delayed(const Duration(milliseconds: 500), () {
        _loadNotificationData();
        // Also refresh the unread count provider for the homepage badge
        ref.invalidate(unreadNotificationCountProvider);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to send notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _sendScheduledNotification(NotificationNotifier notifier) async {
    try {
      // For now, just send another test notification as scheduling isn't available
      await notifier.sendTestNotification();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏰ Test notification sent! (Scheduling feature can be added)'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to send notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _testPermissions(NotificationNotifier notifier) async {
    try {
      await notifier.initialize();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔐 Permission check completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Permission test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Widget _buildDatabaseStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: Colors.indigo),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Database Statistics',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Total', _stats['total']?.toString() ?? '0', Colors.blue),
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
  
  Future<void> _markAsRead(String notificationId) async {
    final success = await _notificationService.markNotificationAsRead(notificationId);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📖 Notification marked as read'),
          backgroundColor: Colors.green,
        ),
      );
      _loadNotificationData(); // Refresh the list
      // Also refresh the unread count provider for the homepage badge
      ref.invalidate(unreadNotificationCountProvider);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to mark as read'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now(); // Local device time
    
    // Simple approach: treat database UTC time as if it's in the same timezone
    // Create a local DateTime with the same values as the UTC time
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
    
    // Debug information available in debug mode
    
    // Handle time formatting
    if (difference.isNegative) {
      // WARNING: Negative time difference detected
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