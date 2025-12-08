/// Pure domain entity for Transaction (no JSON, no Freezed)
/// Represents a financial journal entry with multiple transaction lines
class Transaction {
  final String journalId;
  final String journalNumber;
  final DateTime entryDate;
  final DateTime createdAt;
  final String description;
  final String journalType;
  final bool isDraft;
  final String? storeId;
  final String? storeName;
  final String? storeCode;
  final String? createdBy;
  final String createdByName;
  final String currencyCode;
  final String currencySymbol;
  final double totalDebit;
  final double totalCredit;
  final double totalAmount;
  final List<TransactionLine> lines;
  final List<TransactionAttachment> attachments;

  const Transaction({
    required this.journalId,
    required this.journalNumber,
    required this.entryDate,
    required this.createdAt,
    required this.description,
    required this.journalType,
    required this.isDraft,
    this.storeId,
    this.storeName,
    this.storeCode,
    this.createdBy,
    required this.createdByName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.totalDebit,
    required this.totalCredit,
    required this.totalAmount,
    required this.lines,
    required this.attachments,
  });

  /// Check if the transaction is balanced (debits = credits)
  bool get isBalanced => (totalDebit - totalCredit).abs() < 0.01;

  /// Get the number of attachments
  int get attachmentCount => attachments.length;

  /// Get the net amount
  double get amount => totalAmount;
}

/// Transaction line entity
class TransactionLine {
  final String lineId;
  final String accountId;
  final String accountName;
  final String accountType;
  final double debit;
  final double credit;
  final bool isDebit;
  final String? description;
  final Map<String, dynamic>? counterparty;
  final Map<String, dynamic>? cashLocation;
  final String displayLocation;
  final String displayCounterparty;

  const TransactionLine({
    required this.lineId,
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.debit,
    required this.credit,
    required this.isDebit,
    this.description,
    this.counterparty,
    this.cashLocation,
    required this.displayLocation,
    required this.displayCounterparty,
  });

  /// Get the debit amount
  double get debitAmount => debit;

  /// Get the credit amount
  double get creditAmount => credit;

  /// Get the line amount (debit or credit)
  double get amount => isDebit ? debit : credit;
}

/// Transaction attachment entity
class TransactionAttachment {
  final String attachmentId;
  final String fileName;
  final String fileType;
  final String? fileUrl;

  const TransactionAttachment({
    required this.attachmentId,
    required this.fileName,
    required this.fileType,
    this.fileUrl,
  });

  /// Check if this is an image file
  bool get isImage => fileType.startsWith('image/');

  /// Check if this is a PDF file
  bool get isPdf => fileType == 'application/pdf';

  /// Get file extension
  String get fileExtension => fileName.split('.').last.toLowerCase();
}
