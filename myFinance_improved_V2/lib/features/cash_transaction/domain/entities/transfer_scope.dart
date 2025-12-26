/// Transfer Scope - determines accounting treatment
///
/// UI Extensions (IconData)는 presentation/formatters/에 정의됨
enum TransferScope {
  withinStore,      // 같은 가게 내: Simple cash transfer
  withinCompany,    // 같은 회사 내 다른 가게: Inter-store debt (A/R, A/P)
  betweenCompanies, // 다른 회사: Inter-company debt (A/R, A/P)
}

extension TransferScopeX on TransferScope {
  String get label {
    switch (this) {
      case TransferScope.withinStore:
        return 'Within Store';
      case TransferScope.withinCompany:
        return 'Within Company';
      case TransferScope.betweenCompanies:
        return 'Between Companies';
    }
  }

  String get labelKo {
    switch (this) {
      case TransferScope.withinStore:
        return '가게 내 이동';
      case TransferScope.withinCompany:
        return '회사 내 이동';
      case TransferScope.betweenCompanies:
        return '다른 회사로 이동';
    }
  }

  String get description {
    switch (this) {
      case TransferScope.withinStore:
        return 'Move cash between vaults in this store';
      case TransferScope.withinCompany:
        return 'Transfer to another store in your company';
      case TransferScope.betweenCompanies:
        return 'Transfer to another company you own';
    }
  }

  bool get isDebtTransaction => this != TransferScope.withinStore;
}
