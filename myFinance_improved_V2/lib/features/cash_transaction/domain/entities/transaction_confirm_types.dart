import 'package:image_picker/image_picker.dart';
import 'cash_transaction_enums.dart';

/// Transaction type for confirmation dialog
enum ConfirmTransactionType {
  expense,
  debt,
  transferWithinStore,
  transferWithinCompany,
  transferBetweenCompanies,
}

/// Data class for transaction confirmation
class TransactionConfirmData {
  final ConfirmTransactionType type;
  final double amount;

  // Common
  final String fromCashLocationName;

  // Expense specific
  final String? expenseAccountName;
  final String? expenseAccountCode;

  // Debt specific
  final String? debtTypeName; // e.g., "Lend Money", "Collect Debt"
  final String? counterpartyName;

  // Transfer specific
  final String? fromStoreName;
  final String? toStoreName;
  final String? toCompanyName;
  final String? toCashLocationName;

  const TransactionConfirmData({
    required this.type,
    required this.amount,
    required this.fromCashLocationName,
    this.expenseAccountName,
    this.expenseAccountCode,
    this.debtTypeName,
    this.counterpartyName,
    this.fromStoreName,
    this.toStoreName,
    this.toCompanyName,
    this.toCashLocationName,
  });
}

/// Result from confirmation dialog
class TransactionConfirmResult {
  final bool confirmed;
  final String? memo;
  final List<XFile> attachments;
  final DebtCategory? debtCategory; // For debt transactions

  const TransactionConfirmResult({
    required this.confirmed,
    this.memo,
    this.attachments = const [],
    this.debtCategory,
  });
}
