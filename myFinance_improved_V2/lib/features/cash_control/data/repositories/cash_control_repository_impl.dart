import 'package:flutter/foundation.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../../cash_location/domain/constants/account_ids.dart';
import '../../domain/entities/cash_control_enums.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/counterparty.dart';
import '../../domain/entities/expense_account.dart';
import '../../domain/repositories/cash_control_repository.dart';
import '../datasources/cash_control_datasource.dart';

const _tag = '[CashControlRepoImpl]';

/// Implementation of CashControlRepository
/// Coordinates between domain and data layers
class CashControlRepositoryImpl implements CashControlRepository {
  final CashControlDataSource dataSource;

  CashControlRepositoryImpl({required this.dataSource});

  /// Factory method to create DataSource instance
  static CashControlDataSource createDataSource() {
    return CashControlDataSource();
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
    // For now, use the same method - can be extended for full search
    final models = await dataSource.getExpenseAccounts(
      companyId: companyId,
      userId: '', // Search doesn't need user context
      limit: limit,
    );

    if (query == null || query.isEmpty) {
      return models.map((m) => m.toEntity()).toList();
    }

    // Client-side filtering for search
    final lowerQuery = query.toLowerCase();
    return models
        .where((m) =>
            m.accountName.toLowerCase().contains(lowerQuery) ||
            m.accountCode.toLowerCase().contains(lowerQuery),)
        .map((m) => m.toEntity())
        .toList();
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
    String? memo,
    List<String>? attachmentUrls,
  }) async {
    debugPrint('$_tag 🔄 createExpenseEntry called');
    debugPrint('$_tag   expenseAccountId: $expenseAccountId');
    debugPrint('$_tag   cashLocationId: $cashLocationId');
    debugPrint('$_tag   amount: $amount');

    // Build journal lines for expense
    // DR: Expense Account (amount)
    // CR: Cash Account with cash_location (amount)
    // RPC expects: account_id, debit, credit, cash.cash_location_id
    final lines = [
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
    required String counterpartyId,
    required double amount,
    required DateTime entryDate,
    String? memo,
    List<String>? attachmentUrls,
  }) async {
    debugPrint('$_tag 🔄 createTransferBetweenEntities called');
    debugPrint('$_tag   from: $fromCashLocationId -> to: $toCashLocationId');
    debugPrint('$_tag   toStoreId: $toStoreId, toCompanyId: $toCompanyId');

    // Build journal lines for inter-entity transfer
    // This creates a debt relationship
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

    final result = await dataSource.createExpenseEntry(
      amount: amount,
      companyId: companyId,
      storeId: storeId ?? '',
      createdBy: createdBy,
      description: memo ?? 'Transfer between entities',
      entryDateUtc: DateTimeUtils.toUtc(entryDate),
      lines: lines,
      counterpartyId: counterpartyId,
      cashLocationId: fromCashLocationId,
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
  List<Map<String, dynamic>> _buildDebtJournalLines({
    required DebtSubType debtSubType,
    required double amount,
    required String cashLocationId,
  }) {
    switch (debtSubType) {
      case DebtSubType.lendMoney:
        // Cash Out: DR Receivable, CR Cash
        return [
          {'debt_tag': 'receivable', 'dr_amount': amount, 'cr_amount': 0.0},
          {'cash_location_id': cashLocationId, 'dr_amount': 0.0, 'cr_amount': amount},
        ];
      case DebtSubType.collectDebt:
        // Cash In: DR Cash, CR Receivable
        return [
          {'cash_location_id': cashLocationId, 'dr_amount': amount, 'cr_amount': 0.0},
          {'debt_tag': 'receivable', 'dr_amount': 0.0, 'cr_amount': amount},
        ];
      case DebtSubType.borrowMoney:
        // Cash In: DR Cash, CR Payable
        return [
          {'cash_location_id': cashLocationId, 'dr_amount': amount, 'cr_amount': 0.0},
          {'debt_tag': 'payable', 'dr_amount': 0.0, 'cr_amount': amount},
        ];
      case DebtSubType.repayDebt:
        // Cash Out: DR Payable, CR Cash
        return [
          {'debt_tag': 'payable', 'dr_amount': amount, 'cr_amount': 0.0},
          {'cash_location_id': cashLocationId, 'dr_amount': 0.0, 'cr_amount': amount},
        ];
    }
  }

  /// Get debt account ID based on sub type
  String _getDebtAccountId(DebtSubType subType) {
    // This should be fetched from account configuration
    // For now, return placeholder
    switch (subType) {
      case DebtSubType.lendMoney:
      case DebtSubType.collectDebt:
        return 'receivable_account_id'; // Will be resolved
      case DebtSubType.borrowMoney:
      case DebtSubType.repayDebt:
        return 'payable_account_id'; // Will be resolved
    }
  }
}
