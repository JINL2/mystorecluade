import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_account.freezed.dart';

/// Financial account entity
@freezed
class FinancialAccount with _$FinancialAccount {
  const factory FinancialAccount({
    required String accountId,
    required String accountName,
    required String accountType,
    required double balance,
    @Default(false) bool hasTransactions,
  }) = _FinancialAccount;
}

/// Account with net amount for income statement
@freezed
class IncomeStatementAccount with _$IncomeStatementAccount {
  const factory IncomeStatementAccount({
    required String accountId,
    required String accountName,
    required String accountType,
    required double netAmount,
  }) = _IncomeStatementAccount;
}
