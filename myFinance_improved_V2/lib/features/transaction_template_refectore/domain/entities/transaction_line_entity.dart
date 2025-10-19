import 'package:equatable/equatable.dart';
import '../value_objects/debt_category_mapper.dart';

/// 🏛️ DOMAIN ENTITY: TransactionLine (거래 라인)
///
/// **목적**: Template의 data 배열 안에 있는 각 거래 라인을 타입 안전하게 표현
///
/// **위치**: Domain Layer - 비즈니스 규칙의 핵심
///
/// **타입 안정성 예시**:
/// ```dart
/// // ❌ Map 방식 (오타 발견 못함)
/// final type = line['tyep'];  // null! 오타인데 컴파일러가 모름
///
/// // ✅ Entity 방식 (컴파일 에러!)
/// final type = line.tyep;  // 컴파일 에러: 'tyep' 없음!
/// ```
///
/// **Clean Architecture 위치**:
/// - Domain Entity (비즈니스 규칙 정의)
/// - Data Layer가 이 구조를 따라야 함 (의존성 역전!)
class TransactionLine extends Equatable {
  /// 거래 타입: 'debit' (차변) 또는 'credit' (대변)
  final String type;

  /// 계정 ID (account_chart의 FK)
  final String accountId;

  /// 카테고리 태그: 'cash', 'receivable', 'payable', 'revenue', 'expense' 등
  final String? categoryTag;

  /// 현금 위치 정보 (category_tag가 'cash'일 때만)
  final CashLocation? cash;

  /// 채권/채무 정보 (category_tag가 'receivable'/'payable'일 때만)
  final DebtConfig? debt;

  /// 거래처 ID (외부 거래처)
  final String? counterpartyId;

  /// 메모 (선택 사항)
  final String? memo;

  const TransactionLine({
    required this.type,
    required this.accountId,
    this.categoryTag,
    this.cash,
    this.debt,
    this.counterpartyId,
    this.memo,
  });

  /// 📥 Factory: Template의 Map 데이터 → TransactionLine Entity 변환
  ///
  /// **데이터 흐름**:
  /// ```
  /// Template (DB) → Map<String, dynamic> → [이 함수] → TransactionLine Entity
  /// ```
  ///
  /// **왜 필요한가?**:
  /// - Template은 JSONB로 저장되어 Map으로 로드됨
  /// - 하지만 코드에서는 타입 안전한 Entity로 사용하고 싶음
  /// - 이 factory가 그 변환을 담당!
  factory TransactionLine.fromTemplate(Map<String, dynamic> json) {
    // 🔍 cash 객체 파싱 (있으면)
    CashLocation? cash;
    if (json['cash_location_id'] != null) {
      cash = CashLocation(
        cashLocationId: json['cash_location_id'] as String,
      );
    }

    // 🔍 debt 객체 파싱 (있으면)
    DebtConfig? debt;
    if (json['debt'] != null) {
      final debtMap = json['debt'] as Map<String, dynamic>;
      debt = DebtConfig(
        counterpartyId: debtMap['counterparty_id'] as String?,
        direction: debtMap['direction'] as String?,
        category: debtMap['category'] as String?,
        issueDate: debtMap['issue_date'] as String?,
        dueDate: debtMap['due_date'] as String?,
        linkedCounterpartyStoreId: debtMap['linkedCounterparty_store_id'] as String?,
        linkedCounterpartyCompanyId: debtMap['linkedCounterparty_companyId'] as String?,
      );
    } else if (json['category_tag'] == 'receivable' || json['category_tag'] == 'payable') {
      // ✅ AUTO-GENERATE: Template이 receivable/payable인데 debt 객체 없으면 생성
      final counterpartyId = json['counterparty_id'] as String?;
      if (counterpartyId != null) {
        debt = DebtConfig(
          counterpartyId: counterpartyId,
          direction: json['category_tag'] as String,
          category: DebtCategoryMapper.inferFromTemplateLine(json),  // ✅ 자동 추론!
          issueDate: json['issue_date'] as String?,  // Template에서 가져오기
          dueDate: json['due_date'] as String?,      // Template에서 가져오기
          linkedCounterpartyStoreId: null,  // Template에 없으면 null
          linkedCounterpartyCompanyId: null,
        );
      }
    }

    return TransactionLine(
      type: json['type'] as String,
      accountId: json['account_id'] as String,
      categoryTag: json['category_tag'] as String?,
      cash: cash,
      debt: debt,
      counterpartyId: json['counterparty_id'] as String?,
      memo: json['memo'] as String?,
    );
  }

  /// 📤 Method: TransactionLine Entity → RPC 포맷 Map 변환
  ///
  /// **데이터 흐름**:
  /// ```
  /// TransactionLine Entity → [이 함수] → Map<String, dynamic> → RPC 호출
  /// ```
  ///
  /// **왜 필요한가?**:
  /// - Supabase RPC는 JSON 포맷을 받음
  /// - Entity를 그대로 보낼 수 없으므로 Map으로 변환 필요
  /// - RPC의 정확한 포맷 요구사항을 이 함수가 책임짐!
  ///
  /// **파라미터**:
  /// - [amount]: 실제 거래 금액 (사용자가 입력한 값)
  /// - [selectedMyCashLocationId]: 사용자가 선택한 내 현금 위치 (cash인 경우)
  /// - [selectedCounterpartyId]: 사용자가 선택한 거래처 (debt인 경우)
  /// - [entryDate]: 거래 발생일 (issue_date 기본값으로 사용)
  Map<String, dynamic> toRpc({
    required double amount,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    required String entryDate,  // ✅ issue_date 기본값
  }) {
    // ✅ 기본 구조 생성
    final Map<String, dynamic> rpcLine = {
      'account_id': accountId,
      'description': memo,  // ✅ RPC expects 'description', not 'memo'
    };

    // ✅ CRITICAL: debit/credit을 STRING으로 설정 (RPC 요구사항!)
    if (type == 'debit') {
      rpcLine['debit'] = amount.toStringAsFixed(0);  // "999999"
      rpcLine['credit'] = '0';
    } else {
      rpcLine['debit'] = '0';
      rpcLine['credit'] = amount.toStringAsFixed(0);  // "999999"
    }

    // ✅ cash 객체 추가 (category_tag가 'cash'면)
    if (categoryTag == 'cash') {
      final cashLocationId = cash?.cashLocationId ?? selectedMyCashLocationId;
      if (cashLocationId != null) {
        rpcLine['cash'] = {
          'cash_location_id': cashLocationId,
        };
      }
    }

    // ✅ debt 객체 추가 (category_tag가 'receivable'/'payable'면)
    if (categoryTag == 'receivable' || categoryTag == 'payable') {
      DebtConfig? finalDebt = debt;

      // debt 객체가 없으면 auto-generate
      if (finalDebt == null) {
        final counterpartyId = this.counterpartyId ?? selectedCounterpartyId;
        if (counterpartyId != null) {
          finalDebt = DebtConfig(
            counterpartyId: counterpartyId,
            direction: categoryTag!,
            category: DebtCategoryMapper.defaultCategory,  // ✅ 기본값 'account' 사용
            issueDate: entryDate,  // ✅ entry_date를 issue_date로 사용
            dueDate: null,         // Template에 없으면 null
            linkedCounterpartyStoreId: null,
            linkedCounterpartyCompanyId: null,
          );
        }
      } else if (selectedCounterpartyId != null) {
        // debt 객체가 있지만 사용자가 새로운 counterparty를 선택했으면 override
        finalDebt = DebtConfig(
          counterpartyId: selectedCounterpartyId,
          direction: finalDebt.direction,
          category: finalDebt.category,
          issueDate: finalDebt.issueDate ?? entryDate,  // ✅ 없으면 entry_date 사용
          dueDate: finalDebt.dueDate,
          linkedCounterpartyStoreId: finalDebt.linkedCounterpartyStoreId,
          linkedCounterpartyCompanyId: finalDebt.linkedCounterpartyCompanyId,
        );
      } else if (finalDebt.issueDate == null) {
        // ✅ debt 객체는 있지만 issue_date가 없으면 추가
        finalDebt = DebtConfig(
          counterpartyId: finalDebt.counterpartyId,
          direction: finalDebt.direction,
          category: finalDebt.category,
          issueDate: entryDate,  // ✅ entry_date를 issue_date로 사용
          dueDate: finalDebt.dueDate,
          linkedCounterpartyStoreId: finalDebt.linkedCounterpartyStoreId,
          linkedCounterpartyCompanyId: finalDebt.linkedCounterpartyCompanyId,
        );
      }

      if (finalDebt != null) {
        rpcLine['debt'] = finalDebt.toRpc();
      }
    }

    return rpcLine;
  }

  @override
  List<Object?> get props => [
        type,
        accountId,
        categoryTag,
        cash,
        debt,
        counterpartyId,
        memo,
      ];
}

/// 🏛️ VALUE OBJECT: CashLocation (현금 위치)
///
/// **목적**: 현금 거래 시 어느 현금 위치인지 표현
///
/// **예시**: "본사 금고", "1호점 현금", "은행 계좌 A"
class CashLocation extends Equatable {
  final String cashLocationId;

  const CashLocation({
    required this.cashLocationId,
  });

  @override
  List<Object?> get props => [cashLocationId];
}

/// 🏛️ VALUE OBJECT: DebtConfig (채권/채무 설정)
///
/// **목적**: 채권(receivable) 또는 채무(payable) 정보 표현
///
/// **필드 설명**:
/// - counterpartyId: 누구한테 받을 돈/줄 돈인지
/// - direction: 'receivable' (받을 돈) 또는 'payable' (줄 돈)
/// - category: 'note', 'account', 'loan', 'other' (DB CHECK 제약)
/// - issueDate: 채권/채무 발생일 (NOT NULL 필수!)
/// - dueDate: 만기일 (선택)
/// - linkedCounterpartyStoreId: 상대방 스토어 ID (내부 거래 시)
/// - linkedCounterpartyCompanyId: 상대방 회사 ID (내부 거래 시)
class DebtConfig extends Equatable {
  final String? counterpartyId;
  final String? direction;  // 'receivable' | 'payable'
  final String? category;   // 'note' | 'account' | 'loan' | 'other'
  final String? issueDate;  // 발생일 (YYYY-MM-DD) - NOT NULL!
  final String? dueDate;    // 만기일 (YYYY-MM-DD) - nullable
  final String? linkedCounterpartyStoreId;   // 상대방 스토어 ID (내부 거래)
  final String? linkedCounterpartyCompanyId; // 상대방 회사 ID (내부 거래)

  const DebtConfig({
    this.counterpartyId,
    this.direction,
    this.category,
    this.issueDate,
    this.dueDate,
    this.linkedCounterpartyStoreId,
    this.linkedCounterpartyCompanyId,
  });

  /// RPC 포맷으로 변환
  Map<String, dynamic> toRpc() {
    return {
      'counterparty_id': counterpartyId,
      'direction': direction,
      'category': category,
      'issue_date': issueDate,  // ✅ 필수!
      if (dueDate != null) 'due_date': dueDate,  // 선택
      if (linkedCounterpartyStoreId != null) 'linkedCounterparty_store_id': linkedCounterpartyStoreId,  // ✅ 내부 거래
      if (linkedCounterpartyCompanyId != null) 'linkedCounterparty_companyId': linkedCounterpartyCompanyId,  // ✅ 내부 거래
    };
  }

  @override
  List<Object?> get props => [
        counterpartyId,
        direction,
        category,
        issueDate,
        dueDate,
        linkedCounterpartyStoreId,
        linkedCounterpartyCompanyId,
      ];
}
