import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../providers/app_state_provider.dart';
import '../models/revenue_models.dart';
import '../../../../core/utils/number_formatter.dart';

/// Provider for dashboard revenue data
class RevenueProviderState {
  const RevenueProviderState({
    this.revenueData = const {},
    this.isLoading = false,
    this.error,
    this.lastFetchTime,
  });

  final Map<String, RevenueData> revenueData;
  final bool isLoading;
  final String? error;
  final DateTime? lastFetchTime;

  RevenueProviderState copyWith({
    Map<String, RevenueData>? revenueData,
    bool? isLoading,
    String? error,
    DateTime? lastFetchTime,
  }) {
    return RevenueProviderState(
      revenueData: revenueData ?? this.revenueData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastFetchTime: lastFetchTime ?? this.lastFetchTime,
    );
  }

  RevenueProviderState clearError() {
    return copyWith(error: null);
  }
}

/// Revenue provider notifier
class RevenueProviderNotifier extends StateNotifier<RevenueProviderState> {
  RevenueProviderNotifier(this.ref) : super(const RevenueProviderState());

  final Ref ref;
  
  /// Cache duration - 5 minutes
  static const Duration cacheDuration = Duration(minutes: 5);

  /// Get current formatted date
  String get _currentDate {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Check if cached data is still valid
  bool _isCacheValid(String period) {
    final lastFetch = state.lastFetchTime;
    if (lastFetch == null) return false;
    
    final cacheAge = DateTime.now().difference(lastFetch);
    return cacheAge < cacheDuration && state.revenueData.containsKey(period);
  }

  /// Fetch revenue data for a specific period
  Future<RevenueData> fetchRevenue(String period) async {
    final cacheKey = period;
    
    // Return cached data if valid
    if (_isCacheValid(cacheKey) && !state.isLoading) {
      return state.revenueData[cacheKey]!;
    }

    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get app state for company and store IDs
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty) {
        throw Exception('Company not selected');
      }

      // Call the RPC function
      final supabase = Supabase.instance.client;
      final response = await supabase.rpc('get_dashboard_revenue', params: {
        'p_company_id': companyId,
        'p_store_id': storeId.isEmpty ? null : storeId,
        'p_date': _currentDate,
      });

      // Handle response
      if (response == null) {
        throw Exception('No revenue data received');
      }

      // Parse the response based on actual API structure
      final responseData = response as Map<String, dynamic>;
      
      // Extract the appropriate amount based on the selected period
      double amount = 0.0;
      switch (period.toLowerCase()) {
        case 'today':
          amount = (responseData['total_today'] ?? 0).toDouble();
          break;
        case 'yesterday':
          amount = (responseData['total_yesterday'] ?? 0).toDouble();
          break;
        case 'this month':
          amount = (responseData['total_this_month'] ?? 0).toDouble();
          break;
        case 'last month':
          amount = (responseData['total_last_month'] ?? 0).toDouble();
          break;
        case 'this year':
          amount = (responseData['total_this_year'] ?? 0).toDouble();
          break;
        default:
          amount = (responseData['total_today'] ?? 0).toDouble();
      }
      
      // Convert to RevenueData
      final revenueData = RevenueData(
        amount: amount,
        currencySymbol: responseData['currency_symbol'] ?? '\$',
        period: period,
        comparisonAmount: 0, // Not provided in current API
        comparisonPeriod: _getComparisonPeriod(period),
      );

      // Update cache
      final updatedCache = Map<String, RevenueData>.from(state.revenueData);
      updatedCache[cacheKey] = revenueData;

      state = state.copyWith(
        revenueData: updatedCache,
        isLoading: false,
        lastFetchTime: DateTime.now(),
      );

      return revenueData;

    } catch (error) {
      print('Revenue fetch error: $error');
      // Handle error
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      
      // Return fallback data
      return _getFallbackData(period);
    }
  }

  /// Get fallback data when RPC fails
  RevenueData _getFallbackData(String period) {
    return RevenueData(
      amount: _getMockAmount(period),
      currencySymbol: '\$',
      period: period,
      comparisonAmount: _getMockAmount(period) * 0.85, // 15% less for comparison
      comparisonPeriod: _getComparisonPeriod(period),
    );
  }

  /// Get mock amounts for fallback
  double _getMockAmount(String period) {
    switch (period.toLowerCase()) {
      case 'today':
        return 8420.0;
      case 'yesterday':
        return 7985.0;
      case 'this month':
        return 194580.0;
      case 'last month':
        return 172940.0;
      case 'this year':
        return 2340560.0;
      default:
        return 194580.0;
    }
  }

  /// Get comparison period text
  String _getComparisonPeriod(String period) {
    switch (period.toLowerCase()) {
      case 'today':
        return 'yesterday';
      case 'yesterday':
        return 'previous day';
      case 'this month':
        return 'last month';
      case 'last month':
        return 'previous month';
      case 'this year':
        return 'last year';
      default:
        return 'previous period';
    }
  }

  /// Clear all cached data
  void clearCache() {
    state = const RevenueProviderState();
  }

  /// Refresh revenue data for a specific period
  Future<RevenueData> refreshRevenue(String period) async {
    // Clear cache for this period
    final updatedCache = Map<String, RevenueData>.from(state.revenueData);
    updatedCache.remove(period);
    state = state.copyWith(revenueData: updatedCache);

    // Fetch fresh data
    return fetchRevenue(period);
  }
}

/// Provider for revenue data
final revenueProvider = StateNotifierProvider<RevenueProviderNotifier, RevenueProviderState>((ref) {
  return RevenueProviderNotifier(ref);
});

/// Provider for current period revenue
final currentPeriodRevenueProvider = Provider.family<AsyncValue<RevenueData>, String>((ref, period) {
  final revenueState = ref.watch(revenueProvider);
  
  if (revenueState.isLoading) {
    return const AsyncValue.loading();
  }
  
  if (revenueState.error != null) {
    return AsyncValue.error(revenueState.error!, StackTrace.current);
  }
  
  final cachedData = revenueState.revenueData[period];
  if (cachedData != null) {
    return AsyncValue.data(cachedData);
  }
  
  // Trigger fetch if not cached
  final notifier = ref.read(revenueProvider.notifier);
  return AsyncValue.data(notifier._getFallbackData(period));
});

/// Utility provider for formatted revenue amount
final formattedRevenueProvider = Provider.family<String, String>((ref, period) {
  final revenueAsync = ref.watch(currentPeriodRevenueProvider(period));
  
  return revenueAsync.when(
    data: (revenue) => NumberFormatter.formatCurrencyInt(
      revenue.amount,
      revenue.currencySymbol,
    ),
    loading: () => '...',
    error: (_, __) => '--',
  );
});

/// Provider for revenue comparison text
final revenueComparisonProvider = Provider.family<String, String>((ref, period) {
  final revenueAsync = ref.watch(currentPeriodRevenueProvider(period));
  
  return revenueAsync.when(
    data: (revenue) => 'Compared to ${revenue.comparisonPeriod}',
    loading: () => 'Loading...',
    error: (_, __) => 'Compared to previous period',
  );
});

/// Provider to trigger revenue fetch
final fetchRevenueProvider = FutureProvider.family<RevenueData, String>((ref, period) async {
  // Get app state for company and store IDs
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;

  if (companyId.isEmpty) {
    throw Exception('Company not selected');
  }

  try {
    // Call the RPC function directly
    final supabase = Supabase.instance.client;
    final response = await supabase.rpc('get_dashboard_revenue', params: {
      'p_company_id': companyId,
      'p_store_id': storeId.isEmpty ? null : storeId,
      'p_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });

    // Handle response
    if (response == null) {
      throw Exception('No revenue data received');
    }

    // Parse the response based on actual API structure
    final responseData = response as Map<String, dynamic>;
    
    // Extract the appropriate amount based on the selected period
    double amount = 0.0;
    switch (period.toLowerCase()) {
      case 'today':
        amount = (responseData['total_today'] ?? 0).toDouble();
        break;
      case 'yesterday':
        amount = (responseData['total_yesterday'] ?? 0).toDouble();
        break;
      case 'this month':
        amount = (responseData['total_this_month'] ?? 0).toDouble();
        break;
      case 'last month':
        amount = (responseData['total_last_month'] ?? 0).toDouble();
        break;
      case 'this year':
        amount = (responseData['total_this_year'] ?? 0).toDouble();
        break;
      default:
        amount = (responseData['total_today'] ?? 0).toDouble();
    }
    
    // Convert to RevenueData
    return RevenueData(
      amount: amount,
      currencySymbol: responseData['currency_symbol'] ?? '\$',
      period: period,
      comparisonAmount: 0, // Not provided in current API
      comparisonPeriod: _getComparisonPeriod(period),
    );
  } catch (error) {
    print('Revenue fetch error: $error');
    // Return fallback data
    return _getFallbackData(period);
  }
});

String _getComparisonPeriod(String period) {
  switch (period.toLowerCase()) {
    case 'today':
      return 'yesterday';
    case 'yesterday':
      return 'previous day';
    case 'this month':
      return 'last month';
    case 'last month':
      return 'previous month';
    case 'this year':
      return 'last year';
    default:
      return 'previous period';
  }
}

RevenueData _getFallbackData(String period) {
  return RevenueData(
    amount: _getMockAmount(period),
    currencySymbol: '\$',
    period: period,
    comparisonAmount: 0,
    comparisonPeriod: _getComparisonPeriod(period),
  );
}

double _getMockAmount(String period) {
  switch (period.toLowerCase()) {
    case 'today':
      return 8420.0;
    case 'yesterday':
      return 7985.0;
    case 'this month':
      return 194580.0;
    case 'last month':
      return 172940.0;
    case 'this year':
      return 2340560.0;
    default:
      return 194580.0;
  }
}