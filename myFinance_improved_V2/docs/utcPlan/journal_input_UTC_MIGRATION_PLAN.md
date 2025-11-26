# Journal Input Feature - UTC Migration Plan

## 문서 정보
- **작성일**: 2025-11-25
- **대상 폴더**: `/lib/features/journal_input`
- **목적**: timestamp → timestamptz 마이그레이션
- **전략**: 새 컬럼 (`_utc` 접미사) 추가, 기존 배포 앱 영향 없이 점진적 전환

---

## 📊 Executive Summary

### 발견된 데이터베이스 의존성

#### 1. RPC 함수 (3개)
- `get_cash_locations`
- `get_exchange_rate_v2`
- `insert_journal_with_everything`

#### 2. 직접 테이블 쿼리 (4개)
- `accounts`
- `counterparties`
- `stores`
- `account_mappings`

#### 3. 시간 관련 컬럼 (4개)
- `entry_date` (journal_entries 테이블) - ⚠️ 실제 테이블명 주의
- `issue_date` (debts_receivable 테이블) - ⚠️ 실제 테이블명 주의
- `due_date` (debts_receivable 테이블)
- `acquisition_date` (fixed_assets)

---

## 📋 상세 스캔 결과

| 파일 경로 | 타입 | 함수/테이블명 | 사용 컬럼 | 시간 관련 컬럼 |
|-----------|------|---------------|-----------|----------------|
| `data/datasources/journal_entry_datasource.dart` | TABLE | `accounts` | account_id, account_name, category_tag | - |
| `data/datasources/journal_entry_datasource.dart` | TABLE | `counterparties` | counterparty_id, name, is_internal, linked_company_id | - |
| `data/datasources/journal_entry_datasource.dart` | TABLE | `stores` | store_id, store_name | - |
| `data/datasources/journal_entry_datasource.dart` | TABLE | `account_mappings` | my_account_id, linked_account_id, direction | - |
| `data/datasources/journal_entry_datasource.dart` | RPC | `get_cash_locations` | p_company_id | - |
| `data/datasources/journal_entry_datasource.dart` | RPC | `get_exchange_rate_v2` | p_company_id | - |
| `data/datasources/journal_entry_datasource.dart` | RPC | `insert_journal_with_everything` | p_entry_date, p_base_amount, p_company_id, p_created_by, p_description, p_lines, p_counterparty_id, p_if_cash_location_id, p_store_id | **p_entry_date** |
| `data/models/transaction_line_model.dart` | DATA | Line item JSON | debit, credit, account_id, counterparty_id, description, cash, debt, fix_asset | **issue_date, due_date, acquisition_date** |

---

## 🔍 RPC 함수 상세 분석

### 1. `get_cash_locations`
**위치**: `journal_entry_datasource.dart:83-88`

**현재 사용**:
```dart
await _supabase.rpc<List<dynamic>>(
  'get_cash_locations',
  params: {
    'p_company_id': companyId,
  },
);
```

**반환 데이터**:
```dart
{
  'id': cash_location_id,
  'name': location_name,
  'type': location_type,
  'storeId': store_id
}
```

**시간 관련 컬럼**: ❌ 없음

**마이그레이션 필요**: ❌ **없음** - 시간 관련 데이터를 다루지 않음

---

### 2. `get_exchange_rate_v2`
**위치**: `journal_entry_datasource.dart:152-168`

**현재 사용**:
```dart
await _supabase.rpc<Map<String, dynamic>>(
  'get_exchange_rate_v2',
  params: {
    'p_company_id': companyId,
  },
);
```

**반환 데이터**:
```dart
{
  'base_currency': {
    'currency_id': '...',
    'currency_name': '...',
    'currency_code': '...',
    'symbol': '...'
  },
  'exchange_rates': [
    {
      'currency_id': '...',
      'currency_name': '...',
      'currency_code': '...',
      'symbol': '...',
      'rate': 1.0
    }
  ]
}
```

**시간 관련 컬럼**: ❌ 없음

**마이그레이션 필요**: ❌ **없음** - 시간 관련 데이터를 다루지 않음

---

### 3. `insert_journal_with_everything` ⚠️ **중요**
**위치**: `journal_entry_datasource.dart:171-212`

**현재 사용**:
```dart
await _supabase.rpc<void>(
  'insert_journal_with_everything',
  params: {
    'p_base_amount': totalDebits,
    'p_company_id': companyId,
    'p_created_by': userId,
    'p_description': journalEntry.overallDescription,
    'p_entry_date': entryDate,  // ⚠️ 시간 데이터 전송
    'p_lines': pLines,          // ⚠️ 내부에 시간 데이터 포함
    'p_counterparty_id': mainCounterpartyId,
    'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
    'p_store_id': storeId,
  },
);
```

**시간 데이터 준비 로직**:
```dart
// Line 181: Convert entry date to UTC for database storage
final entryDate = DateTimeUtils.toRpcFormat(journalEntry.entryDate);
// Format: 'yyyy-MM-dd HH:mm:ss' in UTC
```

**전송되는 시간 관련 데이터**:
1. **`p_entry_date`**: 분개 입력 날짜 (현재: `timestamp`, 목표: `timestamptz`)
2. **`p_lines` 내부**:
   - `debt.issue_date`: 채무 발행일
   - `debt.due_date`: 채무 만기일
   - `fix_asset.acquire_date`: 자산 취득일

**마이그레이션 필요**: ✅ **필수**

---

## 🎯 RPC 마이그레이션 전략

### 데이터베이스 팀 전달 사항

#### RPC 함수 복사본 생성: `insert_journal_with_everything_utc`

**1. 기존 RPC 유지**
```sql
-- ❌ 수정하지 마세요!
-- 이미 배포된 앱이 사용 중입니다.
CREATE OR REPLACE FUNCTION insert_journal_with_everything(
  p_base_amount numeric,
  p_company_id uuid,
  p_created_by uuid,
  p_description text,
  p_entry_date timestamp,  -- 기존: timestamp
  p_lines jsonb,
  p_counterparty_id uuid,
  p_if_cash_location_id uuid,
  p_store_id uuid
)
-- ... 기존 로직 유지
```

**2. 새 RPC 생성 (_utc 접미사)**
```sql
-- ✅ 새로 생성하세요!
-- 새 배포 버전이 사용할 함수입니다.
CREATE OR REPLACE FUNCTION insert_journal_with_everything_utc(
  p_base_amount numeric,
  p_company_id uuid,
  p_created_by uuid,
  p_description text,
  p_entry_date_utc timestamptz,  -- 변경: timestamptz
  p_lines jsonb,
  p_counterparty_id uuid,
  p_if_cash_location_id uuid,
  p_store_id uuid
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_journal_id uuid;
  v_line jsonb;
BEGIN
  -- 1. Insert into journals table
  INSERT INTO journals (
    company_id,
    entry_date_utc,  -- 새 컬럼 사용
    description,
    base_amount,
    created_by,
    counterparty_id,
    if_cash_location_id,
    store_id
  ) VALUES (
    p_company_id,
    p_entry_date_utc,
    p_description,
    p_base_amount,
    p_created_by,
    p_counterparty_id,
    p_if_cash_location_id,
    p_store_id
  )
  RETURNING journal_id INTO v_journal_id;

  -- 2. Process each line in p_lines
  FOR v_line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    -- Insert journal line
    INSERT INTO journal_lines (
      journal_id,
      account_id,
      description,
      debit,
      credit,
      counterparty_id
      -- ... other columns
    ) VALUES (
      v_journal_id,
      (v_line->>'account_id')::uuid,
      v_line->>'description',
      (v_line->>'debit')::numeric,
      (v_line->>'credit')::numeric,
      (v_line->>'counterparty_id')::uuid
      -- ... other values
    );

    -- 3. Handle debt information if present
    IF v_line ? 'debt' THEN
      INSERT INTO debts (
        journal_line_id,
        direction,
        category,
        counterparty_id,
        original_amount,
        interest_rate,
        issue_date_utc,  -- 새 컬럼 사용
        due_date_utc,    -- 새 컬럼 사용
        description
        -- ... other columns
      ) VALUES (
        v_line_id,
        v_line->'debt'->>'direction',
        v_line->'debt'->>'category',
        (v_line->'debt'->>'counterparty_id')::uuid,
        (v_line->'debt'->>'original_amount')::numeric,
        (v_line->'debt'->>'interest_rate')::numeric,
        (v_line->'debt'->>'issue_date')::timestamptz,  -- ISO8601 파싱
        (v_line->'debt'->>'due_date')::timestamptz,    -- ISO8601 파싱
        v_line->'debt'->>'description'
        -- ... other values
      );
    END IF;

    -- 4. Handle fixed asset information if present
    IF v_line ? 'fix_asset' THEN
      INSERT INTO fixed_assets (
        journal_line_id,
        asset_name,
        salvage_value,
        acquisition_date_utc,  -- 새 컬럼 사용
        useful_life
        -- ... other columns
      ) VALUES (
        v_line_id,
        v_line->'fix_asset'->>'asset_name',
        (v_line->'fix_asset'->>'salvage_value')::numeric,
        (v_line->'fix_asset'->>'acquire_date')::timestamptz,  -- ISO8601 파싱
        (v_line->'fix_asset'->>'useful_life')::integer
        -- ... other values
      );
    END IF;

    -- 5. Handle cash information if present
    IF v_line ? 'cash' THEN
      INSERT INTO cash_transactions (
        journal_line_id,
        cash_location_id
        -- ... other columns
      ) VALUES (
        v_line_id,
        (v_line->'cash'->>'cash_location_id')::uuid
        -- ... other values
      );
    END IF;
  END LOOP;

  -- 6. Create account mapping records if needed
  -- ... (account mapping logic)

END;
$$;
```

**3. 필요한 테이블 스키마 변경**

```sql
-- ✅ journal_entries 테이블 (실제 테이블명)
-- ⚠️ 2024-11-24 마이그레이션에서 이미 추가됨
-- entry_date_utc, created_at_utc, approved_at_utc 컬럼이 이미 존재

-- 인덱스만 확인/생성
CREATE INDEX IF NOT EXISTS idx_journal_entries_entry_date_utc
ON journal_entries(entry_date_utc);

-- ✅ debts_receivable 테이블 (실제 테이블명)
-- ⚠️ 2024-11-24 마이그레이션에서 이미 추가됨
-- issue_date_utc, due_date_utc, created_at_utc 컬럼이 이미 존재

-- 인덱스만 확인/생성
CREATE INDEX IF NOT EXISTS idx_debts_receivable_issue_date_utc
ON debts_receivable(issue_date_utc);

CREATE INDEX IF NOT EXISTS idx_debts_receivable_due_date_utc
ON debts_receivable(due_date_utc);

-- ✅ fixed_assets 테이블
-- ⚠️ 2024-11-24 마이그레이션에서 이미 추가됨
-- acquisition_date_utc, created_at_utc, impaired_at_utc 컬럼이 이미 존재

-- 인덱스만 확인/생성
CREATE INDEX IF NOT EXISTS idx_fixed_assets_acquisition_date_utc
ON fixed_assets(acquisition_date_utc);
```

**4. 중요 사항**
- ⚠️ **기존 RPC 함수 절대 수정 금지** - 배포된 앱이 사용 중
- ✅ 새 RPC 함수는 `_utc` 접미사 사용
- ✅ 새 테이블 컬럼은 `_utc` 접미사 사용
- ✅ 기존 컬럼은 그대로 유지 (호환성 보장)
- ✅ 데이터 타입: `timestamptz` (timezone 포함)
- ✅ 입력 형식: ISO 8601 (예: `2025-01-15T05:30:00.000Z`)

---

## 📝 Dart 코드 마이그레이션 계획

### Phase 1: Data Model 업데이트

**파일**: `data/models/transaction_line_model.dart`

**변경 사항**:
```dart
// ❌ 기존 (날짜만 전송)
Map<String, dynamic> toJson() {
  // ...
  if (v_line ? 'debt') {
    json['debt'] = {
      'issue_date': issueDate != null
          ? DateTimeUtils.toDateOnly(issueDate!)  // ❌ 시간 정보 손실
          : DateTimeUtils.toDateOnly(DateTime.now()),
      'due_date': dueDate != null
          ? DateTimeUtils.toDateOnly(dueDate!)    // ❌ 시간 정보 손실
          : DateTimeUtils.toDateOnly(DateTime.now().add(const Duration(days: 30))),
    };
  }
}

// ✅ 새 방식 (UTC timestamptz 전송)
Map<String, dynamic> toJson() {
  // ...
  if (v_line ? 'debt') {
    json['debt'] = {
      'issue_date': issueDate != null
          ? DateTimeUtils.toUtc(issueDate!)  // ✅ UTC ISO8601
          : DateTimeUtils.nowUtc(),
      'due_date': dueDate != null
          ? DateTimeUtils.toUtc(dueDate!)    // ✅ UTC ISO8601
          : DateTimeUtils.toUtc(DateTime.now().add(const Duration(days: 30))),
    };
  }

  if (v_line ? 'fix_asset') {
    json['fix_asset'] = {
      'acquire_date': acquisitionDate != null
          ? DateTimeUtils.toUtc(acquisitionDate!)  // ✅ UTC ISO8601
          : DateTimeUtils.nowUtc(),
    };
  }
}
```

### Phase 2: DataSource 업데이트

**파일**: `data/datasources/journal_entry_datasource.dart`

**변경 사항**:
```dart
// ❌ 기존
Future<void> submitJournalEntry({
  required JournalEntryModel journalEntry,
  required String userId,
  required String companyId,
  String? storeId,
}) async {
  try {
    // RPC 포맷으로 변환 (UTC, 'yyyy-MM-dd HH:mm:ss')
    final entryDate = DateTimeUtils.toRpcFormat(journalEntry.entryDate);

    await _supabase.rpc<void>(
      'insert_journal_with_everything',  // ❌ 구 버전
      params: {
        'p_entry_date': entryDate,       // ❌ timestamp
        // ...
      },
    );
  } catch (e) {
    throw Exception('Failed to create journal entry: $e');
  }
}

// ✅ 새 방식
Future<void> submitJournalEntry({
  required JournalEntryModel journalEntry,
  required String userId,
  required String companyId,
  String? storeId,
}) async {
  try {
    // ISO 8601 UTC 형식으로 변환
    final entryDateUtc = DateTimeUtils.toUtc(journalEntry.entryDate);

    await _supabase.rpc<void>(
      'insert_journal_with_everything_utc',  // ✅ 새 버전
      params: {
        'p_entry_date_utc': entryDateUtc,    // ✅ timestamptz (ISO8601)
        'p_base_amount': totalDebits,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': journalEntry.overallDescription,
        'p_lines': pLines,
        'p_counterparty_id': mainCounterpartyId,
        'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
        'p_store_id': storeId,
      },
    );
  } catch (e) {
    throw Exception('Failed to create journal entry: $e');
  }
}
```

### Phase 3: 날짜 형식 변경 요약

| 항목 | 기존 | 새 방식 |
|------|------|---------|
| **entry_date** | `DateTimeUtils.toRpcFormat()` → `"2025-01-15 05:30:00"` (timestamp) | `DateTimeUtils.toUtc()` → `"2025-01-15T05:30:00.000Z"` (timestamptz) |
| **issue_date** | `DateTimeUtils.toDateOnly()` → `"2025-01-15"` (date only) | `DateTimeUtils.toUtc()` → `"2025-01-15T05:30:00.000Z"` (timestamptz) |
| **due_date** | `DateTimeUtils.toDateOnly()` → `"2025-01-15"` (date only) | `DateTimeUtils.toUtc()` → `"2025-01-15T05:30:00.000Z"` (timestamptz) |
| **acquire_date** | `DateTimeUtils.toDateOnly()` → `"2025-01-15"` (date only) | `DateTimeUtils.toUtc()` → `"2025-01-15T05:30:00.000Z"` (timestamptz) |

---

## 🚀 마이그레이션 실행 순서

### Step 1: 데이터베이스 팀 작업 (먼저 실행)
1. ✅ `journal_entries.entry_date_utc` 컬럼 추가 - **이미 완료됨** (2024-11-24)
2. ✅ `debts_receivable.issue_date_utc`, `due_date_utc` 컬럼 추가 - **이미 완료됨**
3. ✅ `fixed_assets.acquisition_date_utc` 컬럼 추가 - **이미 완료됨**
4. ✅ 기존 데이터 마이그레이션 - **확인 필요**
5. ⏳ 인덱스 생성 - **실행 필요**
6. ⏳ `insert_journal_with_everything_utc` RPC 함수 생성 - **실행 필요**
7. ⏳ 테스트 데이터로 RPC 함수 검증

### Step 2: Flutter 앱 개발팀 작업 (DB 작업 완료 후)
1. ✅ `transaction_line_model.dart` 수정
   - `toJson()` 메서드에서 `toDateOnly()` → `toUtc()` 변경
2. ✅ `journal_entry_datasource.dart` 수정
   - RPC 함수명: `insert_journal_with_everything` → `insert_journal_with_everything_utc`
   - 파라미터명: `p_entry_date` → `p_entry_date_utc`
   - 날짜 형식: `toRpcFormat()` → `toUtc()`
3. ✅ 로컬 테스트
4. ✅ 스테이징 환경 배포 및 테스트
5. ✅ 프로덕션 배포

### Step 3: 검증 (배포 후)
1. ✅ 새 분개 입력 테스트
2. ✅ 채무 정보 포함 분개 테스트
3. ✅ 고정자산 정보 포함 분개 테스트
4. ✅ 데이터베이스에서 `_utc` 컬럼 확인
5. ✅ 시간대 변환 정확성 검증

### Step 4: 정리 (6개월 후, 구 버전 앱 사용 중단 확인 후)
1. ⚠️ 기존 컬럼 deprecate 표시
2. ⚠️ 기존 RPC 함수 deprecate 표시
3. ⚠️ 1년 후 완전 제거 계획 수립

---

## 🔒 호환성 전략

### 병렬 운영 기간
- ✅ 구 버전 앱: `insert_journal_with_everything` + `entry_date` (timestamp)
- ✅ 신 버전 앱: `insert_journal_with_everything_utc` + `entry_date_utc` (timestamptz)
- ✅ 두 버전 모두 정상 작동
- ✅ 데이터 일관성 유지

### 롤백 계획
만약 문제 발생 시:
1. Flutter 앱 코드 롤백 (구 RPC 함수 사용)
2. 데이터베이스 변경은 롤백 불필요 (기존 컬럼 유지됨)
3. 새 RPC 함수는 그대로 두고 추후 수정

---

## ✅ 체크리스트

### 데이터베이스 팀
- [x] `journal_entries` 테이블 스키마 변경 완료 - **이미 완료** ✅
- [x] `debts_receivable` 테이블 스키마 변경 완료 - **이미 완료** ✅
- [x] `fixed_assets` 테이블 스키마 변경 완료 - **이미 완료** ✅
- [ ] 기존 데이터 마이그레이션 검증 (NULL 체크)
- [ ] 인덱스 생성 및 확인
- [ ] `insert_journal_with_everything_utc` RPC 생성
- [ ] RPC 함수 단위 테스트 통과
- [ ] 개발 환경 배포 완료
- [ ] 스테이징 환경 배포 완료

### Flutter 개발팀
- [ ] `transaction_line_model.dart` 수정 완료
- [ ] `journal_entry_datasource.dart` 수정 완료
- [ ] 단위 테스트 작성 및 통과
- [ ] 로컬 환경 테스트 완료
- [ ] 코드 리뷰 완료
- [ ] 스테이징 환경 배포 및 테스트 완료
- [ ] 프로덕션 배포 완료

### QA 팀
- [ ] 새 분개 입력 테스트 통과
- [ ] 채무 정보 포함 분개 테스트 통과
- [ ] 고정자산 정보 포함 분개 테스트 통과
- [ ] 다양한 시간대 테스트 (한국, 베트남, 미국 등)
- [ ] 데이터베이스 데이터 검증 완료

---

## 📞 문의 사항

### 데이터베이스 관련
- RPC 함수 구현 상세 사항
- 테이블 스키마 변경 검토

### 앱 개발 관련
- 날짜 형식 변경 영향 범위
- 테스트 계획

---

## 📎 참고 자료

### 관련 문서
- `lib/core/utils/datetime_utils.dart` - 날짜 유틸리티 함수
- `lib/features/journal_input/MIGRATION_NOTES.md` - 기존 마이그레이션 노트

### Supabase 문서
- [Working with Dates and Times](https://supabase.com/docs/guides/database/postgres/dates)
- [PostgreSQL Timestamp Types](https://www.postgresql.org/docs/current/datatype-datetime.html)

---

**마지막 업데이트**: 2025-11-25
