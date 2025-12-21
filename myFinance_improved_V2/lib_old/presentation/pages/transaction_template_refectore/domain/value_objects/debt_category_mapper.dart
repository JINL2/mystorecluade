/// 🏛️ DOMAIN VALUE OBJECT: DebtCategoryMapper
///
/// **목적**: 계정 이름(account_name)에서 채권/채무 카테고리를 자동 추론
///
/// **비즈니스 규칙**:
/// - DB CHECK 제약: category IN ('note', 'account', 'loan', 'other')
/// - 계정 이름의 키워드 기반 자동 매핑
///
/// **Clean Architecture**:
/// - Domain Layer - 핵심 비즈니스 로직
/// - Entity, Use Case, Repository 어디서든 재사용 가능
/// - 순수 함수 (Pure Function) - 테스트 용이
///
/// **사용 예시**:
/// ```dart
/// final category = DebtCategoryMapper.inferFromAccountName('Note Receivable');
/// print(category); // 'note'
/// ```
class DebtCategoryMapper {
  /// 🚨 DB CHECK 제약 조건: 허용되는 카테고리 값
  ///
  /// PostgreSQL:
  /// ```sql
  /// category = ANY (ARRAY['note'::text, 'account'::text, 'loan'::text, 'other'::text])
  /// ```
  static const List<String> allowedCategories = [
    'note',    // 어음 (Note Receivable/Payable)
    'account', // 외상 (Account Receivable/Payable)
    'loan',    // 대여금/차입금 (Loan Receivable/Payable)
    'other',   // 기타
  ];

  /// 기본 카테고리 (추론 실패 시 사용)
  static const String defaultCategory = 'account';

  /// 📊 계정 이름 → 카테고리 매핑 규칙
  ///
  /// **우선순위 순서**:
  /// 1. "Note" → 'note' (어음)
  /// 2. "Loan" → 'loan' (대여금/차입금)
  /// 3. "Account" → 'account' (외상)
  /// 4. 기타 → 'account' (기본값)
  ///
  /// **매핑 테이블**:
  /// | account_name        | category   | 설명          |
  /// |---------------------|------------|---------------|
  /// | Note Receivable     | 'note'     | 받을 어음     |
  /// | Note Payable        | 'note'     | 지급 어음     |
  /// | Loan Receivable     | 'loan'     | 대여금        |
  /// | Loan Payable        | 'loan'     | 차입금        |
  /// | Account Receivable  | 'account'  | 외상 매출금   |
  /// | Account Payable     | 'account'  | 외상 매입금   |
  /// | Trade Receivable    | 'account'  | 외상 매출금   |
  /// | Other Receivable    | 'account'  | 기타 채권     |
  /// | null                | 'account'  | 기본값        |
  ///
  /// **파라미터**:
  /// - [accountName]: 계정 이름 (예: "Note Receivable", "Account Payable")
  ///
  /// **반환값**: 추론된 카테고리 ('note', 'account', 'loan', 'other')
  static String inferFromAccountName(String? accountName) {
    // null 또는 빈 문자열 → 기본값
    if (accountName == null || accountName.isEmpty) {
      return defaultCategory;
    }

    // 대소문자 구분 없이 검색
    final lowerName = accountName.toLowerCase().trim();

    // 🔍 우선순위 1: Note (어음)
    // - "Note Receivable", "Note Payable", "Notes Receivable" 등
    if (lowerName.contains('note')) {
      return 'note';
    }

    // 🔍 우선순위 2: Loan (대여금/차입금)
    // - "Loan Receivable", "Loan Payable", "Loans to Officers" 등
    if (lowerName.contains('loan')) {
      return 'loan';
    }

    // 🔍 우선순위 3: Account (외상)
    // - "Account Receivable", "Account Payable", "Accounts Receivable" 등
    // - "Trade Receivable", "Trade Payable" 등
    if (lowerName.contains('account') || lowerName.contains('trade')) {
      return 'account';
    }

    // 🔍 기본값: account (가장 일반적인 외상 거래)
    return defaultCategory;
  }

  /// 📦 Template line에서 account_name 추출
  ///
  /// **파라미터**:
  /// - [templateLine]: Template의 data 배열 안의 한 라인
  ///
  /// **반환값**: account_name 또는 null
  ///
  /// **예시**:
  /// ```dart
  /// final templateLine = {
  ///   'account_id': 'xxx',
  ///   'account_name': 'Note Receivable',
  ///   'category_tag': 'receivable',
  /// };
  /// final name = DebtCategoryMapper.extractAccountName(templateLine);
  /// // 'Note Receivable'
  /// ```
  static String? extractAccountName(Map<String, dynamic> templateLine) {
    return templateLine['account_name'] as String?;
  }

  /// 🎯 Template line에서 자동으로 category 추론 (통합 메서드)
  ///
  /// **편의 메서드**: extractAccountName() + inferFromAccountName()
  ///
  /// **파라미터**:
  /// - [templateLine]: Template의 data 배열 안의 한 라인
  ///
  /// **반환값**: 추론된 카테고리
  ///
  /// **예시**:
  /// ```dart
  /// final templateLine = {
  ///   'account_name': 'Note Receivable',
  ///   'category_tag': 'receivable',
  /// };
  /// final category = DebtCategoryMapper.inferFromTemplateLine(templateLine);
  /// // 'note'
  /// ```
  static String inferFromTemplateLine(Map<String, dynamic> templateLine) {
    final accountName = extractAccountName(templateLine);
    return inferFromAccountName(accountName);
  }

  /// ✅ 카테고리 값 유효성 검증
  ///
  /// **파라미터**:
  /// - [category]: 검증할 카테고리 값
  ///
  /// **반환값**: DB CHECK 제약을 만족하면 true
  static bool isValidCategory(String category) {
    return allowedCategories.contains(category);
  }

  /// 🔧 카테고리 값 정규화 (유효하지 않으면 기본값 반환)
  ///
  /// **파라미터**:
  /// - [category]: 정규화할 카테고리 값
  ///
  /// **반환값**: 유효한 카테고리 또는 기본값
  static String normalize(String? category) {
    if (category == null || !isValidCategory(category)) {
      return defaultCategory;
    }
    return category;
  }

  /// 📖 카테고리 한글 라벨
  static const Map<String, String> categoryLabels = {
    'note': '어음 (Note)',
    'account': '외상 (Account)',
    'loan': '대여금/차입금 (Loan)',
    'other': '기타 (Other)',
  };

  /// 🌐 카테고리 영문 라벨
  static const Map<String, String> categoryLabelsEn = {
    'note': 'Note',
    'account': 'Account',
    'loan': 'Loan',
    'other': 'Other',
  };
}
