import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/internal_counterparty_models.dart';
import '../models/debt_control_models.dart';
import '../../../../data/repositories/supabase_debt_repository.dart';
import '../../../providers/app_state_provider.dart';
import 'debt_control_providers.dart';

/// Enhanced perspective-aware debt summary provider
final perspectiveDebtSummaryProvider = AsyncNotifierProvider<PerspectiveSummaryNotifier, PerspectiveDebtSummary?>(
  () => PerspectiveSummaryNotifier(),
);

class PerspectiveSummaryNotifier extends AsyncNotifier<PerspectiveDebtSummary?> {
  @override
  Future<PerspectiveDebtSummary?> build() async {
    return null;
  }

  Future<void> loadPerspectiveSummary({
    required String perspectiveType,
    required String entityId,
    String? entityName,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      
      // Load aggregated data based on perspective
      final summary = await _loadSummaryByPerspective(
        repository: repository,
        perspectiveType: perspectiveType,
        entityId: entityId,
        entityName: entityName ?? '',
      );
      
      state = AsyncValue.data(summary);
    } catch (error, stackTrace) {
      // Error loading perspective summary
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<PerspectiveDebtSummary> _loadSummaryByPerspective({
    required SupabaseDebtRepository repository,
    required String perspectiveType,
    required String entityId,
    required String entityName,
  }) async {
    switch (perspectiveType) {
      case 'company':
        // Load company-wide aggregation including all stores
        return await _loadCompanyPerspective(repository, entityId, entityName);
      
      case 'store':
        // Load specific store perspective
        return await _loadStorePerspective(repository, entityId, entityName);
      
      case 'group':
        // Load entire group perspective (all companies)
        return await _loadGroupPerspective(repository, entityId, entityName);
      
      default:
        throw Exception('Invalid perspective type: $perspectiveType');
    }
  }
  
  Future<PerspectiveDebtSummary> _loadCompanyPerspective(
    SupabaseDebtRepository repository,
    String companyId,
    String companyName,
  ) async {
    // Use the new RPC function to get company perspective data
    return await repository.getPerspectiveDebtSummary(
      companyId: companyId,
      storeId: null, // Company view doesn't specify a store
      perspectiveType: 'company',
      entityName: companyName,
    );
  }
  
  Future<PerspectiveDebtSummary> _loadStorePerspective(
    SupabaseDebtRepository repository,
    String storeId,
    String storeName,
  ) async {
    // Use the new RPC function to get store perspective data
    // For store perspective, we need to get the company ID from the storeId
    // This is a simplified approach - in real implementation, we'd need to fetch company_id for the store
    
    // For now, we'll need to get the company ID from context
    // This is a temporary solution until we implement proper store-to-company mapping
    final appState = ref.read(appStateProvider);
    
    return await repository.getPerspectiveDebtSummary(
      companyId: appState.companyChoosen, // Get company ID from app state
      storeId: storeId,
      perspectiveType: 'store',
      entityName: storeName,
    );
  }
  
  Future<PerspectiveDebtSummary> _loadGroupPerspective(
    SupabaseDebtRepository repository,
    String groupId,
    String groupName,
  ) async {
    // TODO: Implement group-wide perspective
    return PerspectiveDebtSummary(
      perspectiveType: 'group',
      entityId: groupId,
      entityName: groupName,
      totalReceivable: 0,
      totalPayable: 0,
      netPosition: 0,
      internalReceivable: 0,
      internalPayable: 0,
      internalNetPosition: 0,
      externalReceivable: 0,
      externalPayable: 0,
      externalNetPosition: 0,
      storeAggregates: [],
      counterpartyCount: 0,
      transactionCount: 0,
      collectionRate: 0.0,
      criticalCount: 0,
    );
  }
}

/// Internal counterparty detail provider with store breakdown
final internalCounterpartyDetailProvider = AsyncNotifierProvider.family<
  InternalCounterpartyNotifier, 
  InternalCounterpartyDetail?, 
  String
>(
  () => InternalCounterpartyNotifier(),
);

class InternalCounterpartyNotifier extends FamilyAsyncNotifier<InternalCounterpartyDetail?, String> {
  @override
  Future<InternalCounterpartyDetail?> build(String counterpartyId) async {
    return null;
  }
  
  Future<void> loadInternalCounterpartyDetail({
    required String counterpartyId,
    required String viewingCompanyId,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(debtRepositoryProvider);
      
      // TODO: Replace with actual database call when getCounterparty is implemented
      // Mock counterparty information for now
      final counterparty = {
        'counterparty_id': counterpartyId,
        'is_internal': true,
        'linked_company_id': 'company2',
        'linked_company_name': 'Sister Company Inc',
      };
      
      if (counterparty == null || counterparty['is_internal'] != true) {
        state = const AsyncValue.data(null);
        return;
      }
      
      final linkedCompanyId = counterparty['linked_company_id'] as String? ?? '';
      final linkedCompanyName = (counterparty['linked_company_name'] as String?) ?? 'Unknown Company';
      
      // TODO: Replace with actual database calls when implemented
      // Mock debt positions for now
      final ourDebts = [
        {'debt_type': 'receivable', 'amount': 10000000.0},
        {'debt_type': 'payable', 'amount': 1500000.0},
      ];
      
      final theirDebts = [
        {'debt_type': 'receivable', 'amount': 1500000.0},
        {'debt_type': 'payable', 'amount': 10000000.0},
      ];
      
      // Calculate positions from both perspectives
      double ourReceivable = 0;
      double ourPayable = 0;
      double theirReceivable = 0;
      double theirPayable = 0;
      
      for (final debt in ourDebts) {
        final amount = (debt['amount'] as num?)?.toDouble() ?? 0.0;
        if (debt['debt_type'] == 'receivable') {
          ourReceivable += amount;
        } else {
          ourPayable += amount;
        }
      }
      
      for (final debt in theirDebts) {
        final amount = (debt['amount'] as num?)?.toDouble() ?? 0.0;
        if (debt['debt_type'] == 'receivable') {
          theirReceivable += amount;
        } else {
          theirPayable += amount;
        }
      }
      
      // Check reconciliation
      final ourNet = ourReceivable - ourPayable;
      final theirNet = theirReceivable - theirPayable;
      final isReconciled = (ourNet + theirNet).abs() < 0.01; // Allow small variance
      
      // Get store-level breakdown
      // TODO: Replace with actual database call
      // Mock stores for now
      final stores = [
        {'store_id': 'store1', 'store_name': 'Store A', 'is_headquarters': false},
        {'store_id': 'store2', 'store_name': 'Store B', 'is_headquarters': false},
      ];
      List<StoreDebtPosition> storeBreakdown = [];
      
      for (final store in stores) {
        // TODO: Replace with actual database call
        // Mock store debts for now
        final storeDebts = [
          {'amount': 1500000.0, 'debt_type': 'receivable'},
          {'amount': 500000.0, 'debt_type': 'payable'},
        ];
        // When implemented, use:
        // final storeDebts = await repository.getStoreDebtsWithCounterparty(
        //   storeId: store['store_id'],
        //   counterpartyId: viewingCompanyId,
        // );
        
        double storeReceivable = 0;
        double storePayable = 0;
        int transactionCount = 0;
        DateTime? lastTransaction;
        
        for (final debt in storeDebts) {
          final amount = (debt['amount'] as num?)?.toDouble() ?? 0.0;
          if (debt['debt_type'] == 'receivable') {
            storeReceivable += amount;
          } else {
            storePayable += amount;
          }
          transactionCount++;
          
          final transDate = debt['created_at'] != null 
            ? DateTime.tryParse(debt['created_at'] as String? ?? '') 
            : null;
          if (transDate != null && (lastTransaction == null || transDate.isAfter(lastTransaction))) {
            lastTransaction = transDate;
          }
        }
        
        if (transactionCount > 0) {
          storeBreakdown.add(StoreDebtPosition(
            storeId: store['store_id'] as String? ?? '',
            storeName: store['store_name'] as String? ?? '',
            storeCode: (store['store_code'] as String?) ?? '',
            receivable: storeReceivable,
            payable: storePayable,
            netPosition: storeReceivable - storePayable,
            transactionCount: transactionCount,
            lastTransactionDate: lastTransaction,
            hasOverdue: false, // TODO: Implement
            hasDispute: false, // TODO: Implement
          ));
        }
      }
      
      final detail = InternalCounterpartyDetail(
        counterpartyId: counterpartyId,
        counterpartyName: (counterparty['name'] as String?) ?? linkedCompanyName,
        linkedCompanyId: linkedCompanyId,
        linkedCompanyName: linkedCompanyName,
        ourTotalReceivable: ourReceivable,
        ourTotalPayable: ourPayable,
        ourNetPosition: ourNet,
        theirTotalReceivable: theirReceivable,
        theirTotalPayable: theirPayable,
        theirNetPosition: theirNet,
        isReconciled: isReconciled,
        variance: isReconciled ? 0 : (ourNet + theirNet).abs(),
        lastReconciliationDate: DateTime.now(),
        storeBreakdown: storeBreakdown,
        activeStoreCount: storeBreakdown.length,
        transactionCount: storeBreakdown.fold(0, (sum, store) => sum + store.transactionCount),
        lastTransactionDate: _getLatestDate(storeBreakdown.map((s) => s.lastTransactionDate).whereType<DateTime>().toList()),
      );
      
      state = AsyncValue.data(detail);
    } catch (error, stackTrace) {
      // Error loading internal counterparty detail
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  DateTime? _getLatestDate(List<DateTime> dates) {
    if (dates.isEmpty) return null;
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

/// Provider for reconciliation status
final reconciliationStatusProvider = FutureProvider.family<ReconciliationStatus?, String>(
  (ref, counterpartyId) async {
    // TODO: Implement reconciliation check
    return null;
  },
);