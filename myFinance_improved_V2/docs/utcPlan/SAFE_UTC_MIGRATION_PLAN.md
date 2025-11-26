# Journal Input - 안전한 UTC 마이그레이션 계획

## 🎯 핵심 원칙

> **기존 코드, RPC, 로직은 절대 수정하지 않는다!**
>
> **오직 데이터베이스 트리거로 _utc 컬럼을 자동 채운다!**

---

## 📊 현재 상황

### ✅ 이미 완료된 작업 (2024-11-24 마이그레이션)

1. **journal_entries** 테이블
   - `entry_date_utc` timestamptz 컬럼 ✅ 존재
   - `created_at_utc` timestamptz 컬럼 ✅ 존재
   - `approved_at_utc` timestamptz 컬럼 ✅ 존재

2. **debts_receivable** 테이블
   - `issue_date_utc` timestamptz 컬럼 ✅ 존재
   - `due_date_utc` timestamptz 컬럼 ✅ 존재
   - `created_at_utc` timestamptz 컬럼 ✅ 존재

3. **fixed_assets** 테이블
   - `acquisition_date_utc` timestamptz 컬럼 ✅ 존재
   - `created_at_utc` timestamptz 컬럼 ✅ 존재
   - `impaired_at_utc` timestamptz 컬럼 ✅ 존재

### 🔍 현재 RPC 함수

```sql
-- ⚠️ 이 함수는 절대 수정하지 않습니다!
CREATE OR REPLACE FUNCTION insert_journal_with_everything(
  p_entry_date timestamp without time zone,  -- 그대로 유지
  ...
)
RETURNS uuid
```

**현재 동작**:
- `entry_date` (date 타입)에 `p_entry_date`의 날짜 부분만 저장
- `created_at` (timestamp)에 `p_entry_date` 그대로 저장
- `entry_date_utc`, `created_at_utc`는 **NULL로 남음**

---

## 🎯 새로운 마이그레이션 전략

### ✅ 전략: 데이터베이스 트리거 사용

기존 RPC는 그대로 두고, **INSERT/UPDATE 시 트리거가 자동으로 _utc 컬럼을 채움**

```
기존 흐름 (변경 없음):
Flutter → RPC → INSERT(entry_date, created_at)

새로운 흐름 (트리거 추가):
Flutter → RPC → INSERT(entry_date, created_at)
                    ↓
                 🔧 트리거 자동 실행
                    ↓
                 UPDATE(entry_date_utc, created_at_utc)
```

---

## 🛠️ 구현 방법

### 1. journal_entries 테이블 트리거

```sql
-- ========================================
-- journal_entries 자동 UTC 변환 트리거
-- ========================================

CREATE OR REPLACE FUNCTION sync_journal_entries_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- entry_date (date) → entry_date_utc (timestamptz)
  IF NEW.entry_date IS NOT NULL THEN
    NEW.entry_date_utc := (NEW.entry_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC';
  END IF;

  -- created_at (timestamp) → created_at_utc (timestamptz)
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  -- approved_at (timestamp) → approved_at_utc (timestamptz)
  IF NEW.approved_at IS NOT NULL THEN
    NEW.approved_at_utc := NEW.approved_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성 (INSERT와 UPDATE 모두)
DROP TRIGGER IF EXISTS trigger_sync_journal_entries_utc ON journal_entries;
CREATE TRIGGER trigger_sync_journal_entries_utc
  BEFORE INSERT OR UPDATE ON journal_entries
  FOR EACH ROW
  EXECUTE FUNCTION sync_journal_entries_utc();
```

### 2. debts_receivable 테이블 트리거

```sql
-- ========================================
-- debts_receivable 자동 UTC 변환 트리거
-- ========================================

CREATE OR REPLACE FUNCTION sync_debts_receivable_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- issue_date (date) → issue_date_utc (timestamptz)
  IF NEW.issue_date IS NOT NULL THEN
    NEW.issue_date_utc := (NEW.issue_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC';
  END IF;

  -- due_date (date) → due_date_utc (timestamptz)
  IF NEW.due_date IS NOT NULL THEN
    NEW.due_date_utc := (NEW.due_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC';
  END IF;

  -- created_at (timestamp) → created_at_utc (timestamptz)
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS trigger_sync_debts_receivable_utc ON debts_receivable;
CREATE TRIGGER trigger_sync_debts_receivable_utc
  BEFORE INSERT OR UPDATE ON debts_receivable
  FOR EACH ROW
  EXECUTE FUNCTION sync_debts_receivable_utc();
```

### 3. fixed_assets 테이블 트리거

```sql
-- ========================================
-- fixed_assets 자동 UTC 변환 트리거
-- ========================================

CREATE OR REPLACE FUNCTION sync_fixed_assets_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- acquisition_date (date) → acquisition_date_utc (timestamptz)
  IF NEW.acquisition_date IS NOT NULL THEN
    NEW.acquisition_date_utc := (NEW.acquisition_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC';
  END IF;

  -- created_at (timestamp) → created_at_utc (timestamptz)
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  -- impaired_at (date) → impaired_at_utc (timestamptz)
  IF NEW.impaired_at IS NOT NULL THEN
    NEW.impaired_at_utc := (NEW.impaired_at || ' 00:00:00')::timestamp AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS trigger_sync_fixed_assets_utc ON fixed_assets;
CREATE TRIGGER trigger_sync_fixed_assets_utc
  BEFORE INSERT OR UPDATE ON fixed_assets
  FOR EACH ROW
  EXECUTE FUNCTION sync_fixed_assets_utc();
```

---

## 🗄️ 기존 데이터 백필

트리거는 새 데이터에만 적용되므로, 기존 데이터는 한 번 업데이트 필요:

```sql
-- ========================================
-- 기존 데이터 일괄 업데이트 (한 번만 실행)
-- ========================================

-- 1. journal_entries
UPDATE journal_entries
SET
  entry_date_utc = (entry_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC',
  created_at_utc = created_at AT TIME ZONE 'UTC',
  approved_at_utc = CASE
    WHEN approved_at IS NOT NULL
    THEN approved_at AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE entry_date_utc IS NULL
  OR created_at_utc IS NULL;

-- 2. debts_receivable
UPDATE debts_receivable
SET
  issue_date_utc = (issue_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC',
  due_date_utc = CASE
    WHEN due_date IS NOT NULL
    THEN (due_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
    ELSE NULL
  END,
  created_at_utc = created_at AT TIME ZONE 'UTC'
WHERE issue_date_utc IS NULL
  OR created_at_utc IS NULL;

-- 3. fixed_assets
UPDATE fixed_assets
SET
  acquisition_date_utc = (acquisition_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC',
  created_at_utc = created_at AT TIME ZONE 'UTC',
  impaired_at_utc = CASE
    WHEN impaired_at IS NOT NULL
    THEN (impaired_at || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE acquisition_date_utc IS NULL
  OR created_at_utc IS NULL;
```

---

## 📈 인덱스 생성 (성능 최적화)

```sql
-- ========================================
-- _utc 컬럼 인덱스 생성
-- ========================================

-- journal_entries
CREATE INDEX IF NOT EXISTS idx_journal_entries_entry_date_utc
ON journal_entries(entry_date_utc);

CREATE INDEX IF NOT EXISTS idx_journal_entries_created_at_utc
ON journal_entries(created_at_utc);

-- debts_receivable
CREATE INDEX IF NOT EXISTS idx_debts_receivable_issue_date_utc
ON debts_receivable(issue_date_utc);

CREATE INDEX IF NOT EXISTS idx_debts_receivable_due_date_utc
ON debts_receivable(due_date_utc);

-- fixed_assets
CREATE INDEX IF NOT EXISTS idx_fixed_assets_acquisition_date_utc
ON fixed_assets(acquisition_date_utc);
```

---

## ✅ 검증 방법

### 1. 트리거 작동 확인

```sql
-- 테스트 데이터 삽입
INSERT INTO journal_entries (
  journal_id, company_id, entry_date, created_at, description, base_amount
) VALUES (
  gen_random_uuid(),
  '12345678-1234-1234-1234-123456789012'::uuid,
  '2025-01-15'::date,
  '2025-01-15 14:30:00'::timestamp,
  'Test entry',
  10000
);

-- entry_date_utc와 created_at_utc가 자동으로 채워졌는지 확인
SELECT
  entry_date,
  entry_date_utc,
  created_at,
  created_at_utc
FROM journal_entries
ORDER BY created_at DESC
LIMIT 1;

-- 예상 결과:
-- entry_date: 2025-01-15
-- entry_date_utc: 2025-01-15 00:00:00+00
-- created_at: 2025-01-15 14:30:00
-- created_at_utc: 2025-01-15 14:30:00+00
```

### 2. NULL 체크

```sql
-- _utc 컬럼이 NULL인 레코드가 있는지 확인
SELECT
  'journal_entries' as table_name,
  COUNT(*) as null_count
FROM journal_entries
WHERE entry_date_utc IS NULL OR created_at_utc IS NULL

UNION ALL

SELECT
  'debts_receivable',
  COUNT(*)
FROM debts_receivable
WHERE issue_date_utc IS NULL OR created_at_utc IS NULL

UNION ALL

SELECT
  'fixed_assets',
  COUNT(*)
FROM fixed_assets
WHERE acquisition_date_utc IS NULL OR created_at_utc IS NULL;

-- 모두 0이어야 함
```

---

## 🚀 배포 순서

### Phase 1: 데이터베이스 작업 (즉시 실행 가능)

```sql
-- 1단계: 트리거 함수 생성
-- (위의 3개 트리거 함수 실행)

-- 2단계: 트리거 연결
-- (위의 3개 트리거 생성 실행)

-- 3단계: 기존 데이터 백필
-- (위의 UPDATE 쿼리 실행)

-- 4단계: 인덱스 생성
-- (위의 인덱스 생성 쿼리 실행)

-- 5단계: 검증
-- (위의 검증 쿼리 실행)
```

### Phase 2: Flutter 앱 (변경 없음!)

**아무것도 수정하지 않습니다!**

- ✅ 기존 코드 그대로 사용
- ✅ 기존 RPC 함수 그대로 호출
- ✅ 데이터 형식 변경 없음

---

## 🎯 이점

### ✅ 1. 무중단 배포
- 기존 앱은 계속 작동
- 새 앱도 그대로 작동
- RPC 함수 수정 없음

### ✅ 2. 자동 데이터 동기화
- 트리거가 자동으로 _utc 컬럼 채움
- 개발자가 신경 쓸 필요 없음
- 데이터 일관성 보장

### ✅ 3. 롤백 용이
```sql
-- 문제 발생 시 트리거만 제거
DROP TRIGGER IF EXISTS trigger_sync_journal_entries_utc ON journal_entries;
DROP TRIGGER IF EXISTS trigger_sync_debts_receivable_utc ON debts_receivable;
DROP TRIGGER IF EXISTS trigger_sync_fixed_assets_utc ON fixed_assets;

-- 함수 제거
DROP FUNCTION IF EXISTS sync_journal_entries_utc();
DROP FUNCTION IF EXISTS sync_debts_receivable_utc();
DROP FUNCTION IF EXISTS sync_fixed_assets_utc();
```

### ✅ 4. 미래 대비
- _utc 컬럼이 항상 최신 상태 유지
- 추후 앱에서 _utc 컬럼 사용 시 즉시 전환 가능
- 데이터 품질 보장

---

## ⚠️ 주의사항

### 1. 시간대 가정
```sql
-- 현재 트리거는 모든 timestamp를 UTC로 간주
NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
```

**만약 created_at이 로컬 시간이라면**:
```sql
-- 예: Asia/Seoul → UTC 변환
NEW.created_at_utc := NEW.created_at AT TIME ZONE 'Asia/Seoul';
```

### 2. date 타입 처리
```sql
-- date → timestamptz 변환 시 00:00:00으로 설정
(NEW.entry_date || ' 00:00:00')::timestamp AT TIME ZONE 'UTC'
```

### 3. 성능 영향
- BEFORE 트리거는 INSERT/UPDATE마다 실행
- 하지만 계산이 매우 단순하여 성능 영향 미미
- 필요시 AFTER 트리거로 변경 가능

---

## 📊 모니터링

```sql
-- 1. 트리거 실행 확인
SELECT
  trigger_name,
  event_manipulation,
  event_object_table,
  action_statement
FROM information_schema.triggers
WHERE trigger_name LIKE '%sync%utc%';

-- 2. 최근 데이터의 _utc 컬럼 확인
SELECT
  entry_date,
  entry_date_utc,
  entry_date_utc IS NOT NULL as has_utc
FROM journal_entries
WHERE created_at >= NOW() - INTERVAL '1 day'
ORDER BY created_at DESC
LIMIT 10;
```

---

## ✅ 최종 체크리스트

### 데이터베이스 팀
- [ ] 트리거 함수 3개 생성
- [ ] 트리거 3개 연결
- [ ] 기존 데이터 백필 실행
- [ ] 인덱스 생성
- [ ] NULL 체크 (0개 확인)
- [ ] 트리거 작동 테스트
- [ ] 개발 환경 배포
- [ ] 스테이징 환경 배포
- [ ] 프로덕션 배포

### Flutter 개발팀
- [x] **아무것도 하지 않음** ✅

### QA 팀
- [ ] 기존 기능 정상 작동 확인
- [ ] _utc 컬럼 자동 채워지는지 확인
- [ ] 다양한 시간대 테스트

---

## 🎉 결론

**이 방식이 가장 안전합니다!**

- ✅ 기존 코드 수정 없음
- ✅ RPC 함수 수정 없음
- ✅ Flutter 앱 수정 없음
- ✅ 자동으로 _utc 컬럼 채워짐
- ✅ 무중단 배포 가능
- ✅ 롤백 용이

**문서 작성일**: 2025-11-25
**전략**: 트리거 기반 자동 동기화
**코드 수정**: 없음 ✅
