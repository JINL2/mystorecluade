import 'package:myfinance_improved/core/utils/app_logger.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/services/debt_risk_assessment_service.dart';
import '../models/debt_control_dto.dart';

/// Supabase implementation of DebtDataSource
///
/// Fetches debt control data from Supabase using RPC functions
/// with caching for better performance.
class SupabaseDebtDataSource {
  final SupabaseClient _client;
  final DebtRiskAssessmentService _riskService;
  final AppLogger _logger = const AppLogger('DebtDataSource');

  // Cache for fetched data (stores FULL response with store and company)
  Map<String, dynamic>? _cachedData;
  DateTime? _lastFetchTime;
  String? _cachedCompanyId;
  String? _cachedStoreId;

  SupabaseDebtDataSource({
    SupabaseClient? client,
    DebtRiskAssessmentService? riskService,
  })  : _client = client ?? Supabase.instance.client,
        _riskService = riskService ?? DebtRiskAssessmentService();

  /// Fetch all debt data from RPC function with caching
  /// Note: Always fetches with filter='all' and caches the FULL response (store + company).
  /// Client-side filtering and perspective extraction done after caching.
  Future<Map<String, dynamic>> _fetchAllDebtData({
    required String companyId,
    String? storeId,
    String perspective = 'company',
    String filter = 'all', // This parameter is kept for compatibility but always uses 'all'
  }) async {
    // Check cache validity (5 minutes)
    // Cache key: companyId + storeId (filter and perspective are ignored)
    // Note: Different cache for each store because store data is different
    if (_cachedData != null &&
        _cachedCompanyId == companyId &&
        _cachedStoreId == storeId &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inMinutes < 5) {
      // Extract the requested perspective from cached full response
      final perspectiveData = perspective == 'store' && storeId != null
        ? _cachedData!['store']
        : _cachedData!['company'];

      if (perspectiveData == null) {
        throw Exception('No data for selected perspective in cache');
      }

      _logger.d('✅ Using cached data', {
        'perspective': perspective,
        'storeId': storeId,
        'cacheAge': '${DateTime.now().difference(_lastFetchTime!).inSeconds}s',
      });

      return perspectiveData as Map<String, dynamic>;
    }

    try {
      // Debug logging
      _logger.d('Calling RPC get_debt_control_data_v3', {
        'companyId': companyId,
        'storeId': storeId,
        'filter': 'all', // Always fetch all data
        'perspective': perspective,
      });

      // Fetch with filter='all' to get complete dataset
      // Pass storeId to get specific store detail when needed
      // Client-side filtering will be applied in repository/provider
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_debt_control_data_v3',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId, // Pass storeId to get specific store data
          'p_filter': 'all', // Always fetch all data
          'p_show_all': true, // Show all counterparties including zero balance
        },
      );

      _logger.i('RPC call successful', {
        'responseKeys': response.keys.toList(),
      });

      // Cache the FULL response (contains both store and company data)
      _cachedData = response;
      _lastFetchTime = DateTime.now();
      _cachedCompanyId = companyId;
      _cachedStoreId = storeId;
      // Don't cache perspective or filter - we have ALL data in cached response

      // Extract the appropriate perspective from cached response
      final cachedResponse = _cachedData!;
      final perspectiveData = perspective == 'store' && storeId != null
        ? cachedResponse['store']
        : cachedResponse['company'];

      final extractedPerspective = perspective == 'store' && storeId != null ? 'store' : 'company';
      _logger.d('Extracting perspective', {
        'perspective': extractedPerspective,
        'dataIsNull': perspectiveData == null,
      });

      if (perspectiveData == null) {
        _logger.w('No data for selected perspective');
        throw Exception('No data for selected perspective');
      }

      if (perspectiveData is Map<String, dynamic>) {
        final summary = perspectiveData['summary'] as Map<String, dynamic>?;
        _logger.d('Summary data', {
          'receivable': summary?['total_receivable'],
          'payable': summary?['total_payable'],
          'counterparties': summary?['counterparty_count'],
        });
      }

      return perspectiveData as Map<String, dynamic>;
    } catch (e, stackTrace) {
      // Log error for debugging
      _logger.e(
        'Error in _fetchAllDebtData',
        error: e,
        stackTrace: stackTrace,
        params: {
          'companyId': companyId,
          'storeId': storeId,
          'perspective': perspective,
          'filter': filter,
        },
      );

      // Return empty structure if error
      return _getEmptyStructure(companyId, storeId, perspective, filter);
    }
  }

  Map<String, dynamic> _getEmptyStructure(
    String companyId,
    String? storeId,
    String perspective,
    String filter,
  ) {
    return {
      'metadata': {
        'company_id': companyId,
        'store_id': storeId,
        'perspective': perspective,
        'filter': filter,
        'generated_at': DateTime.now().toIso8601String(),
        'currency': '₫',
      },
      'summary': {
        'total_receivable': 0.0,
        'total_payable': 0.0,
        'net_position': 0.0,
        'internal_receivable': 0.0,
        'internal_payable': 0.0,
        'external_receivable': 0.0,
        'external_payable': 0.0,
        'counterparty_count': 0,
        'transaction_count': 0,
      },
      'store_aggregates': <Map<String, dynamic>>[],
      'records': <Map<String, dynamic>>[],
    };
  }

  Future<KpiMetricsDto> fetchKpiMetrics({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    final data = await _fetchAllDebtData(
      companyId: companyId,
      storeId: storeId,
      perspective: storeId != null ? 'store' : 'company',
      filter: 'all',
    );

    final summary = data['summary'] as Map<String, dynamic>;
    final records = data['records'] as List? ?? [];

    // Calculate critical count using domain service
    int criticalCount = 0;
    for (final record in records) {
      final daysOutstanding = (record['days_outstanding'] as num?)?.toInt();
      if (daysOutstanding != null) {
        final riskCategory = _riskService.assessRiskCategory(daysOutstanding);
        if (riskCategory == 'critical') {
          criticalCount++;
        }
      }
    }

    // Calculate collection rate
    final totalReceivable = (summary['total_receivable'] as num?)?.toDouble() ?? 0.0;
    final overdueAmount = totalReceivable * 0.15;
    final collectionRate = totalReceivable > 0
        ? ((totalReceivable - overdueAmount) / totalReceivable * 100)
        : 0.0;

    return KpiMetricsDto(
      netPosition: (summary['net_position'] as num?)?.toDouble() ?? 0.0,
      netPositionTrend: 5.2,
      avgDaysOutstanding: 45,
      agingTrend: -2.1,
      collectionRate: collectionRate,
      collectionTrend: 1.5,
      criticalCount: criticalCount,
      criticalTrend: -0.5,
      totalReceivable: totalReceivable,
      totalPayable: (summary['total_payable'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (summary['transaction_count'] as int?) ?? 0,
    );
  }

  Future<AgingAnalysisDto> fetchAgingAnalysis({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    final data = await _fetchAllDebtData(
      companyId: companyId,
      storeId: storeId,
      perspective: storeId != null ? 'store' : 'company',
      filter: 'all',
    );

    final records = data['records'] as List? ?? [];

    double current = 0;
    double overdue30 = 0;
    double overdue60 = 0;
    double overdue90 = 0;

    for (final record in records) {
      final receivableAmount = (record['receivable_amount'] as num?)?.toDouble() ?? 0.0;
      final daysOutstanding = (record['days_outstanding'] as num?)?.toInt() ?? 0;

      if (receivableAmount > 0) {
        if (daysOutstanding <= 0) {
          current += receivableAmount;
        } else if (daysOutstanding <= 30) {
          overdue30 += receivableAmount;
        } else if (daysOutstanding <= 60) {
          overdue60 += receivableAmount;
        } else {
          overdue90 += receivableAmount;
        }
      }
    }

    return AgingAnalysisDto(
      current: current,
      overdue30: overdue30,
      overdue60: overdue60,
      overdue90: overdue90,
      trend: [],
    );
  }

  Future<List<CriticalAlertDto>> fetchCriticalAlerts({
    required String companyId,
    String? storeId,
  }) async {
    // Mock alerts for now
    return [
      CriticalAlertDto(
        id: 'alert_1',
        type: 'overdue_critical',
        message: '3 accounts over 90 days overdue',
        count: 3,
        severity: 'critical',
        createdAt: DateTime.now(),
      ),
      CriticalAlertDto(
        id: 'alert_2',
        type: 'payment_received',
        message: 'Large payment received',
        count: 1,
        severity: 'info',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  Future<List<PrioritizedDebtDto>> fetchTopRiskDebts({
    required String companyId,
    String? storeId,
    required int limit,
  }) async {
    final allDebts = await fetchPrioritizedDebts(
      companyId: companyId,
      storeId: storeId,
      viewpoint: storeId != null ? 'store' : 'company',
      filter: 'all',
      limit: 100,
    );

    // Filter for risky debts (> 30 days overdue)
    final riskDebts = allDebts.where((d) => d.daysOverdue > 30).toList();

    // Note: Sorting is handled in Repository/Presentation layer
    return riskDebts.take(limit).toList();
  }

  Future<List<PrioritizedDebtDto>> fetchPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  }) async {
    final data = await _fetchAllDebtData(
      companyId: companyId,
      storeId: storeId,
      perspective: storeId != null ? 'store' : 'company',
      filter: filter,
    );

    final records = data['records'] as List? ?? [];
    final List<PrioritizedDebtDto> debts = [];

    _logger.d('📋 Processing records', {
      'totalRecords': records.length,
      'filter': filter,
      'viewpoint': viewpoint,
    });

    for (final record in records) {
      final isInternal = record['is_internal'] as bool? ?? false;

      if (filter == 'internal' && !isInternal) continue;
      if (filter == 'external' && isInternal) continue;

      final netAmount = (record['net_amount'] as num?)?.toDouble() ?? 0.0;
      final daysOutstanding = (record['days_outstanding'] as num?)?.toInt() ?? 0;

      // Use domain service for risk assessment
      final riskCategory = _riskService.assessRiskCategory(daysOutstanding);
      final priorityScore = _riskService.calculatePriorityScore(daysOutstanding, riskCategory);
      final suggestedActions = _riskService.getSuggestedActions(riskCategory);

      debts.add(PrioritizedDebtDto(
        id: record['counterparty_id'] as String? ?? '',
        counterpartyId: record['counterparty_id'] as String? ?? '',
        counterpartyName: record['counterparty_name'] as String? ?? 'Unknown',
        counterpartyType: isInternal ? 'internal' : 'external',
        amount: netAmount,
        currency: '₫',
        dueDate: DateTime.now().subtract(Duration(days: daysOutstanding)),
        daysOverdue: daysOutstanding,
        riskCategory: riskCategory,
        priorityScore: priorityScore,
        suggestedActions: suggestedActions,
        transactionCount: (record['transaction_count'] as int?) ?? 0,
        linkedCompanyName: isInternal ? (record['linked_company_id'] as String?) : null,
        lastContactDate: DateTimeUtils.toLocalSafe(record['last_activity'] as String?),
      ),);
    }

    // Note: Sorting is now handled in the Presentation layer (Provider)
    // This keeps Data layer pure and only responsible for data fetching

    _logger.d('✅ Processed debts', {
      'totalDebts': debts.length,
      'afterFilter': debts.length,
      'limit': limit,
      'offset': offset,
    });

    final start = offset;
    final end = (offset + limit).clamp(0, debts.length);

    if (start >= debts.length) return [];

    return debts.sublist(start, end);
  }


  Future<PerspectiveSummaryDto> fetchPerspectiveSummary({
    required String companyId,
    String? storeId,
    required String perspectiveType,
    required String entityName,
  }) async {
    final data = await _fetchAllDebtData(
      companyId: companyId,
      storeId: storeId,
      perspective: perspectiveType,
      filter: 'all',
    );

    final summary = data['summary'] as Map<String, dynamic>;
    final storeAggregates = data['store_aggregates'] as List? ?? [];

    return PerspectiveSummaryDto(
      perspectiveType: perspectiveType,
      entityId: storeId ?? companyId,
      entityName: entityName,
      totalReceivable: (summary['total_receivable'] as num?)?.toDouble() ?? 0.0,
      totalPayable: (summary['total_payable'] as num?)?.toDouble() ?? 0.0,
      netPosition: (summary['net_position'] as num?)?.toDouble() ?? 0.0,
      internalReceivable: (summary['internal_receivable'] as num?)?.toDouble() ?? 0.0,
      internalPayable: (summary['internal_payable'] as num?)?.toDouble() ?? 0.0,
      internalNetPosition: ((summary['internal_receivable'] as num?)?.toDouble() ?? 0.0) -
                          ((summary['internal_payable'] as num?)?.toDouble() ?? 0.0),
      externalReceivable: (summary['external_receivable'] as num?)?.toDouble() ?? 0.0,
      externalPayable: (summary['external_payable'] as num?)?.toDouble() ?? 0.0,
      externalNetPosition: ((summary['external_receivable'] as num?)?.toDouble() ?? 0.0) -
                          ((summary['external_payable'] as num?)?.toDouble() ?? 0.0),
      storeAggregates: storeAggregates.map((s) => StoreAggregateDto(
        storeId: s['store_id'] as String? ?? '',
        storeName: s['store_name'] as String? ?? '',
        receivable: (s['receivable'] as num?)?.toDouble() ?? 0.0,
        payable: (s['payable'] as num?)?.toDouble() ?? 0.0,
        netPosition: (s['net_position'] as num?)?.toDouble() ?? 0.0,
        counterpartyCount: (s['counterparty_count'] as int?) ?? 0,
        isHeadquarters: s['is_headquarters'] as bool? ?? false,
      ),).toList(),
      counterpartyCount: (summary['counterparty_count'] as int?) ?? 0,
      transactionCount: (summary['transaction_count'] as int?) ?? 0,
      collectionRate: 85.0,
      criticalCount: 0,
    );
  }

  Future<void> markAlertAsRead(String alertId) async {
    // Implementation for marking alert as read
    // This would typically update the database
  }

  Future<void> clearCache() async {
    _cachedData = null;
    _lastFetchTime = null;
    _cachedCompanyId = null;
    _cachedStoreId = null;
  }
}
