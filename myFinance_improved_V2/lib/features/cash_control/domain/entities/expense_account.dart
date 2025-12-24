import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_account.freezed.dart';

/// Domain entity representing an expense account
///
/// Maps to `accounts` table where account_type = 'expense'
/// DB columns: account_id, account_name, account_code, expense_nature, category_tag
@freezed
class ExpenseAccount with _$ExpenseAccount {
  const factory ExpenseAccount({
    required String accountId,
    required String accountName,
    required String accountCode,
    String? expenseNature,
    String? categoryTag,
    @Default(false) bool isDefault,
    @Default(0) int usageCount,
  }) = _ExpenseAccount;

  const ExpenseAccount._();

  /// Display name with code
  String get displayName => '$accountCode - $accountName';

  /// Check if this is a variable expense
  bool get isVariable => expenseNature == 'variable';

  /// Check if this is a fixed expense
  bool get isFixed => expenseNature == 'fixed';
}
