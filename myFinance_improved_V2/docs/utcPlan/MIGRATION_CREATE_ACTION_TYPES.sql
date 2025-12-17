-- ================================================================
-- MIGRATION: Create ontology_action_types table
-- Date: 2025-12-16
-- Purpose: Define user actions (세부 행동) that create events
--
-- 구조:
--   features = UI 페이지/권한 (Attendance, Journal Input...)
--   ontology_action_types = 세부 행동 (check_in, check_out, approve_shift...)
--   ontology_event_types = 행동의 결과 기록 (ShiftEvent, TransactionEvent...)
--
-- RUN THIS IN SUPABASE DASHBOARD SQL EDITOR!
-- ================================================================

-- ================================================================
-- PART 1: Create ontology_action_types table
-- ================================================================

CREATE TABLE IF NOT EXISTS ontology_action_types (
  -- ================================================================
  -- 기본 정보
  -- ================================================================
  action_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action_name TEXT NOT NULL UNIQUE,       -- 'check_in', 'approve_shift', 'delete_transaction'
  action_name_ko TEXT,                    -- '체크인', '시프트 승인'
  action_name_en TEXT,                    -- 'Check In', 'Approve Shift'
  action_name_vi TEXT,                    -- 'Chấm công vào'

  -- ================================================================
  -- 행동 주체 (누가?)
  -- ================================================================
  actor_type TEXT NOT NULL,               -- 'employee', 'manager', 'admin', 'system'
  actor_table TEXT DEFAULT 'users',       -- 보통 users, 시스템이면 NULL

  -- ================================================================
  -- 대상 (무엇에?)
  -- ================================================================
  target_table TEXT NOT NULL,             -- 'shift_requests', 'journal_entries'
  target_object TEXT,                     -- 'Shift', 'Transaction' (개념적 이름)
  target_column TEXT,                     -- 수정되는 주요 컬럼 (예: 'status', 'is_approved')

  -- ================================================================
  -- Feature 연결 (어떤 기능에서?)
  -- ================================================================
  feature_id UUID REFERENCES features(feature_id),

  -- ================================================================
  -- 조건 (언제 가능?)
  -- ================================================================
  preconditions JSONB,                    -- {"status": "pending", "is_approved": false}
  required_roles TEXT[],                  -- ['employee'] or ['manager', 'admin']

  -- ================================================================
  -- 결과 (무엇이 발생?)
  -- ================================================================
  operation_type TEXT,                    -- 'INSERT', 'UPDATE', 'DELETE'
  postconditions JSONB,                   -- {"status": "approved", "approved_at": "NOW()"}
  creates_event TEXT,                     -- 'ShiftEvent' → ontology_event_types.event_name
  affects_tables TEXT[],                  -- ['shift_requests', 'notifications']

  -- ================================================================
  -- AI 힌트
  -- ================================================================
  ai_usage_hint TEXT,
  typical_questions JSONB,                -- ["누가 체크인했어?", "승인 대기 중인 시프트"]

  -- ================================================================
  -- 메타
  -- ================================================================
  action_category TEXT,                   -- 'hr', 'finance', 'inventory', 'cash'
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_action_types_feature ON ontology_action_types(feature_id);
CREATE INDEX IF NOT EXISTS idx_action_types_target ON ontology_action_types(target_table);
CREATE INDEX IF NOT EXISTS idx_action_types_category ON ontology_action_types(action_category);
CREATE INDEX IF NOT EXISTS idx_action_types_event ON ontology_action_types(creates_event);

-- ================================================================
-- PART 2: Insert HR Actions (Attendance/Shift)
-- ================================================================

INSERT INTO ontology_action_types (
  action_name, action_name_ko, action_name_en, action_name_vi,
  actor_type, target_table, target_object, target_column,
  feature_id, preconditions, required_roles,
  operation_type, postconditions, creates_event, affects_tables,
  ai_usage_hint, typical_questions, action_category
) VALUES
-- Check In
(
  'check_in', '체크인', 'Check In', 'Chấm công vào',
  'employee', 'shift_requests', 'Shift', 'check_in_time',
  (SELECT feature_id FROM features WHERE feature_name = 'Attendance'),
  '{"is_approved": true, "check_in_time": null}',
  ARRAY['employee', 'manager', 'admin'],
  'UPDATE', '{"check_in_time": "NOW()"}', 'ShiftEvent',
  ARRAY['shift_requests', 'v_shift_request_ai'],
  '⭐ 직원 출근 기록. check_in_time이 설정됨. v_shift_request_ai에서 조회.',
  '["오늘 출근한 직원", "누가 체크인했어?", "출근 현황"]',
  'hr'
),
-- Check Out
(
  'check_out', '체크아웃', 'Check Out', 'Chấm công ra',
  'employee', 'shift_requests', 'Shift', 'check_out_time',
  (SELECT feature_id FROM features WHERE feature_name = 'Attendance'),
  '{"check_in_time": "NOT NULL", "check_out_time": null}',
  ARRAY['employee', 'manager', 'admin'],
  'UPDATE', '{"check_out_time": "NOW()"}', 'ShiftEvent',
  ARRAY['shift_requests', 'v_shift_request_ai'],
  '⭐ 직원 퇴근 기록. check_out_time이 설정됨. 일찍 퇴근 = check_out_time < end_time.',
  '["오늘 퇴근한 직원", "일찍 퇴근한 사람", "퇴근 현황"]',
  'hr'
),
-- Request Shift
(
  'request_shift', '시프트 신청', 'Request Shift', 'Yêu cầu ca',
  'employee', 'shift_requests', 'Shift', NULL,
  (SELECT feature_id FROM features WHERE feature_name = 'Attendance'),
  NULL,
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', '{"is_approved": false}', 'ShiftEvent',
  ARRAY['shift_requests'],
  '⭐ 새 시프트 신청. 승인 대기 상태로 생성됨.',
  '["시프트 신청 현황", "대기 중인 시프트"]',
  'hr'
),
-- Approve Shift
(
  'approve_shift', '시프트 승인', 'Approve Shift', 'Duyệt ca',
  'manager', 'shift_requests', 'Shift', 'is_approved',
  (SELECT feature_id FROM features WHERE feature_name = 'Attendance'),
  '{"is_approved": false}',
  ARRAY['manager', 'admin'],
  'UPDATE', '{"is_approved": true, "approved_by": "$user_id", "approved_at": "NOW()"}', 'ShiftEvent',
  ARRAY['shift_requests', 'notifications'],
  '⭐ 매니저가 시프트 승인. is_approved = true로 변경.',
  '["승인된 시프트", "누가 승인했어?"]',
  'hr'
),
-- Reject Shift
(
  'reject_shift', '시프트 거절', 'Reject Shift', 'Từ chối ca',
  'manager', 'shift_requests', 'Shift', 'is_approved',
  (SELECT feature_id FROM features WHERE feature_name = 'Attendance'),
  '{"is_approved": false}',
  ARRAY['manager', 'admin'],
  'UPDATE', '{"is_rejected": true, "rejected_by": "$user_id"}', 'ShiftEvent',
  ARRAY['shift_requests', 'notifications'],
  '⭐ 매니저가 시프트 거절.',
  '["거절된 시프트", "왜 거절됐어?"]',
  'hr'
)
ON CONFLICT (action_name) DO UPDATE SET
  action_name_ko = EXCLUDED.action_name_ko,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  typical_questions = EXCLUDED.typical_questions;

-- ================================================================
-- PART 3: Insert Finance Actions (Transactions)
-- ================================================================

INSERT INTO ontology_action_types (
  action_name, action_name_ko, action_name_en, action_name_vi,
  actor_type, target_table, target_object, target_column,
  feature_id, preconditions, required_roles,
  operation_type, postconditions, creates_event, affects_tables,
  ai_usage_hint, typical_questions, action_category
) VALUES
-- Create Transaction
(
  'create_transaction', '거래 생성', 'Create Transaction', 'Tạo giao dịch',
  'employee', 'journal_entries', 'Transaction', NULL,
  (SELECT feature_id FROM features WHERE feature_name = 'Journal Input' OR route = 'journalInput' LIMIT 1),
  NULL,
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', '{"is_posted": false}', 'TransactionEvent',
  ARRAY['journal_entries', 'journal_lines'],
  '⭐ 새 거래 생성. journal_entries + journal_lines에 INSERT.',
  '["오늘 생성된 거래", "누가 거래 입력했어?"]',
  'finance'
),
-- Post Transaction
(
  'post_transaction', '거래 전기', 'Post Transaction', 'Ghi sổ giao dịch',
  'manager', 'journal_entries', 'Transaction', 'is_posted',
  (SELECT feature_id FROM features WHERE feature_name = 'Journal Input' OR route = 'journalInput' LIMIT 1),
  '{"is_posted": false}',
  ARRAY['manager', 'admin'],
  'UPDATE', '{"is_posted": true, "posted_at": "NOW()"}', 'TransactionEvent',
  ARRAY['journal_entries', 'company_financial_metrics'],
  '⭐ 거래 전기(확정). is_posted = true. 재무제표에 반영됨.',
  '["전기된 거래", "미전기 거래"]',
  'finance'
),
-- Delete Transaction
(
  'delete_transaction', '거래 삭제', 'Delete Transaction', 'Xóa giao dịch',
  'admin', 'journal_entries', 'Transaction', NULL,
  (SELECT feature_id FROM features WHERE feature_name = 'Delete Transaction'),
  '{"is_posted": false}',
  ARRAY['admin'],
  'DELETE', NULL, 'TransactionEvent',
  ARRAY['journal_entries', 'journal_lines', 'audit_logs'],
  '⭐⭐ 거래 삭제. admin만 가능. is_posted=false인 것만 삭제 가능.',
  '["삭제된 거래", "누가 삭제했어?"]',
  'finance'
)
ON CONFLICT (action_name) DO UPDATE SET
  action_name_ko = EXCLUDED.action_name_ko,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  typical_questions = EXCLUDED.typical_questions;

-- ================================================================
-- PART 4: Insert Cash Actions
-- ================================================================

INSERT INTO ontology_action_types (
  action_name, action_name_ko, action_name_en, action_name_vi,
  actor_type, target_table, target_object, target_column,
  feature_id, preconditions, required_roles,
  operation_type, postconditions, creates_event, affects_tables,
  ai_usage_hint, typical_questions, action_category
) VALUES
-- Cash In
(
  'cash_in', '현금 입금', 'Cash In', 'Nạp tiền',
  'employee', 'cash_amount_entries', 'CashEntry', 'amount',
  (SELECT feature_id FROM features WHERE feature_name = 'Cash Ending' OR route = 'cashEnding' LIMIT 1),
  NULL,
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', '{"direction": "in"}', 'CashEntry',
  ARRAY['cash_amount_entries', 'v_cash_location'],
  '⭐ 현금 입금. direction = in.',
  '["오늘 입금 내역", "현금 입금 현황"]',
  'cash'
),
-- Cash Out
(
  'cash_out', '현금 출금', 'Cash Out', 'Rút tiền',
  'employee', 'cash_amount_entries', 'CashEntry', 'amount',
  (SELECT feature_id FROM features WHERE feature_name = 'Cash Ending' OR route = 'cashEnding' LIMIT 1),
  NULL,
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', '{"direction": "out"}', 'CashEntry',
  ARRAY['cash_amount_entries', 'v_cash_location'],
  '⭐ 현금 출금. direction = out.',
  '["오늘 출금 내역", "현금 출금 현황"]',
  'cash'
),
-- Recount Cash
(
  'recount_cash', '시재 재확인', 'Recount Cash', 'Kiểm đếm lại',
  'employee', 'cash_amount_entries', 'CashEntry', 'method_type',
  (SELECT feature_id FROM features WHERE feature_name = 'Cash Ending' OR route = 'cashEnding' LIMIT 1),
  NULL,
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', '{"method_type": "stock"}', 'CashEntry',
  ARRAY['cash_amount_entries', 'v_cash_location'],
  '⭐ 현금 시재 재확인. method_type = stock.',
  '["Recount 내역", "시재 확인 기록"]',
  'cash'
)
ON CONFLICT (action_name) DO UPDATE SET
  action_name_ko = EXCLUDED.action_name_ko,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  typical_questions = EXCLUDED.typical_questions;

-- ================================================================
-- PART 5: Insert Debt Actions
-- ================================================================

INSERT INTO ontology_action_types (
  action_name, action_name_ko, action_name_en, action_name_vi,
  actor_type, target_table, target_object, target_column,
  feature_id, preconditions, required_roles,
  operation_type, postconditions, creates_event, affects_tables,
  ai_usage_hint, typical_questions, action_category
) VALUES
-- Create Debt
(
  'create_debt', '채권/채무 생성', 'Create Debt', 'Tạo công nợ',
  'employee', 'debts_receivable', 'Debt', NULL,
  (SELECT feature_id FROM features WHERE feature_name = 'Debt Control'),
  NULL,
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', '{"is_active": true}', 'DebtEvent',
  ARRAY['debts_receivable'],
  '⭐ 새 채권/채무 생성. direction으로 receivable/payable 구분.',
  '["새로 생긴 미수금", "채무 생성 내역"]',
  'finance'
),
-- Record Payment
(
  'record_payment', '결제 기록', 'Record Payment', 'Ghi nhận thanh toán',
  'employee', 'debt_payments', 'Payment', 'amount',
  (SELECT feature_id FROM features WHERE feature_name = 'Debt Control'),
  '{"debt.is_active": true}',
  ARRAY['employee', 'manager', 'admin'],
  'INSERT', NULL, 'PaymentEvent',
  ARRAY['debt_payments', 'debts_receivable'],
  '⭐ 채권/채무 결제 기록.',
  '["이번 달 결제 내역", "미수금 회수 현황"]',
  'finance'
)
ON CONFLICT (action_name) DO UPDATE SET
  action_name_ko = EXCLUDED.action_name_ko,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  typical_questions = EXCLUDED.typical_questions;

-- ================================================================
-- PART 6: Register in ontology_columns
-- ================================================================

INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint) VALUES
('ontology_action_types', 'action_id', 'uuid', true, 'PK'),
('ontology_action_types', 'action_name', 'text', true, '⭐⭐ 액션 이름 (check_in, approve_shift 등). 세부 행동 정의.'),
('ontology_action_types', 'actor_type', 'text', true, '⭐ 행동 주체 (employee, manager, admin, system)'),
('ontology_action_types', 'target_table', 'text', true, '⭐⭐ 이 액션이 조작하는 테이블. Path 탐색의 핵심!'),
('ontology_action_types', 'feature_id', 'uuid', true, '⭐ FK → features. 이 액션이 속한 기능.'),
('ontology_action_types', 'creates_event', 'text', true, '⭐⭐ 이 액션이 생성하는 이벤트 → ontology_event_types.event_name'),
('ontology_action_types', 'affects_tables', 'text[]', true, '⭐ 이 액션이 영향 미치는 모든 테이블 목록'),
('ontology_action_types', 'required_roles', 'text[]', true, '⭐ 이 액션을 수행할 수 있는 역할 목록'),
('ontology_action_types', 'ai_usage_hint', 'text', true, 'AI가 이 액션을 이해하기 위한 힌트')
ON CONFLICT (table_name, column_name) DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 7: Add to ontology_relationships
-- ================================================================

INSERT INTO ontology_relationships (
  from_table, to_table, relationship_type, from_column, to_column, ai_usage_hint
) VALUES
('ontology_action_types', 'features', 'many_to_one', 'feature_id', 'feature_id',
 '⭐⭐ Action → Feature. 어떤 기능에서 이 액션이 가능한지.'),
('ontology_action_types', 'ontology_event_types', 'many_to_one', 'creates_event', 'event_name',
 '⭐⭐ Action → Event. 액션이 어떤 이벤트를 생성하는지.')
ON CONFLICT DO NOTHING;

-- ================================================================
-- PART 8: Add constraint for action queries
-- ================================================================

INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'action_query_pattern',
  'QUERY_PATTERN',
  'ontology_action_types',
  'Use ontology_action_types for user action queries',
  'info',
  '## 🎯 Action 조회 패턴

### 구조
```
User → Role → Feature → Action → Event
                          ↓
                     target_table
```

### ✅ 특정 사용자가 할 수 있는 액션 조회
```sql
SELECT DISTINCT a.action_name, a.action_name_ko, a.target_table
FROM ontology_action_types a
JOIN features f ON a.feature_id = f.feature_id
JOIN role_permissions rp ON f.feature_id = rp.feature_id
JOIN user_roles ur ON rp.role_id = ur.role_id
WHERE ur.user_id = $user_id
  AND rp.can_access = true
  AND a.is_active = true
```

### ✅ 특정 테이블에 영향 미치는 액션 조회
```sql
SELECT action_name, actor_type, creates_event
FROM ontology_action_types
WHERE target_table = ''shift_requests''
   OR ''shift_requests'' = ANY(affects_tables)
```

### ✅ 액션 → 이벤트 연결 조회
```sql
SELECT a.action_name, a.action_name_ko,
       e.event_name, e.source_table
FROM ontology_action_types a
JOIN ontology_event_types e ON a.creates_event = e.event_name
WHERE a.action_category = ''hr''
```'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 9: Verification
-- ================================================================

SELECT '=== ontology_action_types created ===' as info;
SELECT action_name, action_name_ko, actor_type, target_table, creates_event
FROM ontology_action_types
WHERE is_active = true
ORDER BY action_category, action_name;

SELECT '=== Actions by category ===' as info;
SELECT action_category, COUNT(*) as action_count
FROM ontology_action_types
GROUP BY action_category
ORDER BY action_count DESC;

SELECT '=== Action → Event mapping ===' as info;
SELECT a.action_name, a.creates_event, e.source_table
FROM ontology_action_types a
LEFT JOIN ontology_event_types e ON a.creates_event = e.event_name
ORDER BY a.action_category;
