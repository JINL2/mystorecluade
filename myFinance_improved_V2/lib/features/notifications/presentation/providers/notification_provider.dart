import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/notifications/models/notification_db_model.dart';
import '../../../../core/notifications/repositories/notification_repository.dart';
import '../../../../core/notifications/services/badge_service.dart';

/// Provider for notification repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

/// Provider for unread notification count
final unreadNotificationCountProvider = StreamProvider<int>((ref) async* {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;
  final badgeService = BadgeService();

  if (userId == null) {
    await badgeService.removeBadge();
    yield 0;
    return;
  }

  final repository = ref.watch(notificationRepositoryProvider);

  // Initial count
  final initialCount = await repository.getUnreadCount(userId);
  await badgeService.updateBadgeCount(initialCount);
  yield initialCount;

  // Subscribe to changes in notifications table
  final stream = supabase
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((notifications) {
        return notifications.where((n) => n['is_read'] == false).length;
      });

  await for (final count in stream) {
    // Update app icon badge when count changes
    await badgeService.updateBadgeCount(count);
    yield count;
  }
});

/// Provider for notifications list
final notificationsProvider = FutureProvider.autoDispose
    .family<List<NotificationDbModel>, NotificationFilter>((ref, filter) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(notificationRepositoryProvider);

  return await repository.getUserNotifications(
    userId: userId,
    limit: filter.limit,
    offset: filter.offset,
    isRead: filter.isRead,
  );
});

/// Filter for notifications
class NotificationFilter {
  final int limit;
  final int offset;
  final bool? isRead;

  const NotificationFilter({
    this.limit = 50,
    this.offset = 0,
    this.isRead,
  });

  NotificationFilter copyWith({
    int? limit,
    int? offset,
    bool? isRead,
  }) {
    return NotificationFilter(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationFilter &&
      other.limit == limit &&
      other.offset == offset &&
      other.isRead == isRead;
  }

  @override
  int get hashCode => limit.hashCode ^ offset.hashCode ^ isRead.hashCode;
}
