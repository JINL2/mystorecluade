-- ========================================
-- Cash Ending RPC 함수 수정
-- 문제: 파라미터 개수 불일치
-- 해결: 기존 시그니처에 맞춰 재생성
-- ========================================

-- ========================================
-- 1. RPC 삭제 및 재생성: get_cash_location_balance_summary_v2_utc
-- 기존: 3개 파라미터 (p_company_id, p_location_id, p_current_date)
-- 수정: 1개 파라미터 (p_location_id) - 기존 v2와 동일
-- ========================================

DROP FUNCTION IF EXISTS get_cash_location_balance_summary_v2_utc(uuid, uuid, text);

CREATE OR REPLACE FUNCTION get_cash_location_balance_summary_v2_utc(
  p_location_id uuid  -- ✅ 파라미터 1개만 (기존과 동일)
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_location_type text;
  v_company_id uuid;
  v_current_date date;
  v_result json;
BEGIN
  -- 현재 날짜 (서버 시간 기준)
  v_current_date := CURRENT_DATE;

  -- 위치 정보 조회 (타입과 company_id)
  SELECT location_type, company_id
  INTO v_location_type, v_company_id
  FROM cash_locations
  WHERE location_id = p_location_id;

  -- 위치가 없으면 에러
  IF v_location_type IS NULL THEN
    RAISE EXCEPTION 'Location not found: %', p_location_id;
  END IF;

  -- 위치 타입에 따라 다른 테이블 조회
  IF v_location_type = 'cash' THEN
    SELECT json_build_object(
      'success', true,
      'current_balance', COALESCE(
        (SELECT balance_after
         FROM cash_amount_entries
         WHERE company_id = v_company_id
           AND location_id = p_location_id
           AND record_date_utc::date = v_current_date  -- ✅ UTC
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      ),
      'previous_balance', COALESCE(
        (SELECT balance_after
         FROM cash_amount_entries
         WHERE company_id = v_company_id
           AND location_id = p_location_id
           AND record_date_utc::date < v_current_date  -- ✅ UTC
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      ),
      'location_type', v_location_type,
      'current_date', v_current_date
    ) INTO v_result;

  ELSIF v_location_type = 'vault' THEN
    SELECT json_build_object(
      'success', true,
      'current_balance', COALESCE(
        (SELECT SUM(debit - credit)
         FROM vault_amount_line
         WHERE company_id = v_company_id
           AND location_id = p_location_id
           AND record_date_utc::date <= v_current_date), 0  -- ✅ UTC
      ),
      'previous_balance', COALESCE(
        (SELECT SUM(debit - credit)
         FROM vault_amount_line
         WHERE company_id = v_company_id
           AND location_id = p_location_id
           AND record_date_utc::date < v_current_date), 0   -- ✅ UTC
      ),
      'location_type', v_location_type,
      'current_date', v_current_date
    ) INTO v_result;

  ELSIF v_location_type = 'bank' THEN
    SELECT json_build_object(
      'success', true,
      'current_balance', COALESCE(
        (SELECT total_amount
         FROM bank_amount
         WHERE company_id = v_company_id
           AND location_id = p_location_id
           AND record_date_utc::date = v_current_date  -- ✅ UTC
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      ),
      'previous_balance', COALESCE(
        (SELECT total_amount
         FROM bank_amount
         WHERE company_id = v_company_id
           AND location_id = p_location_id
           AND record_date_utc::date < v_current_date  -- ✅ UTC
         ORDER BY created_at_utc DESC
         LIMIT 1), 0
      ),
      'location_type', v_location_type,
      'current_date', v_current_date
    ) INTO v_result;
  ELSE
    -- 알 수 없는 타입
    v_result := json_build_object(
      'success', false,
      'error', 'Unknown location type: ' || v_location_type
    );
  END IF;

  RETURN v_result;
END;
$$;

-- ========================================
-- 2. RPC 수정: get_multiple_locations_balance_summary_utc
-- p_date 파라미터 제거, 현재 날짜 사용
-- ========================================

DROP FUNCTION IF EXISTS get_multiple_locations_balance_summary_utc(uuid, uuid[], text);

CREATE OR REPLACE FUNCTION get_multiple_locations_balance_summary_utc(
  p_company_id uuid,
  p_location_ids uuid[]  -- ✅ p_date 파라미터 제거
)
RETURNS json
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN (
    SELECT json_build_object(
      'success', true,
      'locations', json_agg(
        json_build_object(
          'location_id', loc.location_id,
          'location_name', loc.location_name,
          'location_type', loc.location_type,
          'balance', get_cash_location_balance_summary_v2_utc(loc.location_id)
        )
      )
    )
    FROM cash_locations loc
    WHERE loc.company_id = p_company_id
      AND loc.location_id = ANY(p_location_ids)
  );
END;
$$;

-- ========================================
-- 3. RPC 수정: get_company_balance_summary_utc
-- p_date 파라미터 제거, 현재 날짜 사용
-- ========================================

DROP FUNCTION IF EXISTS get_company_balance_summary_utc(uuid, text);

CREATE OR REPLACE FUNCTION get_company_balance_summary_utc(
  p_company_id uuid,
  p_location_type text DEFAULT NULL  -- ✅ p_date 제거, location_type 추가
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_current_date date;
BEGIN
  v_current_date := CURRENT_DATE;

  RETURN (
    SELECT json_build_object(
      'success', true,
      'current_date', v_current_date,
      'total_cash', COALESCE(
        (SELECT SUM(balance_after)
         FROM cash_amount_entries
         WHERE company_id = p_company_id
           AND record_date_utc::date = v_current_date  -- ✅ UTC
           AND (p_location_type IS NULL OR
                location_id IN (
                  SELECT location_id FROM cash_locations
                  WHERE company_id = p_company_id
                  AND location_type = p_location_type
                ))
           AND entry_id IN (
             SELECT DISTINCT ON (location_id) entry_id
             FROM cash_amount_entries
             WHERE company_id = p_company_id
               AND record_date_utc::date = v_current_date  -- ✅ UTC
             ORDER BY location_id, created_at_utc DESC
           )), 0
      ),
      'total_vault', COALESCE(
        (SELECT SUM(debit - credit)
         FROM vault_amount_line
         WHERE company_id = p_company_id
           AND record_date_utc::date <= v_current_date  -- ✅ UTC
           AND (p_location_type IS NULL OR p_location_type = 'vault')), 0
      ),
      'total_bank', COALESCE(
        (SELECT SUM(total_amount)
         FROM bank_amount
         WHERE company_id = p_company_id
           AND record_date_utc::date = v_current_date  -- ✅ UTC
           AND (p_location_type IS NULL OR p_location_type = 'bank')), 0
      )
    )
  );
END;
$$;

-- ========================================
-- 4. 테스트 쿼리
-- ========================================

-- 테스트 1: get_cash_location_balance_summary_v2_utc (1개 파라미터)
SELECT get_cash_location_balance_summary_v2_utc(
  (SELECT location_id FROM cash_locations WHERE location_type = 'cash' LIMIT 1)
);

-- 테스트 2: get_multiple_locations_balance_summary_utc (2개 파라미터)
SELECT get_multiple_locations_balance_summary_utc(
  (SELECT company_id FROM cash_locations LIMIT 1),
  ARRAY(SELECT location_id FROM cash_locations LIMIT 3)
);

-- 테스트 3: get_company_balance_summary_utc (1-2개 파라미터)
SELECT get_company_balance_summary_utc(
  (SELECT company_id FROM cash_locations LIMIT 1),
  NULL  -- 모든 타입
);

-- ========================================
-- 5. 검증
-- ========================================

-- 함수 시그니처 확인
SELECT
  p.proname as function_name,
  pg_get_function_arguments(p.oid) as parameters,
  pg_get_function_result(p.oid) as return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.proname LIKE '%balance_summary%utc';
