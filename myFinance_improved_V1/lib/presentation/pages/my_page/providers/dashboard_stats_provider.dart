import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';

part 'dashboard_stats_provider.freezed.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @Default(0.0) double totalBalance,
    @Default(0) int todayTransactions,
    @Default(0) int totalPoints,
    @Default(0) int newNotifications,
    @Default(0.0) double balanceChange,
    @Default('') String balanceChangeText,
    @Default([]) List<RecentActivity> recentActivities,
    @Default(false) bool isLoading,
    String? error,
  }) = _DashboardStats;
}

@freezed
class RecentActivity with _$RecentActivity {
  const factory RecentActivity({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    required String timeAgo,
    required DateTime createdAt,
    double? amount,
  }) = _RecentActivity;
}

class DashboardStatsNotifier extends StateNotifier<DashboardStats> {
  final SupabaseService _supabaseService;
  final Ref _ref;

  DashboardStatsNotifier(this._supabaseService, this._ref) 
    : super(const DashboardStats()) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = _ref.read(authStateProvider);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not authenticated',
        );
        return;
      }

      final appState = _ref.read(appStateProvider.notifier);
      final selectedCompany = appState.selectedCompany;
      
      if (selectedCompany == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'No company selected',
        );
        return;
      }

      // Fetch stats in parallel
      final futures = await Future.wait([
        _getTotalBalance(selectedCompany['company_id']),
        _getTodayTransactions(selectedCompany['company_id']),
        _getRecentActivities(selectedCompany['company_id'], user.id),
        _getNotificationCount(user.id),
      ]);

      final totalBalance = futures[0] as double;
      final todayTransactions = futures[1] as int;
      final recentActivities = futures[2] as List<RecentActivity>;
      final notifications = futures[3] as int;

      // Calculate balance change (mock calculation for now)
      final balanceChange = (totalBalance * 0.025).round() / 100;
      final balanceChangeText = balanceChange >= 0 ? '+${balanceChange.toStringAsFixed(1)}%' : '${balanceChange.toStringAsFixed(1)}%';

      // Calculate points (based on transaction volume)
      final points = (todayTransactions * 10) + (totalBalance / 100).round();

      state = DashboardStats(
        totalBalance: totalBalance,
        todayTransactions: todayTransactions,
        totalPoints: points,
        newNotifications: notifications,
        balanceChange: balanceChange,
        balanceChangeText: balanceChangeText,
        recentActivities: recentActivities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<double> _getTotalBalance(String companyId) async {
    try {
      // Remove RPC call - use direct query instead
      final response = await _supabaseService.client
          .from('cash_locations')
          .select('location_name')
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      return (response?.length ?? 0) * 1000.0; // Mock balance based on location count
    } catch (e) {
      return 0.0;
    }
  }

  Future<int> _getTodayTransactions(String companyId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final response = await _supabaseService.client
          .from('journal_entries')
          .select('journal_id')
          .eq('company_id', companyId)
          .gte('created_at', startOfDay.toIso8601String())
          .lt('created_at', startOfDay.add(const Duration(days: 1)).toIso8601String());

      return response?.length ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<List<RecentActivity>> _getRecentActivities(String companyId, String userId) async {
    try {
      final response = await _supabaseService.client
          .from('journal_entries')
          .select('journal_id, created_at, journal_lines(debit, credit)')
          .eq('company_id', companyId)
          .order('created_at', ascending: false)
          .limit(5);

      if (response == null) return [];

      return response.map<RecentActivity>((entry) {
        final lines = entry['journal_lines'] as List? ?? [];
        final amount = lines.fold<double>(0.0, (sum, line) => 
          sum + ((line['debit'] as num?)?.toDouble() ?? 0.0));
        
        final createdAt = DateTime.parse(entry['created_at']);
        final timeAgo = _formatTimeAgo(createdAt);

        return RecentActivity(
          id: entry['journal_id'],
          type: 'transaction',
          title: 'Transaction ${entry['journal_id'].toString().substring(0, 8)}',
          subtitle: amount > 0 ? '₫${amount.toStringAsFixed(0)}' : 'Journal Entry',
          timeAgo: timeAgo,
          createdAt: createdAt,
          amount: amount > 0 ? amount : null,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> _getNotificationCount(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('notifications')
          .select('notification_id')
          .eq('user_id', userId)
          .eq('is_read', false);

      return response?.length ?? 0;
    } catch (e) {
      return 0;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
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
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  Future<void> refreshStats() async {
    await _loadStats();
  }
}

// Provider
final dashboardStatsProvider = StateNotifierProvider<DashboardStatsNotifier, DashboardStats>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return DashboardStatsNotifier(supabaseService, ref);
});

// Computed providers
final isDashboardLoadingProvider = Provider<bool>((ref) {
  return ref.watch(dashboardStatsProvider).isLoading;
});

final dashboardErrorProvider = Provider<String?>((ref) {
  return ref.watch(dashboardStatsProvider).error;
});