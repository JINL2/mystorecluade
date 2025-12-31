/// Transaction type for vault operations
enum VaultTransactionType {
  debit,  // In
  credit, // Out
  recount,
}

/// Extension to convert between string and enum
extension VaultTransactionTypeExtension on VaultTransactionType {
  String get stringValue {
    switch (this) {
      case VaultTransactionType.debit:
        return 'debit';
      case VaultTransactionType.credit:
        return 'credit';
      case VaultTransactionType.recount:
        return 'recount';
    }
  }

  static VaultTransactionType fromString(String value) {
    switch (value) {
      case 'debit':
        return VaultTransactionType.debit;
      case 'credit':
        return VaultTransactionType.credit;
      case 'recount':
        return VaultTransactionType.recount;
      default:
        return VaultTransactionType.debit;
    }
  }
}
