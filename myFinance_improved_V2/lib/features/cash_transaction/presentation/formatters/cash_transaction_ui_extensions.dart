import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

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
        return TossColors.info;
      case TransferScope.withinCompany:
        return TossColors.info;
      case TransferScope.betweenCompanies:
        return TossColors.primary;
    }
  }
}
