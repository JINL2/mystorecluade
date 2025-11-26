-- ============================================
-- 신규 RPC 함수: create_mirror_journal_for_counterparty_utc
-- 기존 함수를 복사하고 날짜 관련 부분만 UTC로 변경
-- 작성일: 2025-11-25
-- ============================================

CREATE OR REPLACE FUNCTION public.create_mirror_journal_for_counterparty_utc(
  p_company_id uuid,
  p_store_id uuid,
  p_debt jsonb,
  p_entry_date_utc timestamptz,  -- ✅ 변경: timestamp -> timestamptz
  p_description text,
  p_created_by uuid,
  p_lines jsonb,
  p_if_cash_location_id uuid DEFAULT NULL::uuid
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
  new_mirror_journal_id UUID := gen_random_uuid();
  new_mirror_debt_id UUID := gen_random_uuid();
  new_mirror_line1_id UUID := gen_random_uuid();
  new_mirror_line2_id UUID := gen_random_uuid();

  _linked_company_id UUID;
  _linked_company_store_id UUID;
  _original_direction TEXT := p_debt->>'direction';
  _reverse_direction TEXT;

  _mirror_counterparty_id UUID;
  _mirror_account_id UUID;
  _balancing_account_id UUID;
  _original_account_id UUID := (p_debt->>'account_id')::UUID;

  _period_id UUID;
  _currency_id UUID;
  _amount NUMERIC := (p_debt->>'original_amount')::NUMERIC;

  _original_debt_debit NUMERIC;
  _original_debt_credit NUMERIC;
  _original_cash_debit NUMERIC;
  _original_cash_credit NUMERIC;
  _mirror_debt_debit NUMERIC;
  _mirror_debt_credit NUMERIC;
  _mirror_cash_debit NUMERIC;
  _mirror_cash_credit NUMERIC;
  _duplicate_check UUID;

BEGIN
  -- 기본 검증
  IF p_debt->>'linkedCounterparty_companyId' IS NULL OR p_debt->>'linkedCounterparty_companyId' = '' THEN
    RETURN;
  END IF;

  _linked_company_id := (p_debt->>'linkedCounterparty_companyId')::UUID;
  _linked_company_store_id := NULLIF(p_debt->>'linkedCounterparty_store_id', '')::UUID;

  -- 원본 전표의 Debit/Credit 위치 파악
  SELECT
    COALESCE((elem->>'debit')::NUMERIC, 0),
    COALESCE((elem->>'credit')::NUMERIC, 0)
  INTO
    _original_debt_debit,
    _original_debt_credit
  FROM jsonb_array_elements(p_lines) elem
  WHERE elem ? 'debt'
  LIMIT 1;

  -- Cash 계정의 Debit/Credit 파악
  SELECT
    COALESCE((elem->>'debit')::NUMERIC, 0),
    COALESCE((elem->>'credit')::NUMERIC, 0)
  INTO
    _original_cash_debit,
    _original_cash_credit
  FROM jsonb_array_elements(p_lines) elem
  WHERE NOT (elem ? 'debt')
  LIMIT 1;

  -- Mirror 전표의 Debit/Credit 계산 (정확히 반대로!)
  _mirror_debt_debit := _original_debt_credit;
  _mirror_debt_credit := _original_debt_debit;
  _mirror_cash_debit := _original_cash_credit;
  _mirror_cash_credit := _original_cash_debit;

  -- 무결성 체크
  IF (_mirror_debt_debit + _mirror_cash_debit) != (_mirror_debt_credit + _mirror_cash_credit) THEN
    RAISE EXCEPTION '❌ Mirror 전표 대차불균형: Dr=%, Cr=%',
      (_mirror_debt_debit + _mirror_cash_debit),
      (_mirror_debt_credit + _mirror_cash_credit);
  END IF;

  -- direction 설정
  IF _original_direction = 'payable' THEN
    _reverse_direction := 'receivable';
  ELSIF _original_direction = 'receivable' THEN
    _reverse_direction := 'payable';
  ELSE
    RAISE EXCEPTION '❌ 잘못된 direction: %', _original_direction;
  END IF;

  -- Counterparty 찾기
  SELECT c.counterparty_id INTO _mirror_counterparty_id
  FROM counterparties c
  WHERE c.company_id = _linked_company_id
    AND c.linked_company_id = p_company_id
  LIMIT 1;

  IF _mirror_counterparty_id IS NULL THEN
    RAISE EXCEPTION '❌ 상대방이 나를 등록한 counterparty_id를 찾을 수 없습니다';
  END IF;

  -- Account Mapping 찾기
  SELECT a.linked_account_id INTO _mirror_account_id
  FROM account_mappings a
  WHERE a.my_company_id = p_company_id
    AND a.counterparty_id = (p_debt->>'counterparty_id')::UUID
    AND a.my_account_id = _original_account_id
  LIMIT 1;

  IF _mirror_account_id IS NULL THEN
    RAISE EXCEPTION '❌ linked_account_id를 찾을 수 없습니다';
  END IF;

  -- Balancing Account 찾기
  SELECT (elem->>'account_id')::UUID INTO _balancing_account_id
  FROM jsonb_array_elements(p_lines) elem
  WHERE NOT (elem ? 'debt')
  LIMIT 1;

  -- Period와 Currency 설정
  SELECT f.period_id INTO _period_id
  FROM fiscal_periods f
  WHERE f.start_date <= p_entry_date_utc::date AND f.end_date >= p_entry_date_utc::date  -- ✅ 변경
  ORDER BY f.start_date DESC LIMIT 1;

  SELECT c.base_currency_id INTO _currency_id
  FROM companies c
  WHERE c.company_id = _linked_company_id;

  -- ✅ 수정: Journal Entry 생성 (counterparty_id 추가!)
  INSERT INTO journal_entries (
    journal_id, company_id, store_id, entry_date, period_id,
    currency_id, exchange_rate, base_amount, description,
    counterparty_id,
    created_by, created_at, is_auto_created
  ) VALUES (
    new_mirror_journal_id, _linked_company_id, _linked_company_store_id,
    p_entry_date_utc, _period_id, _currency_id, 1.0, _amount,  -- ✅ 변경
    COALESCE(p_description, '') || ' [Mirror]',
    _mirror_counterparty_id,
    p_created_by, NOW(), TRUE  -- ✅ 변경: p_entry_date -> NOW()
  );

  -- Debt 생성
  INSERT INTO debts_receivable (
    debt_id, company_id, store_id, counterparty_id,
    direction, category, account_id, related_journal_id,
    original_amount, remaining_amount, interest_rate,
    interest_account_id, interest_due_day, issue_date, due_date,
    status, description, linked_company_id, linked_company_store_id,
    is_active, created_at
  ) VALUES (
    new_mirror_debt_id, _linked_company_id, _linked_company_store_id, _mirror_counterparty_id,
    _reverse_direction, p_debt->>'category', _mirror_account_id, new_mirror_journal_id,
    _amount, _amount,
    (p_debt->>'interest_rate')::NUMERIC,
    NULLIF(p_debt->>'interest_account_id', '')::UUID,
    (p_debt->>'interest_due_day')::INT,
    (p_debt->>'issue_date')::DATE,
    (p_debt->>'due_date')::DATE,
    'unpaid', p_debt->>'description',
    p_company_id, p_store_id,
    TRUE, NOW()  -- ✅ 변경: p_entry_date -> NOW()
  );

  -- Journal Line 1: Debt 계정 (Mirror 방향)
  INSERT INTO journal_lines (
    line_id, journal_id, account_id, description,
    debit, credit, store_id, created_at,
    counterparty_id, debt_id
  ) VALUES (
    new_mirror_line1_id, new_mirror_journal_id, _mirror_account_id,
    p_debt->>'description',
    _mirror_debt_debit,
    _mirror_debt_credit,
    _linked_company_store_id, NOW(),  -- ✅ 변경: p_entry_date -> NOW()
    _mirror_counterparty_id, new_mirror_debt_id
  );

  -- Journal Line 2: Cash 계정 (Mirror 방향)
  INSERT INTO journal_lines (
    line_id, journal_id, account_id, description,
    debit, credit, store_id, created_at, cash_location_id
  ) VALUES (
    new_mirror_line2_id, new_mirror_journal_id, _balancing_account_id,
    p_debt->>'description',
    _mirror_cash_debit,
    _mirror_cash_credit,
    _linked_company_store_id, NOW(), p_if_cash_location_id  -- ✅ 변경: p_entry_date -> NOW()
  );

  RAISE NOTICE '✅ Mirror 전표 생성: Original Dr/Cr=(%,%)', _original_debt_debit, _original_debt_credit;
  RAISE NOTICE '✅ Mirror 전표 생성: Mirror Dr/Cr=(%,%)', _mirror_debt_debit, _mirror_debt_credit;

END;
$function$;

-- ============================================
-- 마이그레이션 완료
-- ============================================
