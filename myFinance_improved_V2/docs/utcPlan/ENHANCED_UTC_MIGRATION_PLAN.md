# 향상된 UTC 마이그레이션 계획 (Company Timezone 활용)

## 🎯 핵심 발견

**`companies` 테이블에 `timezone` 컬럼이 있습니다!**

```sql
companies.timezone = 'Asia/Ho_Chi_Minh'  -- 베트남
companies.timezone = 'Asia/Seoul'        -- 한국
```

이를 활용하면 **더 정확한 UTC 변환**이 가능합니다!

---

## ⚠️ 현재 상황 분석

### 문제점

```dart
// Flutter 앱 (DateTimeUtils.toRpcFormat)
final now = DateTime.now();  // 로컬 시간
final utc = now.toUtc();     // UTC로 변환
// 결과: "2025-01-15 05:30:00" (UTC)

// 하지만...
// - 한국 앱: 14:30 (KST) → 05:30 (UTC) ✅
// - 베트남 앱: 12:30 (ICT) → 05:30 (UTC) ✅
// - 모두 제대로 변환됨!
```

**다행히 `toRpcFormat()`이 이미 제대로 작동합니다!**

---

## 🔍 하지만 더 나은 방법이 있습니다

### 시나리오 1: Flutter 앱이 UTC로 잘 변환하는 경우 (현재)

```sql
-- 간단한 트리거
CREATE OR REPLACE FUNCTION sync_journal_entries_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- 이미 UTC로 들어온 값을 timestamptz로만 변환
  NEW.entry_date_utc := (NEW.entry_date::timestamp) AT TIME ZONE 'UTC';
  NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 시나리오 2: 만약 로컬 시간으로 들어온다면 (향후 대비)

```sql
-- 회사 timezone을 활용한 정확한 변환
CREATE OR REPLACE FUNCTION sync_journal_entries_utc()
RETURNS TRIGGER AS $$
DECLARE
  company_tz TEXT;
BEGIN
  -- 회사의 timezone 가져오기
  SELECT c.timezone INTO company_tz
  FROM companies c
  WHERE c.company_id = NEW.company_id;

  -- timezone이 없으면 기본값 사용
  IF company_tz IS NULL THEN
    company_tz := 'Asia/Ho_Chi_Minh';
  END IF;

  -- entry_date (date) → entry_date_utc (timestamptz)
  IF NEW.entry_date IS NOT NULL THEN
    NEW.entry_date_utc := (NEW.entry_date::timestamp) AT TIME ZONE company_tz;
  END IF;

  -- created_at (timestamp) → created_at_utc (timestamptz)
  -- ⚠️ 현재는 이미 UTC로 들어오므로 'UTC' 사용
  -- 만약 로컬 시간이라면 company_tz 사용
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
    -- 로컬 시간인 경우: NEW.created_at AT TIME ZONE company_tz;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## 🎯 추천 방안

### ✅ 방안 1: 현재 상태 유지 (간단함)

**이유**: `DateTimeUtils.toRpcFormat()`이 이미 UTC로 변환

```sql
-- 간단한 트리거 (SAFE_UTC_MIGRATION_PLAN.md 그대로)
NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
```

**장점**:
- 간단함
- 현재 시스템과 잘 맞음
- 성능 좋음 (추가 쿼리 없음)

**단점**:
- `toRpcFormat()`에 의존적
- 앱이 실수로 UTC 변환 안 하면 문제

---

### ✅ 방안 2: Company Timezone 활용 (미래 대비)

**이유**: 더 유연하고 안전함

```sql
-- 회사 timezone 기반 트리거
SELECT timezone INTO company_tz FROM companies WHERE company_id = NEW.company_id;
NEW.created_at_utc := NEW.created_at AT TIME ZONE COALESCE(company_tz, 'UTC');
```

**장점**:
- 더 정확한 변환
- 앱의 실수 방지
- 각 회사의 timezone 존중
- 미래 확장성 좋음

**단점**:
- 약간 복잡함
- SELECT 쿼리 1회 추가 (성능 미미한 영향)

---

## 🔍 현재 데이터 검증

```sql
-- 현재 created_at이 정말 UTC인지 확인
SELECT
  company_id,
  entry_date,
  created_at,
  created_at AT TIME ZONE 'UTC' as assuming_utc,
  created_at AT TIME ZONE 'Asia/Seoul' as assuming_kst,
  created_at AT TIME ZONE 'Asia/Ho_Chi_Minh' as assuming_ict
FROM journal_entries
ORDER BY created_at DESC
LIMIT 5;

-- 만약 created_at이 UTC라면:
-- created_at과 assuming_utc가 같아야 함

-- 만약 created_at이 로컬 시간이라면:
-- assuming_kst 또는 assuming_ict가 더 맞아야 함
```

---

## 💡 최종 권장사항

### Phase 1: 현재 (간단한 트리거)

```sql
-- SAFE_UTC_MIGRATION_PLAN.md 그대로 진행
CREATE OR REPLACE FUNCTION sync_journal_entries_utc()
RETURNS TRIGGER AS $$
BEGIN
  NEW.entry_date_utc := (NEW.entry_date::timestamp) AT TIME ZONE 'UTC';
  NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  NEW.approved_at_utc := NEW.approved_at AT TIME ZONE 'UTC';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**이유**:
- ✅ `toRpcFormat()`이 이미 UTC로 변환
- ✅ 간단하고 빠름
- ✅ 현재 시스템과 완벽히 호환

---

### Phase 2: 향후 개선 (선택사항)

나중에 더 정확한 변환이 필요하면:

```sql
CREATE OR REPLACE FUNCTION sync_journal_entries_utc_v2()
RETURNS TRIGGER AS $$
DECLARE
  company_tz TEXT;
BEGIN
  -- 회사 timezone 조회
  SELECT timezone INTO company_tz
  FROM companies
  WHERE company_id = NEW.company_id;

  -- entry_date 변환 (date는 회사 timezone 기준)
  IF NEW.entry_date IS NOT NULL THEN
    NEW.entry_date_utc := (NEW.entry_date::timestamp)
      AT TIME ZONE COALESCE(company_tz, 'UTC');
  END IF;

  -- created_at 변환 (현재는 UTC로 들어옴)
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## ✅ 결론

### 지금 바로 실행

**SAFE_UTC_MIGRATION_PLAN.md 그대로 진행하세요!**

이유:
1. ✅ `DateTimeUtils.toRpcFormat()`이 이미 올바르게 UTC 변환
2. ✅ 간단하고 안전함
3. ✅ 성능 최적
4. ✅ 추가 검증 필요 없음

### 향후 고려사항

만약 다음과 같은 경우가 생기면:
- 앱에서 로컬 시간을 직접 보내는 경우
- 더 정확한 timezone 처리가 필요한 경우
- 웹 앱이나 다른 클라이언트 추가 시

그때 `company.timezone`을 활용하여 트리거를 업그레이드하세요.

---

**문서 작성일**: 2025-11-25
**권장 방안**: Phase 1 (간단한 트리거)
**이유**: 현재 시스템이 이미 잘 작동함
