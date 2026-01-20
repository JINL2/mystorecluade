-- ============================================================================
-- Migration: Add Store-Location Validation to insert_journal_with_everything_utc
-- Date: 2026-01-16
-- Purpose: Prevent cross-store journal entries by validating that cash_location
--          belongs to the specified store before inserting journal_lines
-- ============================================================================
--
-- Problem:
--   journal_lines.store_id와 cash_locations.store_id가 불일치하는 거래 29건 발견
--   원인: cash_location_id가 p_store_id에 속하는지 검증 없이 INSERT 수행
--
-- Solution:
--   cash_location 변수 설정 직후, debt 처리 전에 검증 로직 추가
--   - cash_location이 NULL이 아니고
--   - p_store_id가 NULL이 아니면
--   - cash_locations 테이블에서 해당 location이 해당 store에 속하는지 확인
--   - 속하지 않으면 EXCEPTION 발생 → 트랜잭션 롤백
-- ============================================================================

CREATE OR REPLACE FUNCTION insert_journal_with_everything_utc(
  p_base_amount NUMERIC,
  p_company_id UUID,
  p_created_by UUID,
  p_description TEXT,
  p_entry_date_utc TIMESTAMPTZ,
  p_lines JSONB,
  p_counterparty_id TEXT DEFAULT NULL,
  p_if_cash_location_id TEXT DEFAULT NULL,
  p_store_id TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  new_journal_id UUID;
  _line_id UUID;
  line JSONB;
  total_debit NUMERIC := 0;
  total_credit NUMERIC := 0;
  has_cash BOOLEAN;
  cash_location UUID;
  new_debt_id UUID;
  debt_counterparty_id UUID;
  original_amt NUMERIC;
  currency_id UUID;
  exchange_rate NUMERIC;
  _period_id UUID;
  _linked_company_id UUID;
  _linked_company_store_id UUID;
  _linked_company_count INT := 0;
  _if_cash_location_uuid UUID;
  _balancing_account_id UUID;
  new_mirror_journal_id UUID;
  new_mirror_line1_id UUID;
  new_mirror_line2_id UUID;
  _mirror_period_id UUID;
BEGIN
  -- ========================================
  -- 1. 기본값 설정
  -- ========================================
  currency_id := (SELECT c.default_currency_id FROM companies c WHERE c.company_id = p_company_id);
  exchange_rate := 1.0;

  -- ========================================
  -- 2. 회계기간 조회 (TIMESTAMPTZ → DATE 변환)
  -- ========================================
  SELECT ap.period_id INTO _period_id
  FROM accounting_periods ap
  WHERE ap.company_id = p_company_id
    AND (p_entry_date_utc AT TIME ZONE 'UTC')::DATE BETWEEN ap.start_date AND ap.end_date
    AND ap.is_closed = false
  LIMIT 1;

  IF _period_id IS NULL THEN
    RAISE EXCEPTION '해당 날짜에 열려 있는 회계 기간이 없습니다: %', p_entry_date_utc;
  END IF;

  -- ========================================
  -- 3. p_if_cash_location_id 파싱
  -- ========================================
  IF p_if_cash_location_id IS NOT NULL AND p_if_cash_location_id NOT IN ('', 'null') THEN
    _if_cash_location_uuid := NULLIF(NULLIF(p_if_cash_location_id, ''), 'null')::UUID;
  ELSE
    _if_cash_location_uuid := NULL;
  END IF;

  -- ========================================
  -- 4. 라인별 유효성 검사 및 합계 계산
  -- ========================================
  FOR line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    -- 4-1. account_id 유효성 검사
    IF line->>'account_id' IS NULL OR line->>'account_id' = '' THEN
      RAISE EXCEPTION '라인에 account_id가 없습니다: %', line;
    END IF;

    BEGIN
      PERFORM (line->>'account_id')::UUID;
    EXCEPTION WHEN OTHERS THEN
      RAISE EXCEPTION '라인에 account_id가 UUID가 아닙니다: %', line;
    END;

    -- 4-2. account_id 존재 확인
    IF NOT EXISTS (SELECT 1 FROM accounts WHERE account_id = (line->>'account_id')::UUID) THEN
      RAISE EXCEPTION '라인에 account_id가 존재하지 않습니다: %', line;
    END IF;

    -- 4-3. debit, credit 숫자형 검사
    IF line->>'debit' IS NOT NULL AND line->>'debit' != '' THEN
      BEGIN
        PERFORM (line->>'debit')::NUMERIC;
      EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION '라인에 debit이 숫자가 아닙니다: %', line;
      END;
    END IF;

    IF line->>'credit' IS NOT NULL AND line->>'credit' != '' THEN
      BEGIN
        PERFORM (line->>'credit')::NUMERIC;
      EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION '라인에 credit이 숫자가 아닙니다: %', line;
      END;
    END IF;

    -- 4-4. debit, credit 둘 다 없는 경우 검사
    IF (line->>'debit' IS NULL OR line->>'debit' = '' OR (line->>'debit')::NUMERIC = 0)
       AND (line->>'credit' IS NULL OR line->>'credit' = '' OR (line->>'credit')::NUMERIC = 0) THEN
      RAISE EXCEPTION '라인에 debit 또는 credit이 없습니다: %', line;
    END IF;

    -- 4-5. 합계 누적
    total_debit := total_debit + COALESCE((line->>'debit')::NUMERIC, 0);
    total_credit := total_credit + COALESCE((line->>'credit')::NUMERIC, 0);

    -- 4-6. debt 유효성 검사
    IF line ? 'debt' THEN
      IF line->'debt'->>'counterparty_id' IS NULL OR line->'debt'->>'counterparty_id' = '' THEN
        RAISE EXCEPTION 'debt에 counterparty_id가 없습니다: %', line;
      END IF;

      BEGIN
        PERFORM (line->'debt'->>'counterparty_id')::UUID;
      EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'debt의 counterparty_id가 UUID가 아닙니다: %', line;
      END;

      IF NOT EXISTS (SELECT 1 FROM counterparties WHERE counterparty_id = (line->'debt'->>'counterparty_id')::UUID) THEN
        RAISE EXCEPTION 'debt의 counterparty_id가 존재하지 않습니다: %', line;
      END IF;

      IF line->'debt'->>'direction' IS NULL OR line->'debt'->>'direction' = '' THEN
        RAISE EXCEPTION 'debt에 direction이 없습니다: %', line;
      END IF;

      IF line->'debt'->>'direction' NOT IN ('receivable', 'payable') THEN
        RAISE EXCEPTION 'debt의 direction이 유효하지 않습니다: %', line;
      END IF;

      IF line->'debt'->>'category' IS NULL OR line->'debt'->>'category' = '' THEN
        RAISE EXCEPTION 'debt에 category가 없습니다: %', line;
      END IF;

      IF line->'debt'->>'interest_rate' IS NOT NULL AND line->'debt'->>'interest_rate' != '' THEN
        BEGIN
          PERFORM (line->'debt'->>'interest_rate')::NUMERIC;
        EXCEPTION WHEN OTHERS THEN
          RAISE EXCEPTION 'debt의 interest_rate가 숫자가 아닙니다: %', line;
        END;
      END IF;

      -- linked_company 카운트
      IF (line->'debt'->>'counterparty_id') IS NOT NULL THEN
        IF EXISTS (
          SELECT 1 FROM counterparties c
          WHERE c.counterparty_id = (line->'debt'->>'counterparty_id')::UUID
            AND c.linked_company_id IS NOT NULL
        ) THEN
          _linked_company_count := _linked_company_count + 1;
        END IF;
      END IF;

      IF _linked_company_count > 1 THEN
        RAISE EXCEPTION '하나의 분개에는 하나의 linked_company만 허용됩니다.';
      END IF;
    END IF;

    -- 4-7. cash 유효성 검사
    IF line ? 'cash' THEN
      IF line->'cash'->>'cash_location_id' IS NOT NULL
         AND line->'cash'->>'cash_location_id' NOT IN ('', 'null') THEN
        BEGIN
          PERFORM (line->'cash'->>'cash_location_id')::UUID;
        EXCEPTION WHEN OTHERS THEN
          RAISE EXCEPTION 'cash의 cash_location_id가 UUID가 아닙니다: %', line;
        END;
      END IF;
    END IF;

    -- 4-8. fixed_asset 유효성 검사
    IF line ? 'fixed_asset' THEN
      IF line->'fixed_asset'->>'asset_name' IS NULL OR line->'fixed_asset'->>'asset_name' = '' THEN
        RAISE EXCEPTION 'fixed_asset에 asset_name이 없습니다: %', line;
      END IF;

      IF line->'fixed_asset'->>'acquisition_date' IS NULL OR line->'fixed_asset'->>'acquisition_date' = '' THEN
        RAISE EXCEPTION 'fixed_asset에 acquisition_date가 없습니다: %', line;
      END IF;

      IF line->'fixed_asset'->>'useful_life_years' IS NULL OR line->'fixed_asset'->>'useful_life_years' = '' THEN
        RAISE EXCEPTION 'fixed_asset에 useful_life_years가 없습니다: %', line;
      END IF;

      IF line->'fixed_asset'->>'salvage_value' IS NULL OR line->'fixed_asset'->>'salvage_value' = '' THEN
        RAISE EXCEPTION 'fixed_asset에 salvage_value가 없습니다: %', line;
      END IF;
    END IF;
  END LOOP;

  -- ========================================
  -- 5. linked_company 경고 (if_cash_location_id 없음)
  -- ========================================
  IF _linked_company_count > 0 AND _if_cash_location_uuid IS NULL THEN
    RAISE WARNING '[경고] linked_company가 있지만 p_if_cash_location_id가 지정되지 않았습니다. Mirror 분개에서 현금 위치가 누락될 수 있습니다.';
  END IF;

  -- ========================================
  -- 6. 차대 균형 검사
  -- ========================================
  IF total_debit != total_credit THEN
    RAISE EXCEPTION '차변(%)과 대변(%)이 일치하지 않습니다.', total_debit, total_credit;
  END IF;

  -- ========================================
  -- 7. 분개 헤더 INSERT
  -- ========================================
  new_journal_id := gen_random_uuid();

  INSERT INTO journal_entries (
    journal_id, company_id, store_id, entry_date, period_id,
    currency_id, exchange_rate, base_amount, description,
    counterparty_id, created_by, created_at
  ) VALUES (
    new_journal_id, p_company_id, NULLIF(NULLIF(p_store_id, ''), 'null')::UUID, p_entry_date_utc,
    _period_id, currency_id, exchange_rate, total_debit, p_description,
    NULLIF(NULLIF(p_counterparty_id, ''), 'null')::UUID, p_created_by, NOW()
  );

  -- ========================================
  -- 8. 분개 라인 INSERT (각 라인별로)
  -- ========================================
  FOR line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    _line_id := gen_random_uuid();

    -- 8-1. cash_location 파싱
    has_cash := line ? 'cash';
    IF has_cash AND line->'cash'->>'cash_location_id' IS NOT NULL AND line->'cash'->>'cash_location_id' NOT IN ('', 'null') THEN
      cash_location := NULLIF(NULLIF(line->'cash'->>'cash_location_id', ''), 'null')::UUID;
    ELSE
      cash_location := NULL;
    END IF;

    -- ============================================================
    -- 8-2. ★★★ STORE-LOCATION VALIDATION (2026-01-16 추가) ★★★
    -- ============================================================
    -- cash_location이 설정된 경우, 해당 store에 속하는지 검증
    -- 다른 store의 cash_location을 사용하면 무결성 문제 발생
    -- ============================================================
    IF cash_location IS NOT NULL
       AND p_store_id IS NOT NULL
       AND p_store_id NOT IN ('', 'null') THEN
      IF NOT EXISTS (
        SELECT 1 FROM cash_locations
        WHERE id = cash_location
        AND store_id = NULLIF(NULLIF(p_store_id, ''), 'null')::UUID
      ) THEN
        RAISE EXCEPTION 'Integrity Error: cash_location_id (%) does not belong to store_id (%). Cross-store journal entry not allowed.',
          cash_location, p_store_id;
      END IF;
    END IF;
    -- ============================================================
    -- END STORE-LOCATION VALIDATION
    -- ============================================================

    -- 8-3. debt 처리
    IF line ? 'debt' THEN
      new_debt_id := gen_random_uuid();
      debt_counterparty_id := NULLIF(NULLIF(line->'debt'->>'counterparty_id', ''), 'null')::UUID;

      IF debt_counterparty_id IS NULL THEN
        RAISE EXCEPTION 'debt에 counterparty_id가 없습니다.';
      END IF;

      SELECT c.linked_company_id INTO _linked_company_id
      FROM counterparties c
      WHERE c.counterparty_id = debt_counterparty_id;

      _linked_company_store_id := NULLIF(NULLIF(line->'debt'->>'linkedCounterparty_store_id', ''), 'null')::UUID;

      IF _linked_company_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM companies WHERE company_id = _linked_company_id
      ) THEN
        RAISE EXCEPTION 'linked_company_id가 존재하지 않습니다.';
      END IF;

      IF _linked_company_store_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM stores WHERE store_id = _linked_company_store_id
      ) THEN
        RAISE EXCEPTION 'linked_company_store_id가 존재하지 않습니다.';
      END IF;

      original_amt := COALESCE((line->>'debit')::NUMERIC, 0);
      IF original_amt = 0 THEN
        original_amt := COALESCE((line->>'credit')::NUMERIC, 0);
      END IF;

      -- debts_receivable INSERT (issue_date COALESCE 수정 포함)
      INSERT INTO debts_receivable (
        debt_id, company_id, store_id, counterparty_id,
        direction, category, original_amount, remaining_amount,
        currency_id, exchange_rate, interest_rate, issue_date,
        due_date, status, journal_id, journal_line_id,
        created_by, created_at
      ) VALUES (
        new_debt_id, p_company_id, NULLIF(NULLIF(p_store_id, ''), 'null')::UUID, debt_counterparty_id,
        line->'debt'->>'direction', line->'debt'->>'category',
        original_amt, original_amt,
        currency_id, exchange_rate,
        COALESCE((line->'debt'->>'interest_rate')::NUMERIC, 0),
        COALESCE(NULLIF(line->'debt'->>'issue_date', '')::DATE, CURRENT_DATE),
        NULLIF(line->'debt'->>'due_date', '')::DATE,
        'outstanding', new_journal_id, _line_id,
        p_created_by, NOW()
      );
    ELSE
      new_debt_id := NULL;
      debt_counterparty_id := NULL;
    END IF;

    -- 8-4. journal_lines INSERT
    INSERT INTO journal_lines (
      line_id, journal_id, account_id, description,
      debit, credit, store_id, created_at,
      counterparty_id, debt_id, fixed_asset_id, cash_location_id
    ) VALUES (
      _line_id,
      new_journal_id,
      (line->>'account_id')::UUID,
      line->>'description',
      COALESCE((line->>'debit')::NUMERIC, 0),
      COALESCE((line->>'credit')::NUMERIC, 0),
      NULLIF(NULLIF(p_store_id, ''), 'null')::UUID,
      NOW(),
      CASE WHEN line ? 'debt' THEN debt_counterparty_id ELSE NULL END,
      CASE WHEN line ? 'debt' THEN new_debt_id ELSE NULL END,
      NULL,
      cash_location
    );
  END LOOP;

  -- ========================================
  -- 9. Mirror Journal (연결회사) 생성
  -- ========================================
  IF _linked_company_id IS NOT NULL THEN
    new_mirror_journal_id := gen_random_uuid();
    new_mirror_line1_id := gen_random_uuid();
    new_mirror_line2_id := gen_random_uuid();

    SELECT ap.period_id INTO _mirror_period_id
    FROM accounting_periods ap
    WHERE ap.company_id = _linked_company_id
      AND (p_entry_date_utc AT TIME ZONE 'UTC')::DATE BETWEEN ap.start_date AND ap.end_date
      AND ap.is_closed = false
    LIMIT 1;

    IF _mirror_period_id IS NULL THEN
      RAISE EXCEPTION '연결회사에 해당 날짜의 열린 회계 기간이 없습니다: %', p_entry_date_utc;
    END IF;

    SELECT a.account_id INTO _balancing_account_id
    FROM accounts a
    WHERE a.company_id = _linked_company_id
      AND a.account_code = '1000'
    LIMIT 1;

    IF _balancing_account_id IS NULL THEN
      RAISE EXCEPTION '연결회사에 계정 1000이 없습니다.';
    END IF;

    INSERT INTO journal_entries (
      journal_id, company_id, store_id, entry_date, period_id,
      currency_id, exchange_rate, base_amount, description,
      counterparty_id,
      created_by, created_at, is_auto_created
    ) VALUES (
      new_mirror_journal_id, _linked_company_id, _linked_company_store_id,
      p_entry_date_utc, _mirror_period_id,
      currency_id, exchange_rate, total_debit, '[Mirror] ' || p_description,
      NULL,
      p_created_by, NOW(), true
    );

    -- Mirror 분개 라인들 생성
    FOR line IN SELECT * FROM jsonb_array_elements(p_lines)
    LOOP
      IF line ? 'debt' THEN
        INSERT INTO journal_lines (
          line_id, journal_id, account_id, description,
          debit, credit, store_id, created_at,
          counterparty_id, debt_id, fixed_asset_id, cash_location_id
        ) VALUES (
          new_mirror_line1_id, new_mirror_journal_id, (line->>'account_id')::UUID,
          '[Mirror] ' || COALESCE(line->>'description', ''),
          COALESCE((line->>'credit')::NUMERIC, 0),
          COALESCE((line->>'debit')::NUMERIC, 0),
          _linked_company_store_id,
          NOW(),
          debt_counterparty_id,
          NULL,
          NULL,
          NULL
        );

        INSERT INTO journal_lines (
          line_id, journal_id, account_id, description,
          debit, credit, store_id, created_at,
          counterparty_id, debt_id, fixed_asset_id, cash_location_id
        ) VALUES (
          new_mirror_line2_id, new_mirror_journal_id, _balancing_account_id,
          '[Mirror Balance] ' || COALESCE(line->>'description', ''),
          COALESCE((line->>'debit')::NUMERIC, 0),
          COALESCE((line->>'credit')::NUMERIC, 0),
          _linked_company_store_id,
          NOW(),
          NULL,
          NULL,
          NULL,
          _if_cash_location_uuid
        );
      END IF;
    END LOOP;
  END IF;

  RETURN new_journal_id;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION insert_journal_with_everything_utc TO authenticated;
GRANT EXECUTE ON FUNCTION insert_journal_with_everything_utc TO service_role;

-- Add comment
COMMENT ON FUNCTION insert_journal_with_everything_utc IS
'분개 생성 함수 (UTC 버전) - 2026-01-16 Store-Location 검증 추가:
cash_location_id가 p_store_id에 속하는지 검증하여 cross-store 무결성 문제 방지';
