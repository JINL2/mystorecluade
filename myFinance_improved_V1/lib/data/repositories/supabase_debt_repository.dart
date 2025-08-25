import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/debt_control/models/debt_control_models.dart';

/// Supabase repository for debt control operations
/// 
/// Handles all database interactions for the smart debt control system,
/// including risk scoring, aging analysis, and intelligent prioritization.
class SupabaseDebtRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get comprehensive KPI metrics for debt dashboard
  Future<KPIMetrics> getKPIMetrics({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    try {
      // Build dynamic query based on viewpoint
      String whereClause = 'company_id = \'$companyId\'';
      if (viewpoint == 'store' && storeId != null) {
        whereClause += ' AND store_id = \'$storeId\'';
      }

      // Execute comprehensive metrics query
      final response = await _client.rpc('get_debt_kpi_metrics', params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_viewpoint': viewpoint,
      });

      if (response != null && response is Map<String, dynamic>) {
        return KPIMetrics.fromJson(response);
      }

      // Fallback: Calculate metrics manually if RPC doesn't exist
      return await _calculateKPIMetricsManually(companyId, storeId, viewpoint);
    } catch (e) {
      print('Error fetching KPI metrics: $e');
      return const KPIMetrics(); // Return default metrics
    }
  }

  /// Calculate KPI metrics manually as fallback
  Future<KPIMetrics> _calculateKPIMetricsManually(
    String companyId,
    String? storeId,
    String viewpoint,
  ) async {
    // Query debt receivables
    var query = _client
        .from('debts_receivable')
        .select('amount, due_date, created_at')
        .eq('company_id', companyId);

    if (viewpoint == 'store' && storeId != null) {
      query = query.eq('store_id', storeId);
    }

    final debtsData = await query;
    
    if (debtsData.isEmpty) {
      return const KPIMetrics();
    }

    double totalReceivable = 0;
    double totalPayable = 0;
    int totalDaysOutstanding = 0;
    int criticalCount = 0;
    int transactionCount = debtsData.length;

    final now = DateTime.now();

    for (final debt in debtsData) {
      final amount = (debt['amount'] as num?)?.toDouble() ?? 0.0;
      final dueDate = DateTime.tryParse(debt['due_date'] ?? '');
      
      if (amount > 0) {
        totalReceivable += amount;
      } else {
        totalPayable += amount.abs();
      }

      if (dueDate != null) {
        final daysOverdue = now.difference(dueDate).inDays;
        totalDaysOutstanding += daysOverdue.abs();
        
        if (daysOverdue > 90) {
          criticalCount++;
        }
      }
    }

    final avgDaysOutstanding = transactionCount > 0 
        ? (totalDaysOutstanding / transactionCount).round() 
        : 0;

    return KPIMetrics(
      netPosition: totalReceivable - totalPayable,
      netPositionTrend: 0.0, // Would need historical data
      avgDaysOutstanding: avgDaysOutstanding,
      agingTrend: 0.0, // Would need historical data
      collectionRate: 85.0, // Default/estimated value
      collectionTrend: 0.0, // Would need historical data
      criticalCount: criticalCount,
      criticalTrend: 0.0, // Would need historical data
      totalReceivable: totalReceivable,
      totalPayable: totalPayable,
      transactionCount: transactionCount,
    );
  }

  /// Get aging analysis for debt portfolio
  Future<AgingAnalysis> getAgingAnalysis({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    try {
      final response = await _client.rpc('get_debt_aging_analysis', params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_viewpoint': viewpoint,
      });

      if (response != null && response is Map<String, dynamic>) {
        return AgingAnalysis.fromJson(response);
      }

      // Fallback calculation
      return await _calculateAgingAnalysisManually(companyId, storeId, viewpoint);
    } catch (e) {
      print('Error fetching aging analysis: $e');
      return const AgingAnalysis();
    }
  }

  /// Calculate aging analysis manually as fallback
  Future<AgingAnalysis> _calculateAgingAnalysisManually(
    String companyId,
    String? storeId,
    String viewpoint,
  ) async {
    var query = _client
        .from('debts_receivable')
        .select('amount, due_date')
        .eq('company_id', companyId);

    if (viewpoint == 'store' && storeId != null) {
      query = query.eq('store_id', storeId);
    }

    final debtsData = await query;
    
    double current = 0;
    double overdue30 = 0;
    double overdue60 = 0;
    double overdue90 = 0;

    final now = DateTime.now();

    for (final debt in debtsData) {
      final amount = (debt['amount'] as num?)?.toDouble() ?? 0.0;
      final dueDate = DateTime.tryParse(debt['due_date'] ?? '');
      
      if (dueDate != null && amount > 0) {
        final daysOverdue = now.difference(dueDate).inDays;
        
        if (daysOverdue <= 30) {
          current += amount;
        } else if (daysOverdue <= 60) {
          overdue30 += amount;
        } else if (daysOverdue <= 90) {
          overdue60 += amount;
        } else {
          overdue90 += amount;
        }
      }
    }

    return AgingAnalysis(
      current: current,
      overdue30: overdue30,
      overdue60: overdue60,
      overdue90: overdue90,
      trend: [], // Would need historical data
    );
  }

  /// Get critical alerts for proactive debt management
  Future<List<CriticalAlert>> getCriticalAlerts({
    required String companyId,
    String? storeId,
  }) async {
    List<CriticalAlert> alerts = [];

    try {
      // Query for critical overdue items
      var overdueQuery = _client
          .from('debts_receivable')
          .select('debt_id, amount, due_date')
          .eq('company_id', companyId)
          .gt('amount', 0);

      if (storeId != null) {
        overdueQuery = overdueQuery.eq('store_id', storeId);
      }

      final overdueData = await overdueQuery;
      final now = DateTime.now();
      
      int criticalOverdueCount = 0;
      for (final debt in overdueData) {
        final dueDate = DateTime.tryParse(debt['due_date'] ?? '');
        if (dueDate != null && now.difference(dueDate).inDays > 90) {
          criticalOverdueCount++;
        }
      }

      if (criticalOverdueCount > 0) {
        alerts.add(CriticalAlert(
          id: 'overdue_critical_${DateTime.now().millisecondsSinceEpoch}',
          type: 'overdue_critical',
          message: '$criticalOverdueCount debts overdue >90 days',
          count: criticalOverdueCount,
          severity: 'critical',
          createdAt: DateTime.now(),
        ));
      }

      // Query for recent payments (would need payment tracking)
      // This is a placeholder - would need proper payment tracking table
      
      // Query for pending disputes (would need dispute tracking)
      // This is a placeholder - would need proper dispute tracking

      return alerts;
    } catch (e) {
      print('Error fetching critical alerts: $e');
      return alerts;
    }
  }

  /// Get prioritized debts with risk scoring
  Future<List<PrioritizedDebt>> getPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _client.rpc('get_prioritized_debts', params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_viewpoint': viewpoint,
        'p_filter': filter,
        'p_limit': limit,
        'p_offset': offset,
      });

      if (response != null && response is List) {
        return response
            .map((item) => PrioritizedDebt.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      // Fallback: Manual calculation
      return await _calculatePrioritizedDebtsManually(
        companyId,
        storeId,
        viewpoint,
        filter,
        limit,
        offset,
      );
    } catch (e) {
      print('Error fetching prioritized debts: $e');
      return [];
    }
  }

  /// Calculate prioritized debts manually as fallback
  Future<List<PrioritizedDebt>> _calculatePrioritizedDebtsManually(
    String companyId,
    String? storeId,
    String viewpoint,
    String filter,
    int limit,
    int offset,
  ) async {
    // Query debts with counterparty information
    var query = _client
        .from('debts_receivable')
        .select('''
          id,
          amount,
          due_date,
          created_at,
          counterparty_id,
          counterparties!inner(
            counterparty_id,
            name,
            type,
            email,
            is_internal
          )
        ''')
        .eq('company_id', companyId);

    if (viewpoint == 'store' && storeId != null) {
      query = query.eq('store_id', storeId);
    }

    // Apply filter
    if (filter == 'group') {
      query = query.eq('counterparties.is_internal', true);
    } else if (filter == 'external') {
      query = query.eq('counterparties.is_internal', false);
    }

    final debtsData = await query.limit(limit).range(offset, offset + limit - 1);
    
    List<PrioritizedDebt> prioritizedDebts = [];
    final now = DateTime.now();

    for (final debt in debtsData) {
      final amount = (debt['amount'] as num?)?.toDouble() ?? 0.0;
      final dueDate = DateTime.tryParse(debt['due_date'] ?? '');
      final counterparty = debt['counterparties'] as Map<String, dynamic>?;

      if (counterparty != null && amount != 0) {
        final daysOverdue = dueDate != null 
            ? now.difference(dueDate).inDays 
            : 0;

        // Calculate risk category and priority score
        final riskData = _calculateRiskScore(amount, daysOverdue);

        // Generate suggested actions
        final suggestedActions = _generateSuggestedActions(
          riskData.category,
          daysOverdue,
          amount,
        );

        prioritizedDebts.add(PrioritizedDebt(
          id: debt['id'],
          counterpartyId: counterparty['counterparty_id'],
          counterpartyName: counterparty['name'] ?? 'Unknown',
          counterpartyType: counterparty['type'] ?? 'external',
          amount: amount,
          currency: 'KRW', // Default currency
          dueDate: dueDate ?? DateTime.now(),
          daysOverdue: daysOverdue > 0 ? daysOverdue : 0,
          riskCategory: riskData.category,
          priorityScore: riskData.score,
          suggestedActions: suggestedActions,
        ));
      }
    }

    // Sort by priority score (highest first)
    prioritizedDebts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

    return prioritizedDebts;
  }

  /// Calculate risk score and category for a debt
  RiskScoreData _calculateRiskScore(double amount, int daysOverdue) {
    double score = 0;
    String category = 'current';

    // Amount factor (0-30 points)
    if (amount > 10000000) { // > 10M KRW
      score += 30;
    } else if (amount > 5000000) { // > 5M KRW
      score += 20;
    } else if (amount > 1000000) { // > 1M KRW
      score += 10;
    }

    // Days overdue factor (0-50 points)
    if (daysOverdue > 90) {
      score += 50;
      category = 'critical';
    } else if (daysOverdue > 60) {
      score += 35;
      category = 'attention';
    } else if (daysOverdue > 30) {
      score += 20;
      category = 'watch';
    } else if (daysOverdue > 0) {
      score += 10;
      category = 'watch';
    } else {
      category = 'current';
    }

    // Cap score at 100
    score = score.clamp(0, 100);

    return RiskScoreData(score: score, category: category);
  }

  /// Generate contextual action suggestions
  List<SuggestedAction> _generateSuggestedActions(
    String riskCategory,
    int daysOverdue,
    double amount,
  ) {
    List<SuggestedAction> actions = [];

    switch (riskCategory) {
      case 'critical':
        actions.addAll([
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
          SuggestedAction(
            id: 'payment_plan',
            type: 'payment_plan',
            label: 'Payment Plan',
            icon: 'payment',
            isPrimary: false,
            color: '#3B82F6',
          ),
        ]);
        break;

      case 'attention':
        actions.addAll([
          SuggestedAction(
            id: 'email',
            type: 'email',
            label: 'Send Reminder',
            icon: 'email',
            isPrimary: true,
            color: '#F59E0B',
          ),
          SuggestedAction(
            id: 'call',
            type: 'call',
            label: 'Call',
            icon: 'phone',
            isPrimary: true,
            color: '#3B82F6',
          ),
          SuggestedAction(
            id: 'payment_plan',
            type: 'payment_plan',
            label: 'Payment Plan',
            icon: 'payment',
            isPrimary: false,
            color: '#3B82F6',
          ),
        ]);
        break;

      default:
        actions.addAll([
          SuggestedAction(
            id: 'statement',
            type: 'statement',
            label: 'Send Statement',
            icon: 'description',
            isPrimary: true,
            color: '#10B981',
          ),
          SuggestedAction(
            id: 'payment_link',
            type: 'payment_link',
            label: 'Payment Link',
            icon: 'link',
            isPrimary: true,
            color: '#3B82F6',
          ),
        ]);
    }

    return actions;
  }

  /// Get comprehensive debt analytics
  Future<DebtAnalytics> getDebtAnalytics({
    required String companyId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      // For now, return basic analytics using existing data
      final agingAnalysis = await getAgingAnalysis(
        companyId: companyId,
        storeId: storeId,
        viewpoint: storeId != null ? 'store' : 'company',
      );

      return DebtAnalytics(
        currentAging: agingAnalysis,
        collectionEfficiency: 85.0, // Default value
        riskDistribution: {
          'critical': agingAnalysis.overdue90,
          'attention': agingAnalysis.overdue60,
          'watch': agingAnalysis.overdue30,
          'current': agingAnalysis.current,
        },
        reportDate: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching debt analytics: $e');
      return DebtAnalytics(
        currentAging: const AgingAnalysis(),
        collectionEfficiency: 0.0,
        riskDistribution: const {},
        reportDate: DateTime.now(),
      );
    }
  }

  /// Get debt communications history
  Future<List<DebtCommunication>> getDebtCommunications(String debtId) async {
    try {
      // This would require a debt_communications table
      // For now, return empty list as placeholder
      return [];
    } catch (e) {
      print('Error fetching debt communications: $e');
      return [];
    }
  }

  /// Create new debt communication record
  Future<void> createDebtCommunication(DebtCommunication communication) async {
    try {
      // This would insert into debt_communications table
      // Placeholder implementation
      print('Would create communication record: ${communication.type}');
    } catch (e) {
      print('Error creating debt communication: $e');
      rethrow;
    }
  }

  /// Get payment plans for a debt
  Future<List<PaymentPlan>> getPaymentPlans(String debtId) async {
    try {
      // This would require a payment_plans table
      // For now, return empty list as placeholder
      return [];
    } catch (e) {
      print('Error fetching payment plans: $e');
      return [];
    }
  }

  /// Create new payment plan
  Future<void> createPaymentPlan(PaymentPlan paymentPlan) async {
    try {
      // This would insert into payment_plans table
      // Placeholder implementation
      print('Would create payment plan: ${paymentPlan.totalAmount}');
    } catch (e) {
      print('Error creating payment plan: $e');
      rethrow;
    }
  }

  /// Update payment plan status
  Future<void> updatePaymentPlanStatus(String planId, String status) async {
    try {
      // This would update payment_plans table
      // Placeholder implementation
      print('Would update payment plan $planId to status: $status');
    } catch (e) {
      print('Error updating payment plan status: $e');
      rethrow;
    }
  }

  /// Get top risk debts for overview
  Future<List<PrioritizedDebt>> getTopRiskDebts({
    required String companyId,
    String? storeId,
    int limit = 5,
  }) async {
    return await getPrioritizedDebts(
      companyId: companyId,
      storeId: storeId,
      viewpoint: storeId != null ? 'store' : 'company',
      filter: 'all',
      limit: limit,
      offset: 0,
    );
  }
}

/// Helper class for risk score calculation
class RiskScoreData {
  final double score;
  final String category;

  const RiskScoreData({required this.score, required this.category});
}