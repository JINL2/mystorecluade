// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TransactionDetailStruct extends BaseStruct {
  TransactionDetailStruct({
    String? accountId,
    String? description,
    String? debit,
    String? credit,
    String? counterpartyId,
    double? amount,
    CashStruct? cash,
    DebtStruct? debt,

    /// fixed asset detail
    FixAssetStruct? fixAsset,
  })  : _accountId = accountId,
        _description = description,
        _debit = debit,
        _credit = credit,
        _counterpartyId = counterpartyId,
        _amount = amount,
        _cash = cash,
        _debt = debt,
        _fixAsset = fixAsset;

  // "account_id" field.
  String? _accountId;
  String get accountId => _accountId ?? '';
  set accountId(String? val) => _accountId = val;

  bool hasAccountId() => _accountId != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "debit" field.
  String? _debit;
  String get debit => _debit ?? '';
  set debit(String? val) => _debit = val;

  bool hasDebit() => _debit != null;

  // "credit" field.
  String? _credit;
  String get credit => _credit ?? '';
  set credit(String? val) => _credit = val;

  bool hasCredit() => _credit != null;

  // "counterparty_id" field.
  String? _counterpartyId;
  String get counterpartyId => _counterpartyId ?? '';
  set counterpartyId(String? val) => _counterpartyId = val;

  bool hasCounterpartyId() => _counterpartyId != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "cash" field.
  CashStruct? _cash;
  CashStruct get cash => _cash ?? CashStruct();
  set cash(CashStruct? val) => _cash = val;

  void updateCash(Function(CashStruct) updateFn) {
    updateFn(_cash ??= CashStruct());
  }

  bool hasCash() => _cash != null;

  // "debt" field.
  DebtStruct? _debt;
  DebtStruct get debt => _debt ?? DebtStruct();
  set debt(DebtStruct? val) => _debt = val;

  void updateDebt(Function(DebtStruct) updateFn) {
    updateFn(_debt ??= DebtStruct());
  }

  bool hasDebt() => _debt != null;

  // "fix_asset" field.
  FixAssetStruct? _fixAsset;
  FixAssetStruct get fixAsset => _fixAsset ?? FixAssetStruct();
  set fixAsset(FixAssetStruct? val) => _fixAsset = val;

  void updateFixAsset(Function(FixAssetStruct) updateFn) {
    updateFn(_fixAsset ??= FixAssetStruct());
  }

  bool hasFixAsset() => _fixAsset != null;

  static TransactionDetailStruct fromMap(Map<String, dynamic> data) =>
      TransactionDetailStruct(
        accountId: data['account_id'] as String?,
        description: data['description'] as String?,
        debit: data['debit'] as String?,
        credit: data['credit'] as String?,
        counterpartyId: data['counterparty_id'] as String?,
        amount: castToType<double>(data['amount']),
        cash: data['cash'] is CashStruct
            ? data['cash']
            : CashStruct.maybeFromMap(data['cash']),
        debt: data['debt'] is DebtStruct
            ? data['debt']
            : DebtStruct.maybeFromMap(data['debt']),
        fixAsset: data['fix_asset'] is FixAssetStruct
            ? data['fix_asset']
            : FixAssetStruct.maybeFromMap(data['fix_asset']),
      );

  static TransactionDetailStruct? maybeFromMap(dynamic data) => data is Map
      ? TransactionDetailStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'account_id': _accountId,
        'description': _description,
        'debit': _debit,
        'credit': _credit,
        'counterparty_id': _counterpartyId,
        'amount': _amount,
        'cash': _cash?.toMap(),
        'debt': _debt?.toMap(),
        'fix_asset': _fixAsset?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'account_id': serializeParam(
          _accountId,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'debit': serializeParam(
          _debit,
          ParamType.String,
        ),
        'credit': serializeParam(
          _credit,
          ParamType.String,
        ),
        'counterparty_id': serializeParam(
          _counterpartyId,
          ParamType.String,
        ),
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'cash': serializeParam(
          _cash,
          ParamType.DataStruct,
        ),
        'debt': serializeParam(
          _debt,
          ParamType.DataStruct,
        ),
        'fix_asset': serializeParam(
          _fixAsset,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static TransactionDetailStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TransactionDetailStruct(
        accountId: deserializeParam(
          data['account_id'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        debit: deserializeParam(
          data['debit'],
          ParamType.String,
          false,
        ),
        credit: deserializeParam(
          data['credit'],
          ParamType.String,
          false,
        ),
        counterpartyId: deserializeParam(
          data['counterparty_id'],
          ParamType.String,
          false,
        ),
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        cash: deserializeStructParam(
          data['cash'],
          ParamType.DataStruct,
          false,
          structBuilder: CashStruct.fromSerializableMap,
        ),
        debt: deserializeStructParam(
          data['debt'],
          ParamType.DataStruct,
          false,
          structBuilder: DebtStruct.fromSerializableMap,
        ),
        fixAsset: deserializeStructParam(
          data['fix_asset'],
          ParamType.DataStruct,
          false,
          structBuilder: FixAssetStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'TransactionDetailStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TransactionDetailStruct &&
        accountId == other.accountId &&
        description == other.description &&
        debit == other.debit &&
        credit == other.credit &&
        counterpartyId == other.counterpartyId &&
        amount == other.amount &&
        cash == other.cash &&
        debt == other.debt &&
        fixAsset == other.fixAsset;
  }

  @override
  int get hashCode => const ListEquality().hash([
        accountId,
        description,
        debit,
        credit,
        counterpartyId,
        amount,
        cash,
        debt,
        fixAsset
      ]);
}

TransactionDetailStruct createTransactionDetailStruct({
  String? accountId,
  String? description,
  String? debit,
  String? credit,
  String? counterpartyId,
  double? amount,
  CashStruct? cash,
  DebtStruct? debt,
  FixAssetStruct? fixAsset,
}) =>
    TransactionDetailStruct(
      accountId: accountId,
      description: description,
      debit: debit,
      credit: credit,
      counterpartyId: counterpartyId,
      amount: amount,
      cash: cash ?? CashStruct(),
      debt: debt ?? DebtStruct(),
      fixAsset: fixAsset ?? FixAssetStruct(),
    );
