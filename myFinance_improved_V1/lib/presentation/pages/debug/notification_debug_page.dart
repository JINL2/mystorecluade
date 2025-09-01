import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/notifications/services/notification_service.dart';
import '../../../core/notifications/services/fcm_service.dart';
import '../../../core/notifications/repositories/notification_repository.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_card.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_border_radius.dart';

class NotificationDebugPage extends ConsumerStatefulWidget {
  const NotificationDebugPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationDebugPage> createState() => _NotificationDebugPageState();
}

class _NotificationDebugPageState extends ConsumerState<NotificationDebugPage> {
  final _notificationService = NotificationService();
  final _fcmService = FcmService();
  final _repository = NotificationRepository();
  final _supabase = Supabase.instance.client;
  
  Map<String, dynamic> _debugInfo = {};
  List<Map<String, dynamic>> _savedTokens = [];
  bool _isLoading = true;
  String _statusMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }
  
  Future<void> _loadDebugInfo() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading debug information...';
    });
    
    try {
      // Get debug info from notification service
      final debugInfo = _notificationService.getDebugInfo();
      
      // Load saved tokens from Supabase
      final userId = _supabase.auth.currentUser?.id;
      List<Map<String, dynamic>> savedTokens = [];
      
      if (userId != null) {
        final response = await _supabase
            .from('user_fcm_tokens')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        
        savedTokens = List<Map<String, dynamic>>.from(response ?? []);
      }
      
      setState(() {
        _debugInfo = debugInfo;
        _savedTokens = savedTokens;
        _isLoading = false;
        _statusMessage = 'Debug information loaded successfully';
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error loading debug info: $e';
      });
    }
  }
  
  Future<void> _initializeNotifications() async {
    setState(() {
      _statusMessage = 'Initializing notification service...';
    });
    
    try {
      await _notificationService.initialize();
      setState(() {
        _statusMessage = '✅ Notification service initialized successfully';
      });
      await _loadDebugInfo();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Failed to initialize: $e';
      });
    }
  }
  
  Future<void> _storeFcmToken() async {
    setState(() {
      _statusMessage = 'Storing FCM token in Supabase...';
    });
    
    try {
      final token = _fcmService.fcmToken;
      final userId = _supabase.auth.currentUser?.id;
      
      if (token == null) {
        setState(() {
          _statusMessage = '❌ No FCM token available';
        });
        return;
      }
      
      if (userId == null) {
        setState(() {
          _statusMessage = '❌ User not authenticated';
        });
        return;
      }
      
      final result = await _repository.storeOrUpdateFcmToken(
        userId: userId,
        token: token,
        platform: 'ios', // or 'android' based on platform
        deviceId: 'debug_device_${DateTime.now().millisecondsSinceEpoch}',
        deviceModel: 'Debug Device',
        appVersion: '1.0.0',
      );
      
      if (result != null) {
        setState(() {
          _statusMessage = '✅ FCM token stored successfully';
        });
        await _loadDebugInfo();
      } else {
        setState(() {
          _statusMessage = '❌ Failed to store FCM token';
        });
      }
      
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error storing token: $e';
      });
    }
  }
  
  Future<void> _sendTestNotification() async {
    setState(() {
      _statusMessage = 'Sending test notification...';
    });
    
    try {
      await _notificationService.sendTestNotification();
      setState(() {
        _statusMessage = '✅ Test notification sent';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Failed to send test notification: $e';
      });
    }
  }
  
  Future<void> _verifySupabaseConnection() async {
    setState(() {
      _statusMessage = 'Verifying Supabase connection...';
    });
    
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          _statusMessage = '❌ Not authenticated with Supabase';
        });
        return;
      }
      
      // Try to query the notifications table
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .limit(1);
      
      setState(() {
        _statusMessage = '✅ Supabase connection verified';
      });
      
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Supabase connection error: $e';
      });
    }
  }
  
  Future<void> _cleanupOldTokens() async {
    setState(() {
      _statusMessage = 'Cleaning up old tokens...';
    });
    
    try {
      final result = await _repository.cleanupOldTokens(daysOld: 30);
      
      setState(() {
        _statusMessage = result 
            ? '✅ Old tokens cleaned up successfully'
            : '❌ Failed to cleanup old tokens';
      });
      
      await _loadDebugInfo();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error during cleanup: $e';
      });
    }
  }
  
  Future<void> _markAllNotificationsAsRead() async {
    setState(() {
      _statusMessage = 'Marking all notifications as read...';
    });
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _statusMessage = '❌ User not authenticated';
        });
        return;
      }
      
      // Update all unread notifications for this user
      final now = DateTime.now().toUtc();
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('is_read', false);
      
      setState(() {
        _statusMessage = '✅ All notifications marked as read';
      });
      
      await _loadDebugInfo();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error marking notifications as read: $e';
      });
    }
  }
  
  Future<void> _forceTokenRefresh() async {
    setState(() {
      _statusMessage = 'Forcing FCM token refresh...';
    });
    
    try {
      // Delete current token to force refresh
      await _fcmService.deleteToken();
      
      // Wait a moment
      await Future.delayed(const Duration(seconds: 1));
      
      // Reinitialize to get new token
      await _fcmService.initialize();
      
      // Get the new token
      final newToken = _fcmService.fcmToken;
      
      if (newToken != null) {
        // Store the new token
        final userId = _supabase.auth.currentUser?.id;
        if (userId != null) {
          await _repository.storeOrUpdateFcmToken(
            userId: userId,
            token: newToken,
            platform: Platform.isIOS ? 'ios' : 'android',
            deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
            deviceModel: 'Refreshed Device',
            appVersion: '1.0.0',
          );
        }
        
        setState(() {
          _statusMessage = '✅ Token refreshed and stored successfully';
        });
        
        await _loadDebugInfo();
      } else {
        setState(() {
          _statusMessage = '❌ Failed to get new token';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error refreshing token: $e';
      });
    }
  }
  
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Notification Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDebugInfo,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: TossLoadingView())
          : SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Message
                  if (_statusMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(TossSpacing.paddingSM),
                      margin: EdgeInsets.only(bottom: TossSpacing.marginMD),
                      decoration: BoxDecoration(
                        color: _statusMessage.startsWith('✅')
                            ? TossColors.success.withValues(alpha: 0.1)
                            : _statusMessage.startsWith('❌')
                                ? TossColors.error.withValues(alpha: 0.1)
                                : TossColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        boxShadow: TossShadows.elevation1,
                        border: Border.all(
                          color: _statusMessage.startsWith('✅')
                              ? TossColors.success
                              : _statusMessage.startsWith('❌')
                                  ? TossColors.error
                                  : TossColors.primary,
                        ),
                      ),
                      child: Text(
                        _statusMessage,
                        style: TossTextStyles.labelLarge.copyWith(
                          color: _statusMessage.startsWith('✅')
                              ? TossColors.success
                              : _statusMessage.startsWith('❌')
                                  ? TossColors.error
                                  : TossColors.primary,
                        ),
                      ),
                    ),
                  
                  // Action Buttons
                  Wrap(
                    spacing: TossSpacing.gapSM,
                    runSpacing: TossSpacing.gapSM,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _initializeNotifications,
                        icon: const Icon(Icons.start),
                        label: const Text('Initialize Service'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _storeFcmToken,
                        icon: const Icon(Icons.save),
                        label: const Text('Store Token'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _sendTestNotification,
                        icon: const Icon(Icons.notifications),
                        label: const Text('Send Test'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _verifySupabaseConnection,
                        icon: const Icon(Icons.cloud_done),
                        label: const Text('Verify Supabase'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _forceTokenRefresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Token'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.warning,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _cleanupOldTokens,
                        icon: const Icon(Icons.cleaning_services),
                        label: const Text('Cleanup Tokens'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _markAllNotificationsAsRead,
                        icon: const Icon(Icons.mark_email_read),
                        label: const Text('Mark All Read'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.success,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: TossSpacing.space6),
                  
                  // Debug Information
                  _buildSection(
                    'Debug Information',
                    _debugInfo.entries.map((e) => _buildInfoRow(
                      e.key.replaceAll('_', ' ').toUpperCase(),
                      e.value?.toString() ?? 'null',
                      canCopy: e.key.contains('token') || e.key.contains('id'),
                    )).toList(),
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // Saved Tokens
                  _buildSection(
                    'Saved FCM Tokens (${_savedTokens.length})',
                    _savedTokens.isEmpty
                        ? [const Text('No tokens found in database')]
                        : _savedTokens.map((token) => _buildTokenCard(token)).toList(),
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // User Information
                  _buildSection(
                    'User Information',
                    [
                      _buildInfoRow('User ID', _supabase.auth.currentUser?.id ?? 'Not authenticated'),
                      _buildInfoRow('Email', _supabase.auth.currentUser?.email ?? 'N/A'),
                      _buildInfoRow('Role', _supabase.auth.currentUser?.role ?? 'N/A'),
                      _buildInfoRow('Session', _supabase.auth.currentSession != null ? 'Active' : 'None'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TossTextStyles.h4,
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.marginXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TossTextStyles.labelLarge,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: value == 'null' || value == 'N/A' 
                          ? TossColors.gray500 
                          : null,
                    ),
                  ),
                ),
                if (canCopy && value != 'null')
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () => _copyToClipboard(value),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTokenCard(Map<String, dynamic> token) {
    final isActive = token['is_active'] ?? false;
    final platform = token['platform'] ?? 'unknown';
    final createdAt = token['created_at'] ?? '';
    final lastUsedAt = token['last_used_at'] ?? '';
    final tokenValue = token['token'] ?? '';
    
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: TossCard(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.paddingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(platform.toUpperCase()),
                  backgroundColor: TossColors.primary.withValues(alpha: 0.2),
                ),
                Chip(
                  label: Text(isActive ? 'ACTIVE' : 'INACTIVE'),
                  backgroundColor: isActive 
                      ? TossColors.success.withValues(alpha: 0.2)
                      : TossColors.gray500.withValues(alpha: 0.2),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space2),
            _buildInfoRow('Token', '${tokenValue.substring(0, 20)}...', canCopy: true),
            _buildInfoRow('Device ID', token['device_id'] ?? 'N/A'),
            _buildInfoRow('Device Model', token['device_model'] ?? 'N/A'),
            _buildInfoRow('App Version', token['app_version'] ?? 'N/A'),
            _buildInfoRow('Created', createdAt),
            _buildInfoRow('Last Used', lastUsedAt),
          ],
        ),
      ),
      ),
    );
  }
}