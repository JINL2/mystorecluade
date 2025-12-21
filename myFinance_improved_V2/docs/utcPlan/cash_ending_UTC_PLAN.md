# Cash Ending - UTC 마이그레이션 계획

## 📋 요약

**목적**: Cash Ending 페이지의 시간 데이터를 `timestamptz` (UTC)로 완전 전환
**전략**: INPUT은 트리거 자동화, OUTPUT은 RPC 신규 버전 생성
**배포 영향**: 기존 앱 무중단, 신규 앱만 UTC 사용

---

## 🔍 현황 분석

### 데이터베이스 상태

✅ **_utc 컬럼 이미 존재** (2024-11-24 마이그레이션 완료)

| 테이블 | 기존 컬럼 | UTC 컬럼 | 상태 |
|--------|----------|---------|------|
| `cash_amount_entries` | `created_at` (timestamp)<br>`record_date` (date) | `created_at_utc` (timestamptz)<br>`record_date_utc` (timestamptz) | ✅ 준비됨 |
| `cash_amount_stock_flow` | `created_at` (timestamp)<br>`system_time` (timestamp) | `created_at_utc` (timestamptz)<br>`system_time_utc` (timestamptz) | ✅ 준비됨 |
| `cashier_amount_lines` | `created_at` (timestamp)<br>`record_date` (date) | `created_at_utc` (timestamptz)<br>`record_date_utc` (timestamptz) | ✅ 준비됨 |
| `vault_amount_line` | `created_at` (timestamp)<br>`record_date` (date) | `created_at_utc` (timestamptz)<br>`record_date_utc` (timestamptz) | ✅ 준비됨 |
| `bank_amount` | `created_at` (timestamp)<br>`record_date` (date) | `created_at_utc` (timestamptz)<br>`record_date_utc` (timestamptz) | ✅ 준비됨 |

### RPC 함수 분석

#### INPUT (데이터 저장)
| RPC 함수 | 테이블 | 수정 필요 | 비고 |
|---------|--------|---------|------|
| `insert_amount_multi_currency` | 5개 테이블 전체 | ❌ 불필요 | 트리거가 자동 처리 |

#### OUTPUT (데이터 조회)
| 기존 RPC | 사용 테이블 | 시간 컬럼 | 수정 필요 | 우선순위 |
|---------|-----------|----------|---------|---------|
| `get_location_stock_flow` | `cash_amount_stock_flow` | `created_at` | ✅ 필요 | 🔴 높음 |
| `get_cash_location_balance_summary_v2` | 여러 테이블 | `record_date` | ✅ 필요 | 🟡 중간 |
| `get_multiple_locations_balance_summary` | 여러 테이블 | `record_date` | ✅ 필요 | 🟡 중간 |
| `get_company_balance_summary` | 여러 테이블 | `record_date` | ✅ 필요 | 🟢 낮음 |

---

## 🎯 마이그레이션 전략

### Phase 1: INPUT - 트리거 방식 (코드 수정 없음)

**원리**: 기존 RPC가 구 컬럼에 저장 → 트리거가 자동으로 _utc 컬럼 채움

```sql
-- 예시: cash_amount_stock_flow 트리거
CREATE OR REPLACE FUNCTION sync_stock_flow_utc()
RETURNS TRIGGER AS $$
BEGIN
  NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  NEW.system_time_utc := NEW.system_time AT TIME ZONE 'UTC';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_stock_flow_utc
  BEFORE INSERT OR UPDATE ON cash_amount_stock_flow
  FOR EACH ROW
  EXECUTE FUNCTION sync_stock_flow_utc();
```

**적용 테이블**: 5개 전체 (`cash_amount_entries`, `cash_amount_stock_flow`, `cashier_amount_lines`, `vault_amount_line`, `bank_amount`)

**장점**:
- ✅ Flutter 코드 수정 불필요
- ✅ 기존 RPC 유지
- ✅ 자동 동기화

### Phase 2: OUTPUT - RPC 신규 버전 생성

**원리**: 기존 RPC 유지, `_utc` 접미사 붙인 신규 RPC 생성

#### 예시: `get_location_stock_flow_utc`

**변경점**:
```sql
-- ❌ 기존
SELECT
  flow_id,
  created_at,              -- timestamp
  system_time              -- timestamp
FROM cash_amount_stock_flow
ORDER BY created_at DESC;

-- ✅ 신규 (_utc 버전)
SELECT
  flow_id,
  created_at_utc,          -- timestamptz (UTC)
  system_time_utc          -- timestamptz (UTC)
FROM cash_amount_stock_flow
ORDER BY created_at_utc DESC;
```

---

## 📊 데이터베이스 팀 작업 명세

### 작업 1: 트리거 생성 (5개)

모든 테이블에 대해 BEFORE INSERT/UPDATE 트리거 생성

**템플릿**:
```sql
CREATE OR REPLACE FUNCTION sync_[테이블명]_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- created_at 변환
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  -- record_date 변환 (해당하는 경우)
  IF NEW.record_date IS NOT NULL THEN
    NEW.record_date_utc := (NEW.record_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC';
  END IF;

  -- system_time 변환 (stock_flow만)
  IF NEW.system_time IS NOT NULL THEN
    NEW.system_time_utc := NEW.system_time AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_[테이블명]_utc
  BEFORE INSERT OR UPDATE ON [테이블명]
  FOR EACH ROW
  EXECUTE FUNCTION sync_[테이블명]_utc();
```

**적용 대상**:
1. `cash_amount_entries` - `created_at`, `record_date`
2. `cash_amount_stock_flow` - `created_at`, `system_time`
3. `cashier_amount_lines` - `created_at`, `record_date`
4. `vault_amount_line` - `created_at`, `record_date`
5. `bank_amount` - `created_at`, `record_date`

### 작업 2: 기존 데이터 백필

```sql
-- 1. cash_amount_entries
UPDATE cash_amount_entries
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  record_date_utc = (record_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL OR record_date_utc IS NULL;

-- 2. cash_amount_stock_flow
UPDATE cash_amount_stock_flow
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  system_time_utc = system_time AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL OR system_time_utc IS NULL;

-- 3. cashier_amount_lines
UPDATE cashier_amount_lines
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  record_date_utc = (record_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL OR record_date_utc IS NULL;

-- 4. vault_amount_line
UPDATE vault_amount_line
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  record_date_utc = (record_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL OR record_date_utc IS NULL;

-- 5. bank_amount
UPDATE bank_amount
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  record_date_utc = (record_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL OR record_date_utc IS NULL;
```

### 작업 3: 인덱스 생성

```sql
-- created_at_utc 인덱스
CREATE INDEX IF NOT EXISTS idx_cash_entries_created_at_utc ON cash_amount_entries(created_at_utc);
CREATE INDEX IF NOT EXISTS idx_stock_flow_created_at_utc ON cash_amount_stock_flow(created_at_utc);
CREATE INDEX IF NOT EXISTS idx_cashier_lines_created_at_utc ON cashier_amount_lines(created_at_utc);
CREATE INDEX IF NOT EXISTS idx_vault_line_created_at_utc ON vault_amount_line(created_at_utc);
CREATE INDEX IF NOT EXISTS idx_bank_amount_created_at_utc ON bank_amount(created_at_utc);

-- record_date_utc 인덱스
CREATE INDEX IF NOT EXISTS idx_cash_entries_record_date_utc ON cash_amount_entries(record_date_utc);
CREATE INDEX IF NOT EXISTS idx_cashier_lines_record_date_utc ON cashier_amount_lines(record_date_utc);
CREATE INDEX IF NOT EXISTS idx_vault_line_record_date_utc ON vault_amount_line(record_date_utc);
CREATE INDEX IF NOT EXISTS idx_bank_amount_record_date_utc ON bank_amount(record_date_utc);

-- system_time_utc 인덱스
CREATE INDEX IF NOT EXISTS idx_stock_flow_system_time_utc ON cash_amount_stock_flow(system_time_utc);
```

### 작업 4: 신규 RPC 함수 생성

별도 문서 참조: `cash_ending_RPC_SPEC.md`

---

## 📱 Flutter 개발팀 작업 명세

### 작업 범위

**Phase 1 (트리거)**: ❌ 작업 없음 (자동 처리)

**Phase 2 (조회 RPC)**: ✅ RPC 호출 변경 필요

### 수정 대상 파일

#### 1. `data/datasources/stock_flow_remote_datasource.dart`

**변경 전**:
```dart
final result = await _supabase.rpc<List<dynamic>>(
  'get_location_stock_flow',  // ❌ 구 버전
  params: {
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_start_date': startDate,
    'p_end_date': endDate,
  },
);
```

**변경 후**:
```dart
final result = await _supabase.rpc<List<dynamic>>(
  'get_location_stock_flow_utc',  // ✅ 신 버전
  params: {
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_start_date': startDate,
    'p_end_date': endDate,
  },
);
```

**DTO 변경**:
```dart
// stock_flow_dto.dart
factory StockFlowDto.fromJson(Map<String, dynamic> json) {
  return StockFlowDto(
    flowId: json['flow_id'],
    createdAt: json['created_at_utc'] != null  // ✅ _utc 컬럼 사용
        ? DateTime.parse(json['created_at_utc'])
        : DateTime.now(),
    systemTime: json['system_time_utc'] != null
        ? DateTime.parse(json['system_time_utc'])
        : DateTime.now(),
    // ...
  );
}
```

#### 2. 기타 데이터소스 파일

동일한 패턴으로 수정:
- `cash_ending_remote_datasource.dart`
- `bank_remote_datasource.dart`
- `vault_remote_datasource.dart`

---

## 🚀 배포 순서

### Step 1: 데이터베이스 (즉시 실행 가능)
1. ✅ 트리거 생성 (5개)
2. ✅ 기존 데이터 백필
3. ✅ 인덱스 생성
4. ✅ NULL 체크 (0개 확인)

**예상 소요**: 30분
**영향**: 없음 (기존 앱 계속 작동)

### Step 2: RPC 함수 생성 (DB 팀과 협의 후)
1. ✅ `get_location_stock_flow_utc` 생성
2. ✅ `get_cash_location_balance_summary_v2_utc` 생성
3. ✅ `get_multiple_locations_balance_summary_utc` 생성
4. ✅ `get_company_balance_summary_utc` 생성
5. ✅ 테스트 실행

**예상 소요**: 2-3시간
**영향**: 없음 (기존 RPC 유지)

### Step 3: Flutter 앱 수정 (RPC 생성 완료 후)
1. ✅ DTO 모델 수정 (4개 파일)
2. ✅ DataSource RPC 호출 변경
3. ✅ 로컬 테스트
4. ✅ 스테이징 배포
5. ✅ 프로덕션 배포

**예상 소요**: 1일
**영향**: 신규 배포 앱만 영향

---

## ✅ 검증 방법

### 1. 트리거 작동 확인
```sql
-- 테스트 데이터 삽입 후 _utc 컬럼 확인
INSERT INTO cash_amount_stock_flow (
  flow_id, company_id, cash_location_id, location_type,
  currency_id, flow_amount, balance_before, balance_after,
  created_by, created_at, system_time
) VALUES (
  gen_random_uuid(), 'test-company-id', 'test-location-id', 'cash',
  'test-currency-id', 1000, 0, 1000,
  'test-user-id', NOW(), NOW()
);

-- created_at_utc, system_time_utc 자동 채워졌는지 확인
SELECT created_at, created_at_utc, system_time, system_time_utc
FROM cash_amount_stock_flow
ORDER BY created_at DESC
LIMIT 1;
```

### 2. NULL 체크
```sql
-- 모든 테이블의 _utc 컬럼 NULL 개수 확인 (모두 0이어야 함)
SELECT 'cash_amount_entries' as table_name,
       COUNT(*) as total,
       COUNT(created_at_utc) as utc_count
FROM cash_amount_entries
UNION ALL
SELECT 'cash_amount_stock_flow', COUNT(*), COUNT(created_at_utc)
FROM cash_amount_stock_flow
UNION ALL
SELECT 'cashier_amount_lines', COUNT(*), COUNT(created_at_utc)
FROM cashier_amount_lines
UNION ALL
SELECT 'vault_amount_line', COUNT(*), COUNT(created_at_utc)
FROM vault_amount_line
UNION ALL
SELECT 'bank_amount', COUNT(*), COUNT(created_at_utc)
FROM bank_amount;
```

---

## 📋 체크리스트

### 데이터베이스 팀
- [ ] 트리거 함수 5개 생성
- [ ] 트리거 5개 연결
- [ ] 기존 데이터 백필 실행
- [ ] 인덱스 생성
- [ ] NULL 체크 (0개 확인)
- [ ] 신규 RPC 함수 4개 생성
- [ ] RPC 테스트 완료
- [ ] 개발 환경 배포
- [ ] 스테이징 환경 배포
- [ ] 프로덕션 배포

### Flutter 개발팀
- [ ] Phase 1 확인 (트리거 작동)
- [ ] DTO 모델 수정 (4개)
- [ ] DataSource RPC 호출 변경
- [ ] 단위 테스트 통과
- [ ] 로컬 테스트 완료
- [ ] 코드 리뷰 완료
- [ ] 스테이징 배포
- [ ] 프로덕션 배포

---

**문서 작성일**: 2025-11-25
**담당자**: Cash Ending 팀
**우선순위**: 🟡 중간 (글로벌 서비스 준비)
