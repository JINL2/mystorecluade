// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DebtOverviewStruct extends BaseStruct {
  DebtOverviewStruct({
    String? viewMode,
    String? scopeDescription,
    int? totalReceivable,
    int? totalPayable,
    int? netBalance,
    int? transactionCount,
    int? activeCounterparties,
  })  : _viewMode = viewMode,
        _scopeDescription = scopeDescription,
        _totalReceivable = totalReceivable,
        _totalPayable = totalPayable,
        _netBalance = netBalance,
        _transactionCount = transactionCount,
        _activeCounterparties = activeCounterparties;

  // "view_mode" field.
  String? _viewMode;
  String get viewMode => _viewMode ?? 'company';
  set viewMode(String? val) => _viewMode = val;

  bool hasViewMode() => _viewMode != null;

  // "scope_description" field.
  String? _scopeDescription;
  String get scopeDescription => _scopeDescription ?? 'company';
  set scopeDescription(String? val) => _scopeDescription = val;

  bool hasScopeDescription() => _scopeDescription != null;

  // "total_receivable" field.
  int? _totalReceivable;
  int get totalReceivable => _totalReceivable ?? 0;
  set totalReceivable(int? val) => _totalReceivable = val;

  void incrementTotalReceivable(int amount) =>
      totalReceivable = totalReceivable + amount;

  bool hasTotalReceivable() => _totalReceivable != null;

  // "total_payable" field.
  int? _totalPayable;
  int get totalPayable => _totalPayable ?? 0;
  set totalPayable(int? val) => _totalPayable = val;

  void incrementTotalPayable(int amount) =>
      totalPayable = totalPayable + amount;

  bool hasTotalPayable() => _totalPayable != null;

  // "net_balance" field.
  int? _netBalance;
  int get netBalance => _netBalance ?? 0;
  set netBalance(int? val) => _netBalance = val;

  void incrementNetBalance(int amount) => netBalance = netBalance + amount;

  bool hasNetBalance() => _netBalance != null;

  // "transaction_count" field.
  int? _transactionCount;
  int get transactionCount => _transactionCount ?? 0;
  set transactionCount(int? val) => _transactionCount = val;

  void incrementTransactionCount(int amount) =>
      transactionCount = transactionCount + amount;

  bool hasTransactionCount() => _transactionCount != null;

  // "active_counterparties" field.
  int? _activeCounterparties;
  int get activeCounterparties => _activeCounterparties ?? 0;
  set activeCounterparties(int? val) => _activeCounterparties = val;

  void incrementActiveCounterparties(int amount) =>
      activeCounterparties = activeCounterparties + amount;

  bool hasActiveCounterparties() => _activeCounterparties != null;

  static DebtOverviewStruct fromMap(Map<String, dynamic> data) =>
      DebtOverviewStruct(
        viewMode: data['view_mode'] as String?,
        scopeDescription: data['scope_description'] as String?,
        totalReceivable: castToType<int>(data['total_receivable']),
        totalPayable: castToType<int>(data['total_payable']),
        netBalance: castToType<int>(data['net_balance']),
        transactionCount: castToType<int>(data['transaction_count']),
        activeCounterparties: castToType<int>(data['active_counterparties']),
      );

  static DebtOverviewStruct? maybeFromMap(dynamic data) => data is Map
      ? DebtOverviewStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'view_mode': _viewMode,
        'scope_description': _scopeDescription,
        'total_receivable': _totalReceivable,
        'total_payable': _totalPayable,
        'net_balance': _netBalance,
        'transaction_count': _transactionCount,
        'active_counterparties': _activeCounterparties,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'view_mode': serializeParam(
          _viewMode,
          ParamType.String,
        ),
        'scope_description': serializeParam(
          _scopeDescription,
          ParamType.String,
        ),
        'total_receivable': serializeParam(
          _totalReceivable,
          ParamType.int,
        ),
        'total_payable': serializeParam(
          _totalPayable,
          ParamType.int,
        ),
        'net_balance': serializeParam(
          _netBalance,
          ParamType.int,
        ),
        'transaction_count': serializeParam(
          _transactionCount,
          ParamType.int,
        ),
        'active_counterparties': serializeParam(
          _activeCounterparties,
          ParamType.int,
        ),
      }.withoutNulls;

  static DebtOverviewStruct fromSerializableMap(Map<String, dynamic> data) =>
      DebtOverviewStruct(
        viewMode: deserializeParam(
          data['view_mode'],
          ParamType.String,
          false,
        ),
        scopeDescription: deserializeParam(
          data['scope_description'],
          ParamType.String,
          false,
        ),
        totalReceivable: deserializeParam(
          data['total_receivable'],
          ParamType.int,
          false,
        ),
        totalPayable: deserializeParam(
          data['total_payable'],
          ParamType.int,
          false,
        ),
        netBalance: deserializeParam(
          data['net_balance'],
          ParamType.int,
          false,
        ),
        transactionCount: deserializeParam(
          data['transaction_count'],
          ParamType.int,
          false,
        ),
        activeCounterparties: deserializeParam(
          data['active_counterparties'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DebtOverviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DebtOverviewStruct &&
        viewMode == other.viewMode &&
        scopeDescription == other.scopeDescription &&
        totalReceivable == other.totalReceivable &&
        totalPayable == other.totalPayable &&
        netBalance == other.netBalance &&
        transactionCount == other.transactionCount &&
        activeCounterparties == other.activeCounterparties;
  }

  @override
  int get hashCode => const ListEquality().hash([
        viewMode,
        scopeDescription,
        totalReceivable,
        totalPayable,
        netBalance,
        transactionCount,
        activeCounterparties
      ]);
}

DebtOverviewStruct createDebtOverviewStruct({
  String? viewMode,
  String? scopeDescription,
  int? totalReceivable,
  int? totalPayable,
  int? netBalance,
  int? transactionCount,
  int? activeCounterparties,
}) =>
    DebtOverviewStruct(
      viewMode: viewMode,
      scopeDescription: scopeDescription,
      totalReceivable: totalReceivable,
      totalPayable: totalPayable,
      netBalance: netBalance,
      transactionCount: transactionCount,
      activeCounterparties: activeCounterparties,
    );
