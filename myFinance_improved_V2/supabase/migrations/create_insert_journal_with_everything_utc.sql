-- ============================================
-- 신규 RPC 함수: insert_journal_with_everything_utc
-- 기존 함수를 복사하고 날짜 관련 부분만 UTC로 변경
-- 작성일: 2025-11-25
-- ============================================

CREATE OR REPLACE FUNCTION public.insert_journal_with_everything_utc(
  p_base_amount numeric,
  p_company_id uuid,
  p_created_by uuid,
  p_description text,
  p_entry_date_utc timestamptz,  -- ✅ 변경: timestamp -> timestamptz
  p_lines jsonb,
  p_counterparty_id text DEFAULT NULL::text,
  p_if_cash_location_id text DEFAULT NULL::text,
  p_store_id text DEFAULT NULL::text
)
RETURNS uuid
LANGUAGE plpgsql
AS $function$
DECLARE
  new_journal_id UUID := gen_random_uuid();
  new_debt_id UUID;
  new_asset_id UUID;
  line JSONB;
  currency_id UUID;
  exchange_rate NUMERIC := 1.0;
  _period_id UUID;
  total_debit NUMERIC := 0;
  total_credit NUMERIC := 0;
  original_amt NUMERIC;

  has_cash BOOLEAN;
  cash_location UUID;
  _if_cash_location_uuid UUID := NULLIF(NULLIF(p_if_cash_location_id, ''), 'null')::UUID;

  debt_counterparty_id UUID;
  _linked_company_id UUID;
  _linked_company_store_id UUID;
  _modified_debt JSONB;
  _line_id UUID;

  -- 검증용 변수
  _line_index INT := 0;
  _linked_company_count INT := 0;
  _first_linked_company UUID;
  _temp_counterparty_id UUID;
  _temp_linked_company UUID;
BEGIN
  -- ========================================
  -- 🔍 파라미터 검증 (디버깅 코드)
  -- ========================================

  -- 1. p_lines가 NULL인지 체크
  IF p_lines IS NULL THEN
    RAISE EXCEPTION '[검증 실패] p_lines가 NULL입니다.';
  END IF;

  -- 2. p_lines가 배열인지 체크
  IF jsonb_typeof(p_lines) != 'array' THEN
    RAISE EXCEPTION '[검증 실패] p_lines는 배열이어야 합니다. 현재 타입: %', jsonb_typeof(p_lines);
  END IF;

  -- 3. p_lines가 비어있는지 체크
  IF jsonb_array_length(p_lines) = 0 THEN
    RAISE EXCEPTION '[검증 실패] p_lines가 비어있습니다. 최소 1개 이상의 라인이 필요합니다.';
  END IF;

  -- 4. 각 라인 검증
  FOR line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    _line_index := _line_index + 1;

    -- 4-1. account_id 필수
    IF NOT (line ? 'account_id') OR line->>'account_id' IS NULL OR line->>'account_id' = '' THEN
      RAISE EXCEPTION '[검증 실패] 라인 %: account_id가 없거나 비어있습니다.', _line_index;
    END IF;

    -- 4-2. account_id가 유효한 UUID인지
    BEGIN
      PERFORM (line->>'account_id')::UUID;
    EXCEPTION WHEN OTHERS THEN
      RAISE EXCEPTION '[검증 실패] 라인 %: account_id가 유효한 UUID가 아닙니다. 값: %', _line_index, line->>'account_id';
    END;

    -- 4-3. debit 또는 credit 중 하나는 있어야 함
    IF NOT (line ? 'debit') AND NOT (line ? 'credit') THEN
      RAISE EXCEPTION '[검증 실패] 라인 %: debit 또는 credit 중 하나는 필수입니다.', _line_index;
    END IF;

    -- 4-4. debit이 있으면 숫자인지 체크
    IF line ? 'debit' THEN
      BEGIN
        PERFORM (line->>'debit')::NUMERIC;
      EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: debit이 숫자가 아닙니다. 값: %', _line_index, line->>'debit';
      END;
    END IF;

    -- 4-5. credit이 있으면 숫자인지 체크
    IF line ? 'credit' THEN
      BEGIN
        PERFORM (line->>'credit')::NUMERIC;
      EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: credit이 숫자가 아닙니다. 값: %', _line_index, line->>'credit';
      END;
    END IF;

    -- 4-6. debt 검증
    IF line ? 'debt' THEN
      -- counterparty_id 필수
      IF NOT (line->'debt' ? 'counterparty_id') OR
         line->'debt'->>'counterparty_id' IS NULL OR
         line->'debt'->>'counterparty_id' IN ('', 'null') THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: debt에 counterparty_id가 없습니다.', _line_index;
      END IF;

      -- counterparty_id UUID 검증
      BEGIN
        _temp_counterparty_id := (line->'debt'->>'counterparty_id')::UUID;
      EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: debt의 counterparty_id가 유효한 UUID가 아닙니다. 값: %',
          _line_index, line->'debt'->>'counterparty_id';
      END;

      -- direction 필수
      IF NOT (line->'debt' ? 'direction') OR
         line->'debt'->>'direction' IS NULL OR
         line->'debt'->>'direction' = '' THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: debt에 direction이 없습니다.', _line_index;
      END IF;

      -- direction 값 검증
      IF line->'debt'->>'direction' NOT IN ('receivable', 'payable') THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: debt의 direction은 "receivable" 또는 "payable"이어야 합니다. 현재 값: %',
          _line_index, line->'debt'->>'direction';
      END IF;

      -- category 필수
      IF NOT (line->'debt' ? 'category') OR
         line->'debt'->>'category' IS NULL OR
         line->'debt'->>'category' = '' THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: debt에 category가 없습니다.', _line_index;
      END IF;

      -- interest_rate 검증 (있으면)
      IF line->'debt' ? 'interest_rate' THEN
        BEGIN
          PERFORM (line->'debt'->>'interest_rate')::NUMERIC;
        EXCEPTION WHEN OTHERS THEN
          RAISE EXCEPTION '[검증 실패] 라인 %: debt의 interest_rate가 숫자가 아닙니다. 값: %',
            _line_index, line->'debt'->>'interest_rate';
        END;
      END IF;

      -- linked_company 카운트 (여러 개 체크)
      SELECT c.linked_company_id INTO _temp_linked_company
      FROM counterparties c
      WHERE c.counterparty_id = _temp_counterparty_id;

      IF _temp_linked_company IS NOT NULL THEN
        _linked_company_count := _linked_company_count + 1;

        IF _linked_company_count = 1 THEN
          _first_linked_company := _temp_linked_company;
        ELSIF _first_linked_company != _temp_linked_company THEN
          RAISE EXCEPTION '[검증 실패] 한 저널에 여러 linked_company가 포함되어 있습니다. 현재 구조는 하나의 linked_company만 지원합니다.';
        END IF;
      END IF;
    END IF;

    -- 4-7. cash 검증
    IF line ? 'cash' THEN
      IF line->'cash' ? 'cash_location_id' AND
         line->'cash'->>'cash_location_id' IS NOT NULL AND
         line->'cash'->>'cash_location_id' NOT IN ('', 'null') THEN
        BEGIN
          PERFORM (line->'cash'->>'cash_location_id')::UUID;
        EXCEPTION WHEN OTHERS THEN
          RAISE EXCEPTION '[검증 실패] 라인 %: cash의 cash_location_id가 유효한 UUID가 아닙니다. 값: %',
            _line_index, line->'cash'->>'cash_location_id';
        END;
      END IF;
    END IF;

    -- 4-8. fix_asset 검증
    IF line ? 'fix_asset' THEN
      -- asset_name 필수
      IF NOT (line->'fix_asset' ? 'asset_name') OR
         line->'fix_asset'->>'asset_name' IS NULL OR
         line->'fix_asset'->>'asset_name' = '' THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: fix_asset에 asset_name이 없습니다.', _line_index;
      END IF;

      -- acquisition_date 필수
      IF NOT (line->'fix_asset' ? 'acquisition_date') OR
         line->'fix_asset'->>'acquisition_date' IS NULL OR
         line->'fix_asset'->>'acquisition_date' = '' THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: fix_asset에 acquisition_date가 없습니다.', _line_index;
      END IF;

      -- useful_life_years 필수
      IF NOT (line->'fix_asset' ? 'useful_life_years') OR
         line->'fix_asset'->>'useful_life_years' IS NULL OR
         line->'fix_asset'->>'useful_life_years' = '' THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: fix_asset에 useful_life_years가 없습니다.', _line_index;
      END IF;

      -- salvage_value 필수
      IF NOT (line->'fix_asset' ? 'salvage_value') THEN
        RAISE EXCEPTION '[검증 실패] 라인 %: fix_asset에 salvage_value가 없습니다.', _line_index;
      END IF;
    END IF;

  END LOOP;

  -- 5. linked_company가 있는데 p_if_cash_location_id가 없으면 경고
  IF _linked_company_count > 0 AND _if_cash_location_uuid IS NULL THEN
    RAISE WARNING '[경고] linked_company가 있지만 p_if_cash_location_id가 지정되지 않았습니다. 미러 저널에 현금 위치가 기록되지 않을 수 있습니다.';
  END IF;

  -- ========================================
  -- 🚀 기존 로직 (날짜 부분만 수정)
  -- ========================================

  SELECT c.base_currency_id INTO currency_id
  FROM companies c
  WHERE c.company_id = p_company_id;

  SELECT f.period_id INTO _period_id
  FROM fiscal_periods f
  WHERE f.start_date <= p_entry_date_utc::date AND f.end_date >= p_entry_date_utc::date  -- ✅ 변경
  ORDER BY f.start_date DESC
  LIMIT 1;

  FOR line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    total_debit := total_debit + COALESCE((line->>'debit')::NUMERIC, 0);
    total_credit := total_credit + COALESCE((line->>'credit')::NUMERIC, 0);
  END LOOP;

  IF total_debit != total_credit THEN
    RAISE EXCEPTION '차변과 대변의 합계가 일치하지 않습니다. 차변: %, 대변: %', total_debit, total_credit;
  END IF;

  INSERT INTO journal_entries (
    journal_id, company_id, store_id, entry_date, period_id,
    currency_id, exchange_rate, base_amount, description,
    counterparty_id, created_by, created_at
  ) VALUES (
    new_journal_id, p_company_id, NULLIF(NULLIF(p_store_id, ''), 'null')::UUID, p_entry_date_utc,  -- ✅ 변경
    _period_id, currency_id, exchange_rate, total_debit, p_description,
    NULLIF(NULLIF(p_counterparty_id, ''), 'null')::UUID, p_created_by, NOW()  -- ✅ 변경: p_entry_date -> NOW()
  );

  FOR line IN SELECT * FROM jsonb_array_elements(p_lines)
  LOOP
    _line_id := gen_random_uuid();

    has_cash := line ? 'cash';
    IF has_cash AND line->'cash'->>'cash_location_id' IS NOT NULL AND line->'cash'->>'cash_location_id' NOT IN ('', 'null') THEN
      cash_location := NULLIF(NULLIF(line->'cash'->>'cash_location_id', ''), 'null')::UUID;
    ELSE
      cash_location := NULL;
    END IF;

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

      INSERT INTO debts_receivable (
        debt_id, company_id, store_id, counterparty_id,
        direction, category, account_id, related_journal_id,
        original_amount, remaining_amount, interest_rate,
        interest_account_id, interest_due_day, issue_date, due_date,
        status, description, linked_company_id, linked_company_store_id,
        is_active, created_at
      ) VALUES (
        new_debt_id, p_company_id, NULLIF(NULLIF(p_store_id, ''), 'null')::UUID,
        debt_counterparty_id,
        line->'debt'->>'direction',
        line->'debt'->>'category',
        (line->>'account_id')::UUID,
        new_journal_id,
        original_amt,
        original_amt,
        (line->'debt'->>'interest_rate')::NUMERIC,
        NULLIF(NULLIF(line->'debt'->>'interest_account_id', ''), 'null')::UUID,
        NULLIF(line->'debt'->>'interest_due_day', '')::INT,
        NULLIF(line->'debt'->>'issue_date', '')::DATE,
        NULLIF(line->'debt'->>'due_date', '')::DATE,
        'unpaid',
        line->'debt'->>'description',
        _linked_company_id,
        _linked_company_store_id,
        TRUE,
        NOW()  -- ✅ 변경: p_entry_date -> NOW()
      );

      IF _linked_company_id IS NOT NULL THEN
        _modified_debt := line->'debt';
        _modified_debt := jsonb_set(_modified_debt, '{linkedCounterparty_companyId}', to_jsonb(_linked_company_id::text));
        _modified_debt := jsonb_set(_modified_debt, '{original_amount}', to_jsonb(original_amt));
        _modified_debt := jsonb_set(_modified_debt, '{account_id}', to_jsonb((line->>'account_id')::text));

        PERFORM create_mirror_journal_for_counterparty_utc(
          p_company_id,
          NULLIF(NULLIF(p_store_id, ''), 'null')::UUID,
          _modified_debt,
          p_entry_date_utc,  -- ✅ 변경
          p_description,
          p_created_by,
          p_lines,
          _if_cash_location_uuid
        );
      END IF;
    END IF;

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
      NOW(),  -- ✅ 변경: p_entry_date -> NOW()
      CASE WHEN line ? 'debt' THEN debt_counterparty_id ELSE NULL END,
      CASE WHEN line ? 'debt' THEN new_debt_id ELSE NULL END,
      NULL,
      cash_location
    );

    IF line ? 'fix_asset' THEN
      new_asset_id := gen_random_uuid();
      INSERT INTO fixed_assets (
        asset_id, company_id, store_id, account_id, asset_name,
        acquisition_date, acquisition_cost, useful_life_years, salvage_value,
        depreciation_method_id, related_journal_line_id, is_active, created_at
      ) VALUES (
        new_asset_id,
        p_company_id,
        NULLIF(NULLIF(p_store_id, ''), 'null')::UUID,
        (line->>'account_id')::UUID,
        line->'fix_asset'->>'asset_name',
        (line->'fix_asset'->>'acquisition_date')::DATE,
        COALESCE((line->>'debit')::NUMERIC, (line->>'credit')::NUMERIC, 0),
        (line->'fix_asset'->>'useful_life_years')::INT,
        (line->'fix_asset'->>'salvage_value')::NUMERIC,
        '257c9f28-1b2c-4569-b7e6-5fb347f4b14c'::UUID,
        _line_id,
        TRUE,
        NOW()  -- ✅ 변경: p_entry_date -> NOW()
      );

      UPDATE journal_lines
      SET fixed_asset_id = new_asset_id
      WHERE line_id = _line_id;
    END IF;
  END LOOP;

  RETURN new_journal_id;
END;
$function$;

-- ============================================
-- 마이그레이션 완료
-- ============================================
