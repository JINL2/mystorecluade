-- ============================================================================
-- Report Control RPC Function Metadata
-- Created: 2025-11-20
-- Description: Insert metadata for Report Control RPC functions into rpc_function_metadata table
-- Feature ID: 982fe5d5-d4d6-42bb-b8a7-cc653aa67a48
-- ============================================================================

-- Delete existing metadata for report control functions (if re-running)
DELETE FROM rpc_function_metadata
WHERE rpc_name LIKE 'report_%';

-- ============================================================================
-- 1. report_get_user_received_reports
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_get_user_received_reports',
  '사용자가 받은 모든 리포트를 완전한 세부정보와 함께 조회합니다. 템플릿 정보, 생성 세션 상태, 구독 설정을 포함하여 UI에서 필터링할 수 있습니다.',
  '{
    "type": "object",
    "required": ["p_user_id"],
    "properties": {
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      },
      "p_company_id": {
        "type": "string",
        "format": "uuid",
        "description": "회사 ID로 필터링 (선택)"
      },
      "p_limit": {
        "type": "integer",
        "default": 50,
        "description": "페이지당 항목 수 (기본: 50)"
      },
      "p_offset": {
        "type": "integer",
        "default": 0,
        "description": "페이지 오프셋 (기본: 0)"
      }
    }
  }'::jsonb,
  '{
    "type": "array",
    "items": {
      "type": "object",
      "properties": {
        "notification_id": {"type": "string", "format": "uuid"},
        "title": {"type": "string"},
        "body": {"type": "string", "description": "리포트 전체 본문 (마크다운)"},
        "is_read": {"type": "boolean"},
        "sent_at": {"type": "string", "format": "date-time"},
        "created_at": {"type": "string", "format": "date-time"},
        "report_date": {"type": "string", "format": "date"},
        "session_id": {"type": "string", "format": "uuid"},
        "template_id": {"type": "string", "format": "uuid"},
        "subscription_id": {"type": "string", "format": "uuid"},
        "template_name": {"type": "string"},
        "template_code": {"type": "string"},
        "template_icon": {"type": "string"},
        "template_frequency": {"type": "string", "enum": ["daily", "weekly", "monthly"]},
        "session_status": {"type": "string", "enum": ["pending", "processing", "completed", "failed"]},
        "session_started_at": {"type": "string", "format": "date-time"},
        "session_completed_at": {"type": "string", "format": "date-time"},
        "session_error_message": {"type": "string"},
        "processing_time_ms": {"type": "integer"},
        "subscription_enabled": {"type": "boolean"},
        "subscription_schedule_time": {"type": "string", "format": "time"},
        "subscription_schedule_days": {"type": "array"},
        "store_id": {"type": "string", "format": "uuid"},
        "store_name": {"type": "string"}
      }
    }
  }'::jsonb,
  '["notification_id", "template_id", "session_status"]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 2. report_get_available_templates_with_status
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_get_available_templates_with_status',
  '구독 가능한 모든 리포트 템플릿과 사용자의 구독 상태를 조회합니다. is_subscribed 필드로 구독 여부를 확인하고, 최근 30일 통계를 포함합니다.',
  '{
    "type": "object",
    "required": ["p_user_id", "p_company_id"],
    "properties": {
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      },
      "p_company_id": {
        "type": "string",
        "format": "uuid",
        "description": "회사 ID (필수)"
      }
    }
  }'::jsonb,
  '{
    "type": "array",
    "items": {
      "type": "object",
      "properties": {
        "template_id": {"type": "string", "format": "uuid"},
        "template_name": {"type": "string"},
        "template_code": {"type": "string"},
        "description": {"type": "string"},
        "frequency": {"type": "string", "enum": ["daily", "weekly", "monthly"]},
        "icon": {"type": "string"},
        "display_order": {"type": "integer"},
        "default_schedule_time": {"type": "string", "format": "time"},
        "default_schedule_days": {"type": "array"},
        "default_monthly_day": {"type": "integer"},
        "category_id": {"type": "string", "format": "uuid"},
        "is_subscribed": {"type": "boolean", "description": "구독 여부 (핵심 필드)"},
        "subscription_id": {"type": "string", "format": "uuid"},
        "subscription_enabled": {"type": "boolean"},
        "subscription_schedule_time": {"type": "string", "format": "time"},
        "subscription_schedule_days": {"type": "array"},
        "subscription_monthly_send_day": {"type": "integer"},
        "subscription_timezone": {"type": "string"},
        "subscription_last_sent_at": {"type": "string", "format": "date-time"},
        "subscription_next_scheduled_at": {"type": "string", "format": "date-time"},
        "subscription_created_at": {"type": "string", "format": "date-time"},
        "store_id": {"type": "string", "format": "uuid"},
        "store_name": {"type": "string"},
        "recent_reports_count": {"type": "integer"},
        "last_report_date": {"type": "string", "format": "date"},
        "last_report_status": {"type": "string"}
      }
    }
  }'::jsonb,
  '["template_id", "is_subscribed", "subscription_enabled"]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 3. report_get_user_statistics
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_get_user_statistics',
  '사용자의 리포트 활동 통계를 요약하여 제공합니다. 대시보드 위젯에 사용됩니다.',
  '{
    "type": "object",
    "required": ["p_user_id", "p_company_id"],
    "properties": {
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      },
      "p_company_id": {
        "type": "string",
        "format": "uuid",
        "description": "회사 ID (필수)"
      }
    }
  }'::jsonb,
  '{
    "type": "object",
    "properties": {
      "total_subscriptions": {"type": "integer", "description": "총 구독 수"},
      "active_subscriptions": {"type": "integer", "description": "활성화된 구독 수"},
      "total_reports_received": {"type": "integer", "description": "받은 총 리포트 수"},
      "unread_reports": {"type": "integer", "description": "안 읽은 리포트 수"},
      "reports_last_7_days": {"type": "integer", "description": "최근 7일간 리포트 수"},
      "reports_last_30_days": {"type": "integer", "description": "최근 30일간 리포트 수"},
      "failed_reports_count": {"type": "integer", "description": "실패한 리포트 수"},
      "pending_reports_count": {"type": "integer", "description": "대기/처리중 리포트 수"}
    }
  }'::jsonb,
  '["total_subscriptions", "unread_reports"]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 4. report_mark_as_read
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_mark_as_read',
  '리포트 알림을 읽음으로 표시합니다.',
  '{
    "type": "object",
    "required": ["p_notification_id", "p_user_id"],
    "properties": {
      "p_notification_id": {
        "type": "string",
        "format": "uuid",
        "description": "알림 ID (필수)"
      },
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      }
    }
  }'::jsonb,
  '{
    "type": "boolean",
    "description": "성공 여부"
  }'::jsonb,
  '[]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 5. report_subscribe_to_template
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_subscribe_to_template',
  '새로운 리포트 구독을 생성합니다. 템플릿의 기본값이 자동으로 적용됩니다.',
  '{
    "type": "object",
    "required": ["p_user_id", "p_company_id", "p_template_id"],
    "properties": {
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      },
      "p_company_id": {
        "type": "string",
        "format": "uuid",
        "description": "회사 ID (필수)"
      },
      "p_store_id": {
        "type": "string",
        "format": "uuid",
        "description": "매장 ID (선택)"
      },
      "p_template_id": {
        "type": "string",
        "format": "uuid",
        "description": "템플릿 ID (필수)"
      },
      "p_subscription_name": {
        "type": "string",
        "description": "커스텀 구독 이름 (선택)"
      },
      "p_schedule_time": {
        "type": "string",
        "format": "time",
        "description": "스케줄 시간 (선택, 기본: 템플릿 기본값)"
      },
      "p_schedule_days": {
        "type": "array",
        "items": {"type": "integer", "minimum": 0, "maximum": 6},
        "description": "스케줄 요일 [0-6] (선택, 기본: 템플릿 기본값)"
      },
      "p_monthly_send_day": {
        "type": "integer",
        "minimum": 1,
        "maximum": 31,
        "description": "월간 발송일 (선택)"
      },
      "p_timezone": {
        "type": "string",
        "default": "UTC",
        "description": "타임존 (기본: UTC)"
      },
      "p_notification_channels": {
        "type": "array",
        "items": {"type": "string", "enum": ["push", "email", "sms"]},
        "default": ["push"],
        "description": "알림 채널 (기본: [push])"
      }
    }
  }'::jsonb,
  '{
    "type": "object",
    "properties": {
      "subscription_id": {"type": "string", "format": "uuid"},
      "template_name": {"type": "string"},
      "enabled": {"type": "boolean"},
      "created_at": {"type": "string", "format": "date-time"}
    }
  }'::jsonb,
  '["subscription_id", "enabled"]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 6. report_update_subscription
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_update_subscription',
  '기존 리포트 구독 설정을 수정합니다. enabled 필드로 ON/OFF 토글이 가능합니다.',
  '{
    "type": "object",
    "required": ["p_subscription_id", "p_user_id"],
    "properties": {
      "p_subscription_id": {
        "type": "string",
        "format": "uuid",
        "description": "구독 ID (필수)"
      },
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      },
      "p_enabled": {
        "type": "boolean",
        "description": "활성화 여부 (선택)"
      },
      "p_schedule_time": {
        "type": "string",
        "format": "time",
        "description": "스케줄 시간 (선택)"
      },
      "p_schedule_days": {
        "type": "array",
        "items": {"type": "integer", "minimum": 0, "maximum": 6},
        "description": "스케줄 요일 [0-6] (선택)"
      },
      "p_monthly_send_day": {
        "type": "integer",
        "minimum": 1,
        "maximum": 31,
        "description": "월간 발송일 (선택)"
      },
      "p_timezone": {
        "type": "string",
        "description": "타임존 (선택)"
      }
    }
  }'::jsonb,
  '{
    "type": "boolean",
    "description": "성공 여부"
  }'::jsonb,
  '[]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 7. report_unsubscribe_from_template
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_unsubscribe_from_template',
  '리포트 구독을 취소(삭제)합니다.',
  '{
    "type": "object",
    "required": ["p_subscription_id", "p_user_id"],
    "properties": {
      "p_subscription_id": {
        "type": "string",
        "format": "uuid",
        "description": "구독 ID (필수)"
      },
      "p_user_id": {
        "type": "string",
        "format": "uuid",
        "description": "사용자 ID (필수)"
      }
    }
  }'::jsonb,
  '{
    "type": "boolean",
    "description": "성공 여부"
  }'::jsonb,
  '[]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- 8. report_get_template_categories
-- ============================================================================
INSERT INTO rpc_function_metadata (
  rpc_name,
  description,
  parameters,
  output_json,
  verifiable_fields,
  feature_id,
  created_at,
  updated_at
) VALUES (
  'report_get_template_categories',
  'UI 필터 드롭다운에 사용할 리포트 템플릿 카테고리 목록을 조회합니다.',
  '{
    "type": "object",
    "properties": {}
  }'::jsonb,
  '{
    "type": "array",
    "items": {
      "type": "object",
      "properties": {
        "category_id": {"type": "string", "format": "uuid"},
        "category_name": {"type": "string"},
        "template_count": {"type": "integer"}
      }
    }
  }'::jsonb,
  '["category_id"]'::jsonb,
  '982fe5d5-d4d6-42bb-b8a7-cc653aa67a48'::uuid,
  NOW(),
  NOW()
);

-- ============================================================================
-- Verify inserted metadata
-- ============================================================================

-- Check all report control RPC metadata
SELECT
  rpc_name,
  description,
  feature_id,
  created_at
FROM rpc_function_metadata
WHERE rpc_name LIKE 'report_%'
ORDER BY rpc_name;

-- ============================================================================
-- END OF FILE
-- ============================================================================
