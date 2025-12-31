import 'package:flutter/material.dart';

import '../../domain/entities/transfer_scope.dart';

/// UI Extensions for Cash Transaction Enums
/// Domain layer purity를 유지하기 위해 IconData 관련 extension을 presentation layer에 분리

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
