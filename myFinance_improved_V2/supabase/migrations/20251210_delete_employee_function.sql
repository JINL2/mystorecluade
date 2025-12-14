-- =====================================================
-- 직원 삭제 RPC 함수 (안전한 버전)
-- Owner만 자신의 회사 직원을 삭제할 수 있음
--
-- 핵심 원칙:
-- 1. users 테이블은 절대 삭제하지 않음 (다른 회사 소속 가능)
-- 2. 회사 연결만 끊음 (user_companies, user_stores, user_roles)
-- 3. created_by 등 FK 참조는 그대로 유지 (users가 남아있으므로 유효함)
-- 4. 히스토리 데이터는 보존
--
-- 실행 방법:
-- 1. Supabase Dashboard > SQL Editor에서 실행
-- 2. 또는 supabase db push 명령어 사용
-- =====================================================

-- =====================================================
-- 연결 구조 (users 테이블 기준)
-- =====================================================
--
-- users (직원) ← 삭제하지 않음!
--   │
--   ├── user_companies (회사 소속) ← Soft Delete
--   │     └── is_deleted = true
--   │
--   ├── user_stores (매장 배정) ← Soft Delete
--   │     └── is_deleted = true
--   │
--   ├── user_roles (역할 배정) ← Soft Delete
--   │     └── is_deleted = true
--   │
--   ├── user_salaries (급여 정보) ← 삭제 (회사별 데이터)
--   │
--   ├── shift_requests (근무 요청) ← 유지 (히스토리)
--   │
--   └── created_by 참조들 ← 그대로 유지 (FK 유효)
--         (journal_entries, inventory_*, cash_* 등)
--
-- =====================================================
-- 삭제 전략
-- =====================================================
--
-- Soft Delete (is_deleted = true):
--   - user_companies
--   - user_stores
--   - user_roles
--
-- Hard Delete (실제 삭제):
--   - user_salaries (회사별 급여 정보)
--
-- 유지 (삭제하지 않음):
--   - users (다른 회사 소속 가능)
--   - shift_requests (근무 히스토리 보존)
--   - journal_entries.created_by (작성자 기록 보존)
--   - 기타 모든 created_by/approved_by 참조
--
-- =====================================================

-- 1. 직원 삭제 검증 함수 (삭제 전 연결된 데이터 확인)
CREATE OR REPLACE FUNCTION validate_employee_deletion(
    p_company_id UUID,
    p_employee_user_id UUID,
    p_requester_user_id UUID
)
RETURNS JSONB AS $$
DECLARE
    v_is_owner BOOLEAN;
    v_employee_exists BOOLEAN;
    v_counts JSONB;
    v_employee_info JSONB;
BEGIN
    -- 1. 요청자가 해당 회사의 Owner인지 확인
    SELECT EXISTS(
        SELECT 1 FROM companies
        WHERE company_id = p_company_id
          AND owner_id = p_requester_user_id
          AND is_deleted = false
    ) INTO v_is_owner;

    IF NOT v_is_owner THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'NOT_OWNER',
            'message', '해당 회사의 소유자만 직원을 삭제할 수 있습니다.'
        );
    END IF;

    -- 2. 삭제 대상 직원이 해당 회사 소속인지 확인
    SELECT EXISTS(
        SELECT 1 FROM user_companies
        WHERE company_id = p_company_id
          AND user_id = p_employee_user_id
          AND is_deleted = false
    ) INTO v_employee_exists;

    IF NOT v_employee_exists THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'EMPLOYEE_NOT_FOUND',
            'message', '해당 직원이 이 회사에 소속되어 있지 않습니다.'
        );
    END IF;

    -- 3. 자기 자신을 삭제하려는 경우 차단
    IF p_employee_user_id = p_requester_user_id THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'CANNOT_DELETE_SELF',
            'message', '자기 자신을 삭제할 수 없습니다.'
        );
    END IF;

    -- 4. 직원 정보 가져오기
    SELECT jsonb_build_object(
        'user_id', u.user_id,
        'name', COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, ''),
        'email', u.email
    ) INTO v_employee_info
    FROM users u
    WHERE u.user_id = p_employee_user_id;

    -- 5. 연결된 데이터 카운트 (삭제될 것과 보존될 것 구분)
    SELECT jsonb_build_object(
        'will_soft_delete', jsonb_build_object(
            'user_companies', (SELECT COUNT(*) FROM user_companies
                               WHERE user_id = p_employee_user_id
                                 AND company_id = p_company_id
                                 AND is_deleted = false),
            'user_stores', (SELECT COUNT(*) FROM user_stores us
                            JOIN stores s ON us.store_id = s.store_id
                            WHERE us.user_id = p_employee_user_id
                              AND s.company_id = p_company_id
                              AND us.is_deleted = false),
            'user_roles', (SELECT COUNT(*) FROM user_roles ur
                           JOIN roles r ON ur.role_id = r.role_id
                           WHERE ur.user_id = p_employee_user_id
                             AND r.company_id = p_company_id
                             AND ur.is_deleted = false)
        ),
        'will_hard_delete', jsonb_build_object(
            'user_salaries', (SELECT COUNT(*) FROM user_salaries
                              WHERE user_id = p_employee_user_id
                                AND company_id = p_company_id)
        ),
        'will_preserve', jsonb_build_object(
            'shift_requests', (SELECT COUNT(*) FROM shift_requests sr
                               JOIN stores s ON sr.store_id = s.store_id
                               WHERE sr.user_id = p_employee_user_id
                                 AND s.company_id = p_company_id),
            'journal_entries_created', (SELECT COUNT(*) FROM journal_entries
                                        WHERE created_by = p_employee_user_id
                                          AND company_id = p_company_id
                                          AND is_deleted = false),
            'cash_amount_entries', (SELECT COUNT(*) FROM cash_amount_entries
                                    WHERE created_by = p_employee_user_id
                                      AND company_id = p_company_id),
            'inventory_invoice', (SELECT COUNT(*) FROM inventory_invoice
                                  WHERE created_by = p_employee_user_id
                                    AND company_id = p_company_id)
        )
    ) INTO v_counts;

    RETURN jsonb_build_object(
        'success', true,
        'message', '삭제 가능합니다.',
        'employee', v_employee_info,
        'company_id', p_company_id,
        'data_summary', v_counts
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. 직원 삭제 실행 함수
-- 기본값: Soft Delete (is_deleted = true)
-- p_delete_salary = true: 급여 정보도 삭제
CREATE OR REPLACE FUNCTION delete_employee_from_company(
    p_company_id UUID,
    p_employee_user_id UUID,
    p_requester_user_id UUID,
    p_delete_salary BOOLEAN DEFAULT true  -- 급여 정보 삭제 여부
)
RETURNS JSONB AS $$
DECLARE
    v_validation JSONB;
    v_store_ids UUID[];
    v_role_ids UUID[];
    v_affected JSONB;
    v_user_stores_count INT := 0;
    v_user_roles_count INT := 0;
    v_user_companies_count INT := 0;
    v_user_salaries_count INT := 0;
BEGIN
    -- 1. 먼저 검증 실행
    v_validation := validate_employee_deletion(p_company_id, p_employee_user_id, p_requester_user_id);

    IF NOT (v_validation->>'success')::boolean THEN
        RETURN v_validation;
    END IF;

    -- 2. 해당 회사의 store_id, role_id 목록 가져오기
    SELECT ARRAY_AGG(store_id) INTO v_store_ids
    FROM stores WHERE company_id = p_company_id AND is_deleted = false;

    SELECT ARRAY_AGG(role_id) INTO v_role_ids
    FROM roles WHERE company_id = p_company_id;

    -- =====================================================
    -- 3. Soft Delete 실행 (is_deleted = true)
    -- =====================================================

    -- user_stores: 매장 배정 해제
    IF v_store_ids IS NOT NULL AND array_length(v_store_ids, 1) > 0 THEN
        WITH updated AS (
            UPDATE user_stores
            SET is_deleted = true,
                deleted_at = NOW(),
                deleted_at_utc = NOW()
            WHERE user_id = p_employee_user_id
              AND store_id = ANY(v_store_ids)
              AND is_deleted = false
            RETURNING 1
        )
        SELECT COUNT(*) INTO v_user_stores_count FROM updated;
    END IF;

    -- user_roles: 역할 해제
    IF v_role_ids IS NOT NULL AND array_length(v_role_ids, 1) > 0 THEN
        WITH updated AS (
            UPDATE user_roles
            SET is_deleted = true,
                deleted_at = NOW(),
                deleted_at_utc = NOW()
            WHERE user_id = p_employee_user_id
              AND role_id = ANY(v_role_ids)
              AND is_deleted = false
            RETURNING 1
        )
        SELECT COUNT(*) INTO v_user_roles_count FROM updated;
    END IF;

    -- user_companies: 회사 소속 해제
    WITH updated AS (
        UPDATE user_companies
        SET is_deleted = true,
            deleted_at = NOW(),
            deleted_at_utc = NOW()
        WHERE user_id = p_employee_user_id
          AND company_id = p_company_id
          AND is_deleted = false
        RETURNING 1
    )
    SELECT COUNT(*) INTO v_user_companies_count FROM updated;

    -- =====================================================
    -- 4. Hard Delete (선택적)
    -- =====================================================

    -- user_salaries: 급여 정보 삭제 (요청 시에만)
    IF p_delete_salary THEN
        WITH deleted AS (
            DELETE FROM user_salaries
            WHERE user_id = p_employee_user_id
              AND company_id = p_company_id
            RETURNING 1
        )
        SELECT COUNT(*) INTO v_user_salaries_count FROM deleted;
    END IF;

    -- =====================================================
    -- 5. 결과 반환
    -- =====================================================

    v_affected := jsonb_build_object(
        'user_stores_soft_deleted', v_user_stores_count,
        'user_roles_soft_deleted', v_user_roles_count,
        'user_companies_soft_deleted', v_user_companies_count,
        'user_salaries_deleted', v_user_salaries_count
    );

    RETURN jsonb_build_object(
        'success', true,
        'message', '직원이 회사에서 제거되었습니다.',
        'employee_id', p_employee_user_id,
        'company_id', p_company_id,
        'affected', v_affected,
        'deleted_at', NOW(),
        'note', 'users 테이블은 유지됩니다. 근무 기록 등 히스토리 데이터도 보존됩니다.'
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'success', false,
        'error', 'DELETE_FAILED',
        'message', SQLERRM,
        'detail', SQLSTATE
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. 간편 호출 함수 (auth.uid() 자동 사용)
CREATE OR REPLACE FUNCTION delete_employee(
    p_company_id UUID,
    p_employee_user_id UUID,
    p_delete_salary BOOLEAN DEFAULT true
)
RETURNS JSONB AS $$
BEGIN
    RETURN delete_employee_from_company(
        p_company_id,
        p_employee_user_id,
        auth.uid(),
        p_delete_salary
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. 삭제 전 검증만 하는 간편 함수
CREATE OR REPLACE FUNCTION validate_employee_delete(
    p_company_id UUID,
    p_employee_user_id UUID
)
RETURNS JSONB AS $$
BEGIN
    RETURN validate_employee_deletion(
        p_company_id,
        p_employee_user_id,
        auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. 함수 설명 추가
COMMENT ON FUNCTION validate_employee_deletion IS '직원 삭제 전 검증 - Owner 권한 확인, 삭제/보존될 데이터 카운트 반환';
COMMENT ON FUNCTION delete_employee_from_company IS '직원 삭제 실행 - Soft Delete 기반, users 테이블은 유지';
COMMENT ON FUNCTION delete_employee IS '직원 삭제 (auth.uid() 자동 사용)';
COMMENT ON FUNCTION validate_employee_delete IS '직원 삭제 검증 (auth.uid() 자동 사용)';

-- =====================================================
-- 사용 예시
-- =====================================================
--
-- 1. 삭제 전 검증 (Flutter에서 호출)
--    SELECT validate_employee_delete('company_id', 'employee_user_id');
--
--    반환값:
--    {
--      "success": true,
--      "employee": {"name": "홍길동", "email": "..."},
--      "data_summary": {
--        "will_soft_delete": {"user_companies": 1, "user_stores": 2, "user_roles": 1},
--        "will_hard_delete": {"user_salaries": 1},
--        "will_preserve": {"shift_requests": 45, "journal_entries_created": 10, ...}
--      }
--    }
--
-- 2. 직원 삭제 (급여 정보도 삭제)
--    SELECT delete_employee('company_id', 'employee_user_id', true);
--
-- 3. 직원 삭제 (급여 정보 유지)
--    SELECT delete_employee('company_id', 'employee_user_id', false);
--
-- =====================================================
-- 안전성 체크리스트
-- =====================================================
--
-- ✅ users 테이블 삭제하지 않음 (다른 회사 소속 가능)
-- ✅ NOT NULL FK 컬럼 건드리지 않음 (에러 방지)
-- ✅ created_by 참조 유지 (히스토리 보존)
-- ✅ shift_requests 유지 (근무 기록 보존)
-- ✅ journal_entries 유지 (회계 기록 보존)
-- ✅ Soft Delete 사용 (복구 가능)
-- ✅ Owner 권한 검증
-- ✅ 자기 자신 삭제 차단
--
-- =====================================================
