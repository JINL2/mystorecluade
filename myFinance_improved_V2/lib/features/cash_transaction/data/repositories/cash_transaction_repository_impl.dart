import 'package:flutter/foundation.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../../cash_location/domain/constants/account_ids.dart';
import '../../domain/entities/cash_transaction_enums.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/counterparty.dart';
import '../../domain/entities/expense_account.dart';
import '../../domain/repositories/cash_transaction_repository.dart';
import '../datasources/cash_transaction_datasource.dart';

const _tag = '[CashControlRepoImpl]';

/// Implementation of CashTransactionRepository
/// Coordinates between domain and data layers
class CashTransactionRepositoryImpl implements CashTransactionRepository {
  final CashTransactionDataSource dataSource;

  /// Cache for completed inter-company setups
  /// Key format: "myCompanyId:targetCompanyId"
  /// Once setup is done, we don't need to call RPC again
  static final Set<String> _completedSetups = {};

  /// Cache for counterparty IDs
  /// Key format: "myCompanyId:targetCompanyId" -> counterpartyId
  static final Map<String, String> _counterpartyCache = {};

  CashTransactionRepositoryImpl({required this.dataSource});

  /// Check if setup is already completed for this company pair
  bool _isSetupCompleted(String myCompanyId, String targetCompanyId) {
    final key = '$myCompanyId:$targetCompanyId';
    return _completedSetups.contains(key);
  }

  /// Mark setup as completed for this company pair
  void _markSetupCompleted(String myCompanyId, String targetCompanyId) {
    final key = '$myCompanyId:$targetCompanyId';
    _completedSetups.add(key);
  }

  /// Get cached counterparty ID
  String? _getCachedCounterparty(String myCompanyId, String targetCompanyId) {
    final key = '$myCompanyId:$targetCompanyId';
    return _counterpartyCache[key];
  }

  /// Cache counterparty ID
  void _cacheCounterparty(String myCompanyId, String targetCompanyId, String counterpartyId) {
    final key = '$myCompanyId:$targetCompanyId';
    _counterpartyCache[key] = counterpartyId;
  }

  /// Clear all caches (useful for logout or testing)
  static void clearCaches() {
    _completedSetups.clear();
    _counterpartyCache.clear();
  }

  /// Factory method to create DataSource instance
  static CashTransactionDataSource createDataSource() {
    return CashTransactionDataSource();
  }

  @override
  Future<List<ExpenseAccount>> getExpenseAccounts({
    required String companyId,
    required String userId,
    int limit = 20,
  }) async {
    final models = await dataSource.getExpenseAccounts(
      companyId: companyId,
      userId: userId,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExpenseAccount>> searchExpenseAccounts({
    required String companyId,
    String? query,
    int limit = 50,
  }) async {
    // Use the new RPC that only returns expense accounts
    debugPrint('$_tag searchExpenseAccounts called with companyId: $companyId, query: $query');

    final models = await dataSource.getAllExpenseAccounts(
      companyId: companyId,
      searchQuery: query,
      limit: limit,
    );

    debugPrint('$_tag Got ${models.length} expense accounts from RPC');
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExpenseAccount>> getExpenseAccountsOnly({
    required String companyId,
    int limit = 50,
  }) async {
    // Get only expense accounts (account_type = 'expense')
    debugPrint('$_tag getExpenseAccountsOnly called with companyId: $companyId');

    final models = await dataSource.getAllExpenseAccounts(
      companyId: companyId,
      limit: limit,
    );

    debugPrint('$_tag Got ${models.length} expense accounts');
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Counterparty>> getCounterparties({
    required String companyId,
    String? query,
    int limit = 50,
  }) async {
    final models = await dataSource.getCounterparties(
      companyId: companyId,
    );

    var entities = models.map((m) => m.toEntity()).toList();

    // Client-side filtering for search
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      entities = entities
          .where((e) => e.name.toLowerCase().contains(lowerQuery))
          .toList();
    }

    return entities.take(limit).toList();
  }

  @override
  Future<Counterparty?> getSelfCounterparty({
    required String companyId,
  }) async {
    debugPrint('$_tag getSelfCounterparty called with companyId: $companyId');
    final model = await dataSource.getSelfCounterparty(companyId: companyId);
    if (model == null) {
      debugPrint('$_tag No self-counterparty found');
      return null;
    }
    debugPrint('$_tag Found self-counterparty: ${model.name}');
    return model.toEntity();
  }

  @override
  Future<List<CashLocation>> getCashLocations({
    required String storeId,
  }) async {
    // This needs companyId - will be passed from provider
    // For now, use empty string which will be handled in presentation
    final models = await dataSource.getCashLocations(
      companyId: '', // Will be overridden in provider
      storeId: storeId,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<CashLocation>> getCashLocationsForCompany({
    required String companyId,
  }) async {
    debugPrint('$_tag getCashLocationsForCompany called with companyId: $companyId');
    final models = await dataSource.getCashLocations(
      companyId: companyId,
    );
    debugPrint('$_tag Got ${models.length} models from datasource');
    final entities = models.map((m) => m.toEntity()).toList();
    debugPrint('$_tag Returning ${entities.length} entities');
    return entities;
  }

  @override
  Future<String> createExpenseEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String expenseAccountId,
    required double amount,
    required DateTime entryDate,
    required bool isRefund,
    String? memo,
    List<String>? attachmentUrls,
  }) async {
    debugPrint('$_tag 🔄 createExpenseEntry called');
    debugPrint('$_tag   expenseAccountId: $expenseAccountId');
    debugPrint('$_tag   cashLocationId: $cashLocationId');
    debugPrint('$_tag   amount: $amount');
    debugPrint('$_tag   isRefund: $isRefund');

    // Build journal lines based on direction
    // Pay (isRefund=false): DR Expense, CR Cash (money goes out)
    // Refund (isRefund=true): DR Cash, CR Expense (money comes back)
    final List<Map<String, dynamic>> lines;

    if (isRefund) {
      // Refund: DR Cash (증가), CR Expense (감소)
      lines = [
        {
          'account_id': AccountIds.cash,
          'debit': amount,
          'credit': 0.0,
          'cash': {
            'cash_location_id': cashLocationId,
          },
        },
        {
          'account_id': expenseAccountId,
          'debit': 0.0,
          'credit': amount,
        },
      ];
    } else {
      // Pay: DR Expense (증가), CR Cash (감소)
      lines = [
        {
          'account_id': expenseAccountId,
          'debit': amount,
          'credit': 0.0,
        },
        {
          'account_id': AccountIds.cash,
          'debit': 0.0,
          'credit': amount,
          'cash': {
            'cash_location_id': cashLocationId,
          },
        },
      ];
    }

    debugPrint('$_tag 📋 Journal lines to create:');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      debugPrint('$_tag   Line $i: account_id=${line['account_id']}, DR=${line['debit']}, CR=${line['credit']}');
      if (line['cash'] != null) {
        debugPrint('$_tag     -> cash_location_id=${line['cash']['cash_location_id']}');
      }
    }

    final result = await dataSource.createExpenseEntry(
      amount: amount,
      companyId: companyId,
      storeId: storeId ?? '',
      createdBy: createdBy,
      description: memo ?? 'Expense',
      entryDateUtc: DateTimeUtils.toUtc(entryDate),
      lines: lines,
      cashLocationId: cashLocationId,
    );

    if (result['success'] == true) {
      // RPC returns UUID directly as String, not as Map
      final data = result['data'];
      final String journalId;
      if (data is String) {
        journalId = data;
      } else if (data is Map<String, dynamic>) {
        journalId = (data['journal_id'] as String?) ?? '';
      } else {
        journalId = '';
      }
      debugPrint('$_tag ✅ Expense entry SUCCESS! journal_id: $journalId');
      return journalId;
    } else {
      debugPrint('$_tag ❌ Expense entry FAILED: ${result['error']}');
      throw Exception(result['error'] ?? 'Failed to create expense entry');
    }
  }

  @override
  Future<String> createDebtEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String counterpartyId,
    required DebtSubType debtSubType,
    required double amount,
    required DateTime entryDate,
    String? memo,
    List<String>? attachmentUrls,
  }) async {
    debugPrint('$_tag 🔄 createDebtEntry called');
    debugPrint('$_tag   debtSubType: ${debtSubType.label}');
    debugPrint('$_tag   debtDirection: ${debtSubType.debtDirection}');
    debugPrint('$_tag   isIncreasing: ${debtSubType.isIncreasing}');
    debugPrint('$_tag   counterpartyId: $counterpartyId');
    debugPrint('$_tag   cashLocationId: $cashLocationId');
    debugPrint('$_tag   amount: $amount');

    // Build journal lines based on debt type
    // Lend: DR Receivable, CR Cash (cash out)
    // Collect: DR Cash, CR Receivable (cash in)
    // Borrow: DR Cash, CR Payable (cash in)
    // Repay: DR Payable, CR Cash (cash out)
    final lines = _buildDebtJournalLines(
      debtSubType: debtSubType,
      amount: amount,
      cashLocationId: cashLocationId,
    );

    debugPrint('$_tag 📋 Debt journal lines to create:');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      debugPrint('$_tag   Line $i: $line');
    }

    final result = await dataSource.createExpenseEntry(
      amount: amount,
      companyId: companyId,
      storeId: storeId ?? '',
      createdBy: createdBy,
      description: memo ?? debtSubType.label,
      entryDateUtc: DateTimeUtils.toUtc(entryDate),
      lines: lines,
      counterpartyId: counterpartyId,
      cashLocationId: cashLocationId,
    );

    if (result['success'] == true) {
      // RPC returns UUID directly as String, not as Map
      final data = result['data'];
      final String journalId;
      if (data is String) {
        journalId = data;
      } else if (data is Map<String, dynamic>) {
        journalId = (data['journal_id'] as String?) ?? '';
      } else {
        journalId = '';
      }
      debugPrint('$_tag ✅ Debt entry journal created! journal_id: $journalId');

      // Create debt record
      await dataSource.createDebtRecord(
        debtInfo: {
          'debt_type': debtSubType.debtDirection,
          'is_increasing': debtSubType.isIncreasing,
        },
        companyId: companyId,
        storeId: storeId ?? '',
        journalId: journalId,
        accountId: _getDebtAccountId(debtSubType),
        amount: amount,
        entryDate: DateTimeUtils.toUtc(entryDate),
      );

      return journalId;
    } else {
      throw Exception(result['error'] ?? 'Failed to create debt entry');
    }
  }

  @override
  Future<String> createTransferWithinStore({
    required String companyId,
    required String storeId,
    required String createdBy,
    required String fromCashLocationId,
    required String toCashLocationId,
    required double amount,
    required DateTime entryDate,
    String? memo,
    List<String>? attachmentUrls,
  }) async {
    debugPrint('$_tag 🔄 createTransferWithinStore called');
    debugPrint('$_tag   companyId: $companyId, storeId: $storeId');
    debugPrint('$_tag   from: $fromCashLocationId -> to: $toCashLocationId');
    debugPrint('$_tag   amount: $amount');

    // Build journal lines for transfer
    // DR: To Location (Cash account, amount goes IN)
    // CR: From Location (Cash account, amount goes OUT)
    // RPC expects: account_id, debit, credit, cash.cash_location_id
    final lines = [
      {
        'account_id': AccountIds.cash,
        'debit': amount,
        'credit': 0.0,
        'cash': {
          'cash_location_id': toCashLocationId,
        },
      },
      {
        'account_id': AccountIds.cash,
        'debit': 0.0,
        'credit': amount,
        'cash': {
          'cash_location_id': fromCashLocationId,
        },
      },
    ];

    debugPrint('$_tag 📤 Calling dataSource.createExpenseEntry...');
    final result = await dataSource.createExpenseEntry(
      amount: amount,
      companyId: companyId,
      storeId: storeId,
      createdBy: createdBy,
      description: memo ?? 'Transfer',
      entryDateUtc: DateTimeUtils.toUtc(entryDate),
      lines: lines,
      cashLocationId: fromCashLocationId,
    );

    debugPrint('$_tag 📥 Result: $result');

    if (result['success'] == true) {
      // RPC returns UUID directly as String, not as Map
      final data = result['data'];
      final String journalId;
      if (data is String) {
        journalId = data;
      } else if (data is Map<String, dynamic>) {
        journalId = (data['journal_id'] as String?) ?? '';
      } else {
        journalId = '';
      }
      debugPrint('$_tag ✅ Transfer SUCCESS! journal_id: $journalId');
      return journalId;
    } else {
      debugPrint('$_tag ❌ Transfer FAILED: ${result['error']}');
      throw Exception(result['error'] ?? 'Failed to create transfer entry');
    }
  }

  @override
  Future<String> createTransferBetweenEntities({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String fromCashLocationId,
    required String toCashLocationId,
    required String? toStoreId,
    required String? toCompanyId,
    String? counterpartyId,
    required double amount,
    required DateTime entryDate,
    String? memo,
    List<String>? attachmentUrls,
  }) async {
    debugPrint('$_tag 🔄 createTransferBetweenEntities called');
    debugPrint('$_tag   from: $fromCashLocationId -> to: $toCashLocationId');
    debugPrint('$_tag   toStoreId: $toStoreId, toCompanyId: $toCompanyId');
    debugPrint('$_tag   counterpartyId (input): $counterpartyId');

    // Determine target company for setup
    final String targetCompanyId = toCompanyId ?? companyId;
    final bool isWithinCompany = targetCompanyId == companyId;
    debugPrint('$_tag   isWithinCompany: $isWithinCompany');
    debugPrint('$_tag   targetCompanyId: $targetCompanyId');

    // ============================================================
    // STEP 1: Get counterparty (with caching to avoid repeated RPC calls)
    // First check cache -> If not cached, call RPC -> Cache result
    // ============================================================
    String? effectiveCounterpartyId = counterpartyId;

    if (effectiveCounterpartyId == null) {
      // Check cache first
      effectiveCounterpartyId = _getCachedCounterparty(companyId, targetCompanyId);

      if (effectiveCounterpartyId != null) {
        debugPrint('$_tag ✅ Using cached counterpartyId: $effectiveCounterpartyId');
      } else {
        debugPrint('$_tag 🔧 No cache, calling getOrCreateCounterpartyForCompany...');

        // Get or create counterparty (this also sets up account mappings)
        effectiveCounterpartyId = await dataSource.getOrCreateCounterpartyForCompany(
          myCompanyId: companyId,
          targetCompanyId: targetCompanyId,
        );

        if (effectiveCounterpartyId == null) {
          debugPrint('$_tag ❌ Failed to get or create counterparty');
          throw Exception('Failed to get or create counterparty for inter-company transfer');
        }

        // Cache the result for future transfers
        _cacheCounterparty(companyId, targetCompanyId, effectiveCounterpartyId);
        _markSetupCompleted(companyId, targetCompanyId);
        debugPrint('$_tag ✅ Got and cached counterpartyId: $effectiveCounterpartyId');
      }
    } else {
      // counterpartyId was provided, ensure account mappings exist (only if not already done)
      if (!_isSetupCompleted(companyId, targetCompanyId)) {
        debugPrint('$_tag 🔧 counterpartyId provided, ensuring inter-company setup...');
        final setupResult = await dataSource.ensureInterCompanySetup(
          myCompanyId: companyId,
          targetCompanyId: targetCompanyId,
        );
        debugPrint('$_tag 📋 ensureInterCompanySetup result: $setupResult');
        _markSetupCompleted(companyId, targetCompanyId);
      } else {
        debugPrint('$_tag ✅ Setup already completed for this company pair (cached)');
      }
    }

    // Select appropriate receivable account based on transfer type
    // Within Company (same company, different store): Inter-branch Receivable (1360)
    // Between Companies: Note Receivable (1110)
    final String receivableAccountId = isWithinCompany
        ? AccountIds.interBranchReceivable
        : AccountIds.noteReceivable;

    debugPrint('$_tag   receivableAccountId: $receivableAccountId');
    debugPrint('$_tag   effectiveCounterpartyId: $effectiveCounterpartyId');

    // Build journal lines for inter-entity transfer with debt
    // From Store perspective:
    // DR Inter-branch/Note Receivable (we are owed money from the other store/company)
    // CR Cash (money leaves our cash location)
    //
    // The RPC will create a mirror journal for the To Store:
    // DR Cash (money arrives at their cash location)
    // CR Inter-branch/Note Payable (they owe us money)
    final List<Map<String, dynamic>> lines = [
      // Debit: Receivable (with debt info for mirror journal creation)
      {
        'account_id': receivableAccountId,
        'debit': amount,
        'credit': 0.0,
        'debt': {
          'counterparty_id': effectiveCounterpartyId,
          'direction': 'receivable',
          'category': 'account',
          if (toStoreId != null) 'linkedCounterparty_store_id': toStoreId,
        },
      },
      // Credit: Cash (from our cash location)
      {
        'account_id': AccountIds.cash,
        'debit': 0.0,
        'credit': amount,
        'cash': {
          'cash_location_id': fromCashLocationId,
        },
      },
    ];

    debugPrint('$_tag   lines: $lines');

    final result = await dataSource.createExpenseEntry(
      amount: amount,
      companyId: companyId,
      storeId: storeId ?? '',
      createdBy: createdBy,
      description: memo ?? 'Transfer between entities',
      entryDateUtc: DateTimeUtils.toUtc(entryDate),
      lines: lines,
      counterpartyId: effectiveCounterpartyId,
      cashLocationId: toCashLocationId, // Target cash location for mirror journal
    );

    if (result['success'] == true) {
      // RPC returns UUID directly as String, not as Map
      final data = result['data'];
      final String journalId;
      if (data is String) {
        journalId = data;
      } else if (data is Map<String, dynamic>) {
        journalId = (data['journal_id'] as String?) ?? '';
      } else {
        journalId = '';
      }
      debugPrint('$_tag ✅ Transfer between entities SUCCESS! journal_id: $journalId');
      return journalId;
    } else {
      debugPrint('$_tag ❌ Transfer between entities FAILED: ${result['error']}');
      throw Exception(result['error'] ?? 'Failed to create transfer entry');
    }
  }

  /// Build journal lines for debt entry
  /// Uses same format as expense: account_id, debit, credit, cash
  List<Map<String, dynamic>> _buildDebtJournalLines({
    required DebtSubType debtSubType,
    required double amount,
    required String cashLocationId,
  }) {
    switch (debtSubType) {
      case DebtSubType.lendMoney:
        // Cash Out: DR Receivable (미수금 증가), CR Cash (현금 감소)
        // 돈을 빌려줌 -> 받을 돈 생김
        return [
          {
            'account_id': AccountIds.accountsReceivable,
            'debit': amount,
            'credit': 0.0,
          },
          {
            'account_id': AccountIds.cash,
            'debit': 0.0,
            'credit': amount,
            'cash': {'cash_location_id': cashLocationId},
          },
        ];
      case DebtSubType.collectDebt:
        // Cash In: DR Cash (현금 증가), CR Receivable (미수금 감소)
        // 빌려준 돈 회수 -> 받을 돈 줄어듦
        return [
          {
            'account_id': AccountIds.cash,
            'debit': amount,
            'credit': 0.0,
            'cash': {'cash_location_id': cashLocationId},
          },
          {
            'account_id': AccountIds.accountsReceivable,
            'debit': 0.0,
            'credit': amount,
          },
        ];
      case DebtSubType.borrowMoney:
        // Cash In: DR Cash (현금 증가), CR Payable (미지급금 증가)
        // 돈을 빌림 -> 갚을 돈 생김
        return [
          {
            'account_id': AccountIds.cash,
            'debit': amount,
            'credit': 0.0,
            'cash': {'cash_location_id': cashLocationId},
          },
          {
            'account_id': AccountIds.accountsPayable,
            'debit': 0.0,
            'credit': amount,
          },
        ];
      case DebtSubType.repayDebt:
        // Cash Out: DR Payable (미지급금 감소), CR Cash (현금 감소)
        // 빌린 돈 갚음 -> 갚을 돈 줄어듦
        return [
          {
            'account_id': AccountIds.accountsPayable,
            'debit': amount,
            'credit': 0.0,
          },
          {
            'account_id': AccountIds.cash,
            'debit': 0.0,
            'credit': amount,
            'cash': {'cash_location_id': cashLocationId},
          },
        ];
    }
  }

  /// Get debt account ID based on sub type
  String _getDebtAccountId(DebtSubType subType) {
    switch (subType) {
      case DebtSubType.lendMoney:
      case DebtSubType.collectDebt:
        return AccountIds.accountsReceivable;
      case DebtSubType.borrowMoney:
      case DebtSubType.repayDebt:
        return AccountIds.accountsPayable;
    }
  }
}
