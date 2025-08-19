import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../providers/notification_provider.dart';

/// Debug page for testing and monitoring the notification system
class NotificationDebugPage extends ConsumerStatefulWidget {
  const NotificationDebugPage({super.key});

  @override
  ConsumerState<NotificationDebugPage> createState() => _NotificationDebugPageState();
}

class _NotificationDebugPageState extends ConsumerState<NotificationDebugPage> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications if not already done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(notificationProvider).isInitialized) {
        ref.read(notificationProvider.notifier).initialize();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final notificationNotifier = ref.read(notificationProvider.notifier);
    
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: const Text('Notification Debug'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.black,
        elevation: 0,
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(notificationState),
                  const SizedBox(height: 16),
                  _buildTokensCard(notificationState),
                  const SizedBox(height: 16),
                  _buildActionsCard(notificationNotifier),
                  const SizedBox(height: 16),
                  _buildSettingsCard(notificationState, notificationNotifier),
                  const SizedBox(height: 16),
                  _buildLogsCard(notificationNotifier),
                  const SizedBox(height: 16),
                  _buildStatisticsCard(notificationNotifier),
                  if (notificationState.error != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorCard(notificationState, notificationNotifier),
                  ],
                ],
              ),
            ),
    );
  }
  
  Widget _buildStatusCard(NotificationState state) {
    return _buildCard(
      title: 'System Status',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _buildStatusRow(
            'Initialized',
            state.isInitialized,
            state.isInitialized ? Icons.check_circle : Icons.cancel,
          ),
          const Divider(),
          _buildStatusRow(
            'Push Enabled',
            state.settings?.pushEnabled ?? false,
            state.settings?.pushEnabled ?? false 
                ? Icons.notifications_active 
                : Icons.notifications_off,
          ),
          const Divider(),
          _buildInfoRow('Platform', Theme.of(context).platform.name),
          const Divider(),
          _buildInfoRow(
            'Last Test',
            state.lastTestNotificationTime?.toString() ?? 'Never',
          ),
        ],
      ),
    );
  }
  
  Widget _buildTokensCard(NotificationState state) {
    return _buildCard(
      title: 'Tokens',
      icon: Icons.key,
      child: Column(
        children: [
          _buildTokenRow('FCM Token', state.fcmToken),
          if (Theme.of(context).platform == TargetPlatform.iOS) ...[
            const Divider(),
            _buildTokenRow('APNs Token', state.apnsToken),
          ],
        ],
      ),
    );
  }
  
  Widget _buildActionsCard(NotificationNotifier notifier) {
    return _buildCard(
      title: 'Actions',
      icon: Icons.play_arrow,
      child: Column(
        children: [
          _buildActionButton(
            'Send Test Notification',
            Icons.send,
            () => notifier.sendTestNotification(),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Refresh Tokens',
            Icons.refresh,
            () => notifier.refreshTokens(),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Export Logs',
            Icons.download,
            () => _exportLogs(notifier),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Clear Logs',
            Icons.delete_outline,
            () => _confirmClearLogs(notifier),
            isDestructive: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsCard(NotificationState state, NotificationNotifier notifier) {
    final settings = state.settings;
    
    if (settings == null) {
      return const SizedBox.shrink();
    }
    
    return _buildCard(
      title: 'Settings',
      icon: Icons.settings,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: settings.pushEnabled,
            onChanged: (value) => notifier.togglePushNotifications(value),
            activeColor: TossColors.blue,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Transaction Alerts'),
            value: settings.transactionAlerts,
            onChanged: (value) => notifier.toggleCategory('transaction', value),
            activeColor: TossColors.blue,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Reminders'),
            value: settings.reminders,
            onChanged: (value) => notifier.toggleCategory('reminder', value),
            activeColor: TossColors.blue,
          ),
        ],
      ),
    );
  }
  
  Widget _buildLogsCard(NotificationNotifier notifier) {
    final logs = notifier.getNotificationLogs();
    
    return _buildCard(
      title: 'Recent Logs (${logs.length})',
      icon: Icons.history,
      child: logs.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No logs available',
                style: TextStyle(color: TossColors.gray500),
              ),
            )
          : Column(
              children: logs.take(5).map((log) {
                return Column(
                  children: [
                    ListTile(
                      leading: _getLogIcon(log.type),
                      title: Text(log.title ?? log.type),
                      subtitle: Text(
                        log.timestamp.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        log.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getLogColor(log.type),
                        ),
                      ),
                    ),
                    if (logs.indexOf(log) < logs.length - 1) const Divider(),
                  ],
                );
              }).toList(),
            ),
    );
  }
  
  Widget _buildStatisticsCard(NotificationNotifier notifier) {
    final stats = notifier.getStatistics();
    
    return _buildCard(
      title: 'Statistics',
      icon: Icons.bar_chart,
      child: Column(
        children: [
          _buildStatRow('Total Logs', stats['total_logs']?.toString() ?? '0'),
          const Divider(),
          _buildStatRow('FCM Messages', stats['fcm_count']?.toString() ?? '0'),
          const Divider(),
          _buildStatRow('Test Messages', stats['test_count']?.toString() ?? '0'),
          const Divider(),
          _buildStatRow('Errors', stats['error_count']?.toString() ?? '0'),
        ],
      ),
    );
  }
  
  Widget _buildErrorCard(NotificationState state, NotificationNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: TossColors.red),
              const SizedBox(width: 8),
              const Text(
                'Error',
                style: TextStyle(
                  color: TossColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => notifier.clearError(),
                color: TossColors.red,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            state.error ?? '',
            style: const TextStyle(color: TossColors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: TossColors.gray700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusRow(String label, bool value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Text(
              value ? 'Active' : 'Inactive',
              style: TextStyle(
                color: value ? TossColors.green : TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 20,
              color: value ? TossColors.green : TossColors.gray500,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(color: TossColors.gray700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTokenRow(String label, String? token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            if (token != null)
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () => _copyToClipboard(token),
                color: TossColors.blue,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            token ?? 'Not available',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: TossColors.gray700,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? TossColors.red : TossColors.blue,
          foregroundColor: TossColors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TossColors.blue,
          ),
        ),
      ],
    );
  }
  
  Icon _getLogIcon(String type) {
    switch (type) {
      case 'FCM':
        return const Icon(Icons.cloud, color: TossColors.blue);
      case 'LOCAL':
        return const Icon(Icons.notifications, color: TossColors.green);
      case 'TEST':
        return const Icon(Icons.science, color: TossColors.orange);
      case 'ERROR':
        return const Icon(Icons.error, color: TossColors.red);
      default:
        return const Icon(Icons.info, color: TossColors.gray500);
    }
  }
  
  Color _getLogColor(String type) {
    switch (type) {
      case 'FCM':
        return TossColors.blue;
      case 'LOCAL':
        return TossColors.green;
      case 'TEST':
        return TossColors.orange;
      case 'ERROR':
        return TossColors.red;
      default:
        return TossColors.gray500;
    }
  }
  
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  void _exportLogs(NotificationNotifier notifier) {
    final logs = notifier.exportLogs();
    _copyToClipboard(logs);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logs exported to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  void _confirmClearLogs(NotificationNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Are you sure you want to clear all notification logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.clearLogs();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logs cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: TossColors.red),
            ),
          ),
        ],
      ),
    );
  }
}