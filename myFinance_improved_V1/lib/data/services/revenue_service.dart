import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/homepage/models/revenue_models.dart';

class RevenueService {
  final SupabaseClient _client = Supabase.instance.client;
  final Random _random = Random();

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
      print('Revenue fetch error: $e');
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
      // Calculate date range based on period
      final dateRange = _getDateRange(period);
      
      // Try to call Supabase RPC function for revenue calculation
      final response = await _client.rpc(
        'calculate_revenue',
        params: {
          'store_id': storeId,
          'company_id': companyId,
          'start_date': dateRange.start.toIso8601String(),
          'end_date': dateRange.end.toIso8601String(),
          'period': period.name,
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );

      if (response != null && response is Map<String, dynamic>) {
        final revenueResponse = RevenueResponse.fromJson(response);
        return RevenueData(
          amount: revenueResponse.amount,
          currencySymbol: revenueResponse.currencySymbol,
          period: period.displayName,
          comparisonAmount: revenueResponse.comparisonAmount ?? 0.0,
          comparisonPeriod: revenueResponse.comparisonPeriod ?? period.comparisonText,
          lastUpdated: revenueResponse.lastUpdated ?? DateTime.now(),
        );
      }

      return null;
    } catch (e) {
      print('Supabase revenue fetch error: $e');
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
      case RevenuePeriod.thisWeek:
        return 15000.0 + _random.nextDouble() * 5000;
      case RevenuePeriod.thisMonth:
        return 65000.0 + _random.nextDouble() * 20000;
      case RevenuePeriod.thisYear:
        return 780000.0 + _random.nextDouble() * 200000;
    }
  }

  /// Get date range for the specified period
  DateRange _getDateRange(RevenuePeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    switch (period) {
      case RevenuePeriod.today:
        return DateRange(
          start: today,
          end: today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );
      case RevenuePeriod.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return DateRange(
          start: yesterday,
          end: today.subtract(const Duration(seconds: 1)),
        );
      case RevenuePeriod.thisWeek:
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        return DateRange(
          start: weekStart,
          end: today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );
      case RevenuePeriod.thisMonth:
        final monthStart = DateTime(today.year, today.month, 1);
        return DateRange(
          start: monthStart,
          end: today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );
      case RevenuePeriod.thisYear:
        final yearStart = DateTime(today.year, 1, 1);
        return DateRange(
          start: yearStart,
          end: today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );
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
      print('Error fetching daily summaries: $e');
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