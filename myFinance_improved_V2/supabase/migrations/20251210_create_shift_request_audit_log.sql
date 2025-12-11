-- =====================================================
-- shift_request_audit_log 테이블 생성
-- 모든 INSERT, UPDATE, DELETE 자동 로깅
--
-- 실행 방법:
-- 1. Supabase Dashboard > SQL Editor에서 실행
-- 2. 또는 supabase db push 명령어 사용
-- =====================================================

-- 1. 감사 로그 테이블 생성
CREATE TABLE IF NOT EXISTS shift_request_audit_log (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- 대상 레코드
    shift_request_id UUID NOT NULL,

    -- 작업 유형: INSERT, UPDATE, DELETE
    operation TEXT NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),

    -- 변경 전/후 데이터 (전체 행)
    old_data JSONB,  -- UPDATE, DELETE 시 저장
    new_data JSONB,  -- INSERT, UPDATE 시 저장

    -- 변경된 컬럼 목록 (UPDATE 시에만)
    changed_columns TEXT[],

    -- 변경 정보
    changed_by UUID,  -- auth.uid() 또는 앱에서 전달
    changed_at TIMESTAMPTZ DEFAULT NOW(),

    -- 추가 컨텍스트
    client_info JSONB,  -- IP, user-agent 등
    reason TEXT  -- 변경 사유 (선택적)
);

-- 2. 인덱스 생성
CREATE INDEX idx_audit_shift_request_id ON shift_request_audit_log(shift_request_id);
CREATE INDEX idx_audit_operation ON shift_request_audit_log(operation);
CREATE INDEX idx_audit_changed_at ON shift_request_audit_log(changed_at DESC);
CREATE INDEX idx_audit_changed_by ON shift_request_audit_log(changed_by);

-- 복합 인덱스: 특정 레코드의 변경 이력 조회용
CREATE INDEX idx_audit_shift_request_time ON shift_request_audit_log(shift_request_id, changed_at DESC);

-- 3. 트리거 함수 생성
CREATE OR REPLACE FUNCTION fn_shift_request_audit()
RETURNS TRIGGER AS $$
DECLARE
    v_old_data JSONB;
    v_new_data JSONB;
    v_changed_columns TEXT[];
    v_changed_by UUID;
    v_key TEXT;
BEGIN
    -- 변경자 결정: auth.uid() 사용, 없으면 NULL
    BEGIN
        v_changed_by := auth.uid();
    EXCEPTION WHEN OTHERS THEN
        v_changed_by := NULL;
    END;

    IF TG_OP = 'INSERT' THEN
        -- INSERT: new_data만 저장
        v_new_data := to_jsonb(NEW);

        INSERT INTO shift_request_audit_log (
            shift_request_id,
            operation,
            old_data,
            new_data,
            changed_columns,
            changed_by
        ) VALUES (
            NEW.shift_request_id,
            'INSERT',
            NULL,
            v_new_data,
            NULL,
            v_changed_by
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        -- UPDATE: old_data, new_data, changed_columns 저장
        v_old_data := to_jsonb(OLD);
        v_new_data := to_jsonb(NEW);

        -- 변경된 컬럼 찾기
        v_changed_columns := ARRAY[]::TEXT[];
        FOR v_key IN SELECT jsonb_object_keys(v_new_data)
        LOOP
            IF v_old_data->v_key IS DISTINCT FROM v_new_data->v_key THEN
                v_changed_columns := array_append(v_changed_columns, v_key);
            END IF;
        END LOOP;

        -- 변경된 컬럼이 있을 때만 로깅
        IF array_length(v_changed_columns, 1) > 0 THEN
            INSERT INTO shift_request_audit_log (
                shift_request_id,
                operation,
                old_data,
                new_data,
                changed_columns,
                changed_by
            ) VALUES (
                NEW.shift_request_id,
                'UPDATE',
                v_old_data,
                v_new_data,
                v_changed_columns,
                v_changed_by
            );
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        -- DELETE: old_data만 저장
        v_old_data := to_jsonb(OLD);

        INSERT INTO shift_request_audit_log (
            shift_request_id,
            operation,
            old_data,
            new_data,
            changed_columns,
            changed_by
        ) VALUES (
            OLD.shift_request_id,
            'DELETE',
            v_old_data,
            NULL,
            NULL,
            v_changed_by
        );

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. 트리거 생성 (기존 트리거 있으면 삭제 후 재생성)
DROP TRIGGER IF EXISTS trg_shift_request_audit ON shift_requests;

CREATE TRIGGER trg_shift_request_audit
    AFTER INSERT OR UPDATE OR DELETE ON shift_requests
    FOR EACH ROW
    EXECUTE FUNCTION fn_shift_request_audit();

-- 5. 테이블 코멘트
COMMENT ON TABLE shift_request_audit_log IS '근무 요청(shift_requests) 테이블의 모든 변경사항을 자동으로 기록하는 감사 로그';
COMMENT ON COLUMN shift_request_audit_log.audit_id IS '감사 로그 고유 ID';
COMMENT ON COLUMN shift_request_audit_log.shift_request_id IS '변경된 shift_request의 ID';
COMMENT ON COLUMN shift_request_audit_log.operation IS '작업 유형: INSERT, UPDATE, DELETE';
COMMENT ON COLUMN shift_request_audit_log.old_data IS '변경 전 데이터 (UPDATE, DELETE 시)';
COMMENT ON COLUMN shift_request_audit_log.new_data IS '변경 후 데이터 (INSERT, UPDATE 시)';
COMMENT ON COLUMN shift_request_audit_log.changed_columns IS '변경된 컬럼 목록 (UPDATE 시)';
COMMENT ON COLUMN shift_request_audit_log.changed_by IS '변경한 사용자 ID';
COMMENT ON COLUMN shift_request_audit_log.changed_at IS '변경 시각';
COMMENT ON COLUMN shift_request_audit_log.client_info IS '클라이언트 정보 (IP, user-agent 등)';
COMMENT ON COLUMN shift_request_audit_log.reason IS '변경 사유';

-- 6. RLS 정책 (보안 설정)
ALTER TABLE shift_request_audit_log ENABLE ROW LEVEL SECURITY;

-- 읽기: 인증된 사용자만
CREATE POLICY "audit_log_select_policy" ON shift_request_audit_log
    FOR SELECT
    TO authenticated
    USING (true);

-- 쓰기: 트리거에서만 (SECURITY DEFINER 함수 통해서만)
-- 일반 사용자는 직접 INSERT/UPDATE/DELETE 불가
CREATE POLICY "audit_log_insert_policy" ON shift_request_audit_log
    FOR INSERT
    TO authenticated
    WITH CHECK (false);  -- 트리거는 SECURITY DEFINER라 우회됨

-- =====================================================
-- 유틸리티 함수들
-- =====================================================

-- 특정 shift_request의 변경 이력 조회
CREATE OR REPLACE FUNCTION get_shift_request_history(p_shift_request_id UUID)
RETURNS TABLE (
    audit_id UUID,
    operation TEXT,
    changed_columns TEXT[],
    changed_by UUID,
    changed_at TIMESTAMPTZ,
    old_data JSONB,
    new_data JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        sal.audit_id,
        sal.operation,
        sal.changed_columns,
        sal.changed_by,
        sal.changed_at,
        sal.old_data,
        sal.new_data
    FROM shift_request_audit_log sal
    WHERE sal.shift_request_id = p_shift_request_id
    ORDER BY sal.changed_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 특정 컬럼의 변경 이력만 조회
CREATE OR REPLACE FUNCTION get_column_change_history(
    p_shift_request_id UUID,
    p_column_name TEXT
)
RETURNS TABLE (
    changed_at TIMESTAMPTZ,
    old_value JSONB,
    new_value JSONB,
    changed_by UUID
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        sal.changed_at,
        sal.old_data->p_column_name as old_value,
        sal.new_data->p_column_name as new_value,
        sal.changed_by
    FROM shift_request_audit_log sal
    WHERE sal.shift_request_id = p_shift_request_id
      AND sal.operation = 'UPDATE'
      AND p_column_name = ANY(sal.changed_columns)
    ORDER BY sal.changed_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 최근 N일간의 변경 통계
CREATE OR REPLACE FUNCTION get_audit_statistics(p_days INT DEFAULT 7)
RETURNS TABLE (
    operation TEXT,
    change_count BIGINT,
    unique_records BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        sal.operation,
        COUNT(*) as change_count,
        COUNT(DISTINCT sal.shift_request_id) as unique_records
    FROM shift_request_audit_log sal
    WHERE sal.changed_at >= NOW() - (p_days || ' days')::INTERVAL
    GROUP BY sal.operation
    ORDER BY change_count DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
