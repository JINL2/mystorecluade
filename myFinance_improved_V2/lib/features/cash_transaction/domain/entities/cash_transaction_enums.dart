// Cash Control Feature - Enums
// 직원용 간편 현금 입출금 시스템
//
// Note: Icon extensions are in presentation/widgets/cash_transaction_icons.dart
// to keep domain layer pure (no Flutter dependencies)

/// 현금 방향 (In/Out)
enum CashDirection {
  cashIn,   // 돈 받음
  cashOut,  // 돈 나감
}

extension CashDirectionX on CashDirection {
  String get label {
    switch (this) {
      case CashDirection.cashIn:
        return 'Cash In';
      case CashDirection.cashOut:
        return 'Cash Out';
    }
  }

  String get labelKo {
    switch (this) {
      case CashDirection.cashIn:
        return '돈 받음';
      case CashDirection.cashOut:
        return '돈 나감';
    }
  }

  String get emoji {
    switch (this) {
      case CashDirection.cashIn:
        return '💵';
      case CashDirection.cashOut:
        return '💸';
    }
  }

  String get description {
    switch (this) {
      case CashDirection.cashIn:
        return 'Money coming in';
      case CashDirection.cashOut:
        return 'Money going out';
    }
  }
}

/// 거래 유형 (비용/부채/현금이동)
enum TransactionType {
  expense,    // 비용 (물건구매, 서비스 등)
  debt,       // 부채 (빌려준돈/빌린돈)
  transfer,   // 현금 이동 (금고간 이동)
}

extension TransactionTypeX on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.debt:
        return 'Debt';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  String get labelKo {
    switch (this) {
      case TransactionType.expense:
        return '비용';
      case TransactionType.debt:
        return '부채';
      case TransactionType.transfer:
        return '이동';
    }
  }

  String get emoji {
    switch (this) {
      case TransactionType.expense:
        return '💳';
      case TransactionType.debt:
        return '📝';
      case TransactionType.transfer:
        return '🔄';
    }
  }

  String get description {
    switch (this) {
      case TransactionType.expense:
        return 'Purchase, services, etc.';
      case TransactionType.debt:
        return 'Lend or borrow money';
      case TransactionType.transfer:
        return 'Move cash between locations';
    }
  }

  String get descriptionKo {
    switch (this) {
      case TransactionType.expense:
        return '물건구매, 서비스 등';
      case TransactionType.debt:
        return '빌려준돈 / 빌린돈';
      case TransactionType.transfer:
        return '다른 금고로 현금 옮기기';
    }
  }

  /// expense 유형은 cash out 시에만 주로 사용
  bool get isRecommendedForCashOut => this == TransactionType.expense;
}

/// 부채 세부 유형
enum DebtSubType {
  lendMoney,      // 돈 빌려줌 (내가 → 상대방, receivable 증가)
  collectDebt,    // 빌려준 돈 회수 (상대방 → 나, receivable 감소)
  borrowMoney,    // 돈 빌림 (상대방 → 나, payable 증가)
  repayDebt,      // 빌린 돈 갚음 (나 → 상대방, payable 감소)
}

extension DebtSubTypeX on DebtSubType {
  String get label {
    switch (this) {
      case DebtSubType.lendMoney:
        return 'Lend Money';
      case DebtSubType.collectDebt:
        return 'Collect Debt';
      case DebtSubType.borrowMoney:
        return 'Borrow Money';
      case DebtSubType.repayDebt:
        return 'Repay Debt';
    }
  }

  String get labelKo {
    switch (this) {
      case DebtSubType.lendMoney:
        return '돈 빌려줌';
      case DebtSubType.collectDebt:
        return '빌려준 돈 회수';
      case DebtSubType.borrowMoney:
        return '돈 빌림';
      case DebtSubType.repayDebt:
        return '빌린 돈 갚음';
    }
  }

  String get emoji {
    switch (this) {
      case DebtSubType.lendMoney:
        return '➡️';
      case DebtSubType.collectDebt:
        return '⬅️';
      case DebtSubType.borrowMoney:
        return '⬅️';
      case DebtSubType.repayDebt:
        return '➡️';
    }
  }

  String get description {
    switch (this) {
      case DebtSubType.lendMoney:
        return 'You give money to someone';
      case DebtSubType.collectDebt:
        return 'Someone returns your money';
      case DebtSubType.borrowMoney:
        return 'You receive money from someone';
      case DebtSubType.repayDebt:
        return 'You return borrowed money';
    }
  }

  /// 이 유형이 적합한 CashDirection
  CashDirection get applicableDirection {
    switch (this) {
      case DebtSubType.lendMoney:
        return CashDirection.cashOut;
      case DebtSubType.collectDebt:
        return CashDirection.cashIn;
      case DebtSubType.borrowMoney:
        return CashDirection.cashIn;
      case DebtSubType.repayDebt:
        return CashDirection.cashOut;
    }
  }

  /// RPC에서 사용할 debt direction
  String get debtDirection {
    switch (this) {
      case DebtSubType.lendMoney:
      case DebtSubType.collectDebt:
        return 'receivable';
      case DebtSubType.borrowMoney:
      case DebtSubType.repayDebt:
        return 'payable';
    }
  }

  /// 잔액 증가/감소 여부
  bool get isIncreasing {
    switch (this) {
      case DebtSubType.lendMoney:
      case DebtSubType.borrowMoney:
        return true; // 채권/채무 증가
      case DebtSubType.collectDebt:
      case DebtSubType.repayDebt:
        return false; // 채권/채무 감소
    }
  }

  /// CashDirection에 해당하는 DebtSubType 목록
  static List<DebtSubType> forDirection(CashDirection direction) {
    return DebtSubType.values
        .where((type) => type.applicableDirection == direction)
        .toList();
  }
}

/// 부채 카테고리 (Account vs Note)
/// - Account: 미수금/미지급금 (Accounts Receivable/Payable) - 일반 거래 관계
/// - Note: 어음 (Notes Receivable/Payable) - 정식 약속어음/차용증
enum DebtCategory {
  account, // 미수금/미지급금 (일반)
  note,    // 어음 (정식)
}

extension DebtCategoryX on DebtCategory {
  String get label {
    switch (this) {
      case DebtCategory.account:
        return 'Account';
      case DebtCategory.note:
        return 'Note';
    }
  }

  String get labelKo {
    switch (this) {
      case DebtCategory.account:
        return '미수/미지급금';
      case DebtCategory.note:
        return '어음';
    }
  }

  String get description {
    switch (this) {
      case DebtCategory.account:
        return 'Informal debt from business transactions';
      case DebtCategory.note:
        return 'Formal promissory note with terms';
    }
  }

  String get descriptionKo {
    switch (this) {
      case DebtCategory.account:
        return '일반 거래 관계의 채권/채무';
      case DebtCategory.note:
        return '정식 약속어음/차용증';
    }
  }

  /// 사용할 계정 ID 접미사
  String get accountIdSuffix {
    switch (this) {
      case DebtCategory.account:
        return 'accounts'; // accountsReceivable, accountsPayable
      case DebtCategory.note:
        return 'note'; // noteReceivable, notePayable
    }
  }
}
