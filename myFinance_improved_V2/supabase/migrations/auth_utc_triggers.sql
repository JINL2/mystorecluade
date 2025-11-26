-- ============================================================================
-- Auth Feature UTC 마이그레이션 트리거
-- ============================================================================
-- 목적: created_at, updated_at, deleted_at을 자동으로 _utc 컬럼에 동기화
-- 작성일: 2025-11-24
-- 대상 테이블: companies, users, stores, user_companies, user_stores
-- ============================================================================

-- ============================================================================
-- Step 1: 트리거 함수 생성 (모든 테이블에서 재사용)
-- ============================================================================

CREATE OR REPLACE FUNCTION sync_timestamp_to_utc()
RETURNS TRIGGER AS $$
BEGIN
  -- created_at 동기화
  -- created_at이 있고, created_at_utc가 NULL이면 자동으로 채우기
  IF NEW.created_at IS NOT NULL AND NEW.created_at_utc IS NULL THEN
    NEW.created_at_utc := NEW.created_at AT TIME ZONE 'UTC';
  END IF;

  -- updated_at 동기화
  -- updated_at이 있으면 항상 updated_at_utc 업데이트
  IF NEW.updated_at IS NOT NULL THEN
    NEW.updated_at_utc := NEW.updated_at AT TIME ZONE 'UTC';
  END IF;

  -- deleted_at 동기화
  -- deleted_at이 있고, deleted_at_utc가 NULL이면 자동으로 채우기
  IF NEW.deleted_at IS NOT NULL AND NEW.deleted_at_utc IS NULL THEN
    NEW.deleted_at_utc := NEW.deleted_at AT TIME ZONE 'UTC';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION sync_timestamp_to_utc() IS
'Automatically sync timestamp columns to their UTC equivalents (_utc suffix)';

-- ============================================================================
-- Step 2: 기존 트리거 삭제 (있을 경우)
-- ============================================================================

DROP TRIGGER IF EXISTS sync_companies_timestamp_to_utc ON companies;
DROP TRIGGER IF EXISTS sync_users_timestamp_to_utc ON users;
DROP TRIGGER IF EXISTS sync_stores_timestamp_to_utc ON stores;
DROP TRIGGER IF EXISTS sync_user_companies_timestamp_to_utc ON user_companies;
DROP TRIGGER IF EXISTS sync_user_stores_timestamp_to_utc ON user_stores;

-- ============================================================================
-- Step 3: 각 테이블에 트리거 적용
-- ============================================================================

-- 3.1 companies 테이블
CREATE TRIGGER sync_companies_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

COMMENT ON TRIGGER sync_companies_timestamp_to_utc ON companies IS
'Auto-sync created_at, updated_at, deleted_at to UTC columns';

-- 3.2 users 테이블
CREATE TRIGGER sync_users_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

COMMENT ON TRIGGER sync_users_timestamp_to_utc ON users IS
'Auto-sync created_at, updated_at, deleted_at to UTC columns';

-- 3.3 stores 테이블
CREATE TRIGGER sync_stores_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

COMMENT ON TRIGGER sync_stores_timestamp_to_utc ON stores IS
'Auto-sync created_at, updated_at, deleted_at to UTC columns';

-- 3.4 user_companies 테이블
CREATE TRIGGER sync_user_companies_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON user_companies
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

COMMENT ON TRIGGER sync_user_companies_timestamp_to_utc ON user_companies IS
'Auto-sync created_at, updated_at, deleted_at to UTC columns';

-- 3.5 user_stores 테이블
CREATE TRIGGER sync_user_stores_timestamp_to_utc
  BEFORE INSERT OR UPDATE ON user_stores
  FOR EACH ROW
  EXECUTE FUNCTION sync_timestamp_to_utc();

COMMENT ON TRIGGER sync_user_stores_timestamp_to_utc ON user_stores IS
'Auto-sync created_at, updated_at, deleted_at to UTC columns';

-- ============================================================================
-- Step 4: 기존 데이터 마이그레이션 (NULL인 데이터 채우기)
-- ============================================================================

-- 4.1 companies 테이블
UPDATE companies
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  updated_at_utc = updated_at AT TIME ZONE 'UTC',
  deleted_at_utc = CASE
    WHEN deleted_at IS NOT NULL THEN deleted_at AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE created_at_utc IS NULL
   OR updated_at_utc IS NULL
   OR (deleted_at IS NOT NULL AND deleted_at_utc IS NULL);

-- 4.2 users 테이블
UPDATE users
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  updated_at_utc = updated_at AT TIME ZONE 'UTC',
  deleted_at_utc = CASE
    WHEN deleted_at IS NOT NULL THEN deleted_at AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE created_at_utc IS NULL
   OR updated_at_utc IS NULL
   OR (deleted_at IS NOT NULL AND deleted_at_utc IS NULL);

-- 4.3 stores 테이블
UPDATE stores
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  updated_at_utc = updated_at AT TIME ZONE 'UTC',
  deleted_at_utc = CASE
    WHEN deleted_at IS NOT NULL THEN deleted_at AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE created_at_utc IS NULL
   OR updated_at_utc IS NULL
   OR (deleted_at IS NOT NULL AND deleted_at_utc IS NULL);

-- 4.4 user_companies 테이블
UPDATE user_companies
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  updated_at_utc = updated_at AT TIME ZONE 'UTC',
  deleted_at_utc = CASE
    WHEN deleted_at IS NOT NULL THEN deleted_at AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE created_at_utc IS NULL
   OR updated_at_utc IS NULL
   OR (deleted_at IS NOT NULL AND deleted_at_utc IS NULL);

-- 4.5 user_stores 테이블
UPDATE user_stores
SET
  created_at_utc = created_at AT TIME ZONE 'UTC',
  updated_at_utc = updated_at AT TIME ZONE 'UTC',
  deleted_at_utc = CASE
    WHEN deleted_at IS NOT NULL THEN deleted_at AT TIME ZONE 'UTC'
    ELSE NULL
  END
WHERE created_at_utc IS NULL
   OR updated_at_utc IS NULL
   OR (deleted_at IS NOT NULL AND deleted_at_utc IS NULL);

-- ============================================================================
-- Step 5: 검증 쿼리
-- ============================================================================

-- 5.1 각 테이블의 UTC 컬럼 채움률 확인
SELECT
  'companies' as table_name,
  COUNT(*) as total_rows,
  COUNT(created_at_utc) as utc_filled,
  COUNT(*) - COUNT(created_at_utc) as utc_missing,
  ROUND(100.0 * COUNT(created_at_utc) / NULLIF(COUNT(*), 0), 2) as fill_percentage
FROM companies

UNION ALL

SELECT
  'users',
  COUNT(*),
  COUNT(created_at_utc),
  COUNT(*) - COUNT(created_at_utc),
  ROUND(100.0 * COUNT(created_at_utc) / NULLIF(COUNT(*), 0), 2)
FROM users

UNION ALL

SELECT
  'stores',
  COUNT(*),
  COUNT(created_at_utc),
  COUNT(*) - COUNT(created_at_utc),
  ROUND(100.0 * COUNT(created_at_utc) / NULLIF(COUNT(*), 0), 2)
FROM stores

UNION ALL

SELECT
  'user_companies',
  COUNT(*),
  COUNT(created_at_utc),
  COUNT(*) - COUNT(created_at_utc),
  ROUND(100.0 * COUNT(created_at_utc) / NULLIF(COUNT(*), 0), 2)
FROM user_companies

UNION ALL

SELECT
  'user_stores',
  COUNT(*),
  COUNT(created_at_utc),
  COUNT(*) - COUNT(created_at_utc),
  ROUND(100.0 * COUNT(created_at_utc) / NULLIF(COUNT(*), 0), 2)
FROM user_stores;

-- 5.2 데이터 일치 여부 확인 (샘플)
SELECT
  'companies' as table_name,
  company_id as record_id,
  created_at,
  created_at_utc,
  CASE
    WHEN created_at::timestamptz = created_at_utc THEN 'OK'
    ELSE 'MISMATCH'
  END as sync_status
FROM companies
WHERE created_at_utc IS NOT NULL
LIMIT 5;

-- ============================================================================
-- Step 6: 트리거 테스트
-- ============================================================================

-- 6.1 테스트 데이터 INSERT (created_at 전달 안 함)
DO $$
DECLARE
  test_company_id UUID;
BEGIN
  INSERT INTO companies (
    company_id,
    company_name,
    owner_id,
    company_type_id
  ) VALUES (
    gen_random_uuid(),
    'Trigger Test Company',
    (SELECT user_id FROM users LIMIT 1),
    (SELECT company_type_id FROM company_types LIMIT 1)
  ) RETURNING company_id INTO test_company_id;

  -- 결과 확인
  RAISE NOTICE 'Test company created: %', test_company_id;

  -- UTC 컬럼이 자동으로 채워졌는지 확인
  PERFORM 1 FROM companies
  WHERE company_id = test_company_id
    AND created_at_utc IS NOT NULL;

  IF FOUND THEN
    RAISE NOTICE '✅ Trigger working: created_at_utc is filled automatically';
  ELSE
    RAISE WARNING '❌ Trigger not working: created_at_utc is NULL';
  END IF;

  -- 테스트 데이터 삭제
  DELETE FROM companies WHERE company_id = test_company_id;
  RAISE NOTICE 'Test data cleaned up';
END $$;

-- ============================================================================
-- 완료 메시지
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '============================================================================';
  RAISE NOTICE '✅ Auth Feature UTC 마이그레이션 완료!';
  RAISE NOTICE '============================================================================';
  RAISE NOTICE '';
  RAISE NOTICE '설치된 트리거:';
  RAISE NOTICE '  - companies: sync_companies_timestamp_to_utc';
  RAISE NOTICE '  - users: sync_users_timestamp_to_utc';
  RAISE NOTICE '  - stores: sync_stores_timestamp_to_utc';
  RAISE NOTICE '  - user_companies: sync_user_companies_timestamp_to_utc';
  RAISE NOTICE '  - user_stores: sync_user_stores_timestamp_to_utc';
  RAISE NOTICE '';
  RAISE NOTICE '다음 단계:';
  RAISE NOTICE '  1. 위의 검증 쿼리 결과 확인';
  RAISE NOTICE '  2. fill_percentage가 100%인지 확인';
  RAISE NOTICE '  3. Flutter 앱 테스트 (INSERT/UPDATE)';
  RAISE NOTICE '  4. 데이터베이스에서 _utc 컬럼 값 확인';
  RAISE NOTICE '';
  RAISE NOTICE '============================================================================';
END $$;
