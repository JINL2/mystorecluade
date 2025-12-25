import 'package:flutter/material.dart';

import '../../domain/entities/cash_transaction_enums.dart';

/// UI Extensions for Cash Transaction Enums
/// Separated from domain to keep domain layer pure (no Flutter dependencies)

extension CashDirectionIconX on CashDirection {
  IconData get icon {
    switch (this) {
      case CashDirection.cashIn:
        return Icons.south_west;
      case CashDirection.cashOut:
        return Icons.north_east;
    }
  }
}

extension TransactionTypeIconX on TransactionType {
  IconData get icon {
    switch (this) {
      case TransactionType.expense:
        return Icons.receipt_long;
      case TransactionType.debt:
        return Icons.swap_horiz;
      case TransactionType.transfer:
        return Icons.sync_alt;
    }
  }
}
