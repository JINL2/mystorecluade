-- Migration: Create monthly_attendance table for monthly salary employees
-- Purpose: Track daily check-in/check-out for monthly employees (separate from shift_requests)

-- ============================================================================
-- 1. Create monthly_attendance table
-- ============================================================================
CREATE TABLE IF NOT EXISTS monthly_attendance (
  attendance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES companies(company_id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(store_id) ON DELETE SET NULL,  -- QR 스캔한 매장
  work_schedule_template_id UUID REFERENCES work_schedule_templates(template_id) ON DELETE SET NULL,

  -- 날짜 및 시간
  attendance_date DATE NOT NULL,
  scheduled_start_time TIME,  -- 템플릿에서 가져온 예정 시작 (로컬)
  scheduled_end_time TIME,    -- 템플릿에서 가져온 예정 종료 (로컬)
  check_in_time TIMESTAMPTZ,  -- 실제 체크인 (UTC)
  check_out_time TIMESTAMPTZ, -- 실제 체크아웃 (UTC)

  -- 위치 정보
  check_in_lat DECIMAL(10, 8),
  check_in_lng DECIMAL(11, 8),
  check_out_lat DECIMAL(10, 8),
  check_out_lng DECIMAL(11, 8),

  -- 상태
  status TEXT NOT NULL DEFAULT 'scheduled'
    CHECK (status IN ('scheduled', 'present', 'absent', 'late', 'early_leave', 'holiday', 'leave')),

  -- 문제 감지
  is_late BOOLEAN DEFAULT false,
  late_minutes INT DEFAULT 0,
  is_early_leave BOOLEAN DEFAULT false,
  early_leave_minutes INT DEFAULT 0,
  has_location_issue BOOLEAN DEFAULT false,

  -- 메타데이터
  notes TEXT,
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW(),

  -- 유니크 제약 (하루에 한 출근 기록)
  UNIQUE(user_id, company_id, attendance_date)
);

-- ============================================================================
-- 2. Create indexes
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_monthly_attendance_user_date
  ON monthly_attendance(user_id, attendance_date DESC);

CREATE INDEX IF NOT EXISTS idx_monthly_attendance_company_date
  ON monthly_attendance(company_id, attendance_date DESC);

CREATE INDEX IF NOT EXISTS idx_monthly_attendance_status
  ON monthly_attendance(status);

-- ============================================================================
-- 3. Enable RLS
-- ============================================================================
ALTER TABLE monthly_attendance ENABLE ROW LEVEL SECURITY;

-- Users can view own attendance
CREATE POLICY "monthly_attendance_select_own"
  ON monthly_attendance FOR SELECT
  USING (user_id = auth.uid());

-- Users can insert own attendance
CREATE POLICY "monthly_attendance_insert_own"
  ON monthly_attendance FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Users can update own attendance
CREATE POLICY "monthly_attendance_update_own"
  ON monthly_attendance FOR UPDATE
  USING (user_id = auth.uid());

-- Managers/Admins can view company attendance
CREATE POLICY "monthly_attendance_select_company"
  ON monthly_attendance FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM user_companies uc
      WHERE uc.user_id = auth.uid()
        AND uc.company_id = monthly_attendance.company_id
        AND uc.role IN ('owner', 'admin', 'manager')
    )
  );

-- ============================================================================
-- 4. Create trigger for updated_at
-- ============================================================================
CREATE OR REPLACE FUNCTION update_monthly_attendance_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at_utc = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_monthly_attendance_updated_at ON monthly_attendance;
CREATE TRIGGER trigger_monthly_attendance_updated_at
  BEFORE UPDATE ON monthly_attendance
  FOR EACH ROW
  EXECUTE FUNCTION update_monthly_attendance_updated_at();

-- ============================================================================
-- 5. Add comment
-- ============================================================================
COMMENT ON TABLE monthly_attendance IS 'Daily attendance records for monthly salary employees. Each row represents one day of attendance.';
