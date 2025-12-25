-- ============================================================
-- RPC: ensure_inter_company_setup
-- ============================================================
-- 회사 간 거래 전에 호출하여 필요한 모든 설정을 자동 생성합니다:
-- 1. 상대방 회사에 나를 등록한 counterparty가 없으면 자동 생성
-- 2. 양쪽 account_mappings 자동 생성
--
-- 케이스별 매핑:
-- - Within Company (같은 회사, 다른 가게): Inter-branch Receivable/Payable (1360/2360)
-- - Between Companies (다른 회사): Note Receivable/Payable (1110/2010)
--
-- 사용법:
-- SELECT ensure_inter_company_setup(
--   'my_company_id',
--   'target_company_id'  -- linked_company_id (거래 상대방 회사)
-- );
-- ============================================================

CREATE OR REPLACE FUNCTION ensure_inter_company_setup(
  p_my_company_id UUID,
  p_target_company_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  -- Inter-branch accounts (within same company, different stores)
  inter_branch_receivable_id UUID := '70910193-f3a4-4ff1-91ee-ca299bc0f532'; -- 1360
  inter_branch_payable_id UUID := '37efeb1a-31e1-4730-a584-8568e0b1e111';    -- 2360

  -- Note accounts (between different companies)
  note_receivable_id UUID := 'f04a4895-5846-450f-8fe9-08f1182d23d1';         -- 1110
  notes_payable_id UUID := 'e2ab1c58-f374-46b7-9c5b-ff5929ad4027';           -- 2010

  _my_company_name TEXT;
  _target_company_name TEXT;

  _my_counterparty_id UUID;      -- 내가 상대방을 등록한 counterparty
  _their_counterparty_id UUID;   -- 상대방이 나를 등록한 counterparty

  _is_same_company BOOLEAN;
  _receivable_account_id UUID;
  _payable_account_id UUID;

  _counterparties_created INT := 0;
  _mappings_created INT := 0;
BEGIN
  RAISE NOTICE '[ensure_inter_company_setup] START - my_company: %, target_company: %', p_my_company_id, p_target_company_id;

  -- 같은 회사면 Within Company (Inter-branch 사용)
  -- 다른 회사면 Between Companies (Note 사용)
  _is_same_company := (p_my_company_id = p_target_company_id);
  RAISE NOTICE '[ensure_inter_company_setup] is_same_company: %', _is_same_company;

  IF _is_same_company THEN
    -- Within Company: Inter-branch accounts
    _receivable_account_id := inter_branch_receivable_id;
    _payable_account_id := inter_branch_payable_id;
    RAISE NOTICE '[ensure_inter_company_setup] Same company detected - redirecting to ensure_within_company_setup';

    -- 같은 회사 내에서는 self-counterparty만 필요
    -- counterparty와 mapping 생성 없이 바로 반환
    RETURN jsonb_build_object(
      'success', true,
      'message', 'Same company - using self-counterparty for within-company transfer',
      'is_within_company', true,
      'counterparties_created', 0,
      'mappings_created', 0
    );
  ELSE
    -- Between Companies: Note accounts
    _receivable_account_id := note_receivable_id;
    _payable_account_id := notes_payable_id;
    RAISE NOTICE '[ensure_inter_company_setup] Different companies - using Note accounts (1110/2010)';
  END IF;

  -- 회사명 조회
  SELECT company_name INTO _my_company_name
  FROM companies WHERE company_id = p_my_company_id;

  SELECT company_name INTO _target_company_name
  FROM companies WHERE company_id = p_target_company_id;

  RAISE NOTICE '[ensure_inter_company_setup] my_company_name: %, target_company_name: %', _my_company_name, _target_company_name;

  IF _my_company_name IS NULL OR _target_company_name IS NULL THEN
    RAISE WARNING '[ensure_inter_company_setup] ERROR: Company not found - my: %, target: %', _my_company_name, _target_company_name;
    RETURN jsonb_build_object(
      'success', false,
      'error', 'One or both companies not found',
      'my_company_id', p_my_company_id,
      'target_company_id', p_target_company_id
    );
  END IF;

  -- ============================================================
  -- STEP 1: Counterparty 확인 및 생성 (양방향)
  -- ============================================================
  RAISE NOTICE '[ensure_inter_company_setup] STEP 1: Checking/creating counterparties...';

  -- 1-1. 내가 상대방을 등록한 counterparty 찾기
  SELECT counterparty_id INTO _my_counterparty_id
  FROM counterparties
  WHERE company_id = p_my_company_id
    AND linked_company_id = p_target_company_id
    AND is_deleted = false
  LIMIT 1;

  -- 없으면 생성
  IF _my_counterparty_id IS NULL THEN
    _my_counterparty_id := gen_random_uuid();
    INSERT INTO counterparties (
      counterparty_id, company_id, name, type, is_internal,
      linked_company_id, is_deleted, created_at
    ) VALUES (
      _my_counterparty_id, p_my_company_id, _target_company_name,
      'My Company', true, p_target_company_id, false, NOW()
    );
    _counterparties_created := _counterparties_created + 1;
    RAISE NOTICE '[ensure_inter_company_setup] CREATED my_counterparty: % (% -> %)', _my_counterparty_id, _my_company_name, _target_company_name;
  ELSE
    RAISE NOTICE '[ensure_inter_company_setup] FOUND existing my_counterparty: %', _my_counterparty_id;
  END IF;

  -- 1-2. 상대방이 나를 등록한 counterparty 찾기
  SELECT counterparty_id INTO _their_counterparty_id
  FROM counterparties
  WHERE company_id = p_target_company_id
    AND linked_company_id = p_my_company_id
    AND is_deleted = false
  LIMIT 1;

  -- 없으면 생성
  IF _their_counterparty_id IS NULL THEN
    _their_counterparty_id := gen_random_uuid();
    INSERT INTO counterparties (
      counterparty_id, company_id, name, type, is_internal,
      linked_company_id, is_deleted, created_at
    ) VALUES (
      _their_counterparty_id, p_target_company_id, _my_company_name,
      'My Company', true, p_my_company_id, false, NOW()
    );
    _counterparties_created := _counterparties_created + 1;
    RAISE NOTICE '[ensure_inter_company_setup] CREATED their_counterparty: % (% -> %)', _their_counterparty_id, _target_company_name, _my_company_name;
  ELSE
    RAISE NOTICE '[ensure_inter_company_setup] FOUND existing their_counterparty: %', _their_counterparty_id;
  END IF;

  -- ============================================================
  -- STEP 2: Account Mappings 생성 (내 회사 -> 상대방) - 2개
  -- ============================================================
  RAISE NOTICE '[ensure_inter_company_setup] STEP 2: Creating account mappings for my_company...';

  -- 2-1. My Receivable → Their Payable
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_my_company_id
      AND counterparty_id = _my_counterparty_id
      AND my_account_id = _receivable_account_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_my_company_id, _receivable_account_id,
      _my_counterparty_id, _payable_account_id, 'receivable', NOW(), false
    );
    _mappings_created := _mappings_created + 1;
    RAISE NOTICE '[ensure_inter_company_setup] CREATED mapping: my_receivable(%) -> their_payable(%)', _receivable_account_id, _payable_account_id;
  ELSE
    RAISE NOTICE '[ensure_inter_company_setup] SKIPPED: my_receivable mapping already exists';
  END IF;

  -- 2-2. My Payable → Their Receivable
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_my_company_id
      AND counterparty_id = _my_counterparty_id
      AND my_account_id = _payable_account_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_my_company_id, _payable_account_id,
      _my_counterparty_id, _receivable_account_id, 'payable', NOW(), false
    );
    _mappings_created := _mappings_created + 1;
    RAISE NOTICE '[ensure_inter_company_setup] CREATED mapping: my_payable(%) -> their_receivable(%)', _payable_account_id, _receivable_account_id;
  ELSE
    RAISE NOTICE '[ensure_inter_company_setup] SKIPPED: my_payable mapping already exists';
  END IF;

  -- ============================================================
  -- STEP 3: Account Mappings 생성 (상대방 -> 내 회사) - 2개
  -- ============================================================
  RAISE NOTICE '[ensure_inter_company_setup] STEP 3: Creating account mappings for target_company...';

  -- 3-1. Their Receivable → My Payable
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_target_company_id
      AND counterparty_id = _their_counterparty_id
      AND my_account_id = _receivable_account_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_target_company_id, _receivable_account_id,
      _their_counterparty_id, _payable_account_id, 'receivable', NOW(), false
    );
    _mappings_created := _mappings_created + 1;
    RAISE NOTICE '[ensure_inter_company_setup] CREATED mapping: their_receivable(%) -> my_payable(%)', _receivable_account_id, _payable_account_id;
  ELSE
    RAISE NOTICE '[ensure_inter_company_setup] SKIPPED: their_receivable mapping already exists';
  END IF;

  -- 3-2. Their Payable → My Receivable
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_target_company_id
      AND counterparty_id = _their_counterparty_id
      AND my_account_id = _payable_account_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_target_company_id, _payable_account_id,
      _their_counterparty_id, _receivable_account_id, 'payable', NOW(), false
    );
    _mappings_created := _mappings_created + 1;
    RAISE NOTICE '[ensure_inter_company_setup] CREATED mapping: their_payable(%) -> my_receivable(%)', _payable_account_id, _receivable_account_id;
  ELSE
    RAISE NOTICE '[ensure_inter_company_setup] SKIPPED: their_payable mapping already exists';
  END IF;

  RAISE NOTICE '[ensure_inter_company_setup] COMPLETE - counterparties_created: %, mappings_created: %', _counterparties_created, _mappings_created;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Inter-company setup completed',
    'is_within_company', false,
    'account_type', 'note',
    'counterparties_created', _counterparties_created,
    'mappings_created', _mappings_created,
    'my_counterparty_id', _my_counterparty_id,
    'their_counterparty_id', _their_counterparty_id,
    'my_company_name', _my_company_name,
    'target_company_name', _target_company_name
  );

EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '[ensure_inter_company_setup] EXCEPTION: %', SQLERRM;
  RETURN jsonb_build_object(
    'success', false,
    'error', SQLERRM,
    'counterparties_created', _counterparties_created,
    'mappings_created', _mappings_created
  );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION ensure_inter_company_setup(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION ensure_inter_company_setup(UUID, UUID) TO service_role;

-- ============================================================
-- RPC: ensure_within_company_setup
-- ============================================================
-- 같은 회사 내 다른 가게 간 거래를 위한 설정
-- Inter-branch Receivable/Payable (1360/2360) 매핑 생성
--
-- 사용법:
-- SELECT ensure_within_company_setup('company_id');
-- ============================================================

CREATE OR REPLACE FUNCTION ensure_within_company_setup(
  p_company_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  -- Inter-branch accounts
  inter_branch_receivable_id UUID := '70910193-f3a4-4ff1-91ee-ca299bc0f532'; -- 1360
  inter_branch_payable_id UUID := '37efeb1a-31e1-4730-a584-8568e0b1e111';    -- 2360

  _company_name TEXT;
  _self_counterparty_id UUID;
  _counterparty_created BOOLEAN := false;
  _mappings_created INT := 0;
BEGIN
  RAISE NOTICE '[ensure_within_company_setup] START - company_id: %', p_company_id;

  -- 회사명 조회
  SELECT company_name INTO _company_name
  FROM companies WHERE company_id = p_company_id;

  RAISE NOTICE '[ensure_within_company_setup] company_name: %', _company_name;

  IF _company_name IS NULL THEN
    RAISE WARNING '[ensure_within_company_setup] ERROR: Company not found';
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Company not found',
      'company_id', p_company_id
    );
  END IF;

  -- ============================================================
  -- STEP 1: Self-counterparty 확인 및 생성
  -- ============================================================
  RAISE NOTICE '[ensure_within_company_setup] STEP 1: Checking/creating self-counterparty...';

  SELECT counterparty_id INTO _self_counterparty_id
  FROM counterparties
  WHERE company_id = p_company_id
    AND linked_company_id = p_company_id
    AND is_deleted = false
  LIMIT 1;

  IF _self_counterparty_id IS NULL THEN
    _self_counterparty_id := gen_random_uuid();
    INSERT INTO counterparties (
      counterparty_id, company_id, name, type, is_internal,
      linked_company_id, is_deleted, created_at
    ) VALUES (
      _self_counterparty_id, p_company_id, _company_name,
      'My Company', true, p_company_id, false, NOW()
    );
    _counterparty_created := true;
    RAISE NOTICE '[ensure_within_company_setup] CREATED self-counterparty: % for %', _self_counterparty_id, _company_name;
  ELSE
    RAISE NOTICE '[ensure_within_company_setup] FOUND existing self-counterparty: %', _self_counterparty_id;
  END IF;

  -- ============================================================
  -- STEP 2: Account Mappings 생성 (Inter-branch) - 2개
  -- ============================================================
  RAISE NOTICE '[ensure_within_company_setup] STEP 2: Creating inter-branch account mappings...';

  -- 2-1. Inter-branch Receivable (1360) → Inter-branch Payable (2360)
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_company_id
      AND counterparty_id = _self_counterparty_id
      AND my_account_id = inter_branch_receivable_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_company_id, inter_branch_receivable_id,
      _self_counterparty_id, inter_branch_payable_id, 'receivable', NOW(), false
    );
    _mappings_created := _mappings_created + 1;
    RAISE NOTICE '[ensure_within_company_setup] CREATED mapping: inter_branch_receivable(1360) -> inter_branch_payable(2360)';
  ELSE
    RAISE NOTICE '[ensure_within_company_setup] SKIPPED: inter_branch_receivable mapping already exists';
  END IF;

  -- 2-2. Inter-branch Payable (2360) → Inter-branch Receivable (1360)
  IF NOT EXISTS (
    SELECT 1 FROM account_mappings
    WHERE my_company_id = p_company_id
      AND counterparty_id = _self_counterparty_id
      AND my_account_id = inter_branch_payable_id
      AND is_deleted = false
  ) THEN
    INSERT INTO account_mappings (
      mapping_id, my_company_id, my_account_id, counterparty_id,
      linked_account_id, direction, created_at, is_deleted
    ) VALUES (
      gen_random_uuid(), p_company_id, inter_branch_payable_id,
      _self_counterparty_id, inter_branch_receivable_id, 'payable', NOW(), false
    );
    _mappings_created := _mappings_created + 1;
    RAISE NOTICE '[ensure_within_company_setup] CREATED mapping: inter_branch_payable(2360) -> inter_branch_receivable(1360)';
  ELSE
    RAISE NOTICE '[ensure_within_company_setup] SKIPPED: inter_branch_payable mapping already exists';
  END IF;

  RAISE NOTICE '[ensure_within_company_setup] COMPLETE - counterparty_created: %, mappings_created: %', _counterparty_created, _mappings_created;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Within-company setup completed',
    'company_name', _company_name,
    'self_counterparty_id', _self_counterparty_id,
    'counterparty_created', _counterparty_created,
    'mappings_created', _mappings_created
  );

EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '[ensure_within_company_setup] EXCEPTION: %', SQLERRM;
  RETURN jsonb_build_object(
    'success', false,
    'error', SQLERRM,
    'mappings_created', _mappings_created
  );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION ensure_within_company_setup(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION ensure_within_company_setup(UUID) TO service_role;

-- ============================================================
-- Helper RPC: Get or create counterparty for target company
-- ============================================================
-- 특정 회사에 대한 counterparty_id를 반환합니다.
-- 없으면 자동 생성 후 반환합니다.
--
-- Within Company: self-counterparty 반환 + Inter-branch 매핑 생성
-- Between Companies: counterparty 반환 + Note 매핑 생성
-- ============================================================

CREATE OR REPLACE FUNCTION get_or_create_counterparty_for_company(
  p_my_company_id UUID,
  p_target_company_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  _counterparty_id UUID;
  _is_same_company BOOLEAN;
BEGIN
  _is_same_company := (p_my_company_id = p_target_company_id);
  RAISE NOTICE '[get_or_create_counterparty] START - my: %, target: %, same_company: %', p_my_company_id, p_target_company_id, _is_same_company;

  -- 같은 회사면 Within Company (self-counterparty + Inter-branch 매핑)
  IF _is_same_company THEN
    RAISE NOTICE '[get_or_create_counterparty] Calling ensure_within_company_setup...';
    -- ensure_within_company_setup 호출
    PERFORM ensure_within_company_setup(p_my_company_id);

    -- self-counterparty 반환
    SELECT counterparty_id INTO _counterparty_id
    FROM counterparties
    WHERE company_id = p_my_company_id
      AND linked_company_id = p_my_company_id
      AND is_deleted = false
    LIMIT 1;

    RAISE NOTICE '[get_or_create_counterparty] Returning self-counterparty: %', _counterparty_id;
    RETURN _counterparty_id;
  END IF;

  -- 다른 회사면 Between Companies (counterparty + Note 매핑)
  RAISE NOTICE '[get_or_create_counterparty] Calling ensure_inter_company_setup...';
  PERFORM ensure_inter_company_setup(p_my_company_id, p_target_company_id);

  SELECT counterparty_id INTO _counterparty_id
  FROM counterparties
  WHERE company_id = p_my_company_id
    AND linked_company_id = p_target_company_id
    AND is_deleted = false
  LIMIT 1;

  RAISE NOTICE '[get_or_create_counterparty] Returning counterparty: %', _counterparty_id;
  RETURN _counterparty_id;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_or_create_counterparty_for_company(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_or_create_counterparty_for_company(UUID, UUID) TO service_role;
