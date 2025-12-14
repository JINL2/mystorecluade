-- ============================================
-- v_shift_request_ai: AI 전용 깔끔한 View
-- ============================================
-- 목적: deprecated 컬럼 제외, AI가 필요한 컬럼만 포함
-- 원본: v_shift_request (101개 컬럼 → 30개로 축소)
-- ============================================

CREATE OR REPLACE VIEW v_shift_request_ai AS
SELECT
  -- 🔑 식별자
  shift_request_id,
  company_id,
  store_id,
  store_name,
  user_id,
  user_name,

  -- 📅 시간 (UTC만 - 로컬 변환은 쿼리에서)
  start_time_utc,              -- 예정 시작
  end_time_utc,                -- 예정 종료
  actual_start_time_utc,       -- 실제 출근
  actual_end_time_utc,         -- 실제 퇴근
  confirm_start_time_v2,       -- 급여용 시작
  confirm_end_time_v2,         -- 급여용 종료

  -- ⏱️ 근무시간
  scheduled_hours_v2,          -- 예정 근무시간
  actual_worked_hours_v2,      -- 실제 근무시간
  paid_hours_v2,               -- 급여 지급 시간

  -- 💰 급여
  salary_amount,               -- 기본 급여
  bonus_amount_v2,             -- 보너스
  total_pay_with_bonus_v2,     -- 총 급여 (보너스 포함)

  -- ✅ 상태
  is_approved,                 -- 승인 여부 (CRITICAL!)

  -- 🚨 문제 정보 (핵심!)
  problem_details_v2,          -- JSON: 지각/초과근무/결근 모든 정보
  is_problem_solved_v2,        -- 문제 해결 여부

  -- 📝 보고
  is_reported_v2,              -- 직원 사유 보고 여부
  report_reason_v2,            -- 보고 사유
  report_time_utc,             -- 보고 시간
  is_reported_solved_v2,       -- 보고 처리 여부

  -- 📍 위치
  is_valid_checkin_location_v2,
  is_valid_checkout_location_v2,
  checkin_distance_from_store_v2,
  checkout_distance_from_store_v2,

  -- 📋 기타
  manager_memo_v2,             -- 매니저 메모
  shift_id,                    -- 시프트 ID
  shift_name                   -- 시프트 이름

FROM v_shift_request;

-- View 설명 추가
COMMENT ON VIEW v_shift_request_ai IS 'AI 전용 시프트 View. deprecated 컬럼 제외됨. 문제 조회는 problem_details_v2 사용!';
