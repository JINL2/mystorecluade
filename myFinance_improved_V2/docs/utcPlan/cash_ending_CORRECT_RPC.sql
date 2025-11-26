-- ========================================
-- Cash Ending RPC 함수 - 정확한 시그니처로 재생성
-- 기존 함수와 동일한 파라미터 사용
-- ========================================

-- ========================================
-- 기존 함수 시그니처 (참고용)
-- ========================================
/*
1. get_cash_location_balance_summary_v2(p_location_id uuid)
2. get_multiple_locations_balance_summary(p_location_ids uuid[])
3. get_company_balance_summary(p_company_id uuid, p_location_type text DEFAULT NULL)
4. get_location_stock_flow(p_company_id uuid, p_store_id uuid, p_cash_location_id uuid, p_offset integer DEFAULT 0, p_limit integer DEFAULT 20)
*/

-- ========================================
-- 1. get_cash_location_balance_summary_v2_utc
-- 파라미터: p_location_id uuid (1개만)
-- ========================================

DROP FUNCTION IF EXISTS get_cash_location_balance_summary_v2_utc(uuid);

CREATE OR REPLACE FUNCTION get_cash_location_balance_summary_v2_utc(
  p_location_id uuid  -- ✅ 기존과 동일
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
  -- 현재 날짜
  v_current_date := CURRENT_DATE;

  -- 위치 정보 조회
  SELECT location_type, company_id
  INTO v_location_type, v_company_id
  FROM cash_locations
  WHERE location_id = p_location_id;

  IF v_location_type IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Location not found'
    );
  END IF;

  -- 위치 타입별 조회
  IF v_location_type = 'cash' THEN
    v_result := json_build_object(
      'success', true,
      'current_balance', COALESCE(
        (SELECT balance_after FROM cash_amount_entries
         WHERE location_id = p_location_id
           AND record_date_utc::date = v_current_date
         ORDER BY created_at_utc DESC LIMIT 1), 0
      ),
      'previous_balance', COALESCE(
        (SELECT balance_after FROM cash_amount_entries
         WHERE location_id = p_location_id
           AND record_date_utc::date < v_current_date
         ORDER BY created_at_utc DESC LIMIT 1), 0
      )
    );

  ELSIF v_location_type = 'vault' THEN
    v_result := json_build_object(
      'success', true,
      'current_balance', COALESCE(
        (SELECT SUM(debit - credit) FROM vault_amount_line
         WHERE location_id = p_location_id
           AND record_date_utc::date <= v_current_date), 0
      ),
      'previous_balance', COALESCE(
        (SELECT SUM(debit - credit) FROM vault_amount_line
         WHERE location_id = p_location_id
           AND record_date_utc::date < v_current_date), 0
      )
    );

  ELSIF v_location_type = 'bank' THEN
    v_result := json_build_object(
      'success', true,
      'current_balance', COALESCE(
        (SELECT total_amount FROM bank_amount
         WHERE location_id = p_location_id
           AND record_date_utc::date = v_current_date
         ORDER BY created_at_utc DESC LIMIT 1), 0
      ),
      'previous_balance', COALESCE(
        (SELECT total_amount FROM bank_amount
         WHERE location_id = p_location_id
           AND record_date_utc::date < v_current_date
         ORDER BY created_at_utc DESC LIMIT 1), 0
      )
    );
  END IF;

  RETURN v_result;
END;
$$;

-- ========================================
-- 2. get_multiple_locations_balance_summary_utc
-- 파라미터: p_location_ids uuid[] (1개만)
-- ========================================

DROP FUNCTION IF EXISTS get_multiple_locations_balance_summary_utc(uuid[]);

CREATE OR REPLACE FUNCTION get_multiple_locations_balance_summary_utc(
  p_location_ids uuid[]  -- ✅ 기존과 동일
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
    WHERE loc.location_id = ANY(p_location_ids)
  );
END;
$$;

-- ========================================
-- 3. get_company_balance_summary_utc
-- 파라미터: p_company_id uuid, p_location_type text DEFAULT NULL
-- ========================================

DROP FUNCTION IF EXISTS get_company_balance_summary_utc(uuid, text);

CREATE OR REPLACE FUNCTION get_company_balance_summary_utc(
  p_company_id uuid,
  p_location_type text DEFAULT NULL  -- ✅ 기존과 동일
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_current_date date;
BEGIN
  v_current_date := CURRENT_DATE;

  RETURN json_build_object(
    'success', true,
    'total_cash', COALESCE(
      (SELECT SUM(balance_after) FROM cash_amount_entries
       WHERE company_id = p_company_id
         AND record_date_utc::date = v_current_date
         AND (p_location_type IS NULL OR location_id IN (
           SELECT location_id FROM cash_locations
           WHERE company_id = p_company_id AND location_type = p_location_type
         ))
         AND entry_id IN (
           SELECT DISTINCT ON (location_id) entry_id
           FROM cash_amount_entries
           WHERE company_id = p_company_id
             AND record_date_utc::date = v_current_date
           ORDER BY location_id, created_at_utc DESC
         )), 0
    ),
    'total_vault', COALESCE(
      (SELECT SUM(debit - credit) FROM vault_amount_line
       WHERE company_id = p_company_id
         AND record_date_utc::date <= v_current_date
         AND (p_location_type IS NULL OR p_location_type = 'vault')), 0
    ),
    'total_bank', COALESCE(
      (SELECT SUM(total_amount) FROM bank_amount
       WHERE company_id = p_company_id
         AND record_date_utc::date = v_current_date
         AND (p_location_type IS NULL OR p_location_type = 'bank')), 0
    )
  );
END;
$$;

-- ========================================
-- 4. get_location_stock_flow_utc
-- 파라미터: p_company_id, p_store_id, p_cash_location_id, p_offset, p_limit
-- ========================================

DROP FUNCTION IF EXISTS get_location_stock_flow_utc(uuid, uuid, uuid, integer, integer);

CREATE OR REPLACE FUNCTION get_location_stock_flow_utc(
  p_company_id uuid,
  p_store_id uuid,
  p_cash_location_id uuid,
  p_offset integer DEFAULT 0,
  p_limit integer DEFAULT 20  -- ✅ 기존과 동일
)
RETURNS json
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN (
    SELECT json_build_object(
      'success', true,
      'data', json_build_object(
        'location_summary', (
          SELECT row_to_json(t) FROM (
            SELECT
              location_id as cash_location_id,
              location_name,
              location_type,
              bank_name,
              bank_account_number as bank_account
            FROM cash_locations
            WHERE location_id = p_cash_location_id
          ) t
        ),
        'actual_flows', (
          SELECT json_agg(row_to_json(f))
          FROM (
            SELECT
              flow_id,
              created_at_utc as created_at,        -- ✅ UTC 컬럼
              system_time_utc as system_time,      -- ✅ UTC 컬럼
              balance_before,
              flow_amount,
              balance_after,
              denomination_details as current_denominations,
              (SELECT row_to_json(c) FROM (
                SELECT currency_id, currency_code, currency_name, symbol
                FROM currency_types WHERE currency_id = csf.currency_id
              ) c) as currency,
              (SELECT row_to_json(u) FROM (
                SELECT user_id, full_name
                FROM user_profiles WHERE user_id = csf.created_by
              ) u) as created_by
            FROM cash_amount_stock_flow csf
            WHERE company_id = p_company_id
              AND store_id = p_store_id
              AND cash_location_id = p_cash_location_id
            ORDER BY created_at_utc DESC
            LIMIT p_limit OFFSET p_offset
          ) f
        )
      ),
      'pagination', json_build_object(
        'offset', p_offset,
        'limit', p_limit,
        'total_actual_flows', (
          SELECT COUNT(*) FROM cash_amount_stock_flow
          WHERE company_id = p_company_id
            AND store_id = p_store_id
            AND cash_location_id = p_cash_location_id
        ),
        'has_more', (
          SELECT COUNT(*) > (p_offset + p_limit)
          FROM cash_amount_stock_flow
          WHERE company_id = p_company_id
            AND store_id = p_store_id
            AND cash_location_id = p_cash_location_id
        )
      )
    )
  );
END;
$$;

-- ========================================
-- 테스트
-- ========================================

-- 1. Balance Summary v2 (1개 파라미터)
SELECT get_cash_location_balance_summary_v2_utc(
  (SELECT location_id FROM cash_locations WHERE location_type = 'cash' LIMIT 1)
);

-- 2. Multiple Balance Summary (1개 파라미터)
SELECT get_multiple_locations_balance_summary_utc(
  ARRAY(SELECT location_id FROM cash_locations LIMIT 3)
);

-- 3. Company Balance Summary (2개 파라미터)
SELECT get_company_balance_summary_utc(
  (SELECT company_id FROM cash_locations LIMIT 1),
  NULL
);

-- 4. Location Stock Flow (5개 파라미터)
SELECT get_location_stock_flow_utc(
  (SELECT company_id FROM cash_amount_stock_flow LIMIT 1),
  (SELECT store_id FROM cash_amount_stock_flow LIMIT 1),
  (SELECT cash_location_id FROM cash_amount_stock_flow LIMIT 1),
  0,
  20
);

-- ========================================
-- 검증: 함수 시그니처 확인
-- ========================================
SELECT
  p.proname as function_name,
  pg_get_function_arguments(p.oid) as parameters
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.proname LIKE '%_utc'
ORDER BY p.proname;
