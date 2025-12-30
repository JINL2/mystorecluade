# Template to RPC Mapping Manual

## Overview

이 문서는 `transaction_templates.data` 구조를 `insert_journal_with_everything_utc` RPC 파라미터로 변환하는 방법을 설명합니다.

---

## 1. RPC 파라미터 구조

### 1.1 Function Signature

```sql
insert_journal_with_everything_utc(
  p_base_amount numeric,           -- 필수: 거래 금액
  p_company_id uuid,               -- 필수: 회사 ID
  p_created_by uuid,               -- 필수: 생성자 ID
  p_description text,              -- 필수: 거래 설명
  p_entry_date_utc timestamptz,    -- 필수: 거래 날짜 (UTC)
  p_lines jsonb,                   -- 필수: 저널 라인 배열
  p_counterparty_id text DEFAULT NULL,        -- 선택: 거래처 ID
  p_if_cash_location_id text DEFAULT NULL,    -- 선택: 내부거래 시 상대방 현금위치
  p_store_id text DEFAULT NULL                -- 선택: 매장 ID
)
RETURNS uuid  -- 생성된 journal_id 반환
```

### 1.2 p_lines 배열 구조

```typescript
interface RpcLine {
  account_id: string;      // 필수: 계정 UUID
  debit: string;           // 차변 금액 (문자열, "0" 또는 금액)
  credit: string;          // 대변 금액 (문자열, "0" 또는 금액)
  description?: string;    // 선택: 라인별 설명

  // 현금 계정인 경우
  cash?: {
    cash_location_id: string;  // 현금 위치 UUID
  };

  // 채권/채무 계정인 경우
  debt?: {
    counterparty_id: string;           // 필수: 거래처 UUID
    direction: 'receivable' | 'payable';  // 필수: 채권/채무 방향
    category: string;                   // 필수: 카테고리 (예: 'account', 'loan')
    interest_rate?: number;             // 선택: 이자율
    interest_account_id?: string;       // 선택: 이자 계정 ID
    interest_due_day?: number;          // 선택: 이자 지급일
    issue_date?: string;                // 선택: 발행일 (YYYY-MM-DD)
    due_date?: string;                  // 선택: 만기일 (YYYY-MM-DD)
    description?: string;               // 선택: 채무 설명
    linkedCounterparty_store_id?: string;  // 선택: 내부거래 상대 매장 ID
  };

  // 고정자산인 경우
  fix_asset?: {
    asset_name: string;           // 필수: 자산명
    acquisition_date: string;     // 필수: 취득일 (YYYY-MM-DD)
    useful_life_years: number;    // 필수: 내용연수
    salvage_value: number;        // 필수: 잔존가치
  };
}
```

---

## 2. Template Data 구조

### 2.1 transaction_templates.data 구조

```typescript
interface TemplateData {
  type: 'debit' | 'credit';        // 라인 타입
  account_id: string;              // 계정 UUID
  category_tag: string;            // 카테고리 태그 (cash, bank, receivable, payable, expense, revenue, fix_asset 등)

  // 현금 계정용
  cash_location_id?: string;       // 현금 위치 ID

  // 채권/채무용
  counterparty_id?: string;        // 거래처 ID
  debt_category?: string;          // 채무 카테고리
}
```

---

## 3. 매핑 규칙

### 3.1 기본 라인 매핑

| Template Field | RPC Line Field | 변환 규칙 |
|---------------|----------------|----------|
| `account_id` | `account_id` | 그대로 복사 |
| `type: 'debit'` | `debit: amount, credit: '0'` | type이 debit이면 debit에 금액 |
| `type: 'credit'` | `debit: '0', credit: amount` | type이 credit이면 credit에 금액 |

### 3.2 category_tag 기반 중첩 객체 생성

| category_tag | 생성할 객체 | 필요 정보 |
|-------------|------------|----------|
| `cash`, `bank` | `cash` | `cash_location_id` 필요 |
| `receivable` | `debt` | `counterparty_id`, `direction: 'receivable'` |
| `payable` | `debt` | `counterparty_id`, `direction: 'payable'` |
| `other` | 없음 | 비용/수익/기타 계정 (중첩 객체 불필요) |
| `fix_asset` | `fix_asset` | 사용자 입력 필요 |

> **Note**: 실제 DB에서 expense(5000-6999), revenue(4000-4999) 계정은 `category_tag: "other"`로 저장됨

### 3.3 Cash 객체 매핑

```dart
// Template data
{
  "type": "debit",
  "account_id": "xxx-cash-account",
  "category_tag": "cash",
  "cash_location_id": "xxx-cash-location"
}

// RPC line으로 변환
{
  "account_id": "xxx-cash-account",
  "debit": "10000",
  "credit": "0",
  "cash": {
    "cash_location_id": "xxx-cash-location"
  }
}
```

### 3.4 Debt 객체 매핑

```dart
// Template data (receivable)
{
  "type": "debit",
  "account_id": "xxx-receivable-account",
  "category_tag": "receivable",
  "counterparty_id": "xxx-counterparty",
  "debt_category": "account"
}

// RPC line으로 변환
{
  "account_id": "xxx-receivable-account",
  "debit": "10000",
  "credit": "0",
  "debt": {
    "counterparty_id": "xxx-counterparty",
    "direction": "receivable",
    "category": "account"
  }
}
```

```dart
// Template data (payable)
{
  "type": "credit",
  "account_id": "xxx-payable-account",
  "category_tag": "payable",
  "counterparty_id": "xxx-counterparty",
  "debt_category": "account"
}

// RPC line으로 변환
{
  "account_id": "xxx-payable-account",
  "debit": "0",
  "credit": "10000",
  "debt": {
    "counterparty_id": "xxx-counterparty",
    "direction": "payable",
    "category": "account"
  }
}
```

---

## 4. Dart 변환 코드 예시

### 4.1 Template Line → RPC Line 변환 함수

```dart
Map<String, dynamic> convertTemplateLineToRpcLine({
  required Map<String, dynamic> templateLine,
  required double amount,
  String? overrideCashLocationId,
  String? overrideCounterpartyId,
  String? debtCategory,
  String? dueDate,
  double? interestRate,
}) {
  final type = templateLine['type'] as String;
  final accountId = templateLine['account_id'] as String;
  final categoryTag = templateLine['category_tag'] as String?;

  // 기본 라인 구조
  final rpcLine = <String, dynamic>{
    'account_id': accountId,
    'debit': type == 'debit' ? amount.toStringAsFixed(0) : '0',
    'credit': type == 'credit' ? amount.toStringAsFixed(0) : '0',
  };

  // Cash 객체 추가
  if (categoryTag == 'cash' || categoryTag == 'bank') {
    final cashLocationId = overrideCashLocationId ??
                           templateLine['cash_location_id'] as String?;
    if (cashLocationId != null && cashLocationId.isNotEmpty) {
      rpcLine['cash'] = {
        'cash_location_id': cashLocationId,
      };
    }
  }

  // Debt 객체 추가
  if (categoryTag == 'receivable' || categoryTag == 'payable') {
    final counterpartyId = overrideCounterpartyId ??
                           templateLine['counterparty_id'] as String?;
    if (counterpartyId != null && counterpartyId.isNotEmpty) {
      final debtObj = <String, dynamic>{
        'counterparty_id': counterpartyId,
        'direction': categoryTag, // 'receivable' or 'payable'
        'category': debtCategory ??
                    templateLine['debt_category'] as String? ??
                    'account',
      };

      // 선택적 필드 추가
      if (dueDate != null) {
        debtObj['due_date'] = dueDate;
      }
      if (interestRate != null) {
        debtObj['interest_rate'] = interestRate;
      }

      rpcLine['debt'] = debtObj;
    }
  }

  // Fix Asset 객체 추가 (사용자 입력 필요)
  if (categoryTag == 'fix_asset') {
    // fix_asset은 사용자 입력이 필요하므로 UI에서 처리
    // 여기서는 기본 구조만 준비
  }

  return rpcLine;
}
```

### 4.2 전체 Template → RPC 파라미터 변환

```dart
Future<Map<String, dynamic>> buildRpcParams({
  required TransactionTemplate template,
  required double amount,
  required String companyId,
  required String userId,
  required String description,
  required DateTime entryDate,
  String? storeId,
  String? overrideCashLocationId,
  String? overrideCounterpartyId,
  String? counterpartyCashLocationId,
}) async {
  final templateData = template.data;
  final rpcLines = <Map<String, dynamic>>[];

  for (final line in templateData) {
    final rpcLine = convertTemplateLineToRpcLine(
      templateLine: line,
      amount: amount,
      overrideCashLocationId: overrideCashLocationId,
      overrideCounterpartyId: overrideCounterpartyId,
    );
    rpcLines.add(rpcLine);
  }

  return {
    'p_base_amount': amount,
    'p_company_id': companyId,
    'p_created_by': userId,
    'p_description': description,
    'p_entry_date_utc': entryDate.toUtc().toIso8601String(),
    'p_lines': rpcLines,
    if (storeId != null) 'p_store_id': storeId,
    if (counterpartyCashLocationId != null)
      'p_if_cash_location_id': counterpartyCashLocationId,
  };
}
```

---

## 5. Template 복잡도별 처리

### 5.1 Expense + Cash (Other + Cash)

```
실제 예시: "expense+cash"
  - debit: expense (6800, category_tag: "other")
  - credit: cash (1000, category_tag: "cash") + cash_location_id

UI 필요 입력:
  - amount (금액)
  - description (설명)
  - cash_location_id (현금 위치 - 변경 가능 ✅)
```

### 5.2 Revenue + Cash (Other + Cash)

```
실제 예시: "revenue_cash"
  - debit: cash (1000, category_tag: "cash") + cash_location_id
  - credit: revenue (4000, category_tag: "other")

UI 필요 입력:
  - amount
  - description
  - cash_location_id (변경 가능 ✅)
```

### 5.3 Cash-Cash (Internal Cash Movement)

```
실제 예시: "internal cash movement"
  - debit: cash (1000) + cash_location_id (sb)
  - credit: cash (1000) + cash_location_id (ads)
  - counterparty: null

UI 필요 입력:
  - amount
  - description
  - ❌ cash_location 변경 불가 (양쪽 고정)
```

### 5.4 External Debt + Cash (Receivable/Payable)

```
실제 예시: "inside store" (외부 거래처)
  - debit: receivable (1100, category_tag: "receivable") + counterparty_id
  - credit: cash (1000, category_tag: "cash") + cash_location_id

UI 필요 입력:
  - amount
  - description
  - counterparty_id (거래처 - 변경 가능 ✅)
  - cash_location_id (변경 가능 ✅)
  - due_date (선택)
  - debt_category (선택, 기본값: "account")
```

### 5.5 Internal Transaction (Linked Company)

```
특징: counterparty에 linked_company_id가 있음
  - 템플릿에 counterparty_cash_location_id 존재
  - mirror journal 자동 생성

UI 필요 입력:
  - amount
  - description
  - ❌ counterparty 변경 불가 (고정)
  - ❌ cash_location 변경 불가 (고정)
```

### 5.6 템플릿 타입 판별 로직

```dart
TemplateType determineTemplateType(List<dynamic> templateLines) {
  int cashCount = 0;
  bool hasReceivablePayable = false;
  bool hasOther = false;
  bool hasCounterpartyCashLocationId = false;

  for (final line in templateLines) {
    final categoryTag = line['category_tag']?.toString();

    if (categoryTag == 'cash' || categoryTag == 'bank') {
      cashCount++;
    }
    if (categoryTag == 'receivable' || categoryTag == 'payable') {
      hasReceivablePayable = true;
    }
    if (categoryTag == 'other') {
      hasOther = true;
    }
    if (line['counterparty_cash_location_id'] != null) {
      hasCounterpartyCashLocationId = true;
    }
  }

  // 1. Cash-Cash: 양쪽 다 현금
  if (cashCount >= 2) {
    return TemplateType.cashCash; // 모든 값 고정
  }

  // 2. Internal (linked_company): counterparty_cash_location_id 존재
  if (hasCounterpartyCashLocationId && hasReceivablePayable) {
    return TemplateType.internal; // 모든 값 고정
  }

  // 3. External Debt + Cash
  if (hasReceivablePayable && cashCount == 1) {
    return TemplateType.externalDebt; // counterparty, cash_location 변경 가능
  }

  // 4. Expense/Revenue + Cash
  if (hasOther && cashCount == 1) {
    return TemplateType.expenseRevenueCash; // cash_location 변경 가능
  }

  return TemplateType.unknown;
}

enum TemplateType {
  cashCash,           // Cash-Cash: 모든 값 고정
  internal,           // Internal: 모든 값 고정
  externalDebt,       // External Debt: counterparty, cash_location 변경 가능
  expenseRevenueCash, // Expense/Revenue + Cash: cash_location만 변경 가능
  unknown,
}
```

---

## 6. RPC 검증 규칙

RPC 함수 내부에서 다음 검증이 수행됩니다:

### 6.1 필수 검증

| 항목 | 검증 내용 | 에러 메시지 |
|-----|---------|-----------|
| p_lines | NULL 불가 | `p_lines가 NULL입니다` |
| p_lines | 배열 타입 | `p_lines는 배열이어야 합니다` |
| p_lines | 비어있으면 안됨 | `p_lines가 비어있습니다` |

### 6.2 라인별 검증

| 항목 | 검증 내용 |
|-----|---------|
| account_id | 필수, 유효한 UUID |
| debit/credit | 최소 하나 필수, 숫자여야 함 |
| debt.counterparty_id | debt가 있으면 필수, 유효한 UUID |
| debt.direction | 필수, 'receivable' 또는 'payable' |
| debt.category | 필수 |
| cash.cash_location_id | 있으면 유효한 UUID |
| fix_asset.asset_name | fix_asset이 있으면 필수 |
| fix_asset.acquisition_date | fix_asset이 있으면 필수 |
| fix_asset.useful_life_years | fix_asset이 있으면 필수 |
| fix_asset.salvage_value | fix_asset이 있으면 필수 |

### 6.3 합계 검증

```
total_debit == total_credit (차변과 대변 합계 일치)
```

---

## 7. 에러 처리

### 7.1 RPC 호출 예시

```dart
try {
  final params = await buildRpcParams(...);

  final journalId = await supabase.rpc(
    'insert_journal_with_everything_utc',
    params: params,
  );

  return JournalResult.success(journalId);

} on PostgrestException catch (e) {
  // RPC 검증 에러 처리
  if (e.message.contains('[검증 실패]')) {
    return JournalResult.validationError(e.message);
  }
  return JournalResult.error(e.message);
} catch (e) {
  return JournalResult.error(e.toString());
}
```

---

## 8. 내부 거래 (Linked Company) 특별 처리

### 8.1 Mirror Journal 자동 생성

linked_company_id가 있는 counterparty를 사용하면:
1. 원본 저널이 생성됨
2. `create_mirror_journal_for_counterparty_utc` 함수가 자동 호출
3. 상대 회사에 미러 저널이 생성됨

### 8.2 필요 파라미터

```dart
// 내부 거래시 필수
'p_if_cash_location_id': counterpartyCashLocationId, // 상대방 현금 위치

// debt 객체 내
'linkedCounterparty_store_id': counterpartyStoreId, // 상대방 매장 ID
```

---

## 9. Quick Reference

### Template → RPC 필드 매핑 테이블

| Template Field | RPC Field | 조건 |
|---------------|-----------|------|
| `type: 'debit'` | `debit: amount` | - |
| `type: 'credit'` | `credit: amount` | - |
| `account_id` | `account_id` | 항상 |
| `category_tag: 'cash'/'bank'` | `cash.cash_location_id` | cash_location_id 필요 |
| `category_tag: 'receivable'` | `debt.direction: 'receivable'` | counterparty_id 필요 |
| `category_tag: 'payable'` | `debt.direction: 'payable'` | counterparty_id 필요 |
| `counterparty_id` | `debt.counterparty_id` | debt 계정일 때 |
| `debt_category` | `debt.category` | debt 계정일 때 |
| `cash_location_id` | `cash.cash_location_id` | cash 계정일 때 |

---

## 10. 검증 및 에러 처리

### 10.1 에러 발생 위치

```
┌─────────────────────────────────────────────────────────────────┐
│                      에러 발생 흐름                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [Client]                    [Server]                           │
│                                                                 │
│  1. Dart 사전 검증  ──────►  (호출 전 잡음)                      │
│                                                                 │
│  2. RPC 호출        ──────►  3. RPC 내부 검증                    │
│                              ↓                                  │
│                              [검증 실패] RAISE EXCEPTION         │
│                              ↓                                  │
│  4. PostgrestException ◄────  에러 메시지 전달                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 10.2 RPC 에러 메시지 패턴

RPC 함수 내부에서 발생하는 에러 메시지는 `[검증 실패]` 접두사로 시작합니다:

| 에러 패턴 | 의미 |
|----------|------|
| `[검증 실패] p_lines가 NULL입니다` | p_lines 파라미터 누락 |
| `[검증 실패] p_lines는 배열이어야 합니다` | p_lines가 배열이 아님 |
| `[검증 실패] p_lines가 비어있습니다` | 빈 배열 전송 |
| `[검증 실패] 라인 N: account_id가 없거나 비어있습니다` | 계정 ID 누락 |
| `[검증 실패] 라인 N: account_id가 유효한 UUID가 아닙니다` | 잘못된 UUID 형식 |
| `[검증 실패] 라인 N: debit 또는 credit 중 하나는 필수입니다` | 금액 누락 |
| `[검증 실패] 라인 N: debt에 counterparty_id가 없습니다` | 채권/채무에 거래처 누락 |
| `[검증 실패] 라인 N: debt에 direction이 없습니다` | direction 누락 |
| `[검증 실패] 라인 N: debt의 direction은 "receivable" 또는 "payable"이어야 합니다` | 잘못된 direction 값 |
| `[검증 실패] 라인 N: debt에 category가 없습니다` | category 누락 |
| `차변과 대변의 합계가 일치하지 않습니다` | 차대변 불균형 |

### 10.3 Dart 에러 캐치 코드

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<RpcResult> callInsertJournal(Map<String, dynamic> params) async {
  try {
    final journalId = await supabase.rpc(
      'insert_journal_with_everything_utc',
      params: params,
    );

    return RpcResult.success(journalId as String);

  } on PostgrestException catch (e) {
    // RPC 검증 에러 파싱
    final message = e.message ?? '';

    // 1. [검증 실패] 패턴 매칭
    if (message.contains('[검증 실패]')) {
      // 라인 번호 추출 (있는 경우)
      final lineMatch = RegExp(r'라인 (\d+):').firstMatch(message);
      final lineNumber = lineMatch?.group(1);

      return RpcResult.validationError(
        message: message,
        lineNumber: lineNumber != null ? int.parse(lineNumber) : null,
        field: _extractFieldFromError(message),
      );
    }

    // 2. 차대변 불균형
    if (message.contains('차변과 대변의 합계가 일치하지 않습니다')) {
      return RpcResult.balanceError(message);
    }

    // 3. 기타 DB 에러
    return RpcResult.databaseError(
      code: e.code ?? 'UNKNOWN',
      message: message,
    );

  } catch (e) {
    return RpcResult.unknownError(e.toString());
  }
}

/// 에러 메시지에서 필드명 추출
String? _extractFieldFromError(String message) {
  if (message.contains('account_id')) return 'account_id';
  if (message.contains('counterparty_id')) return 'counterparty_id';
  if (message.contains('direction')) return 'direction';
  if (message.contains('category')) return 'category';
  if (message.contains('cash_location_id')) return 'cash_location_id';
  if (message.contains('debit') || message.contains('credit')) return 'amount';
  if (message.contains('asset_name')) return 'asset_name';
  if (message.contains('acquisition_date')) return 'acquisition_date';
  if (message.contains('useful_life_years')) return 'useful_life_years';
  if (message.contains('salvage_value')) return 'salvage_value';
  return null;
}
```

### 10.4 RpcResult 클래스 정의

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rpc_result.freezed.dart';

@freezed
class RpcResult with _$RpcResult {
  /// 성공
  const factory RpcResult.success(String journalId) = RpcSuccess;

  /// 검증 에러 (RPC 내부)
  const factory RpcResult.validationError({
    required String message,
    int? lineNumber,
    String? field,
  }) = RpcValidationError;

  /// 차대변 불균형
  const factory RpcResult.balanceError(String message) = RpcBalanceError;

  /// DB 에러
  const factory RpcResult.databaseError({
    required String code,
    required String message,
  }) = RpcDatabaseError;

  /// 알 수 없는 에러
  const factory RpcResult.unknownError(String message) = RpcUnknownError;
}
```

### 10.5 Dart 클라이언트 사전 검증

RPC 호출 전에 클라이언트에서 먼저 검증하면 불필요한 서버 요청을 줄일 수 있습니다:

```dart
class TemplateValidator {
  /// p_lines 사전 검증
  static ValidationResult validateLines(List<Map<String, dynamic>> lines) {
    final errors = <ValidationError>[];

    // 1. 빈 배열 체크
    if (lines.isEmpty) {
      return ValidationResult.error('p_lines가 비어있습니다');
    }

    double totalDebit = 0;
    double totalCredit = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNum = i + 1;

      // 2. account_id 필수
      final accountId = line['account_id']?.toString();
      if (accountId == null || accountId.isEmpty) {
        errors.add(ValidationError(
          line: lineNum,
          field: 'account_id',
          message: 'account_id가 필요합니다',
        ));
        continue;
      }

      // 3. UUID 형식 검증
      if (!_isValidUuid(accountId)) {
        errors.add(ValidationError(
          line: lineNum,
          field: 'account_id',
          message: 'account_id가 유효한 UUID가 아닙니다',
        ));
      }

      // 4. debit/credit 검증
      final debit = double.tryParse(line['debit']?.toString() ?? '0') ?? 0;
      final credit = double.tryParse(line['credit']?.toString() ?? '0') ?? 0;

      if (debit == 0 && credit == 0) {
        errors.add(ValidationError(
          line: lineNum,
          field: 'amount',
          message: 'debit 또는 credit 중 하나는 0보다 커야 합니다',
        ));
      }

      totalDebit += debit;
      totalCredit += credit;

      // 5. debt 객체 검증
      if (line.containsKey('debt')) {
        final debt = line['debt'] as Map<String, dynamic>?;
        if (debt != null) {
          _validateDebt(debt, lineNum, errors);
        }
      }

      // 6. cash 객체 검증
      if (line.containsKey('cash')) {
        final cash = line['cash'] as Map<String, dynamic>?;
        if (cash != null) {
          _validateCash(cash, lineNum, errors);
        }
      }
    }

    // 7. 차대변 균형 검증
    if ((totalDebit - totalCredit).abs() > 0.01) {
      errors.add(ValidationError(
        line: null,
        field: 'balance',
        message: '차변($totalDebit)과 대변($totalCredit)의 합계가 일치하지 않습니다',
      ));
    }

    if (errors.isNotEmpty) {
      return ValidationResult.errors(errors);
    }

    return ValidationResult.valid();
  }

  static void _validateDebt(
    Map<String, dynamic> debt,
    int lineNum,
    List<ValidationError> errors,
  ) {
    // counterparty_id 필수
    final counterpartyId = debt['counterparty_id']?.toString();
    if (counterpartyId == null || counterpartyId.isEmpty) {
      errors.add(ValidationError(
        line: lineNum,
        field: 'debt.counterparty_id',
        message: 'counterparty_id가 필요합니다',
      ));
    } else if (!_isValidUuid(counterpartyId)) {
      errors.add(ValidationError(
        line: lineNum,
        field: 'debt.counterparty_id',
        message: 'counterparty_id가 유효한 UUID가 아닙니다',
      ));
    }

    // direction 필수
    final direction = debt['direction']?.toString();
    if (direction == null || direction.isEmpty) {
      errors.add(ValidationError(
        line: lineNum,
        field: 'debt.direction',
        message: 'direction이 필요합니다',
      ));
    } else if (direction != 'receivable' && direction != 'payable') {
      errors.add(ValidationError(
        line: lineNum,
        field: 'debt.direction',
        message: 'direction은 "receivable" 또는 "payable"이어야 합니다',
      ));
    }

    // category 필수
    final category = debt['category']?.toString();
    if (category == null || category.isEmpty) {
      errors.add(ValidationError(
        line: lineNum,
        field: 'debt.category',
        message: 'category가 필요합니다',
      ));
    }
  }

  static void _validateCash(
    Map<String, dynamic> cash,
    int lineNum,
    List<ValidationError> errors,
  ) {
    final cashLocationId = cash['cash_location_id']?.toString();
    if (cashLocationId != null &&
        cashLocationId.isNotEmpty &&
        !_isValidUuid(cashLocationId)) {
      errors.add(ValidationError(
        line: lineNum,
        field: 'cash.cash_location_id',
        message: 'cash_location_id가 유효한 UUID가 아닙니다',
      ));
    }
  }

  static bool _isValidUuid(String value) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(value);
  }
}

class ValidationError {
  final int? line;
  final String field;
  final String message;

  ValidationError({
    required this.line,
    required this.field,
    required this.message,
  });

  @override
  String toString() {
    if (line != null) {
      return '라인 $line: $field - $message';
    }
    return '$field - $message';
  }
}

class ValidationResult {
  final bool isValid;
  final List<ValidationError> errors;

  ValidationResult.valid() : isValid = true, errors = [];

  ValidationResult.error(String message)
      : isValid = false,
        errors = [ValidationError(line: null, field: 'general', message: message)];

  ValidationResult.errors(this.errors) : isValid = false;
}
```

### 10.6 통합 사용 예시

```dart
Future<void> createJournalFromTemplate({
  required TransactionTemplate template,
  required double amount,
  required String companyId,
  required String userId,
  required String description,
  // ... other params
}) async {
  // 1. Template → p_lines 변환
  final lines = _buildLinesFromTemplate(template, amount);

  // 2. 클라이언트 사전 검증
  final validationResult = TemplateValidator.validateLines(lines);
  if (!validationResult.isValid) {
    // UI에 검증 에러 표시
    _showValidationErrors(validationResult.errors);
    return;
  }

  // 3. RPC 호출
  final params = {
    'p_base_amount': amount,
    'p_company_id': companyId,
    'p_created_by': userId,
    'p_description': description,
    'p_entry_date_utc': DateTime.now().toUtc().toIso8601String(),
    'p_lines': lines,
    // ...
  };

  final result = await callInsertJournal(params);

  // 4. 결과 처리
  result.when(
    success: (journalId) {
      _showSuccess('저널이 생성되었습니다: $journalId');
    },
    validationError: (message, lineNumber, field) {
      _showError('검증 실패: $message');
      if (lineNumber != null) {
        _highlightErrorLine(lineNumber);
      }
    },
    balanceError: (message) {
      _showError('차대변 불균형: $message');
    },
    databaseError: (code, message) {
      _showError('DB 에러 [$code]: $message');
    },
    unknownError: (message) {
      _showError('알 수 없는 에러: $message');
    },
  );
}
```

### 10.7 에러 메시지 → UI 매핑

| RPC 에러 필드 | UI 표시 위치 |
|--------------|-------------|
| `account_id` | 계정 선택 필드 하이라이트 |
| `counterparty_id` | 거래처 선택 필드 하이라이트 |
| `direction` | 내부 에러 (템플릿 문제) |
| `category` | 내부 에러 (템플릿 문제) |
| `cash_location_id` | 현금 위치 선택 필드 하이라이트 |
| `amount` / `debit` / `credit` | 금액 입력 필드 하이라이트 |
| `balance` | 금액 입력 필드 + 전체 에러 메시지 |

---

## 11. 디버깅 가이드

### 11.1 Console Debug Output

테스트 페이지에서 다음 디버그 출력을 확인할 수 있습니다:

```
═══════════════════════════════════════════════════════════════
📋 TEMPLATE SELECTED
═══════════════════════════════════════════════════════════════
Name: 현금매출
ID: xxx-xxx-xxx
Default Cash Location ID: yyy-yyy-yyy
Template data lines: 2
...

═══════════════════════════════════════════════════════════════
🔧 BUILD p_lines JSON
═══════════════════════════════════════════════════════════════
Template: 현금매출
Amount: 10000
Selected Cash Location: zzz-zzz-zzz
...

═══════════════════════════════════════════════════════════════
🚀 CALLING insert_journal_with_everything_utc
═══════════════════════════════════════════════════════════════
{
  "p_base_amount": 10000,
  "p_company_id": "...",
  "p_lines": [...],
  ...
}

✅ RPC RESULT: abc-def-ghi (journal_id)
```

### 11.2 에러 발생 시 디버그 출력

```
❌ RPC ERROR: PostgrestException(message: [검증 실패] 라인 1: debt에 counterparty_id가 없습니다., ...)
Stack trace: ...
```

---

## 12. 테스트 검증 결과

### 12.1 테스트 완료 현황 (2025-12-29)

| Template Type | 테스트 결과 | Journal ID | 비고 |
|---------------|------------|------------|------|
| Internal Receivable + Cash | ✅ SUCCESS | `d495ce43-...` | Mirror Journal 자동 생성 확인 |
| Cash-Cash (내부 이동) | ✅ SUCCESS | `f0d44607-...` | 양측 cash_location 정상 |
| Revenue + Cash | ✅ SUCCESS | `6b4ba2d0-...` | other 카테고리 정상 처리 |
| Expense + Cash | ✅ SUCCESS | `e9ae21c9-...` | other 카테고리 정상 처리 |

### 12.2 검증된 사항

1. **p_lines 구조**: 중첩 `cash`, `debt` 객체가 정상 작동
2. **category_tag: "other"**: expense/revenue 계정이 `other`로 저장되어도 정상 처리
3. **Mirror Journal**: Internal counterparty (linked_company_id 있음) 시 미러 저널 자동 생성
4. **차대변 균형**: RPC 내부 검증 정상 작동
5. **cash_location_id**: 템플릿 기본값 및 오버라이드 모두 정상

### 12.3 알려진 제한사항

- `counterparty_cash_location_id`가 있는 템플릿은 counterparty/cash_location 변경 불가 (Internal Transaction)
- Cash-Cash 템플릿은 양쪽 cash_location 모두 고정

---

*Last Updated: 2025-12-29*
