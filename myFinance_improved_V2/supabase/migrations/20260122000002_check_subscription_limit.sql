-- ============================================================================
-- Migration: check_subscription_limit
-- Description: 구독 플랜 제한 검증 RPC 함수
--   - 생성 시점에 최신 count를 확인하여 추가 가능 여부 반환
--   - p_check_type: 'company', 'store', 'employee'
-- Date: 2026-01-22
-- ============================================================================

CREATE OR REPLACE FUNCTION public.check_subscription_limit(
  p_user_id UUID,
  p_check_type TEXT,
  p_company_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_plan_name TEXT;
  v_max_limit INT;
  v_current_count INT;
  v_can_add BOOLEAN;
  v_plan_id UUID;
BEGIN
  -- 1. 사용자의 현재 플랜 정보 가져오기
  -- 회사별 검증인 경우 해당 회사의 플랜, 아니면 첫 번째 회사의 플랜 사용
  IF p_company_id IS NOT NULL THEN
    SELECT c.inherited_plan_id
    INTO v_plan_id
    FROM companies c
    WHERE c.company_id = p_company_id
      AND c.is_deleted = false;
  ELSE
    -- 사용자의 첫 번째 회사 플랜 사용
    SELECT c.inherited_plan_id
    INTO v_plan_id
    FROM user_companies uc
    JOIN companies c ON c.company_id = uc.company_id
    WHERE uc.user_id = p_user_id
      AND uc.is_deleted = false
      AND c.is_deleted = false
    ORDER BY uc.created_at
    LIMIT 1;
  END IF;

  -- 플랜이 없으면 Free 플랜 기본값 사용
  IF v_plan_id IS NULL THEN
    SELECT sp.plan_id INTO v_plan_id
    FROM subscription_plans sp
    WHERE sp.plan_name = 'free'
    LIMIT 1;
  END IF;

  -- 2. 검증 타입에 따라 max_limit 및 current_count 계산
  CASE p_check_type
    -- ===== COMPANY 검증 =====
    WHEN 'company' THEN
      SELECT sp.plan_name, sp.max_companies
      INTO v_plan_name, v_max_limit
      FROM subscription_plans sp
      WHERE sp.plan_id = v_plan_id;

      SELECT COUNT(DISTINCT c.company_id)
      INTO v_current_count
      FROM user_companies uc
      JOIN companies c ON c.company_id = uc.company_id
      WHERE uc.user_id = p_user_id
        AND uc.is_deleted = false
        AND c.is_deleted = false;

    -- ===== STORE 검증 =====
    WHEN 'store' THEN
      SELECT sp.plan_name, sp.max_stores
      INTO v_plan_name, v_max_limit
      FROM subscription_plans sp
      WHERE sp.plan_id = v_plan_id;

      -- 특정 회사의 가게 수
      IF p_company_id IS NOT NULL THEN
        SELECT COUNT(DISTINCT s.store_id)
        INTO v_current_count
        FROM user_stores us
        JOIN stores s ON s.store_id = us.store_id
        WHERE us.user_id = p_user_id
          AND us.is_deleted = false
          AND s.is_deleted = false
          AND s.company_id = p_company_id;
      ELSE
        -- 전체 가게 수
        SELECT COUNT(DISTINCT s.store_id)
        INTO v_current_count
        FROM user_stores us
        JOIN stores s ON s.store_id = us.store_id
        WHERE us.user_id = p_user_id
          AND us.is_deleted = false
          AND s.is_deleted = false;
      END IF;

    -- ===== EMPLOYEE 검증 =====
    -- NOTE: roles table does NOT have is_deleted column
    WHEN 'employee' THEN
      SELECT sp.plan_name, sp.max_employees
      INTO v_plan_name, v_max_limit
      FROM subscription_plans sp
      WHERE sp.plan_id = v_plan_id;

      -- 특정 회사의 직원 수
      IF p_company_id IS NOT NULL THEN
        SELECT COUNT(DISTINCT ur.user_id)
        INTO v_current_count
        FROM user_roles ur
        JOIN roles r ON r.role_id = ur.role_id
        WHERE r.company_id = p_company_id
          AND ur.is_deleted = false;
      ELSE
        -- 전체 직원 수 (사용자가 속한 모든 회사)
        SELECT COUNT(DISTINCT ur.user_id)
        INTO v_current_count
        FROM user_companies uc
        JOIN companies c ON c.company_id = uc.company_id
        JOIN roles r ON r.company_id = c.company_id
        JOIN user_roles ur ON ur.role_id = r.role_id
        WHERE uc.user_id = p_user_id
          AND uc.is_deleted = false
          AND c.is_deleted = false
          AND ur.is_deleted = false;
      END IF;

    ELSE
      -- 잘못된 check_type
      RETURN jsonb_build_object(
        'error', 'Invalid check_type. Use: company, store, or employee',
        'can_add', false
      );
  END CASE;

  -- 3. 추가 가능 여부 판단
  -- max_limit이 NULL이면 무제한 (Pro 플랜)
  IF v_max_limit IS NULL THEN
    v_can_add := true;
  ELSE
    v_can_add := v_current_count < v_max_limit;
  END IF;

  -- 4. 결과 반환
  RETURN jsonb_build_object(
    'can_add', v_can_add,
    'plan_name', COALESCE(v_plan_name, 'free'),
    'max_limit', v_max_limit,  -- NULL = 무제한
    'current_count', v_current_count,
    'check_type', p_check_type
  );

END;
$function$;

-- 함수에 대한 코멘트
COMMENT ON FUNCTION public.check_subscription_limit(UUID, TEXT, UUID) IS
'구독 플랜 제한 검증 함수. check_type: company/store/employee.
반환값: {can_add, plan_name, max_limit, current_count, check_type}';
