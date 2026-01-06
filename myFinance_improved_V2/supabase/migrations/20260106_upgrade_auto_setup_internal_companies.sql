-- ============================================================
-- Migration: Upgrade auto setup for internal companies
-- ============================================================
-- 회사 생성 시 자동으로:
-- 1. Self-counterparty 생성 + Inter-branch 매핑 (1360 ↔ 2360)
-- 2. Owner가 소유한 다른 회사들과 Internal counterparty 생성 (양방향)
-- 3. Internal counterparty에 Note + Account 매핑 추가
--    - 1110 ↔ 2010 (Note Receivable ↔ Notes Payable)
--    - 1100 ↔ 2000 (Accounts Receivable ↔ Accounts Payable)
-- ============================================================

-- Account IDs (템플릿)
-- Inter-branch (같은 회사, 가게간)
--   1360: 70910193-f3a4-4ff1-91ee-ca299bc0f532 (Inter-branch Receivable)
--   2360: 37efeb1a-31e1-4730-a584-8568e0b1e111 (Inter-branch Payable)
-- Note (같은 Owner, 다른 회사간)
--   1110: f04a4895-5846-450f-8fe9-08f1182d23d1 (Note Receivable)
--   2010: e2ab1c58-f374-46b7-9c5b-ff5929ad4027 (Notes Payable)
-- Account (같은 Owner, 다른 회사간)
--   1100: 600bac8d-d8a7-40c2-8e0e-44f90fde5f07 (Accounts Receivable)
--   2000: 2e61e534-a9fa-4648-bfaf-bb0077ddaffc (Accounts Payable)

-- ============================================================
-- Helper Function: Create account mapping if not exists
-- ============================================================
CREATE OR REPLACE FUNCTION create_account_mapping_if_not_exists(
  p_my_company_id UUID,
  p_counterparty_id UUID,
  p_my_account_id UUID,
  p_linked_account_id UUID,
  p_direction TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_my_company_id
      AND counterparty_id = p_counterparty_id
      AND my_account_id = p_my_account_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_my_company_id, p_my_account_id,
      p_counterparty_id, p_linked_account_id, p_direction, NOW(), false
    );
    RETURN true;
  END IF;
  RETURN false;
END;
$$;

-- ============================================================
-- Main Function: Setup internal companies for new company
-- ============================================================
CREATE OR REPLACE FUNCTION setup_internal_companies_for_new_company(
  p_new_company_id UUID,
  p_owner_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  -- Account IDs
  inter_branch_receivable_id UUID := '70910193-f3a4-4ff1-91ee-ca299bc0f532'; -- 1360
  inter_branch_payable_id UUID := '37efeb1a-31e1-4730-a584-8568e0b1e111';    -- 2360
  note_receivable_id UUID := 'f04a4895-5846-450f-8fe9-08f1182d23d1';         -- 1110
  notes_payable_id UUID := 'e2ab1c58-f374-46b7-9c5b-ff5929ad4027';           -- 2010
  accounts_receivable_id UUID := '600bac8d-d8a7-40c2-8e0e-44f90fde5f07';     -- 1100
  accounts_payable_id UUID := '2e61e534-a9fa-4648-bfaf-bb0077ddaffc';        -- 2000

  _new_company_name TEXT;
  _other_company RECORD;
  
  _self_counterparty_id UUID;
  _new_to_other_cp_id UUID;
  _other_to_new_cp_id UUID;
  
  _self_cp_created BOOLEAN := false;
  _internal_cp_created INT := 0;
  _mappings_created INT := 0;
BEGIN
  RAISE NOTICE '[setup_internal_companies] START - new_company: %, owner: %', p_new_company_id, p_owner_id;
  
  -- 새 회사 이름 조회
  SELECT company_name INTO _new_company_name
  FROM companies WHERE company_id = p_new_company_id;
  
  IF _new_company_name IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Company not found');
  END IF;
  
  -- ============================================================
  -- STEP 1: Self-counterparty 생성 + Inter-branch 매핑
  -- ============================================================
  RAISE NOTICE '[setup_internal_companies] STEP 1: Self-counterparty setup...';
  
  SELECT counterparty_id INTO _self_counterparty_id
  FROM counterparties
  WHERE company_id = p_new_company_id
    AND linked_company_id = p_new_company_id
    AND is_deleted = false
  LIMIT 1;
  
  IF _self_counterparty_id IS NULL THEN
    _self_counterparty_id := gen_random_uuid();
    INSERT INTO counterparties (
      counterparty_id, company_id, name, type, is_internal,
      linked_company_id, is_deleted, created_at
    ) VALUES (
      _self_counterparty_id, p_new_company_id, _new_company_name,
      'My Company', true, p_new_company_id, false, NOW()
    );
    _self_cp_created := true;
    RAISE NOTICE '[setup_internal_companies] Created self-counterparty: %', _self_counterparty_id;
  END IF;
  
  -- Self-counterparty에 Inter-branch 매핑 (1360 ↔ 2360)
  IF create_account_mapping_if_not_exists(
    p_new_company_id, _self_counterparty_id,
    inter_branch_receivable_id, inter_branch_payable_id, 'receivable'
  ) THEN _mappings_created := _mappings_created + 1; END IF;
  
  IF create_account_mapping_if_not_exists(
    p_new_company_id, _self_counterparty_id,
    inter_branch_payable_id, inter_branch_receivable_id, 'payable'
  ) THEN _mappings_created := _mappings_created + 1; END IF;
  
  -- ============================================================
  -- STEP 2: Owner의 다른 회사들과 Internal counterparty 생성
  -- ============================================================
  IF p_owner_id IS NULL THEN
    RAISE NOTICE '[setup_internal_companies] No owner_id - skipping internal companies';
    RETURN jsonb_build_object(
      'success', true,
      'message', 'Self-counterparty setup completed (no owner)',
      'self_counterparty_created', _self_cp_created,
      'internal_counterparties_created', 0,
      'mappings_created', _mappings_created
    );
  END IF;
  
  RAISE NOTICE '[setup_internal_companies] STEP 2: Internal counterparties setup...';
  
  FOR _other_company IN
    SELECT company_id, company_name
    FROM companies
    WHERE owner_id = p_owner_id
      AND company_id != p_new_company_id
      AND is_deleted = false
  LOOP
    RAISE NOTICE '[setup_internal_companies] Processing: % (%)', _other_company.company_name, _other_company.company_id;
    
    -- ========================================
    -- 2-1: 새 회사 → 다른 회사 (counterparty)
    -- ========================================
    SELECT counterparty_id INTO _new_to_other_cp_id
    FROM counterparties
    WHERE company_id = p_new_company_id
      AND linked_company_id = _other_company.company_id
      AND is_deleted = false
    LIMIT 1;
    
    IF _new_to_other_cp_id IS NULL THEN
      _new_to_other_cp_id := gen_random_uuid();
      INSERT INTO counterparties (
        counterparty_id, company_id, name, type, is_internal,
        linked_company_id, is_deleted, created_at
      ) VALUES (
        _new_to_other_cp_id, p_new_company_id, _other_company.company_name,
        'My Company', true, _other_company.company_id, false, NOW()
      );
      _internal_cp_created := _internal_cp_created + 1;
      RAISE NOTICE '[setup_internal_companies] Created: new(%)->other(%) cp: %', 
        _new_company_name, _other_company.company_name, _new_to_other_cp_id;
    END IF;
    
    -- 새 회사의 매핑: Note (1110 ↔ 2010) + Account (1100 ↔ 2000)
    IF create_account_mapping_if_not_exists(
      p_new_company_id, _new_to_other_cp_id,
      note_receivable_id, notes_payable_id, 'receivable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    IF create_account_mapping_if_not_exists(
      p_new_company_id, _new_to_other_cp_id,
      notes_payable_id, note_receivable_id, 'payable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    IF create_account_mapping_if_not_exists(
      p_new_company_id, _new_to_other_cp_id,
      accounts_receivable_id, accounts_payable_id, 'receivable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    IF create_account_mapping_if_not_exists(
      p_new_company_id, _new_to_other_cp_id,
      accounts_payable_id, accounts_receivable_id, 'payable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    -- ========================================
    -- 2-2: 다른 회사 → 새 회사 (counterparty)
    -- ========================================
    SELECT counterparty_id INTO _other_to_new_cp_id
    FROM counterparties
    WHERE company_id = _other_company.company_id
      AND linked_company_id = p_new_company_id
      AND is_deleted = false
    LIMIT 1;
    
    IF _other_to_new_cp_id IS NULL THEN
      _other_to_new_cp_id := gen_random_uuid();
      INSERT INTO counterparties (
        counterparty_id, company_id, name, type, is_internal,
        linked_company_id, is_deleted, created_at
      ) VALUES (
        _other_to_new_cp_id, _other_company.company_id, _new_company_name,
        'My Company', true, p_new_company_id, false, NOW()
      );
      _internal_cp_created := _internal_cp_created + 1;
      RAISE NOTICE '[setup_internal_companies] Created: other(%)->new(%) cp: %', 
        _other_company.company_name, _new_company_name, _other_to_new_cp_id;
    END IF;
    
    -- 다른 회사의 매핑: Note (1110 ↔ 2010) + Account (1100 ↔ 2000)
    IF create_account_mapping_if_not_exists(
      _other_company.company_id, _other_to_new_cp_id,
      note_receivable_id, notes_payable_id, 'receivable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    IF create_account_mapping_if_not_exists(
      _other_company.company_id, _other_to_new_cp_id,
      notes_payable_id, note_receivable_id, 'payable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    IF create_account_mapping_if_not_exists(
      _other_company.company_id, _other_to_new_cp_id,
      accounts_receivable_id, accounts_payable_id, 'receivable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
    IF create_account_mapping_if_not_exists(
      _other_company.company_id, _other_to_new_cp_id,
      accounts_payable_id, accounts_receivable_id, 'payable'
    ) THEN _mappings_created := _mappings_created + 1; END IF;
    
  END LOOP;
  
  RAISE NOTICE '[setup_internal_companies] COMPLETE - self_cp: %, internal_cp: %, mappings: %',
    _self_cp_created, _internal_cp_created, _mappings_created;
  
  RETURN jsonb_build_object(
    'success', true,
    'message', 'Internal companies setup completed',
    'new_company_name', _new_company_name,
    'self_counterparty_id', _self_counterparty_id,
    'self_counterparty_created', _self_cp_created,
    'internal_counterparties_created', _internal_cp_created,
    'mappings_created', _mappings_created
  );

EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '[setup_internal_companies] EXCEPTION: %', SQLERRM;
  RETURN jsonb_build_object(
    'success', false,
    'error', SQLERRM
  );
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION create_account_mapping_if_not_exists(UUID, UUID, UUID, UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION create_account_mapping_if_not_exists(UUID, UUID, UUID, UUID, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION setup_internal_companies_for_new_company(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION setup_internal_companies_for_new_company(UUID, UUID) TO service_role;

-- ============================================================
-- Upgrade Trigger Function
-- ============================================================
CREATE OR REPLACE FUNCTION fn_auto_setup_within_company()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  _result JSONB;
BEGIN
  RAISE NOTICE '[fn_auto_setup_within_company] Company created: % (%), owner: %', 
    NEW.company_name, NEW.company_id, NEW.owner_id;
  
  -- 업그레이드된 함수 호출 (self + internal companies)
  _result := setup_internal_companies_for_new_company(NEW.company_id, NEW.owner_id);
  
  IF (_result->>'success')::boolean THEN
    RAISE NOTICE '[fn_auto_setup_within_company] SUCCESS: internal_cp=%, mappings=%', 
      _result->>'internal_counterparties_created', _result->>'mappings_created';
  ELSE
    RAISE WARNING '[fn_auto_setup_within_company] FAILED: %', _result->>'error';
  END IF;
  
  RETURN NEW;

EXCEPTION WHEN OTHERS THEN
  -- 에러가 발생해도 회사 생성은 실패하지 않도록
  RAISE WARNING '[fn_auto_setup_within_company] EXCEPTION: % - continuing anyway', SQLERRM;
  RETURN NEW;
END;
$$;

-- ============================================================
-- Comment
-- ============================================================
COMMENT ON FUNCTION setup_internal_companies_for_new_company IS 
'회사 생성 시 자동으로:
1. Self-counterparty + Inter-branch 매핑 (1360 ↔ 2360)
2. Owner의 다른 회사들과 Internal counterparty 양방향 생성
3. Internal counterparty에 Note(1110↔2010) + Account(1100↔2000) 매핑';
