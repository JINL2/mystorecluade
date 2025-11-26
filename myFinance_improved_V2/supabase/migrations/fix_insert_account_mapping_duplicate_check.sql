-- Fix insert_account_mapping_with_company to check counterparty_id in duplicate detection
-- Problem: The RPC was checking only account combinations without counterparty_id
-- This prevented creating multiple mappings with same accounts but different counterparties
-- Solution: Add counterparty_id check to the duplicate detection logic

CREATE OR REPLACE FUNCTION public.insert_account_mapping_with_company(
  p_my_company_id uuid,
  p_my_account_id uuid,
  p_counterparty_company_id uuid,
  p_linked_account_id uuid,
  p_direction text,
  p_created_by uuid
)
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE
  v_counterparty_id UUID;
  v_reverse_counterparty_id UUID;
  v_exists_count INT;
  v_my_company_name TEXT;
  v_counterparty_company_name TEXT;
BEGIN
  -- 0. 회사 이름 미리 조회 (counterparty name으로 사용)
  SELECT company_name INTO v_my_company_name FROM companies WHERE company_id = p_my_company_id;
  SELECT company_name INTO v_counterparty_company_name FROM companies WHERE company_id = p_counterparty_company_id;

  -- 1. 내 회사 → 상대 회사로 등록된 counterparty 확인
  SELECT c.counterparty_id INTO v_counterparty_id
  FROM counterparties c
  WHERE c.company_id = p_my_company_id AND c.linked_company_id = p_counterparty_company_id;

  -- 1-1. 없다면 생성
  IF v_counterparty_id IS NULL THEN
    INSERT INTO counterparties (
      company_id,
      linked_company_id,
      name,
      is_internal,
      created_at,
      created_by
    ) VALUES (
      p_my_company_id,
      p_counterparty_company_id,
      v_counterparty_company_name,
      TRUE,
      NOW(),
      p_created_by
    ) RETURNING counterparty_id INTO v_counterparty_id;
  END IF;

  -- 2. 상대 회사 → 내 회사로 등록된 counterparty 확인
  SELECT c.counterparty_id INTO v_reverse_counterparty_id
  FROM counterparties c
  WHERE c.company_id = p_counterparty_company_id AND c.linked_company_id = p_my_company_id;

  -- 2-1. 없다면 생성
  IF v_reverse_counterparty_id IS NULL THEN
    INSERT INTO counterparties (
      company_id,
      linked_company_id,
      name,
      is_internal,
      created_at,
      created_by
    ) VALUES (
      p_counterparty_company_id,
      p_my_company_id,
      v_my_company_name,
      TRUE,
      NOW(),
      p_created_by
    ) RETURNING counterparty_id INTO v_reverse_counterparty_id;
  END IF;

  -- ✅ 3. 기존 매핑 존재 여부 확인 (counterparty_id 포함하여 체크)
  -- FIXED: Added counterparty_id check to prevent false duplicates
  SELECT COUNT(*) INTO v_exists_count
  FROM account_mappings am
  WHERE
    am.my_company_id = p_my_company_id
    AND am.counterparty_id = v_counterparty_id
    AND am.direction = p_direction
    AND (
      (am.my_account_id = p_my_account_id AND am.linked_account_id = p_linked_account_id)
      OR
      (am.my_account_id = p_linked_account_id AND am.linked_account_id = p_my_account_id)
    );

  -- 4. 없을 때 쌍으로 삽입
  IF v_exists_count = 0 THEN
    -- 4-1. 내 회사 기준 매핑
    INSERT INTO account_mappings (
      mapping_id,
      my_company_id,
      my_account_id,
      counterparty_id,
      linked_account_id,
      direction,
      created_at,
      created_by
    ) VALUES (
      gen_random_uuid(),
      p_my_company_id,
      p_my_account_id,
      v_counterparty_id,
      p_linked_account_id,
      p_direction,
      NOW(),
      p_created_by
    );

    -- 4-2. 상대 회사 기준 역매핑 (반대 방향)
    INSERT INTO account_mappings (
      mapping_id,
      my_company_id,
      my_account_id,
      counterparty_id,
      linked_account_id,
      direction,
      created_at,
      created_by
    ) VALUES (
      gen_random_uuid(),
      p_counterparty_company_id,
      p_linked_account_id,
      v_reverse_counterparty_id,
      p_my_account_id,
      CASE
        WHEN p_direction = 'payable' THEN 'receivable'
        WHEN p_direction = 'receivable' THEN 'payable'
        ELSE p_direction
      END,
      NOW(),
      p_created_by
    );

    RETURN 'inserted';
  ELSE
    RETURN 'already_exists';
  END IF;
END;
$function$;
