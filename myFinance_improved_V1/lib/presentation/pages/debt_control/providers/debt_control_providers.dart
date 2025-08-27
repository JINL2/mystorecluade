import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/supabase_debt_repository.dart';
import '../models/debt_control_models.dart';

/// Repository provider for debt control operations
final debtRepositoryProvider = Provider<SupabaseDebtRepository>((ref) {
  return SupabaseDebtRepository();
});

/// Smart debt overview provider with caching and error handling
final smartDebtOverviewProvider = AsyncNotifierProvider<SmartDebtOverviewNotifier, SmartDebtOverview?>(
  () => SmartDebtOverviewNotifier(),
);

class SmartDebtOverviewNotifier extends AsyncNotifier<SmartDebtOverview?> {
  @override
  Future<SmartDebtOverview?> build() async {
    return null; // Initial state
  }

  /// Load smart overview with AI-driven insights
  Future<void> loadSmartOverview({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      
      // Load KPI metrics with error handling
      KPIMetrics kpiMetrics;
      try {
        // Use direct database query method
        kpiMetrics = await repository.getKPIMetricsFromDatabase(
          companyId: companyId,
          storeId: storeId,
        );
      } catch (e) {
        try {
          // Fallback to original method if new method fails
          kpiMetrics = await repository.getKPIMetrics(
            companyId: companyId,
            storeId: storeId,
            viewpoint: viewpoint,
          );
        } catch (e2) {
          // Using default KPI metrics due to error
          kpiMetrics = const KPIMetrics();
        }
      }
      
      // Load aging analysis with error handling
      AgingAnalysis agingAnalysis;
      try {
        agingAnalysis = await repository.getAgingAnalysis(
          companyId: companyId,
          storeId: storeId,
          viewpoint: viewpoint,
        );
      } catch (e) {
        // Using default aging analysis due to error
        agingAnalysis = const AgingAnalysis();
      }
      
      // Load critical alerts with error handling
      List<CriticalAlert> criticalAlerts;
      try {
        criticalAlerts = await repository.getCriticalAlerts(
          companyId: companyId,
          storeId: storeId,
        );
      } catch (e) {
        // Using empty critical alerts due to error
        criticalAlerts = [];
      }
      
      // Load top risk debts with error handling
      List<PrioritizedDebt> topRisks;
      try {
        topRisks = await repository.getTopRiskDebts(
          companyId: companyId,
          storeId: storeId,
          limit: 5,
        );
      } catch (e) {
        // Using empty top risks due to error
        topRisks = [];
      }
      
      final overview = SmartDebtOverview(
        kpiMetrics: kpiMetrics,
        agingAnalysis: agingAnalysis,
        criticalAlerts: criticalAlerts,
        topRisks: topRisks,
        viewpointDescription: _getViewpointDescription(viewpoint),
        lastUpdated: DateTime.now(),
      );
      
      state = AsyncValue.data(overview);
    } catch (error, stackTrace) {
      // Provide a default state instead of error state for better UX
      // Critical error in loadSmartOverview
      state = AsyncValue.data(SmartDebtOverview(
        kpiMetrics: const KPIMetrics(),
        agingAnalysis: const AgingAnalysis(),
        criticalAlerts: [],
        topRisks: [],
        viewpointDescription: _getViewpointDescription(viewpoint),
        lastUpdated: DateTime.now(),
      ));
    }
  }
  
  String _getViewpointDescription(String viewpoint) {
    switch (viewpoint) {
      case 'company':
        return 'Company-wide debt overview';
      case 'store':
        return 'Store-specific debt analysis';
      case 'headquarters':
        return 'Headquarters debt management';
      default:
        return 'Debt overview';
    }
  }
}

/// Prioritized debts provider with intelligent sorting
final prioritizedDebtsProvider = AsyncNotifierProvider<PrioritizedDebtsNotifier, List<PrioritizedDebt>>(
  () => PrioritizedDebtsNotifier(),
);

class PrioritizedDebtsNotifier extends AsyncNotifier<List<PrioritizedDebt>> {
  @override
  Future<List<PrioritizedDebt>> build() async {
    return []; // Initial empty state
  }

  /// Load prioritized debts with risk scoring
  Future<void> loadPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      
      // Use getPrioritizedDebts which internally uses RPC with local filtering
      final debts = await repository.getPrioritizedDebts(
        companyId: companyId,
        storeId: storeId,
        viewpoint: viewpoint,
        filter: filter, // 'all', 'internal', 'external'
        limit: limit,
        offset: offset,
      );
      
      state = AsyncValue.data(debts);
    } catch (error, stackTrace) {
      // Provide empty list instead of error state for better UX
      // Error loading prioritized debts
      state = const AsyncValue.data([]);
    }
  }
  
  /// Add new debt to the list
  void addDebt(PrioritizedDebt debt) {
    if (state.hasValue) {
      final currentDebts = state.value!;
      final updatedDebts = [...currentDebts, debt];
      // Re-sort by priority score
      updatedDebts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
      state = AsyncValue.data(updatedDebts);
    }
  }
  
  /// Update debt in the list
  void updateDebt(String debtId, PrioritizedDebt updatedDebt) {
    if (state.hasValue) {
      final currentDebts = state.value!;
      final index = currentDebts.indexWhere((d) => d.id == debtId);
      if (index != -1) {
        final updatedDebts = [...currentDebts];
        updatedDebts[index] = updatedDebt;
        // Re-sort by priority score
        updatedDebts.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
        state = AsyncValue.data(updatedDebts);
      }
    }
  }
  
  /// Remove debt from the list
  void removeDebt(String debtId) {
    if (state.hasValue) {
      final currentDebts = state.value!;
      final updatedDebts = currentDebts.where((d) => d.id != debtId).toList();
      state = AsyncValue.data(updatedDebts);
    }
  }
}

/// Debt analytics provider for reporting and insights
final debtAnalyticsProvider = AsyncNotifierProvider<DebtAnalyticsNotifier, DebtAnalytics?>(
  () => DebtAnalyticsNotifier(),
);

class DebtAnalyticsNotifier extends AsyncNotifier<DebtAnalytics?> {
  @override
  Future<DebtAnalytics?> build() async {
    return null;
  }

  /// Load comprehensive debt analytics
  Future<void> loadAnalytics({
    required String companyId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      
      final analytics = await repository.getDebtAnalytics(
        companyId: companyId,
        storeId: storeId,
        fromDate: fromDate,
        toDate: toDate,
      );
      
      state = AsyncValue.data(analytics);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Quick actions configuration provider
final quickActionsProvider = Provider<List<QuickAction>>((ref) {
  return [
    QuickAction(
      id: 'create_invoice',
      type: 'creation',
      label: 'Create Invoice',
      icon: 'receipt',
      color: '#3B82F6',
      isEnabled: true,
      description: 'Create a new invoice for debt tracking',
    ),
    QuickAction(
      id: 'record_payment',
      type: 'payment',
      label: 'Record Payment',
      icon: 'payment',
      color: '#10B981',
      isEnabled: true,
      description: 'Record a received payment',
    ),
    QuickAction(
      id: 'bulk_reminder',
      type: 'communication',
      label: 'Bulk Reminder',
      icon: 'email',
      color: '#F59E0B',
      isEnabled: true,
      description: 'Send reminders to multiple customers',
    ),
    QuickAction(
      id: 'analytics',
      type: 'analysis',
      label: 'Analytics',
      icon: 'analytics',
      color: '#8B5CF6',
      isEnabled: true,
      description: 'View detailed debt analytics',
    ),
  ];
});

/// Debt communication provider for tracking follow-ups
final debtCommunicationProvider = AsyncNotifierProvider.family<DebtCommunicationNotifier, List<DebtCommunication>, String>(
  () => DebtCommunicationNotifier(),
);

class DebtCommunicationNotifier extends FamilyAsyncNotifier<List<DebtCommunication>, String> {
  @override
  Future<List<DebtCommunication>> build(String debtId) async {
    final repository = ref.read(debtRepositoryProvider);
    return await repository.getDebtCommunications(debtId);
  }

  /// Add new communication record
  Future<void> addCommunication(DebtCommunication communication) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.createDebtCommunication(communication);
      
      // Reload communications
      final communications = await repository.getDebtCommunications(arg);
      state = AsyncValue.data(communications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Payment plan provider for structured debt collection
final paymentPlansProvider = AsyncNotifierProvider.family<PaymentPlansNotifier, List<PaymentPlan>, String>(
  () => PaymentPlansNotifier(),
);

class PaymentPlansNotifier extends FamilyAsyncNotifier<List<PaymentPlan>, String> {
  @override
  Future<List<PaymentPlan>> build(String debtId) async {
    final repository = ref.read(debtRepositoryProvider);
    return await repository.getPaymentPlans(debtId);
  }

  /// Create new payment plan
  Future<void> createPaymentPlan(PaymentPlan paymentPlan) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.createPaymentPlan(paymentPlan);
      
      // Reload payment plans
      final plans = await repository.getPaymentPlans(arg);
      state = AsyncValue.data(plans);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Update payment plan status
  Future<void> updatePaymentPlanStatus(String planId, String status) async {
    if (state.hasValue) {
      final currentPlans = state.value!;
      final repository = ref.read(debtRepositoryProvider);
      
      try {
        await repository.updatePaymentPlanStatus(planId, status);
        
        // Update local state
        final updatedPlans = currentPlans.map((plan) {
          if (plan.id == planId) {
            return plan.copyWith(status: status);
          }
          return plan;
        }).toList();
        
        state = AsyncValue.data(updatedPlans);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

/// Debt filter state provider
final debtFilterProvider = StateNotifierProvider<DebtFilterNotifier, DebtFilter>(
  (ref) => DebtFilterNotifier(),
);

class DebtFilterNotifier extends StateNotifier<DebtFilter> {
  DebtFilterNotifier() : super(const DebtFilter());

  /// Update counterparty type filter
  void setCounterpartyType(String type) {
    state = state.copyWith(counterpartyType: type);
  }

  /// Update risk category filter
  void setRiskCategory(String category) {
    state = state.copyWith(riskCategory: category);
  }

  /// Update payment status filter
  void setPaymentStatus(String status) {
    state = state.copyWith(paymentStatus: status);
  }

  /// Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update date range
  void setDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(fromDate: from, toDate: to);
  }

  /// Reset all filters
  void reset() {
    state = const DebtFilter();
  }
}

/// Current selected debt provider for detail view
final selectedDebtProvider = StateProvider<PrioritizedDebt?>((ref) => null);

/// Debt action loading state provider
final debtActionLoadingProvider = StateProvider<Set<String>>((ref) => <String>{});

/// Helper provider to manage debt action loading states
final debtActionLoadingNotifierProvider = StateNotifierProvider<DebtActionLoadingNotifier, Set<String>>(
  (ref) => DebtActionLoadingNotifier(),
);

class DebtActionLoadingNotifier extends StateNotifier<Set<String>> {
  DebtActionLoadingNotifier() : super(<String>{});

  /// Add debt to loading state
  void addLoading(String debtId) {
    state = {...state, debtId};
  }

  /// Remove debt from loading state
  void removeLoading(String debtId) {
    state = state.where((id) => id != debtId).toSet();
  }

  /// Check if debt is loading
  bool isLoading(String debtId) {
    return state.contains(debtId);
  }
}