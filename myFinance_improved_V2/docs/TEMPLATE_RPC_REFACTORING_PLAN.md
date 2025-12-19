# Template Usage RPC Refactoring Plan

> **목적**: Template Usage 페이지의 모든 클라이언트 사이드 로직을 효율적인 RPC로 이동
> **작성일**: 2025-12-19
> **상태**: Planning
> **DB 스키마 검증**: 2025-12-19 ✅ 완료

---

## 0. DB 스키마 검증 결과 (CRITICAL)

> **검증 방법**: Supabase MCP를 통한 실제 데이터 구조 분석
> **검증일**: 2025-12-19

### 0.1 `transaction_templates` 테이블 컬럼

| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| `template_id` | UUID | PK |
| `name` | TEXT | 템플릿 이름 |
| `data` | JSONB | **핵심!** 거래 라인 배열 |
| `tags` | JSONB | 메타데이터 (accounts, categories, cash_locations) |
| `company_id` | UUID | 회사 ID |
| `store_id` | UUID | 스토어 ID (nullable) |
| `counterparty_id` | UUID | 거래처 ID (nullable) |
| `counterparty_cash_location_id` | UUID | 상대방 현금위치 (nullable) |
| `is_active` | BOOLEAN | 활성 여부 |
| `required_attachment` | BOOLEAN | 첨부파일 필수 여부 |

### 0.2 `data` JSONB 구조 (각 entry별 필드)

```jsonc
{
  "type": "debit" | "credit",           // 차변/대변
  "account_id": "uuid",                  // 계정 ID (FK → accounts)
  "account_name": "Cash",                // 계정 이름 (display)
  "account_code": "1000",                // ⭐ 계정 코드 (5000-9999 = expense)
  "category_tag": "cash" | "receivable" | "payable" | "other",

  // cash 관련
  "cash_location_id": "uuid" | null,     // 현금 위치 ID
  "cash_location_name": "sb",            // 현금 위치 이름

  // counterparty 관련 (receivable/payable일 때)
  "counterparty_id": "uuid" | null,      // 거래처 ID
  "counterparty_name": "diff",           // 거래처 이름
  "counterparty_cash_location_id": "uuid" | null,  // 상대방 현금위치

  // ⚠️ internal 거래처 확인용 (일부 템플릿에만 있음!)
  "linked_company_id": "uuid" | null     // internal 거래처면 존재
}
```

### 0.3 ⚠️ RPC 계획서 수정 필요 사항

#### 문제 1: `linked_company_id` 위치 불일치

**현재 계획서**:
```sql
-- entry에서만 확인
IF v_entry->>'linked_company_id' IS NOT NULL...
```

**실제 데이터**:
- 일부 템플릿: `linked_company_id`가 **entry 안에** 있음
- 일부 템플릿: **counterparties 테이블**에서 JOIN 필요

**수정된 로직**:
```sql
-- 1. entry에서 먼저 확인
v_is_internal := (v_entry->>'linked_company_id') IS NOT NULL
                 AND (v_entry->>'linked_company_id') != '';

-- 2. 없으면 counterparties 테이블에서 확인
IF NOT v_is_internal AND v_default_counterparty_id IS NOT NULL THEN
  SELECT c.linked_company_id IS NOT NULL INTO v_is_internal
  FROM counterparties c
  WHERE c.counterparty_id = v_default_counterparty_id;
END IF;
```

#### 문제 2: template-level vs entry-level counterparty

**실제 데이터 구조**:
- `transaction_templates.counterparty_id`: 템플릿 레벨 (외부)
- `data[].counterparty_id`: 엔트리 레벨 (JSONB 내부)

**두 곳 모두 확인 필요!**:
```sql
-- Priority: entry > template
v_default_counterparty_id := COALESCE(
  (v_entry->>'counterparty_id')::UUID,
  v_template.counterparty_id
);
```

#### 문제 3: `counterparty_cash_location_id` 위치

**실제 데이터**:
- `transaction_templates.counterparty_cash_location_id`: 템플릿 레벨
- `data[].counterparty_cash_location_id`: 엔트리 레벨

**수정된 로직**:
```sql
-- Priority: entry > template
v_default_counterparty_cash_location_id := COALESCE(
  (v_entry->>'counterparty_cash_location_id')::UUID,
  v_template.counterparty_cash_location_id
);
```

### 0.4 검증된 테이블들

| 테이블 | 컬럼 확인 | 상태 |
|--------|----------|------|
| `transaction_templates` | template_id, data, counterparty_id, counterparty_cash_location_id | ✅ 일치 |
| `accounts` | account_id, account_code, category_tag | ✅ 일치 |
| `counterparties` | counterparty_id, linked_company_id, is_internal | ✅ 일치 |
| `cash_locations` | cash_location_id, location_name | ✅ 일치 |
| `debts_receivable` | direction, category, issue_date, counterparty_id | ✅ 일치 |

### 0.5 ⭐ 핵심: 데이터 흐름 & JSONB 구조 매핑

#### 📊 전체 데이터 흐름
```
┌─────────────────────────────────────────────────────────────────────────┐
│ 1. TEMPLATE 생성 (TemplateLineFactory.createLine)                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│ Flutter: add_template_bottom_sheet.dart                                  │
│     ↓                                                                    │
│ TemplateLineFactory.createLines() → FLAT structure                       │
│     ↓                                                                    │
│ DB: transaction_templates.data (JSONB Array)                             │
│                                                                          │
│ ⚠️ 주의: linked_company_id는 생성 시 포함 안됨!                         │
│          edit_template에서만 추가됨 (기존 counterparty lookup)            │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ 2. TEMPLATE 사용 (TransactionLine.toRpc)                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│ Flutter: template_usage_bottom_sheet.dart                                │
│     ↓                                                                    │
│ TransactionLine.fromTemplate(templateData) → Entity                      │
│     ↓                                                                    │
│ TransactionLine.toRpc() → RPC Format (NESTED structure)                  │
│     ↓                                                                    │
│ RPC: insert_journal_with_everything_utc(p_lines: JSONB)                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

#### 📦 Template Data JSONB (FLAT - DB 저장용)
```jsonc
// transaction_templates.data 배열의 각 entry
{
  // 기본 필드
  "type": "debit" | "credit",
  "account_id": "uuid",
  "account_name": "Cash",
  "account_code": "1000",              // expense 판단용 (5000-9999)
  "category_tag": "cash" | "receivable" | "payable" | "other",
  "amount": "0",                        // template은 항상 "0"
  "debit": "0",
  "credit": "0",
  "description": "Debit entry - ...",

  // cash 관련 (FLAT)
  "cash_location_id": "uuid" | null,
  "cash_location_name": "sb" | null,

  // counterparty 관련 (FLAT)
  "counterparty_id": "uuid" | null,
  "counterparty_name": "diff" | null,
  "counterparty_cash_location_id": "uuid" | null,
  "counterparty_cash_location_name": "..." | null,

  // ⚠️ internal 거래처 (edit_template에서만 추가됨)
  "linked_company_id": "uuid" | null,
  "counterparty_store_id": "uuid" | null,
  "counterparty_store_name": "..." | null
}
```

#### 📦 RPC Lines JSONB (NESTED - RPC 호출용)
```jsonc
// insert_journal_with_everything_utc의 p_lines 배열의 각 entry
{
  // 기본 필드
  "account_id": "uuid",
  "description": "...",
  "debit": "50000",                     // 실제 금액 (STRING!)
  "credit": "0",                        // 실제 금액 (STRING!)

  // cash 관련 (NESTED object)
  "cash": {
    "cash_location_id": "uuid"
  },

  // debt 관련 (NESTED object) - receivable/payable일 때
  "debt": {
    "counterparty_id": "uuid",          // 필수!
    "direction": "receivable" | "payable",  // 필수!
    "category": "account" | "note" | "loan" | "other",  // 필수!
    "issue_date": "2025-01-01",         // 필수! (entry_date 사용)
    "due_date": "2025-02-01" | null,    // 선택
    "interest_rate": 0.0 | null,        // 선택
    "linkedCounterparty_store_id": "uuid" | null,  // internal일 때
    "linkedCounterparty_companyId": "uuid" | null  // RPC가 자동 추가
  },

  // fix_asset 관련 (NESTED object) - 고정자산일 때
  "fix_asset": {
    "asset_name": "...",
    "acquisition_date": "2025-01-01",
    "useful_life_years": 5,
    "salvage_value": 0
  }
}
```

#### 🔄 FLAT → NESTED 변환 (TransactionLine.toRpc)
```dart
// transaction_line_entity.dart 에서 수행
Map<String, dynamic> toRpc({
  required double amount,
  String? selectedMyCashLocationId,
  String? selectedCounterpartyId,
  required String entryDate,
}) {
  final rpcLine = {
    'account_id': accountId,
    'description': memo,
    'debit': type == 'debit' ? amount.toStringAsFixed(0) : '0',
    'credit': type == 'credit' ? amount.toStringAsFixed(0) : '0',
  };

  // FLAT → NESTED: cash
  if (categoryTag == 'cash') {
    final cashLocationId = selectedMyCashLocationId ?? cash?.cashLocationId;
    if (cashLocationId != null) {
      rpcLine['cash'] = {'cash_location_id': cashLocationId};
    }
  }

  // FLAT → NESTED: debt
  if (categoryTag == 'receivable' || categoryTag == 'payable') {
    rpcLine['debt'] = {
      'counterparty_id': selectedCounterpartyId ?? counterpartyId,
      'direction': categoryTag,
      'category': debt?.category ?? 'account',
      'issue_date': entryDate,
      // ...
    };
  }

  return rpcLine;
}
```

### 0.6 ⚠️ RPC 계획서 추가 수정 필요

#### 문제 4: `linked_company_id` 소스 차이

**Template 생성 시 (add_template_bottom_sheet)**:
- `account_selector_card.dart`에서 counterparty 선택 시 `linked_company_id` **전달됨**:
  ```dart
  // account_selector_card.dart:176-180
  widget.onCounterpartyDataChanged({
    'name': counterparty.name,
    'is_internal': counterparty.isInternal,
    'linked_company_id': counterparty.linkedCompanyId,  // ✅ 있음!
  });
  ```
- 하지만 `TemplateLineFactory.createLines()`에 **전달하지 않음**:
  ```dart
  // add_template_bottom_sheet.dart:232-256
  final data = TemplateLineFactory.createLines(
    // ... counterpartyId, counterpartyName만 전달
    // ❌ linked_company_id 파라미터 없음!
  );
  ```
- 결과: DB에 `linked_company_id` **저장 안 됨**

**Template 수정 시 (edit_template_bottom_sheet)**:
- counterparties 테이블에서 조회하여 추가
- `_loadMissingCounterpartyData()`로 `linked_company_id` 추가

**🔧 수정 방안 2가지**:

**방안 A: Flutter 수정 (권장)**
```dart
// TemplateLineFactory.createLine()에 파라미터 추가
static Map<String, dynamic> createLine({
  // ... existing params
  String? linkedCompanyId,  // NEW
}) {
  // payable/receivable 케이스에서:
  line['linked_company_id'] = linkedCompanyId;
}
```

**방안 B: RPC에서 해결 (현재 계획)**
```sql
-- counterparties 테이블에서 linked_company_id 조회
SELECT c.linked_company_id INTO v_linked_company_id
FROM counterparties c
WHERE c.counterparty_id = v_default_counterparty_id;

-- entry에 없어도 counterparties 테이블에서 확인!
v_is_internal_counterparty := v_linked_company_id IS NOT NULL;
```

**결론**: RPC에서는 **방안 B**로 처리하되, Flutter 코드 개선 시 **방안 A**도 적용 권장

### 0.8 ⭐ CRITICAL: Internal Counterparty 완전한 데이터 요구사항

#### 왜 중요한가?

Internal counterparty는 **같은 DB를 공유하는 두 회사** 간의 거래입니다.
데이터 무결성을 위해 **양쪽 회사에 동시에 거래를 생성**해야 합니다.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                 INTERNAL COUNTERPARTY 거래 데이터 흐름                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  [내 회사 - Company A]                    [상대방 회사 - Company B]          │
│  ─────────────────────                    ─────────────────────────          │
│                                                                              │
│  📝 내가 입력하는 거래:                   📝 자동 생성되는 Mirror 거래:       │
│  ├─ "돈을 보냈다" (Payable)              ├─ "돈을 받았다" (Receivable)        │
│  ├─ 금액: 50,000                         ├─ 금액: 50,000                      │
│  ├─ 내 계정: Notes Payable               ├─ 상대방 계정: Notes Receivable     │
│  ├─ 내 현금위치: 본사금고                ├─ 상대방 현금위치: ??? ← 필요!     │
│  │                                        │                                   │
│  └─ 상대방 정보:                          └─ 상대방 정보:                     │
│      ├─ counterparty_id                       ├─ counterparty_id (역방향)    │
│      ├─ linked_company_id (B)                 ├─ linked_company_id (A)       │
│      ├─ linked_company_store_id               ├─ linked_company_store_id     │
│      └─ counterparty_cash_location_id ───────▶└─ cash_location_id로 저장!   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Internal Counterparty 거래 시 필수 데이터

| 데이터 | 설명 | 출처 |
|--------|------|------|
| `counterparty_id` | 내 회사에서 본 상대방 | Template entry 또는 user 선택 |
| `linked_company_id` | 상대방 회사 UUID | `counterparties.linked_company_id` |
| `linked_company_store_id` | 상대방 가게 UUID | User 선택 (StoreSelector) |
| `counterparty_cash_location_id` | **상대방 가게의 현금위치** | User 선택 (CashLocationSelector) |

#### `create_mirror_journal_for_counterparty_utc` RPC 핵심 로직

```sql
-- 1. 내가 payable → 상대방은 receivable (반대로!)
IF _original_direction = 'payable' THEN
  _reverse_direction := 'receivable';
END IF;

-- 2. 상대방 입장에서 나를 가리키는 counterparty 찾기
SELECT c.counterparty_id INTO _mirror_counterparty_id
FROM counterparties c
WHERE c.company_id = _linked_company_id      -- 상대방 회사에서
  AND c.linked_company_id = p_company_id;    -- 나를 등록한 counterparty

-- 3. ⭐ Account Mapping에서 상대방이 사용할 계정 찾기
SELECT a.linked_account_id INTO _mirror_account_id
FROM account_mappings a
WHERE a.my_company_id = p_company_id
  AND a.counterparty_id = debt_counterparty_id
  AND a.my_account_id = _original_account_id;

-- 4. 상대방 회사에 Mirror 전표 생성
INSERT INTO journal_entries (company_id, store_id, ...)
VALUES (_linked_company_id, _linked_company_store_id, ...);

-- 5. Mirror Debt 생성 (반대 방향, 상대방 계정)
INSERT INTO debts_receivable (
  company_id, store_id, direction, account_id, ...
) VALUES (
  _linked_company_id,           -- 상대방 회사
  _linked_company_store_id,     -- 상대방 가게
  _reverse_direction,           -- 반대 방향!
  _mirror_account_id,           -- 상대방 계정 (account_mapping에서)
  ...
);

-- 6. Mirror Cash Line 생성 (상대방 현금위치!)
INSERT INTO journal_lines (
  cash_location_id, ...
) VALUES (
  p_if_cash_location_id,  -- ⭐ 이게 counterparty_cash_location_id!
  ...
);
```

#### Template Usage RPC에서 필요한 검증

```sql
-- Internal counterparty인 경우 필수 검증
IF v_is_internal_counterparty THEN
  -- 1. Account Mapping 존재 확인 (필수!)
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_company_id
      AND counterparty_id = v_counterparty_id
      AND my_account_id = v_debt_account_id
  ) THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'account_mapping_required',
      'message', 'Account mapping is required for internal counterparty'
    );
  END IF;

  -- 2. Counterparty Store 선택 확인
  IF p_selected_counterparty_store_id IS NULL THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'validation_error',
      'message', 'Counterparty store is required for internal transfers'
    );
  END IF;

  -- 3. Counterparty Cash Location 선택 확인
  IF p_selected_counterparty_cash_location_id IS NULL THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'validation_error',
      'message', 'Counterparty cash location is required for internal transfers'
    );
  END IF;
END IF;
```

### 0.9 `account_mappings` 테이블 구조

```sql
CREATE TABLE account_mappings (
  mapping_id UUID PRIMARY KEY,
  my_company_id UUID NOT NULL,        -- 내 회사
  my_account_id UUID NOT NULL,        -- 내가 사용하는 계정 (예: Notes Payable)
  counterparty_id UUID NOT NULL,      -- 상대방 거래처
  linked_account_id UUID NOT NULL,    -- 상대방이 사용할 계정 (예: Notes Receivable)
  direction TEXT NOT NULL,            -- 'payable' | 'receivable'
  created_by UUID,
  created_at TIMESTAMPTZ,
  is_deleted BOOLEAN DEFAULT FALSE
);
```

**예시 데이터**:
- 내가 Company A, 상대방이 Company B
- 내가 "Notes Payable"로 기록하면 → 상대방은 "Notes Receivable"로 기록

| my_company | my_account | counterparty | linked_account | direction |
|------------|------------|--------------|----------------|-----------|
| A | Notes Payable | B의 counterparty | Notes Receivable | payable |
| A | Notes Receivable | B의 counterparty | Notes Payable | receivable |

### 0.7 기존 RPC 파라미터 구조 (insert_journal_with_everything_utc)

```sql
-- 입력 파라미터
p_base_amount NUMERIC,           -- 거래 금액
p_company_id UUID,               -- 회사 ID
p_created_by UUID,               -- 생성자 ID
p_description TEXT,              -- 설명
p_entry_date_utc TIMESTAMPTZ,    -- 거래 날짜 (UTC)
p_lines JSONB,                   -- ⭐ 거래 라인 배열 (NESTED 구조)
p_counterparty_id TEXT,          -- 거래처 ID (nullable)
p_if_cash_location_id TEXT,      -- 상대방 현금 위치 ID (nullable)
p_store_id TEXT                  -- 스토어 ID (nullable)

-- 반환값
RETURNS UUID  -- 생성된 journal_id
```

---

## 1. 현재 아키텍처 문제점

### 1.1 현재 데이터 흐름
```
[Flutter App]
     │
     ├─1. Template 선택 (template_usage_bottom_sheet.dart)
     │
     ├─2. 클라이언트 분석 (template_analysis_result.dart)
     │   ├─ _needsCashLocationSelection() - expense+cash 체크
     │   ├─ _analyzeCounterpartyRequirements() - internal/external 체크
     │   └─ complexity 계산
     │
     ├─3. UI 렌더링 (selector 표시 여부 결정)
     │
     ├─4. 사용자 입력 + Validation (template_form_validator.dart)
     │
     ├─5. Transaction Line 변환 (transaction_line_entity.dart)
     │   └─ toRpc() - 사용자 선택 > 템플릿 기본값 우선순위
     │
     └─6. RPC 호출 (insert_journal_with_everything_utc)
```

### 1.2 문제점
| 문제 | 설명 | 영향 |
|------|------|------|
| **복잡한 클라이언트 로직** | 분석/validation이 Flutter에서 수행 | 유지보수 어려움, 버그 발생 가능 |
| **중복 로직** | Flutter와 DB 양쪽에서 validation | 불일치 가능성 |
| **비효율적 데이터 흐름** | Template 가져온 후 클라이언트에서 분석 | 불필요한 데이터 전송 |
| **account_code 의존성** | expense 판단을 위해 accounts 테이블 조회 필요 | 추가 쿼리 발생 |

---

## 2. 제안 아키텍처

### 2.1 새로운 데이터 흐름
```
[Flutter App]
     │
     ├─1. Template 선택
     │
     ├─2. RPC: get_template_for_usage(template_id)  ← NEW
     │   └─ Returns: 분석된 template + UI 설정
     │
     ├─3. UI 렌더링 (RPC 결과 기반)
     │
     ├─4. 사용자 입력
     │
     └─5. RPC: create_transaction_from_template()  ← NEW
         └─ 모든 validation + 생성을 DB에서 수행
```

### 2.2 새로운 RPC 목록

| RPC 이름 | 목적 | 호출 시점 |
|----------|------|----------|
| `get_template_for_usage` | Template 분석 + UI 설정 반환 | Modal 열릴 때 |
| `create_transaction_from_template` | Validation + Transaction 생성 | Submit 버튼 클릭 |

---

## 3. RPC 상세 설계

### 3.1 `get_template_for_usage` RPC

#### 3.1.1 Input Parameters
```sql
p_template_id UUID,           -- 템플릿 ID
p_company_id UUID,            -- 현재 회사 ID
p_store_id UUID DEFAULT NULL  -- 현재 스토어 ID (optional)
```

#### 3.1.2 Output Structure (JSON)
```json
{
  "template": {
    "template_id": "uuid",
    "name": "돈 보내기",
    "description": "외부 거래처에게 돈 보내기",
    "required_attachment": false,
    "data": [...],  // 원본 data 배열
    "tags": {...}   // 원본 tags
  },

  "analysis": {
    "complexity": "withCounterparty",  // simple | withCash | withCounterparty | complex
    "missing_items": ["counterparty"], // UI에서 표시할 selector 목록
    "is_ready": false,
    "completeness_score": 75
  },

  "ui_config": {
    "show_cash_location_selector": false,
    "show_counterparty_selector": true,
    "show_counterparty_store_selector": false,      // ⭐ NEW: internal일 때 true
    "show_counterparty_cash_location_selector": false,
    "counterparty_is_locked": false,  // internal이면 true
    "locked_counterparty_name": null  // internal일 때 표시할 이름
  },

  "defaults": {
    "cash_location_id": "uuid-or-null",
    "cash_location_name": "sb",
    "counterparty_id": "uuid-or-null",
    "counterparty_name": "diff",
    "counterparty_store_id": null,                  // ⭐ NEW
    "counterparty_store_name": null,                // ⭐ NEW
    "counterparty_cash_location_id": null,
    "is_internal_counterparty": false
  },

  "display_info": {
    "debit_category": "Receivable",
    "credit_category": "Cash",
    "transaction_type": "Receivable → Cash"
  }
}
```

#### 3.1.3 SQL 로직 (PostgreSQL Function)
```sql
CREATE OR REPLACE FUNCTION get_template_for_usage(
  p_template_id UUID,
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_template RECORD;
  v_data JSONB;
  v_tags JSONB;
  v_entry JSONB;

  -- Analysis variables
  v_has_expense_account BOOLEAN := FALSE;
  v_has_cash_account BOOLEAN := FALSE;
  v_has_receivable_payable BOOLEAN := FALSE;
  v_is_internal_counterparty BOOLEAN := FALSE;
  v_has_counterparty BOOLEAN := FALSE;
  v_has_counterparty_store BOOLEAN := FALSE;              -- ⭐ NEW
  v_has_counterparty_cash_location BOOLEAN := FALSE;

  -- UI config
  v_show_cash_location BOOLEAN := FALSE;
  v_show_counterparty BOOLEAN := FALSE;
  v_show_counterparty_store BOOLEAN := FALSE;             -- ⭐ NEW
  v_show_counterparty_cash_location BOOLEAN := FALSE;
  v_counterparty_locked BOOLEAN := FALSE;

  -- Defaults
  v_default_cash_location_id UUID;
  v_default_cash_location_name TEXT;
  v_default_counterparty_id UUID;
  v_default_counterparty_name TEXT;
  v_default_counterparty_store_id UUID;                   -- ⭐ NEW
  v_default_counterparty_store_name TEXT;                 -- ⭐ NEW
  v_default_counterparty_cash_location_id UUID;

  -- Display
  v_debit_category TEXT;
  v_credit_category TEXT;

  -- Result
  v_missing_items TEXT[] := ARRAY[]::TEXT[];
  v_complexity TEXT := 'simple';
BEGIN
  -- 1. Get template
  SELECT * INTO v_template
  FROM transaction_templates
  WHERE template_id = p_template_id
    AND company_id = p_company_id
    AND is_active = TRUE;

  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Template not found');
  END IF;

  v_data := v_template.data;
  v_tags := COALESCE(v_template.tags, '{}'::JSONB);

  -- 2. Analyze each entry in data array
  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    -- Check category_tag
    CASE v_entry->>'category_tag'
      WHEN 'cash' THEN
        v_has_cash_account := TRUE;
        -- Get default cash location
        IF v_default_cash_location_id IS NULL AND v_entry->>'cash_location_id' IS NOT NULL THEN
          v_default_cash_location_id := (v_entry->>'cash_location_id')::UUID;
          v_default_cash_location_name := v_entry->>'cash_location_name';
        END IF;

      WHEN 'receivable', 'payable' THEN
        v_has_receivable_payable := TRUE;

        -- ✅ FIXED: Check counterparty (entry > template level priority)
        IF v_default_counterparty_id IS NULL THEN
          v_default_counterparty_id := COALESCE(
            NULLIF(v_entry->>'counterparty_id', '')::UUID,
            v_template.counterparty_id  -- fallback to template level
          );
          v_default_counterparty_name := v_entry->>'counterparty_name';
          IF v_default_counterparty_id IS NOT NULL THEN
            v_has_counterparty := TRUE;
          END IF;
        END IF;

        -- ✅ FIXED: Check if internal (entry level OR counterparties table)
        -- Step 1: Check entry-level linked_company_id
        IF v_entry->>'linked_company_id' IS NOT NULL AND v_entry->>'linked_company_id' != '' THEN
          v_is_internal_counterparty := TRUE;
        END IF;

        -- Step 2: If not found in entry, check counterparties table
        IF NOT v_is_internal_counterparty AND v_default_counterparty_id IS NOT NULL THEN
          SELECT (c.linked_company_id IS NOT NULL) INTO v_is_internal_counterparty
          FROM counterparties c
          WHERE c.counterparty_id = v_default_counterparty_id;
        END IF;

        -- ⭐ NEW: Check counterparty_store (entry level)
        IF v_default_counterparty_store_id IS NULL THEN
          v_default_counterparty_store_id := NULLIF(v_entry->>'counterparty_store_id', '')::UUID;
          v_default_counterparty_store_name := v_entry->>'counterparty_store_name';
          IF v_default_counterparty_store_id IS NOT NULL THEN
            v_has_counterparty_store := TRUE;
          END IF;
        END IF;

        -- ✅ FIXED: Check counterparty_cash_location (entry > template level priority)
        IF v_default_counterparty_cash_location_id IS NULL THEN
          v_default_counterparty_cash_location_id := COALESCE(
            NULLIF(v_entry->>'counterparty_cash_location_id', '')::UUID,
            v_template.counterparty_cash_location_id  -- fallback to template level
          );
          IF v_default_counterparty_cash_location_id IS NOT NULL THEN
            v_has_counterparty_cash_location := TRUE;
          END IF;
        END IF;

        -- Set display category
        IF v_entry->>'type' = 'debit' THEN
          v_debit_category := INITCAP(v_entry->>'category_tag');
        ELSE
          v_credit_category := INITCAP(v_entry->>'category_tag');
        END IF;
    END CASE;

    -- Check account_code for expense (5000-9999)
    IF v_entry->>'account_code' IS NOT NULL THEN
      DECLARE
        v_code INT;
      BEGIN
        v_code := (v_entry->>'account_code')::INT;
        IF v_code >= 5000 AND v_code <= 9999 THEN
          v_has_expense_account := TRUE;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        -- Ignore non-numeric codes
      END;
    END IF;

    -- Set display categories
    IF v_entry->>'type' = 'debit' AND v_debit_category IS NULL THEN
      v_debit_category := COALESCE(INITCAP(v_entry->>'category_tag'), 'Other');
    ELSIF v_entry->>'type' = 'credit' AND v_credit_category IS NULL THEN
      v_credit_category := COALESCE(INITCAP(v_entry->>'category_tag'), 'Other');
    END IF;
  END LOOP;

  -- 3. Determine UI configuration

  -- Cash location selector: expense + cash → always show
  IF v_has_expense_account AND v_has_cash_account THEN
    v_show_cash_location := TRUE;
    v_missing_items := array_append(v_missing_items, 'cash_location');
  -- Cash account without preset location
  ELSIF v_has_cash_account AND v_default_cash_location_id IS NULL THEN
    v_show_cash_location := TRUE;
    v_missing_items := array_append(v_missing_items, 'cash_location');
  END IF;

  -- Counterparty selector
  IF v_has_receivable_payable THEN
    IF v_is_internal_counterparty THEN
      -- Internal: locked, may need store and cash location
      v_counterparty_locked := TRUE;

      -- ⭐ Check counterparty store
      IF NOT v_has_counterparty_store THEN
        v_show_counterparty_store := TRUE;
        v_missing_items := array_append(v_missing_items, 'counterparty_store');
      END IF;

      -- ⭐ Check counterparty cash location
      IF NOT v_has_counterparty_cash_location THEN
        v_show_counterparty_cash_location := TRUE;
        v_missing_items := array_append(v_missing_items, 'counterparty_cash_location');
      END IF;
    ELSE
      -- External: always show selector (user can change)
      v_show_counterparty := TRUE;
      v_missing_items := array_append(v_missing_items, 'counterparty');
    END IF;
  END IF;

  -- 4. Determine complexity
  IF array_length(v_missing_items, 1) IS NULL OR array_length(v_missing_items, 1) = 0 THEN
    v_complexity := 'simple';
  ELSIF 'counterparty' = ANY(v_missing_items) OR 'counterparty_cash_location' = ANY(v_missing_items) THEN
    v_complexity := 'withCounterparty';
  ELSIF 'cash_location' = ANY(v_missing_items) THEN
    v_complexity := 'withCash';
  ELSE
    v_complexity := 'complex';
  END IF;

  -- 5. Build and return result
  RETURN json_build_object(
    'template', json_build_object(
      'template_id', v_template.template_id,
      'name', v_template.name,
      'description', v_template.description,
      'required_attachment', COALESCE(v_template.required_attachment, FALSE),
      'data', v_data,
      'tags', v_tags
    ),
    'analysis', json_build_object(
      'complexity', v_complexity,
      'missing_items', v_missing_items,
      'is_ready', array_length(v_missing_items, 1) IS NULL OR array_length(v_missing_items, 1) = 0,
      'completeness_score', CASE
        WHEN array_length(v_missing_items, 1) IS NULL THEN 100
        ELSE GREATEST(0, 100 - (array_length(v_missing_items, 1) * 25))
      END
    ),
    'ui_config', json_build_object(
      'show_cash_location_selector', v_show_cash_location,
      'show_counterparty_selector', v_show_counterparty,
      'show_counterparty_store_selector', v_show_counterparty_store,  -- ⭐ NEW
      'show_counterparty_cash_location_selector', v_show_counterparty_cash_location,
      'counterparty_is_locked', v_counterparty_locked,
      'locked_counterparty_name', CASE WHEN v_counterparty_locked THEN v_default_counterparty_name ELSE NULL END
    ),
    'defaults', json_build_object(
      'cash_location_id', v_default_cash_location_id,
      'cash_location_name', v_default_cash_location_name,
      'counterparty_id', v_default_counterparty_id,
      'counterparty_name', v_default_counterparty_name,
      'counterparty_store_id', v_default_counterparty_store_id,        -- ⭐ NEW
      'counterparty_store_name', v_default_counterparty_store_name,    -- ⭐ NEW
      'counterparty_cash_location_id', v_default_counterparty_cash_location_id,
      'is_internal_counterparty', v_is_internal_counterparty
    ),
    'display_info', json_build_object(
      'debit_category', COALESCE(v_debit_category, 'Other'),
      'credit_category', COALESCE(v_credit_category, 'Other'),
      'transaction_type', COALESCE(v_debit_category, 'Other') || ' → ' || COALESCE(v_credit_category, 'Other')
    )
  );
END;
$$;
```

---

### 3.2 `create_transaction_from_template` RPC

#### 3.2.1 Input Parameters
```sql
p_template_id UUID,                        -- 템플릿 ID
p_amount NUMERIC,                          -- 거래 금액
p_company_id UUID,                         -- 회사 ID
p_user_id UUID,                            -- 사용자 ID
p_store_id UUID DEFAULT NULL,              -- 스토어 ID
p_description TEXT DEFAULT NULL,           -- 메모
p_selected_cash_location_id UUID DEFAULT NULL,      -- 사용자 선택 cash location
p_selected_counterparty_id UUID DEFAULT NULL,       -- 사용자 선택 counterparty
p_selected_counterparty_store_id UUID DEFAULT NULL, -- ⭐ NEW: 상대방 가게 ID (internal용)
p_selected_counterparty_cash_location_id UUID DEFAULT NULL,  -- 사용자 선택 counterparty cash location
p_entry_date DATE DEFAULT CURRENT_DATE     -- 거래일
```

#### 3.2.2 Output Structure (JSON)
```json
{
  "success": true,
  "journal_id": "uuid",
  "message": "Transaction created successfully"
}
```

또는 에러 시:
```json
{
  "success": false,
  "error": "validation_error",
  "message": "Amount must be greater than 0",
  "field": "amount"
}
```

#### 3.2.3 SQL 로직 (PostgreSQL Function)
```sql
CREATE OR REPLACE FUNCTION create_transaction_from_template(
  p_template_id UUID,
  p_amount NUMERIC,
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_selected_cash_location_id UUID DEFAULT NULL,
  p_selected_counterparty_id UUID DEFAULT NULL,
  p_selected_counterparty_store_id UUID DEFAULT NULL,  -- ⭐ NEW: internal용
  p_selected_counterparty_cash_location_id UUID DEFAULT NULL,
  p_entry_date DATE DEFAULT CURRENT_DATE
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_template RECORD;
  v_data JSONB;
  v_entry JSONB;
  v_lines JSONB := '[]'::JSONB;
  v_line JSONB;

  -- Resolved values (user selection > template default)
  v_cash_location_id UUID;
  v_counterparty_id UUID;
  v_counterparty_store_id UUID;           -- ⭐ NEW
  v_counterparty_cash_location_id UUID;
  v_is_internal BOOLEAN := FALSE;
  v_linked_company_id UUID;               -- ⭐ NEW: for internal check
  v_debt_account_id UUID;                 -- ⭐ NEW: for account_mapping check

  -- Result
  v_journal_id UUID;
  v_entry_date_str TEXT;
BEGIN
  -- ═══════════════════════════════════════════════════════
  -- 1. VALIDATION
  -- ═══════════════════════════════════════════════════════

  -- Amount validation
  IF p_amount IS NULL OR p_amount <= 0 THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'validation_error',
      'message', 'Amount must be greater than 0',
      'field', 'amount'
    );
  END IF;

  -- Get template
  SELECT * INTO v_template
  FROM transaction_templates
  WHERE template_id = p_template_id
    AND company_id = p_company_id
    AND is_active = TRUE;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'not_found',
      'message', 'Template not found or inactive'
    );
  END IF;

  v_data := v_template.data;
  v_entry_date_str := TO_CHAR(p_entry_date, 'YYYY-MM-DD');

  -- ═══════════════════════════════════════════════════════
  -- 2. RESOLVE VALUES (User Selection > Template Default)
  -- ═══════════════════════════════════════════════════════

  -- Extract defaults from template data
  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    -- Cash location
    IF v_entry->>'category_tag' = 'cash' AND v_cash_location_id IS NULL THEN
      v_cash_location_id := NULLIF(v_entry->>'cash_location_id', '')::UUID;
    END IF;

    -- Counterparty (receivable/payable)
    IF v_entry->>'category_tag' IN ('receivable', 'payable') THEN
      -- Save debt account_id for account_mapping check
      IF v_debt_account_id IS NULL THEN
        v_debt_account_id := NULLIF(v_entry->>'account_id', '')::UUID;
      END IF;

      IF v_counterparty_id IS NULL THEN
        v_counterparty_id := NULLIF(v_entry->>'counterparty_id', '')::UUID;
      END IF;
      IF v_counterparty_store_id IS NULL THEN
        v_counterparty_store_id := NULLIF(v_entry->>'counterparty_store_id', '')::UUID;
      END IF;
      IF v_counterparty_cash_location_id IS NULL THEN
        v_counterparty_cash_location_id := NULLIF(v_entry->>'counterparty_cash_location_id', '')::UUID;
      END IF;
      -- Check if internal from entry
      IF v_entry->>'linked_company_id' IS NOT NULL AND v_entry->>'linked_company_id' != '' THEN
        v_is_internal := TRUE;
        v_linked_company_id := (v_entry->>'linked_company_id')::UUID;
      END IF;
    END IF;
  END LOOP;

  -- ⭐ Check internal from counterparties table (if not found in entry)
  IF NOT v_is_internal AND v_counterparty_id IS NOT NULL THEN
    SELECT c.linked_company_id INTO v_linked_company_id
    FROM counterparties c
    WHERE c.counterparty_id = v_counterparty_id
      AND c.is_deleted = FALSE;

    IF v_linked_company_id IS NOT NULL THEN
      v_is_internal := TRUE;
    END IF;
  END IF;

  -- Apply user selections (priority: user > template)
  IF p_selected_cash_location_id IS NOT NULL THEN
    v_cash_location_id := p_selected_cash_location_id;
  END IF;

  IF p_selected_counterparty_id IS NOT NULL THEN
    v_counterparty_id := p_selected_counterparty_id;
    -- ⭐ Re-check internal for user-selected counterparty
    SELECT c.linked_company_id INTO v_linked_company_id
    FROM counterparties c
    WHERE c.counterparty_id = p_selected_counterparty_id
      AND c.is_deleted = FALSE;
    v_is_internal := (v_linked_company_id IS NOT NULL);
  END IF;

  IF p_selected_counterparty_store_id IS NOT NULL THEN
    v_counterparty_store_id := p_selected_counterparty_store_id;
  END IF;

  IF p_selected_counterparty_cash_location_id IS NOT NULL THEN
    v_counterparty_cash_location_id := p_selected_counterparty_cash_location_id;
  END IF;

  -- ═══════════════════════════════════════════════════════
  -- 3. VALIDATION - Required fields based on template type
  -- ═══════════════════════════════════════════════════════

  -- Check cash location for cash accounts (if expense + cash, must have location)
  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    IF v_entry->>'category_tag' = 'cash' AND v_cash_location_id IS NULL THEN
      -- Check if this is expense + cash (requires selection)
      DECLARE
        v_has_expense BOOLEAN := FALSE;
        v_check_entry JSONB;
        v_code INT;
      BEGIN
        FOR v_check_entry IN SELECT * FROM jsonb_array_elements(v_data)
        LOOP
          IF v_check_entry->>'account_code' IS NOT NULL THEN
            BEGIN
              v_code := (v_check_entry->>'account_code')::INT;
              IF v_code >= 5000 AND v_code <= 9999 THEN
                v_has_expense := TRUE;
                EXIT;
              END IF;
            EXCEPTION WHEN OTHERS THEN
              NULL;
            END;
          END IF;
        END LOOP;

        IF v_has_expense THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'validation_error',
            'message', 'Cash location is required for expense transactions',
            'field', 'cash_location'
          );
        END IF;
      END;
    END IF;

    -- Check counterparty for receivable/payable (external only)
    IF v_entry->>'category_tag' IN ('receivable', 'payable') THEN
      IF NOT v_is_internal AND v_counterparty_id IS NULL THEN
        RETURN json_build_object(
          'success', FALSE,
          'error', 'validation_error',
          'message', 'Counterparty is required',
          'field', 'counterparty'
        );
      END IF;

      -- ⭐ Internal counterparty: Additional validations
      IF v_is_internal THEN
        -- 1. Check counterparty_store_id
        IF v_counterparty_store_id IS NULL THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'validation_error',
            'message', 'Counterparty store is required for internal transfers',
            'field', 'counterparty_store'
          );
        END IF;

        -- 2. Check counterparty_cash_location_id
        IF v_counterparty_cash_location_id IS NULL THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'validation_error',
            'message', 'Counterparty cash location is required for internal transfers',
            'field', 'counterparty_cash_location'
          );
        END IF;

        -- 3. ⭐ Check account_mapping exists (CRITICAL for mirror journal!)
        IF NOT EXISTS (
          SELECT 1 FROM account_mappings
          WHERE my_company_id = p_company_id
            AND counterparty_id = v_counterparty_id
            AND my_account_id = v_debt_account_id
            AND is_deleted = FALSE
        ) THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'account_mapping_required',
            'message', 'Account mapping is required for internal counterparty. ' ||
                       'Please set up account mapping in Counter Party > Account Settings.',
            'field', 'account_mapping'
          );
        END IF;
      END IF;
    END IF;
  END LOOP;

  -- ═══════════════════════════════════════════════════════
  -- 4. BUILD TRANSACTION LINES
  -- ═══════════════════════════════════════════════════════

  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    -- Base line structure
    v_line := jsonb_build_object(
      'account_id', v_entry->>'account_id',
      'description', COALESCE(p_description, v_entry->>'description')
    );

    -- Set debit/credit based on type (as STRING - RPC requirement!)
    IF v_entry->>'type' = 'debit' THEN
      v_line := v_line || jsonb_build_object(
        'debit', p_amount::TEXT,
        'credit', '0'
      );
    ELSE
      v_line := v_line || jsonb_build_object(
        'debit', '0',
        'credit', p_amount::TEXT
      );
    END IF;

    -- Add cash object for cash accounts
    IF v_entry->>'category_tag' = 'cash' AND v_cash_location_id IS NOT NULL THEN
      v_line := v_line || jsonb_build_object(
        'cash', jsonb_build_object('cash_location_id', v_cash_location_id)
      );
    END IF;

    -- Add debt object for receivable/payable
    IF v_entry->>'category_tag' IN ('receivable', 'payable') AND v_counterparty_id IS NOT NULL THEN
      -- ⭐ Build debt object with internal counterparty fields if applicable
      IF v_is_internal THEN
        v_line := v_line || jsonb_build_object(
          'debt', jsonb_build_object(
            'counterparty_id', v_counterparty_id,
            'direction', v_entry->>'category_tag',
            'category', COALESCE(v_entry->'debt'->>'category', 'account'),
            'issue_date', v_entry_date_str,
            'linkedCounterparty_store_id', v_counterparty_store_id,  -- ⭐ Internal
            'linkedCounterparty_companyId', v_linked_company_id      -- ⭐ Internal
          )
        );
      ELSE
        v_line := v_line || jsonb_build_object(
          'debt', jsonb_build_object(
            'counterparty_id', v_counterparty_id,
            'direction', v_entry->>'category_tag',
            'category', COALESCE(v_entry->'debt'->>'category', 'account'),
            'issue_date', v_entry_date_str
          )
        );
      END IF;
    END IF;

    v_lines := v_lines || v_line;
  END LOOP;

  -- ═══════════════════════════════════════════════════════
  -- 5. CALL insert_journal_with_everything_utc
  -- ═══════════════════════════════════════════════════════

  v_journal_id := insert_journal_with_everything_utc(
    p_base_amount := p_amount,
    p_company_id := p_company_id,
    p_created_by := p_user_id,
    p_description := p_description,
    p_entry_date_utc := v_entry_date_str,
    p_lines := v_lines,
    p_counterparty_id := v_counterparty_id,
    p_if_cash_location_id := v_counterparty_cash_location_id,
    p_store_id := p_store_id
  );

  -- ═══════════════════════════════════════════════════════
  -- 6. RETURN SUCCESS
  -- ═══════════════════════════════════════════════════════

  RETURN json_build_object(
    'success', TRUE,
    'journal_id', v_journal_id,
    'message', 'Transaction created successfully'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', FALSE,
    'error', 'database_error',
    'message', SQLERRM
  );
END;
$$;
```

---

## 4. Flutter 코드 변경 사항

### 4.1 삭제할 파일/코드
| 파일 | 삭제 항목 | 이유 |
|------|----------|------|
| `template_analysis_result.dart` | 전체 로직 | RPC로 이동 |
| `template_form_validator.dart` | 대부분의 validation | RPC에서 수행 |
| `transaction_line_entity.dart` | `toRpc()` 메서드 | RPC에서 line 빌드 |

### 4.2 수정할 파일

#### `template_usage_bottom_sheet.dart`
```dart
// BEFORE (현재)
@override
void initState() {
  super.initState();
  _analysis = TemplateAnalysisResult.analyze(widget.template);  // 클라이언트 분석
  // ... UI 설정
}

// AFTER (리팩토링 후)
@override
void initState() {
  super.initState();
  _loadTemplateAnalysis();  // RPC 호출
}

Future<void> _loadTemplateAnalysis() async {
  final result = await ref.read(supabaseServiceProvider).client.rpc(
    'get_template_for_usage',
    params: {
      'p_template_id': widget.templateId,
      'p_company_id': companyId,
      'p_store_id': storeId,
    },
  );

  setState(() {
    _templateData = result['template'];
    _uiConfig = result['ui_config'];
    _defaults = result['defaults'];
    _displayInfo = result['display_info'];
    _isLoading = false;
  });
}
```

#### Transaction 생성
```dart
// BEFORE (현재)
Future<String> _createTransactionFromTemplate(double amount) async {
  final params = CreateTransactionFromTemplateParams(...);
  final useCase = ref.read(createTransactionFromTemplateUseCaseProvider);
  return await useCase.execute(params);  // 복잡한 변환 로직
}

// AFTER (리팩토링 후)
Future<Map<String, dynamic>> _createTransactionFromTemplate(double amount) async {
  final result = await ref.read(supabaseServiceProvider).client.rpc(
    'create_transaction_from_template',
    params: {
      'p_template_id': widget.templateId,
      'p_amount': amount,
      'p_company_id': companyId,
      'p_user_id': userId,
      'p_store_id': storeId,
      'p_description': _descriptionController.text,
      'p_selected_cash_location_id': _selectedMyCashLocationId,
      'p_selected_counterparty_id': _selectedCounterpartyId,
      'p_selected_counterparty_store_id': _selectedCounterpartyStoreId,  // ⭐ NEW
      'p_selected_counterparty_cash_location_id': _selectedCounterpartyCashLocationId,
      'p_entry_date': DateTime.now().toIso8601String().split('T')[0],
    },
  );

  if (result['success'] == true) {
    return result;
  } else {
    throw Exception(result['message']);
  }
}
```

### 4.3 새로운 DTO/Model

```dart
/// RPC 응답을 위한 DTO
class TemplateUsageResponse {
  final TemplateData template;
  final TemplateAnalysis analysis;
  final TemplateUiConfig uiConfig;
  final TemplateDefaults defaults;
  final TemplateDisplayInfo displayInfo;

  factory TemplateUsageResponse.fromJson(Map<String, dynamic> json) {
    return TemplateUsageResponse(
      template: TemplateData.fromJson(json['template']),
      analysis: TemplateAnalysis.fromJson(json['analysis']),
      uiConfig: TemplateUiConfig.fromJson(json['ui_config']),
      defaults: TemplateDefaults.fromJson(json['defaults']),
      displayInfo: TemplateDisplayInfo.fromJson(json['display_info']),
    );
  }
}

class TemplateUiConfig {
  final bool showCashLocationSelector;
  final bool showCounterpartySelector;
  final bool showCounterpartyCashLocationSelector;
  final bool counterpartyIsLocked;
  final String? lockedCounterpartyName;

  // fromJson...
}

class TemplateDefaults {
  final String? cashLocationId;
  final String? cashLocationName;
  final String? counterpartyId;
  final String? counterpartyName;
  final String? counterpartyCashLocationId;
  final bool isInternalCounterparty;

  // fromJson...
}
```

---

## 5. 마이그레이션 계획

### Phase 1: RPC 생성 (DB)
1. `get_template_for_usage` RPC 생성
2. `create_transaction_from_template` RPC 생성
3. 테스트 쿼리로 검증

### Phase 2: Flutter DTO 추가
1. `TemplateUsageResponse` DTO 생성
2. `TemplateUiConfig`, `TemplateDefaults` 등 모델 생성

### Phase 3: UI 코드 수정
1. `template_usage_bottom_sheet.dart` 수정
   - RPC 호출로 변경
   - UI 렌더링 로직 단순화
2. `_buildDynamicFields()` 수정
   - `_uiConfig` 기반으로 selector 표시

### Phase 4: 레거시 코드 정리
1. `template_analysis_result.dart` - 미사용 코드 제거 또는 deprecated
2. `template_form_validator.dart` - 클라이언트 validation 최소화
3. `transaction_line_entity.dart` - `toRpc()` 제거

### Phase 5: 테스트 및 검증
1. 모든 템플릿 유형 테스트
   - Simple (amount only)
   - With Cash (expense + cash)
   - With Counterparty (external)
   - With Internal Counterparty (locked)
2. Edge cases 테스트
3. 성능 비교

---

## 6. 예상 효과

| 지표 | Before | After | 개선 |
|------|--------|-------|------|
| 클라이언트 로직 라인 수 | ~500 lines | ~100 lines | **80% 감소** |
| DB 호출 횟수 | 2-3 calls | 1 call | **66% 감소** |
| Validation 위치 | Client + Server | Server only | **일원화** |
| 유지보수성 | 분산된 로직 | 중앙화된 RPC | **향상** |
| 버그 가능성 | Client/Server 불일치 | 단일 소스 | **감소** |

---

## 7. 추가 고려사항

### 7.1 Attachment 처리
- 현재: Transaction 생성 후 별도 Storage 업로드
- 제안: 그대로 유지 (Storage 업로드는 클라이언트에서 수행이 적절)

### 7.2 에러 처리
- RPC에서 상세한 에러 메시지 반환
- Flutter에서 에러 타입별 UI 처리

### 7.3 캐싱
- `get_template_for_usage` 결과는 Modal 열릴 때마다 호출 (캐싱 불필요)
- 템플릿 수정 시 자동으로 최신 분석 결과 반영

### 7.4 하위 호환성
- 기존 `insert_journal_with_everything_utc` RPC는 그대로 유지
- 새 RPC는 내부적으로 기존 RPC 호출

---

## 8. 테스트 시나리오

### 8.1 `get_template_for_usage` 테스트
```sql
-- Test 1: Expense + Cash template
SELECT get_template_for_usage(
  '572364cd-45f3-4004-abcc-5321bed254a6',  -- cash expenses
  'company-id',
  'store-id'
);
-- Expected: show_cash_location_selector = true

-- Test 2: External counterparty template
SELECT get_template_for_usage(
  'ddfc6507-642c-4590-a24d-d5ac26cce471',  -- 돈 보내기
  'company-id',
  'store-id'
);
-- Expected: show_counterparty_selector = true, counterparty_is_locked = false

-- Test 3: Internal counterparty template
SELECT get_template_for_usage(
  'internal-template-id',
  'company-id',
  'store-id'
);
-- Expected: counterparty_is_locked = true
```

### 8.2 `create_transaction_from_template` 테스트
```sql
-- Test 1: Valid transaction
SELECT create_transaction_from_template(
  p_template_id := '572364cd-45f3-4004-abcc-5321bed254a6',
  p_amount := 50000,
  p_company_id := 'company-id',
  p_user_id := 'user-id',
  p_selected_cash_location_id := 'cash-location-id'
);
-- Expected: success = true, journal_id = 'uuid'

-- Test 2: Missing required field
SELECT create_transaction_from_template(
  p_template_id := '572364cd-45f3-4004-abcc-5321bed254a6',
  p_amount := 50000,
  p_company_id := 'company-id',
  p_user_id := 'user-id'
  -- Missing cash_location_id for expense template
);
-- Expected: success = false, error = 'validation_error'

-- Test 3: Invalid amount
SELECT create_transaction_from_template(
  p_template_id := '572364cd-45f3-4004-abcc-5321bed254a6',
  p_amount := 0,
  p_company_id := 'company-id',
  p_user_id := 'user-id'
);
-- Expected: success = false, message = 'Amount must be greater than 0'
```

---

## 9. 구현 체크리스트

### DB (Supabase)
- [ ] `get_template_for_usage` RPC 생성
- [ ] `create_transaction_from_template` RPC 생성
- [ ] RPC 테스트 완료
- [ ] 권한 설정 (SECURITY DEFINER)

### Flutter
- [ ] `TemplateUsageResponse` DTO 생성
- [ ] `TemplateUiConfig` 모델 생성
- [ ] `TemplateDefaults` 모델 생성
- [ ] `template_usage_bottom_sheet.dart` 수정
- [ ] Provider 추가 (RPC 호출용)
- [ ] 에러 처리 구현
- [ ] UI 테스트

### 정리
- [ ] `template_analysis_result.dart` 정리/삭제
- [ ] `template_form_validator.dart` 정리
- [ ] `transaction_line_entity.dart` 의 `toRpc()` 정리
- [ ] 미사용 import 정리

---

## 10. 베스트 프랙티스 검증 (Critical Review)

> **검증일**: 2025-12-19
> **검증 방법**: 업계 표준, Supabase 공식 문서, Flutter 커뮤니티 베스트 프랙티스 분석

### 10.1 이 접근법이 올바른 이유

| 검증 항목 | 결과 | 근거 |
|----------|------|------|
| **RPC 사용 여부** | ✅ 적절 | Supabase 공식 문서: "복잡한 비즈니스 로직은 RPC로 처리 권장" |
| **서버 사이드 검증** | ✅ 필수 | OWASP: 클라이언트 검증만으로는 보안 취약, 서버 검증 필수 |
| **Single RPC 호출** | ✅ 효율적 | N+1 문제 방지, latency 감소 |
| **Clean Architecture 호환** | ✅ 유지됨 | Repository 패턴 그대로, RPC는 Data Source 구현의 일부 |

### 10.2 개선 권장사항 (수정 필요)

#### ⚠️ 클라이언트 검증 완전 제거는 부적절

현재 계획:
```
| `template_form_validator.dart` | 대부분의 validation | RPC에서 수행 |
```

**권장 수정**:
```dart
// 클라이언트에서 유지해야 할 검증 (UX 피드백용)
TemplateFormValidator.validateAmountField(amountText);  // ✅ 유지

// RPC에서만 수행할 검증 (최종 검증)
create_transaction_from_template(...);  // ✅ 서버 검증
```

**이유**:
- 실시간 버튼 활성화/비활성화는 클라이언트 검증 필요
- 네트워크 없이도 기본 유효성 검사 가능해야 함
- 서버는 "최종 검증"으로 이중 안전장치 역할

#### 📋 수정된 Flutter 코드 변경 사항

| 파일 | 삭제 항목 | 유지 항목 |
|------|----------|----------|
| `template_analysis_result.dart` | 전체 분석 로직 | (삭제 가능) |
| `template_form_validator.dart` | complexity 기반 검증 | `validateAmountField()` 유지 |
| `transaction_line_entity.dart` | `toRpc()` 메서드 | Entity 구조 유지 |

### 10.3 업계 표준과의 비교

#### Flutter + Supabase 프로덕션 패턴
```
┌─────────────────────────────────────────────────────────────┐
│                    Production Best Practice                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  [Flutter Client]                                            │
│       │                                                      │
│       ├── 1. 기본 입력 검증 (empty, format) ← 유지          │
│       │                                                      │
│       ├── 2. RPC 호출 (단일 요청)                            │
│       │       └── 복잡한 분석/검증은 서버에서               │
│       │                                                      │
│       └── 3. 결과 처리 (성공/에러)                          │
│                                                              │
│  [Supabase Server]                                           │
│       │                                                      │
│       ├── 비즈니스 로직 검증                                 │
│       ├── 데이터 무결성 검증                                 │
│       └── Transaction 실행 (atomic)                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 10.4 최종 결론

| 항목 | 평가 |
|------|------|
| **전체 접근법** | ✅ **올바름** - 업계 표준 준수 |
| **RPC 2개 분리** | ✅ **좋음** - 단일 책임 원칙 |
| **서버 검증** | ✅ **필수** - 보안 표준 |
| **클라이언트 검증 제거** | ⚠️ **수정 필요** - 기본 검증은 유지 |

### 10.5 참고 자료

- [Supabase RPC Best Practices](https://supabase.com/docs/guides/database/functions)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [OWASP Input Validation](https://owasp.org/www-community/Input_Validation_Cheat_Sheet)

---

**문서 끝**
