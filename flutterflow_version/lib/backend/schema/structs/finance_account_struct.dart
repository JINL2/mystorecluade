// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FinanceAccountStruct extends BaseStruct {
  FinanceAccountStruct({
    String? accountId,
    String? accountName,
    String? accountType,
    String? expenseNature,
    String? categoryTag,
  })  : _accountId = accountId,
        _accountName = accountName,
        _accountType = accountType,
        _expenseNature = expenseNature,
        _categoryTag = categoryTag;

  // "account_id" field.
  String? _accountId;
  String get accountId => _accountId ?? '';
  set accountId(String? val) => _accountId = val;

  bool hasAccountId() => _accountId != null;

  // "account_name" field.
  String? _accountName;
  String get accountName => _accountName ?? '';
  set accountName(String? val) => _accountName = val;

  bool hasAccountName() => _accountName != null;

  // "account_type" field.
  String? _accountType;
  String get accountType => _accountType ?? '';
  set accountType(String? val) => _accountType = val;

  bool hasAccountType() => _accountType != null;

  // "expense_nature" field.
  String? _expenseNature;
  String get expenseNature => _expenseNature ?? '';
  set expenseNature(String? val) => _expenseNature = val;

  bool hasExpenseNature() => _expenseNature != null;

  // "category_tag" field.
  String? _categoryTag;
  String get categoryTag => _categoryTag ?? '';
  set categoryTag(String? val) => _categoryTag = val;

  bool hasCategoryTag() => _categoryTag != null;

  static FinanceAccountStruct fromMap(Map<String, dynamic> data) =>
      FinanceAccountStruct(
        accountId: data['account_id'] as String?,
        accountName: data['account_name'] as String?,
        accountType: data['account_type'] as String?,
        expenseNature: data['expense_nature'] as String?,
        categoryTag: data['category_tag'] as String?,
      );

  static FinanceAccountStruct? maybeFromMap(dynamic data) => data is Map
      ? FinanceAccountStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'account_id': _accountId,
        'account_name': _accountName,
        'account_type': _accountType,
        'expense_nature': _expenseNature,
        'category_tag': _categoryTag,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'account_id': serializeParam(
          _accountId,
          ParamType.String,
        ),
        'account_name': serializeParam(
          _accountName,
          ParamType.String,
        ),
        'account_type': serializeParam(
          _accountType,
          ParamType.String,
        ),
        'expense_nature': serializeParam(
          _expenseNature,
          ParamType.String,
        ),
        'category_tag': serializeParam(
          _categoryTag,
          ParamType.String,
        ),
      }.withoutNulls;

  static FinanceAccountStruct fromSerializableMap(Map<String, dynamic> data) =>
      FinanceAccountStruct(
        accountId: deserializeParam(
          data['account_id'],
          ParamType.String,
          false,
        ),
        accountName: deserializeParam(
          data['account_name'],
          ParamType.String,
          false,
        ),
        accountType: deserializeParam(
          data['account_type'],
          ParamType.String,
          false,
        ),
        expenseNature: deserializeParam(
          data['expense_nature'],
          ParamType.String,
          false,
        ),
        categoryTag: deserializeParam(
          data['category_tag'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FinanceAccountStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FinanceAccountStruct &&
        accountId == other.accountId &&
        accountName == other.accountName &&
        accountType == other.accountType &&
        expenseNature == other.expenseNature &&
        categoryTag == other.categoryTag;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([accountId, accountName, accountType, expenseNature, categoryTag]);
}

FinanceAccountStruct createFinanceAccountStruct({
  String? accountId,
  String? accountName,
  String? accountType,
  String? expenseNature,
  String? categoryTag,
}) =>
    FinanceAccountStruct(
      accountId: accountId,
      accountName: accountName,
      accountType: accountType,
      expenseNature: expenseNature,
      categoryTag: categoryTag,
    );
