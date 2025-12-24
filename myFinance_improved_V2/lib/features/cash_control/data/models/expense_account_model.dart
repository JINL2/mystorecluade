import '../../domain/entities/expense_account.dart';

/// Data model for ExpenseAccount
///
/// Handles JSON serialization and mapping to domain entity
class ExpenseAccountModel {
  final String accountId;
  final String accountName;
  final String accountCode;
  final String? expenseNature;
  final String? categoryTag;
  final bool isDefault;
  final int usageCount;

  ExpenseAccountModel({
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    this.expenseNature,
    this.categoryTag,
    this.isDefault = false,
    this.usageCount = 0,
  });

  /// From JSON (API/Database) → Model
  factory ExpenseAccountModel.fromJson(Map<String, dynamic> json) {
    return ExpenseAccountModel(
      accountId: json['account_id'] as String? ?? '',
      accountName: json['account_name'] as String? ?? '',
      accountCode: json['account_code'] as String? ?? '',
      expenseNature: json['expense_nature'] as String?,
      categoryTag: json['category_tag'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      usageCount: json['usage_count'] as int? ?? 0,
    );
  }

  /// Model → Domain Entity
  ExpenseAccount toEntity() {
    return ExpenseAccount(
      accountId: accountId,
      accountName: accountName,
      accountCode: accountCode,
      expenseNature: expenseNature,
      categoryTag: categoryTag,
      isDefault: isDefault,
      usageCount: usageCount,
    );
  }

  /// Model → JSON (for API calls)
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'account_name': accountName,
      'account_code': accountCode,
      'expense_nature': expenseNature,
      'category_tag': categoryTag,
      'is_default': isDefault,
      'usage_count': usageCount,
    };
  }
}
