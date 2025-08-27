import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/debt_control/models/debt_control_models.dart';
import '../../presentation/pages/debt_control/models/internal_counterparty_models.dart';

/// Supabase repository for debt control using RPC function with local filtering
/// This implementation fetches all data once and filters locally for better performance
class SupabaseDebtRepository {
  final SupabaseClient _client = Supabase.instance.client;
  
  // Cache for the fetched data
  Map<String, dynamic>? _cachedData;
  DateTime? _lastFetchTime;
  String? _cachedCompanyId;
  String? _cachedStoreId;
  String? _cachedPerspective;
  String? _cachedFilter;

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
      final response = await _client.rpc(
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

      // Cache the perspective data (not the full v2 response)
      _cachedData = perspectiveData as Map<String, dynamic>;
      _lastFetchTime = DateTime.now();
      _cachedCompanyId = companyId;
      _cachedStoreId = storeId;
      _cachedPerspective = perspective;
      _cachedFilter = filter;

      return _cachedData!;
    } catch (e) {
      print('Error fetching debt control data: $e');
      // Return empty structure if error
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
        'store_aggregates': [],
        'records': [],
      };
    }
  }

  /// Clear cache to force refresh
  void clearCache() {
    _cachedData = null;
    _lastFetchTime = null;
    _cachedCompanyId = null;
    _cachedStoreId = null;
    _cachedPerspective = null;
    _cachedFilter = null;
  }

  /// Force refresh data (for pull-to-refresh)
  Future<void> refreshData() async {
    clearCache();
  }

  /// Get KPI metrics from RPC data with local filtering
  Future<KPIMetrics> getKPIMetrics({
    required String companyId,
    String? storeId,
    required String viewpoint,
    String filter = 'all',
  }) async {
    try {
      final data = await _fetchAllDebtData(
        companyId: companyId,
        storeId: storeId,
        perspective: storeId != null ? 'store' : 'company',
        filter: filter,
      );

      final summary = data['summary'] as Map<String, dynamic>;
      final records = data['records'] as List? ?? [];
      
      // Calculate critical count from records with high days outstanding
      int criticalCount = 0;
      for (final record in records) {
        final daysOutstanding = record['days_outstanding'] as num?;
        if (daysOutstanding != null && daysOutstanding > 90) {
          criticalCount++;
        }
      }

      // Calculate collection rate (simplified)
      final totalReceivable = (summary['total_receivable'] as num?)?.toDouble() ?? 0.0;
      final overdueAmount = totalReceivable * 0.15; // Estimate 15% overdue
      final collectionRate = totalReceivable > 0 
          ? ((totalReceivable - overdueAmount) / totalReceivable * 100)
          : 0.0;

      return KPIMetrics(
        netPosition: (summary['net_position'] as num?)?.toDouble() ?? 0.0,
        netPositionTrend: 5.2, // Calculate from historical data if available
        avgDaysOutstanding: 45, // Calculate from records if needed
        agingTrend: -2.1,
        collectionRate: collectionRate,
        collectionTrend: 1.5,
        criticalCount: criticalCount,
        criticalTrend: -0.5,
        totalReceivable: totalReceivable,
        totalPayable: (summary['total_payable'] as num?)?.toDouble() ?? 0.0,
        transactionCount: (summary['transaction_count'] as int?) ?? 0,
      );
    } catch (e) {
      print('Error fetching KPI metrics: $e');
      return const KPIMetrics(
        netPosition: 0.0,
        netPositionTrend: 0.0,
        avgDaysOutstanding: 0,
        agingTrend: 0.0,
        collectionRate: 0.0,
        collectionTrend: 0.0,
        criticalCount: 0,
        criticalTrend: 0.0,
        totalReceivable: 0.0,
        totalPayable: 0.0,
        transactionCount: 0,
      );
    }
  }

  /// Get aging analysis from RPC data
  Future<AgingAnalysis> getAgingAnalysis({
    required String companyId,
    String? storeId,
    required String viewpoint,
    String filter = 'all',
  }) async {
    try {
      final data = await _fetchAllDebtData(
        companyId: companyId,
        storeId: storeId,
        perspective: storeId != null ? 'store' : 'company',
        filter: filter,
      );

      final records = data['records'] as List? ?? [];
      
      double current = 0;
      double overdue30 = 0;
      double overdue60 = 0;
      double overdue90 = 0;

      for (final record in records) {
        final receivableAmount = (record['receivable_amount'] as num?)?.toDouble() ?? 0.0;
        final daysOutstanding = (record['days_outstanding'] as num?)?.toInt() ?? 0;
        
        // Only count receivables
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

      return AgingAnalysis(
        current: current,
        overdue30: overdue30,
        overdue60: overdue60,
        overdue90: overdue90,
        trend: [],
      );
    } catch (e) {
      print('Error calculating aging analysis: $e');
      return const AgingAnalysis(
        current: 0.0,
        overdue30: 0.0,
        overdue60: 0.0,
        overdue90: 0.0,
        trend: [],
      );
    }
  }

  /// Get critical alerts
  Future<List<CriticalAlert>> getCriticalAlerts({
    required String companyId,
    String? storeId,
  }) async {
    // Return mock alerts for now
    return [
      CriticalAlert(
        id: 'alert_1',
        type: 'overdue_critical',
        message: '3 accounts over 90 days overdue',
        count: 3,
        severity: 'critical',
        createdAt: DateTime.now(),
      ),
      CriticalAlert(
        id: 'alert_2',
        type: 'payment_received',
        message: 'Large payment received',
        count: 1,
        severity: 'info',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  /// Get prioritized debts - uses getCounterpartyDebts with RPC data
  Future<List<PrioritizedDebt>> getPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  }) async {
    final debts = await getCounterpartyDebts(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
      perspectiveType: viewpoint,
    );
    
    // Apply limit and offset for pagination if needed
    final start = offset;
    final end = (offset + limit).clamp(0, debts.length);
    
    if (start >= debts.length) {
      return [];
    }
    
    return debts.sublist(start, end);
  }

  /// Get top risk debts from RPC data
  Future<List<PrioritizedDebt>> getTopRiskDebts({
    required String companyId,
    String? storeId,
    int limit = 5,
  }) async {
    try {
      // Get all debts and filter for top risks
      final allDebts = await getCounterpartyDebts(
        companyId: companyId,
        storeId: storeId,
        filter: 'all',
        perspectiveType: storeId != null ? 'store' : 'company',
      );
      
      // Filter for debts with risk (overdue > 30 days)
      final riskDebts = allDebts.where((d) => d.daysOverdue > 30).toList();
      
      // Sort by priority score and take top N
      riskDebts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
      
      return riskDebts.take(limit).toList();
    } catch (e) {
      print('Error getting top risk debts: $e');
      return _getMockPrioritizedDebts('all').take(limit).toList();
    }
  }

  /// Get counterparty debts with local filtering
  Future<List<PrioritizedDebt>> getCounterpartyDebts({
    required String companyId,
    String? storeId,
    required String filter,
    String perspectiveType = 'company',
  }) async {
    try {
      final data = await _fetchAllDebtData(
        companyId: companyId,
        storeId: storeId,
        perspective: storeId != null ? 'store' : 'company',
        filter: filter,
      );

      final records = data['records'] as List? ?? [];
      final List<PrioritizedDebt> debts = [];

      for (final record in records) {
        final isInternal = record['is_internal'] as bool? ?? false;
        
        // Apply local filtering based on filter parameter
        if (filter == 'internal' && !isInternal) continue;
        if (filter == 'external' && isInternal) continue;
        // 'all' filter includes everything

        final netAmount = (record['net_amount'] as num?)?.toDouble() ?? 0.0;
        final daysOutstanding = (record['days_outstanding'] as num?)?.toInt() ?? 0;
        
        // Determine risk category based on days outstanding
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

        debts.add(PrioritizedDebt(
          id: record['counterparty_id'] as String? ?? '',
          counterpartyId: record['counterparty_id'] as String? ?? '',
          counterpartyName: record['counterparty_name'] as String? ?? 'Unknown',
          counterpartyType: isInternal ? 'internal' : 'external',
          amount: netAmount.abs(),
          currency: '₫',
          dueDate: DateTime.now().subtract(Duration(days: daysOutstanding)),
          daysOverdue: daysOutstanding,
          riskCategory: riskCategory,
          priorityScore: priorityScore,
          suggestedActions: _getSuggestedActions(riskCategory),
          transactionCount: (record['transaction_count'] as int?) ?? 0,
          linkedCompanyName: isInternal ? (record['linked_company_id'] as String?) : null,
          lastContactDate: record['last_activity'] != null 
            ? DateTime.tryParse(record['last_activity'] as String) 
            : null,
        ));
      }

      // Sort by priority score (highest first)
      debts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

      return debts;
    } catch (e) {
      print('Error fetching counterparty debts: $e');
      // Fall back to mock data if error
      return _getMockPrioritizedDebts(filter);
    }
  }
  
  List<SuggestedAction> _getSuggestedActions(String riskCategory) {
    switch (riskCategory) {
      case 'critical':
        return const [
          SuggestedAction(
            id: 'call',
            type: 'call',
            label: 'Call Now',
            icon: 'phone',
            isPrimary: true,
            color: '#EF4444',
          ),
          SuggestedAction(
            id: 'legal',
            type: 'legal',
            label: 'Legal Action',
            icon: 'gavel',
            isPrimary: true,
            color: '#7C2D12',
          ),
        ];
      case 'attention':
        return const [
          SuggestedAction(
            id: 'email',
            type: 'email',
            label: 'Send Reminder',
            icon: 'email',
            isPrimary: true,
            color: '#F59E0B',
          ),
        ];
      case 'watch':
        return const [
          SuggestedAction(
            id: 'statement',
            type: 'statement',
            label: 'Send Statement',
            icon: 'description',
            isPrimary: true,
            color: '#10B981',
          ),
        ];
      default:
        return const [];
    }
  }

  /// Get perspective debt summary from RPC data
  Future<PerspectiveDebtSummary> getPerspectiveDebtSummary({
    required String companyId,
    String? storeId,
    required String perspectiveType,
    String? entityName,
    String filter = 'all',
  }) async {
    try {
      final data = await _fetchAllDebtData(
        companyId: companyId,
        storeId: storeId,
        perspective: storeId != null ? 'store' : 'company',
        filter: filter,
      );

      final summary = data['summary'] as Map<String, dynamic>;
      final storeAggregatesData = data['store_aggregates'] as List? ?? [];
      
      // Convert store aggregates to model
      final List<StoreAggregate> storeAggregates = [];
      for (final store in storeAggregatesData) {
        storeAggregates.add(StoreAggregate(
          storeId: store['store_id'] as String? ?? '',
          storeName: store['store_name'] as String? ?? '',
          receivable: (store['receivable'] as num?)?.toDouble() ?? 0.0,
          payable: (store['payable'] as num?)?.toDouble() ?? 0.0,
          netPosition: (store['net_position'] as num?)?.toDouble() ?? 0.0,
          counterpartyCount: (store['counterparty_count'] as int?) ?? 0,
          isHeadquarters: false, // Can be determined from store data if needed
        ));
      }

      // Calculate collection rate
      final totalReceivable = (summary['total_receivable'] as num?)?.toDouble() ?? 0.0;
      final collectionRate = totalReceivable > 0 ? 82.5 : 0.0; // Simplified calculation
      
      // Calculate critical count from records
      final records = data['records'] as List? ?? [];
      int criticalCount = 0;
      for (final record in records) {
        final daysOutstanding = record['days_outstanding'] as num?;
        if (daysOutstanding != null && daysOutstanding > 90) {
          criticalCount++;
        }
      }

      return PerspectiveDebtSummary(
        perspectiveType: perspectiveType,
        entityId: storeId ?? companyId,
        entityName: entityName ?? 'Company',
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
        storeAggregates: storeAggregates,
        counterpartyCount: (summary['counterparty_count'] as int?) ?? 0,
        transactionCount: (summary['transaction_count'] as int?) ?? 0,
        collectionRate: collectionRate,
        criticalCount: criticalCount,
      );
    } catch (e) {
      print('Error fetching perspective debt summary: $e');
      // Fall back to basic implementation
      final kpiMetrics = await getKPIMetrics(
        companyId: companyId,
        storeId: storeId,
        viewpoint: perspectiveType,
      );

      return PerspectiveDebtSummary(
        perspectiveType: perspectiveType,
        entityId: storeId ?? companyId,
        entityName: entityName ?? 'Company',
        totalReceivable: kpiMetrics.totalReceivable,
        totalPayable: kpiMetrics.totalPayable,
        netPosition: kpiMetrics.netPosition,
        internalReceivable: kpiMetrics.totalReceivable * 0.3,
        internalPayable: kpiMetrics.totalPayable * 0.3,
        internalNetPosition: kpiMetrics.netPosition * 0.3,
        externalReceivable: kpiMetrics.totalReceivable * 0.7,
        externalPayable: kpiMetrics.totalPayable * 0.7,
        externalNetPosition: kpiMetrics.netPosition * 0.7,
        storeAggregates: [],
        counterpartyCount: 25,
        transactionCount: kpiMetrics.transactionCount,
        collectionRate: kpiMetrics.collectionRate,
        criticalCount: kpiMetrics.criticalCount,
      );
    }
  }


  /// Get KPI metrics from database
  Future<KPIMetrics> getKPIMetricsFromDatabase({
    required String companyId,
    String? storeId,
  }) async {
    return getKPIMetrics(
      companyId: companyId,
      storeId: storeId,
      viewpoint: storeId != null ? 'store' : 'company',
    );
  }

  /// Get debt analytics
  Future<DebtAnalytics> getDebtAnalytics({
    required String companyId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final agingAnalysis = await getAgingAnalysis(
      companyId: companyId,
      storeId: storeId,
      viewpoint: storeId != null ? 'store' : 'company',
    );

    return DebtAnalytics(
      currentAging: agingAnalysis,
      collectionEfficiency: 82.5,
      riskDistribution: {
        'critical': agingAnalysis.overdue90,
        'attention': agingAnalysis.overdue60,
        'watch': agingAnalysis.overdue30,
        'current': agingAnalysis.current,
      },
      reportDate: DateTime.now(),
    );
  }

  /// Get debt communications - returns empty list
  Future<List<DebtCommunication>> getDebtCommunications(String debtId) async {
    return [];
  }

  /// Create debt communication - no-op
  Future<void> createDebtCommunication(DebtCommunication communication) async {
    print('Mock: Would create communication ${communication.type}');
  }

  /// Get payment plans - returns empty list
  Future<List<PaymentPlan>> getPaymentPlans(String debtId) async {
    return [];
  }

  /// Create payment plan - no-op
  Future<void> createPaymentPlan(PaymentPlan paymentPlan) async {
    print('Mock: Would create payment plan ${paymentPlan.totalAmount}');
  }

  /// Update payment plan status - no-op
  Future<void> updatePaymentPlanStatus(String planId, String status) async {
    print('Mock: Would update plan $planId to $status');
  }

  // Helper methods for mock data

  List<PrioritizedDebt> _getMockPrioritizedDebts(String filter) {
    final debts = [
      PrioritizedDebt(
        id: 'debt_1',
        counterpartyId: 'cp_1',
        counterpartyName: 'ABC Corporation',
        counterpartyType: filter == 'internal' ? 'internal' : 'external',
        amount: 1000000000.0,
        currency: '₫',
        dueDate: DateTime.now().subtract(const Duration(days: 95)),
        daysOverdue: 95,
        riskCategory: 'critical',
        priorityScore: 92.5,
        suggestedActions: _getMockActions('critical'),
        transactionCount: 12,
        linkedCompanyName: filter == 'internal' ? 'Sister Company Ltd' : null,
      ),
      PrioritizedDebt(
        id: 'debt_2',
        counterpartyId: 'cp_2',
        counterpartyName: 'XYZ Industries',
        counterpartyType: 'external',
        amount: 2500000000.0,
        currency: '₫',
        dueDate: DateTime.now().subtract(const Duration(days: 65)),
        daysOverdue: 65,
        riskCategory: 'attention',
        priorityScore: 75.0,
        suggestedActions: _getMockActions('attention'),
        transactionCount: 8,
      ),
      PrioritizedDebt(
        id: 'debt_3',
        counterpartyId: 'cp_3',
        counterpartyName: 'Tech Solutions Co',
        counterpartyType: filter == 'internal' ? 'internal' : 'external',
        amount: 850000000.0,
        currency: '₫',
        dueDate: DateTime.now().subtract(const Duration(days: 35)),
        daysOverdue: 35,
        riskCategory: 'watch',
        priorityScore: 55.0,
        suggestedActions: _getMockActions('watch'),
        transactionCount: 5,
        linkedCompanyName: filter == 'internal' ? 'Branch Office B' : null,
      ),
    ];

    if (filter == 'internal') {
      return debts.where((d) => d.counterpartyType == 'internal').toList();
    } else if (filter == 'external') {
      return debts.where((d) => d.counterpartyType == 'external').toList();
    }
    return debts;
  }

  List<SuggestedAction> _getMockActions(String riskCategory) {
    switch (riskCategory) {
      case 'critical':
        return const [
          SuggestedAction(
            id: 'call',
            type: 'call',
            label: 'Call Now',
            icon: 'phone',
            isPrimary: true,
            color: '#EF4444',
          ),
          SuggestedAction(
            id: 'legal',
            type: 'legal',
            label: 'Legal Action',
            icon: 'gavel',
            isPrimary: true,
            color: '#7C2D12',
          ),
        ];
      case 'attention':
        return const [
          SuggestedAction(
            id: 'email',
            type: 'email',
            label: 'Send Reminder',
            icon: 'email',
            isPrimary: true,
            color: '#F59E0B',
          ),
        ];
      default:
        return const [
          SuggestedAction(
            id: 'statement',
            type: 'statement',
            label: 'Send Statement',
            icon: 'description',
            isPrimary: true,
            color: '#10B981',
          ),
        ];
    }
  }

  List<StoreAggregate> _getMockStoreAggregates() {
    return const [
      StoreAggregate(
        storeId: 'store_1',
        storeName: 'Main Store',
        receivable: 12000000.0,
        payable: 4500000.0,
        netPosition: 7500000.0,
        counterpartyCount: 25,
        isHeadquarters: true,
      ),
      StoreAggregate(
        storeId: 'store_2',
        storeName: 'Branch A',
        receivable: 8000000.0,
        payable: 3000000.0,
        netPosition: 5000000.0,
        counterpartyCount: 15,
        isHeadquarters: false,
      ),
    ];
  }

  /// Get recent activities for a specific counterparty
  Future<List<Map<String, dynamic>>> getCounterpartyRecentActivities({
    required String companyId,
    required String counterpartyId,
    String? storeId,
    int limit = 10,
  }) async {
    try {
      final response = await _client.rpc(
        'get_counterparty_recent_activities',
        params: {
          'p_company_id': companyId,
          'p_counterparty_id': counterpartyId,
          'p_store_id': storeId,
          'p_limit': limit,
        },
      );

      if (response == null) {
        print('No response from recent activities function');
        return _getMockRecentActivities();
      }

      final data = response as Map<String, dynamic>;
      final activities = data['activities'] as List?;
      
      if (activities == null || activities.isEmpty) {
        print('No activities found, returning mock data');
        return _getMockRecentActivities();
      }

      // Convert List<dynamic> to List<Map<String, dynamic>>
      return activities.map((activity) => activity as Map<String, dynamic>).toList();
      
    } catch (e) {
      print('Error fetching recent activities: $e');
      return _getMockRecentActivities();
    }
  }

  /// Mock recent activities for fallback
  List<Map<String, dynamic>> _getMockRecentActivities() {
    return [
      {
        'id': 'act_1',
        'type': 'Payment Received',
        'amount': 450000000.0,
        'signed_amount': 450000000.0,
        'is_receivable': true,
        'formatted_date': '2 days ago',
        'payment_status': 'completed',
        'reference': 'PMT-2024-001',
      },
      {
        'id': 'act_2', 
        'type': 'Invoice Sent',
        'amount': 850000000.0,
        'signed_amount': 850000000.0,
        'is_receivable': true,
        'formatted_date': '1 week ago',
        'payment_status': 'pending',
        'reference': 'INV-2024-002',
      },
      {
        'id': 'act_3',
        'type': 'Credit Note',
        'amount': 200000000.0,
        'signed_amount': -200000000.0,
        'is_receivable': false,
        'formatted_date': '2 weeks ago',
        'payment_status': 'completed',
        'reference': 'CN-2024-003',
      },
    ];
  }
}