-- ============================================================
-- Migration: Auto setup within-company on company creation
-- ============================================================
-- 회사 생성 시 자동으로:
-- 1. Self-counterparty 생성 (linked_company_id = company_id)
-- 2. Inter-branch account mappings 생성 (1360 ↔ 2360)
--
-- 이렇게 하면 가게간 거래(within-company transfer) 시 
-- 별도의 setup 없이 바로 미러 분개가 작동합니다.
-- ============================================================

-- Trigger function
CREATE OR REPLACE FUNCTION fn_auto_setup_within_company()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  _result JSONB;
BEGIN
  RAISE NOTICE '[fn_auto_setup_within_company] Company created: % (%)', NEW.company_name, NEW.company_id;
  
  -- ensure_within_company_setup 호출
  _result := ensure_within_company_setup(NEW.company_id);
  
  IF (_result->>'success')::boolean THEN
    RAISE NOTICE '[fn_auto_setup_within_company] SUCCESS: self_counterparty_id=%', _result->>'self_counterparty_id';
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

-- Drop existing trigger if exists
DROP TRIGGER IF EXISTS trg_auto_setup_within_company ON companies;

-- Create trigger (AFTER INSERT)
CREATE TRIGGER trg_auto_setup_within_company
  AFTER INSERT ON companies
  FOR EACH ROW
  EXECUTE FUNCTION fn_auto_setup_within_company();

-- ============================================================
-- 기존 회사들에 대해 within-company setup 일괄 실행
-- ============================================================
DO $$
DECLARE
  _company RECORD;
  _result JSONB;
  _success_count INT := 0;
  _skip_count INT := 0;
  _error_count INT := 0;
BEGIN
  RAISE NOTICE '=== Starting bulk within-company setup for existing companies ===';
  
  FOR _company IN 
    SELECT company_id, company_name 
    FROM companies 
    WHERE is_deleted = false
  LOOP
    BEGIN
      -- 이미 self-counterparty가 있는지 확인
      IF EXISTS (
        SELECT 1 FROM counterparties 
        WHERE company_id = _company.company_id 
          AND linked_company_id = _company.company_id
          AND is_deleted = false
      ) THEN
        _skip_count := _skip_count + 1;
        CONTINUE; -- 이미 설정됨, 스킵
      END IF;
      
      _result := ensure_within_company_setup(_company.company_id);
      
      IF (_result->>'success')::boolean THEN
        _success_count := _success_count + 1;
        RAISE NOTICE 'Setup completed for: % (%)', _company.company_name, _company.company_id;
      ELSE
        _error_count := _error_count + 1;
        RAISE WARNING 'Setup failed for %: %', _company.company_name, _result->>'error';
      END IF;
      
    EXCEPTION WHEN OTHERS THEN
      _error_count := _error_count + 1;
      RAISE WARNING 'Exception for %: %', _company.company_name, SQLERRM;
    END;
  END LOOP;
  
  RAISE NOTICE '=== Bulk setup complete: success=%, skipped=%, errors=% ===', 
    _success_count, _skip_count, _error_count;
END;
$$;

-- ============================================================
-- 검증: 현재 상태 확인
-- ============================================================
DO $$
DECLARE
  _total_companies INT;
  _with_self_cp INT;
  _with_mappings INT;
BEGIN
  SELECT COUNT(*) INTO _total_companies FROM companies WHERE is_deleted = false;
  
  SELECT COUNT(DISTINCT c.company_id) INTO _with_self_cp
  FROM companies c
  JOIN counterparties cp ON cp.company_id = c.company_id AND cp.linked_company_id = c.company_id
  WHERE c.is_deleted = false AND cp.is_deleted = false;
  
  SELECT COUNT(DISTINCT am.my_company_id) INTO _with_mappings
  FROM account_mappings am
  WHERE am.my_account_id IN (
    '70910193-f3a4-4ff1-91ee-ca299bc0f532', -- 1360
    '37efeb1a-31e1-4730-a584-8568e0b1e111'  -- 2360
  )
  AND am.is_deleted = false;
  
  RAISE NOTICE '=== Verification ===';
  RAISE NOTICE 'Total active companies: %', _total_companies;
  RAISE NOTICE 'Companies with self-counterparty: %', _with_self_cp;
  RAISE NOTICE 'Companies with inter-branch mappings: %', _with_mappings;
END;
$$;
