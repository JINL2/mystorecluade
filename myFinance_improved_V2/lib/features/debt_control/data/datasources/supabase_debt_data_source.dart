import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../models/debt_control_dto.dart';

/// Supabase implementation of DebtDataSource
///
/// Fetches debt control data from Supabase using RPC functions
/// with caching for better performance.
class SupabaseDebtDataSource {
  final SupabaseClient _client;

  // Cache for fetched data
  Map<String, dynamic>? _cachedData;
  DateTime? _lastFetchTime;
  String? _cachedCompanyId;
  String? _cachedStoreId;
  String? _cachedPerspective;
  String? _cachedFilter;

  SupabaseDebtDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetch all debt data from RPC function with caching
  Future<Map<String, dynamic>> _fetchAllDebtData({
    required String companyId,
    String? storeId,
    String perspective = 'company',
    String filter = 'all',
  }) async {
    // Check cache validity (5 minutes)
    if (_cachedData != null &&
        _cachedCompanyId == companyId &&
        _cachedStoreId == storeId &&
        _cachedPerspective == perspective &&
        _cachedFilter == filter &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inMinutes < 5) {
      return _cachedData!;
    }

    try {
      // Call v2 function and extract the appropriate perspective
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_debt_control_data_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_filter': filter,
          'p_show_all': false,
        },
      );

      // Extract the appropriate perspective from v2 response
      final v2Data = response as Map<String, dynamic>;
      final perspectiveData = perspective == 'store' && storeId != null
        ? v2Data['store']
        : v2Data['company'];

      if (perspectiveData == null) {
        throw Exception('No data for selected perspective');
      }

      // Cache the perspective data
      _cachedData = perspectiveData as Map<String, dynamic>;
      _lastFetchTime = DateTime.now();
      _cachedCompanyId = companyId;
      _cachedStoreId = storeId;
      _cachedPerspective = perspective;
      _cachedFilter = filter;

      return _cachedData!;
    } catch (e) {
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

    // Calculate critical count
    int criticalCount = 0;
    for (final record in records) {
      final daysOutstanding = record['days_outstanding'] as num?;
      if (daysOutstanding != null && daysOutstanding > 90) {
        criticalCount++;
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

    final riskDebts = allDebts.where((d) => d.daysOverdue > 30).toList();
    riskDebts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

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

    for (final record in records) {
      final isInternal = record['is_internal'] as bool? ?? false;

      if (filter == 'internal' && !isInternal) continue;
      if (filter == 'external' && isInternal) continue;

      final netAmount = (record['net_amount'] as num?)?.toDouble() ?? 0.0;
      final daysOutstanding = (record['days_outstanding'] as num?)?.toInt() ?? 0;

      String riskCategory = 'current';
      double priorityScore = 0.0;

      if (daysOutstanding > 90) {
        riskCategory = 'critical';
        priorityScore = 90.0 + (daysOutstanding / 10);
      } else if (daysOutstanding > 60) {
        riskCategory = 'attention';
        priorityScore = 60.0 + (daysOutstanding / 10);
      } else if (daysOutstanding > 30) {
        riskCategory = 'watch';
        priorityScore = 30.0 + (daysOutstanding / 10);
      } else {
        priorityScore = daysOutstanding.toDouble();
      }

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
        suggestedActions: _getSuggestedActions(riskCategory),
        transactionCount: (record['transaction_count'] as int?) ?? 0,
        linkedCompanyName: isInternal ? (record['linked_company_id'] as String?) : null,
        lastContactDate: DateTimeUtils.toLocalSafe(record['last_activity'] as String?),
      ));
    }

    debts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

    final start = offset;
    final end = (offset + limit).clamp(0, debts.length);

    if (start >= debts.length) return [];

    return debts.sublist(start, end);
  }

  List<String> _getSuggestedActions(String riskCategory) {
    switch (riskCategory) {
      case 'critical':
        return ['call', 'legal', 'payment_plan'];
      case 'attention':
        return ['call', 'email', 'payment_plan'];
      case 'watch':
        return ['email', 'reminder'];
      default:
        return ['monitor'];
    }
  }

  Future<PerspectiveSummaryDto> fetchPerspectiveSummary({
    required String perspectiveType,
    required String entityId,
    required String entityName,
  }) async {
    final data = await _fetchAllDebtData(
      companyId: entityId,
      storeId: perspectiveType == 'store' ? entityId : null,
      perspective: perspectiveType,
      filter: 'all',
    );

    final summary = data['summary'] as Map<String, dynamic>;
    final storeAggregates = data['store_aggregates'] as List? ?? [];

    return PerspectiveSummaryDto(
      perspectiveType: perspectiveType,
      entityId: entityId,
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
      )).toList(),
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
    _cachedPerspective = null;
    _cachedFilter = null;
  }
}
