import 'package:flutter/material.dart';

import '../../domain/entities/cash_transaction_enums.dart';
import '../../domain/entities/transfer_scope.dart';

/// UI Extensions for Cash Transaction Enums
/// Domain layer purity를 유지하기 위해 IconData 관련 extension을 presentation layer에 분리

/// CashDirection UI Extension
extension CashDirectionUIX on CashDirection {
  IconData get icon {
    switch (this) {
      case CashDirection.cashIn:
        return Icons.south_west;
      case CashDirection.cashOut:
        return Icons.north_east;
    }
  }

  Color get color {
    switch (this) {
      case CashDirection.cashIn:
        return Colors.green;
      case CashDirection.cashOut:
        return Colors.red;
    }
  }
}

/// TransactionType UI Extension
extension TransactionTypeUIX on TransactionType {
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

  Color get color {
    switch (this) {
      case TransactionType.expense:
        return Colors.orange;
      case TransactionType.debt:
        return Colors.purple;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }
}

/// TransferScope UI Extension
extension TransferScopeUIX on TransferScope {
  IconData get icon {
    switch (this) {
      case TransferScope.withinStore:
        return Icons.swap_horiz;
      case TransferScope.withinCompany:
        return Icons.store;
      case TransferScope.betweenCompanies:
        return Icons.business;
    }
  }

  Color get color {
    switch (this) {
      case TransferScope.withinStore:
        return Colors.blue;
      case TransferScope.withinCompany:
        return Colors.teal;
      case TransferScope.betweenCompanies:
        return Colors.indigo;
    }
  }
}
