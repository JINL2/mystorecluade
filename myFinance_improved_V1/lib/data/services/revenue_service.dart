import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/homepage/models/revenue_models.dart';

class RevenueService {
  final SupabaseClient _client = Supabase.instance.client;
  final Random _random = Random();
  
  // Cache the full response to access store-specific data
  Map<String, dynamic>? _lastResponse;

  /// Fetch revenue data from Supabase with mock fallback
  Future<RevenueData> fetchRevenue({
    required String storeId,
    required String companyId,
    required RevenuePeriod period,
  }) async {
    try {
      // Try to fetch from Supabase first
      final response = await _fetchFromSupabase(
        storeId: storeId,
        companyId: companyId,
        period: period,
      );
      
      if (response != null) {
        return response;
      }
      
      // Fallback to mock data if Supabase fetch fails
      return _generateMockRevenue(period);
    } catch (e) {
      // Return mock data on any error
      return _generateMockRevenue(period);
    }
  }

  /// Fetch revenue data from Supabase
  Future<RevenueData?> _fetchFromSupabase({
    required String storeId,
    required String companyId,
    required RevenuePeriod period,
  }) async {
    try {
      // Get current date in yyyy-MM-dd format
      final now = DateTime.now();
      final currentDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      // Call the actual get_dashboard_revenue RPC function
      // Always pass null for store_id to get all company data with all stores
      final response = await _client.rpc(
        'get_dashboard_revenue',
        params: {
          'p_company_id': companyId,
          'p_store_id': null,  // Always null to get full company data
          'p_date': currentDate,
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );

      if (response != null && response is Map<String, dynamic>) {
        // Store the full response for store-specific data access
        _lastResponse = response;
        
        // Extract the appropriate amount based on the selected period
        double amount = 0.0;
        switch (period) {
          case RevenuePeriod.today:
            amount = (response['total_today'] ?? 0).toDouble();
            break;
          case RevenuePeriod.yesterday:
            amount = (response['total_yesterday'] ?? 0).toDouble();
            break;
          case RevenuePeriod.thisMonth:
            amount = (response['total_this_month'] ?? 0).toDouble();
            break;
          case RevenuePeriod.thisYear:
            amount = (response['total_this_year'] ?? 0).toDouble();
            break;
        }
        
        // Get currency symbol from response
        final currencySymbol = response['currency_symbol'] ?? 'USD';
        
        // Calculate comparison amounts (for growth percentage)
        double comparisonAmount = 0.0;
        switch (period) {
          case RevenuePeriod.today:
            comparisonAmount = (response['total_yesterday'] ?? 0).toDouble();
            break;
          case RevenuePeriod.yesterday:
            // For yesterday, we don't have day before data, use 0
            comparisonAmount = amount * 0.9; // Mock 10% growth
            break;
          case RevenuePeriod.thisMonth:
            comparisonAmount = (response['total_last_month'] ?? 0).toDouble();
            break;
          case RevenuePeriod.thisYear:
            // Last year data not available, use mock
            comparisonAmount = amount * 0.85; // Mock 15% growth
            break;
        }
        
        return RevenueData(
          amount: amount,
          currencySymbol: currencySymbol,
          period: period.displayName,
          comparisonAmount: comparisonAmount,
          comparisonPeriod: period.comparisonText,
          lastUpdated: DateTime.now(),
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Generate mock revenue data for testing
  RevenueData _generateMockRevenue(RevenuePeriod period) {
    // Generate realistic mock revenue based on period
    final baseAmount = _getBaseAmount(period);
    final variation = _random.nextDouble() * 0.3 - 0.15; // ±15% variation
    final amount = baseAmount * (1 + variation);
    
    // Generate comparison amount (previous period)
    final comparisonVariation = _random.nextDouble() * 0.2 - 0.1; // ±10% variation
    final comparisonAmount = baseAmount * (1 + comparisonVariation);
    
    return RevenueData(
      amount: amount,
      currencySymbol: 'USD',
      period: period.displayName,
      comparisonAmount: comparisonAmount,
      comparisonPeriod: period.comparisonText,
      lastUpdated: DateTime.now(),
      isLoading: false,
    );
  }

  /// Get base amount for mock data based on period
  double _getBaseAmount(RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.today:
        return 2500.0 + _random.nextDouble() * 1000;
      case RevenuePeriod.yesterday:
        return 2300.0 + _random.nextDouble() * 800;
      case RevenuePeriod.thisMonth:
        return 65000.0 + _random.nextDouble() * 20000;
      case RevenuePeriod.thisYear:
        return 780000.0 + _random.nextDouble() * 200000;
    }
  }


  /// Fetch daily revenue summaries for a date range
  Future<List<DailyRevenueSummary>> fetchDailyRevenueSummaries({
    required String storeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Try Supabase first
      final response = await _client
          .from('daily_revenue_summary')
          .select()
          .eq('store_id', storeId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => [],
          );

      if (response.isNotEmpty) {
        return response
            .map((json) => DailyRevenueSummary.fromJson(json))
            .toList();
      }

      // Return mock data if no data from Supabase
      return _generateMockDailySummaries(startDate, endDate);
    } catch (e) {
      return _generateMockDailySummaries(startDate, endDate);
    }
  }

  /// Generate mock daily revenue summaries
  List<DailyRevenueSummary> _generateMockDailySummaries(
    DateTime startDate,
    DateTime endDate,
  ) {
    final summaries = <DailyRevenueSummary>[];
    var currentDate = startDate;
    
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final baseRevenue = 2000.0 + _random.nextDouble() * 3000;
      final expenses = baseRevenue * (0.15 + _random.nextDouble() * 0.1);
      
      summaries.add(DailyRevenueSummary(
        date: currentDate,
        grossRevenue: baseRevenue,
        netRevenue: baseRevenue - expenses,
        expenses: expenses,
        transactionCount: 50 + _random.nextInt(100),
        currencySymbol: 'USD',
        categoryBreakdown: _generateMockCategoryBreakdown(baseRevenue),
      ));
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return summaries;
  }

  /// Get store-specific revenue from cached response
  double getStoreRevenue(String storeId, RevenuePeriod period) {
    if (_lastResponse == null) return 0.0;
    
    final stores = _lastResponse!['stores'] as List<dynamic>? ?? [];
    
    // Find the specific store
    for (final store in stores) {
      if (store['store_id'] == storeId) {
        switch (period) {
          case RevenuePeriod.today:
            return (store['sales_today'] ?? 0).toDouble();
          case RevenuePeriod.yesterday:
            return (store['sales_yesterday'] ?? 0).toDouble();
          case RevenuePeriod.thisMonth:
            return (store['sales_this_month'] ?? 0).toDouble();
          case RevenuePeriod.thisYear:
            return (store['sales_this_year'] ?? 0).toDouble();
        }
      }
    }
    
    return 0.0;
  }

  /// Generate mock category breakdown
  List<RevenueCategoryBreakdown> _generateMockCategoryBreakdown(double totalAmount) {
    final categories = [
      ('Food & Beverages', 'restaurant', '#FF6B6B'),
      ('Electronics', 'devices', '#4ECDC4'),
      ('Clothing', 'shirt', '#45B7D1'),
      ('Services', 'settings', '#96CEB4'),
      ('Other', 'more_horiz', '#FFD93D'),
    ];
    
    final breakdown = <RevenueCategoryBreakdown>[];
    var remainingPercentage = 100.0;
    
    for (int i = 0; i < categories.length - 1; i++) {
      final percentage = _random.nextDouble() * min(30, remainingPercentage);
      breakdown.add(RevenueCategoryBreakdown(
        category: categories[i].$1,
        amount: totalAmount * (percentage / 100),
        percentage: percentage,
        iconName: categories[i].$2,
        colorHex: categories[i].$3,
      ));
      remainingPercentage -= percentage;
    }
    
    // Add remaining to last category
    breakdown.add(RevenueCategoryBreakdown(
      category: categories.last.$1,
      amount: totalAmount * (remainingPercentage / 100),
      percentage: remainingPercentage,
      iconName: categories.last.$2,
      colorHex: categories.last.$3,
    ));
    
    return breakdown;
  }
}

/// Date range helper class
class DateRange {
  final DateTime start;
  final DateTime end;
  
  const DateRange({required this.start, required this.end});
}