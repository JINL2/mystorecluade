-- ========================================
-- journal_amount_stock_flow UTC 트리거 추가
-- ========================================

-- 1. 기존 데이터 마이그레이션 (NULL인 UTC 컬럼 채우기)
UPDATE journal_amount_stock_flow
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  system_time_utc = system_time AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL OR system_time_utc IS NULL;

-- 2. 트리거 함수 생성
CREATE OR REPLACE FUNCTION sync_journal_stock_flow_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- created_at_utc 동기화
  IF NEW.created_at IS NOT NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  -- system_time_utc 동기화
  IF NEW.system_time IS NOT NULL THEN
    NEW.system_time_utc := NEW.system_time AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. 트리거 생성
DROP TRIGGER IF EXISTS trigger_sync_journal_stock_flow_utc ON journal_amount_stock_flow;

CREATE TRIGGER trigger_sync_journal_stock_flow_utc
  BEFORE INSERT OR UPDATE ON journal_amount_stock_flow
  FOR EACH ROW
  EXECUTE FUNCTION sync_journal_stock_flow_utc();

-- 4. 검증 쿼리
-- 기존 NULL 데이터가 업데이트 되었는지 확인
SELECT
  COUNT(*) as total_rows,
  COUNT(created_at_utc) as has_created_at_utc,
  COUNT(system_time_utc) as has_system_time_utc,
  COUNT(*) - COUNT(created_at_utc) as null_created_at_utc,
  COUNT(*) - COUNT(system_time_utc) as null_system_time_utc
FROM journal_amount_stock_flow;

-- 샘플 데이터 확인
SELECT
  flow_id,
  created_at,
  created_at_utc,
  system_time,
  system_time_utc
FROM journal_amount_stock_flow
ORDER BY system_time DESC
LIMIT 5;
