-- =====================================================
-- Fix send_notification_to_user - Remove manual push call
-- =====================================================
-- Problem: send_push_notification_via_edge fails when called from
-- another function because JWT claims are not available.
--
-- Solution: Remove the manual push call since notifications table
-- has a trigger that automatically calls the Edge Function on INSERT.
-- This avoids the JWT issue entirely.

CREATE OR REPLACE FUNCTION public.send_notification_to_user(
  p_user_id uuid,
  p_title text,
  p_body text,
  p_category character varying DEFAULT NULL::character varying,
  p_data jsonb DEFAULT NULL::jsonb,
  p_action_url text DEFAULT NULL::text,
  p_image_url text DEFAULT NULL::text,
  p_scheduled_time timestamp with time zone DEFAULT NULL::timestamp with time zone
)
RETURNS uuid
LANGUAGE plpgsql
AS $function$
DECLARE
  v_notification_id UUID;
BEGIN
  -- 알림 레코드 생성
  -- ★ Trigger on notifications table will automatically call Edge Function
  INSERT INTO notifications (
    user_id,
    title,
    body,
    category,
    data,
    action_url,
    image_url,
    scheduled_time
  ) VALUES (
    p_user_id,
    p_title,
    p_body,
    p_category,
    p_data,
    p_action_url,
    p_image_url,
    p_scheduled_time
  ) RETURNING id INTO v_notification_id;

  -- ★ REMOVED: Manual push call - trigger handles this automatically
  -- IF p_scheduled_time IS NULL OR p_scheduled_time <= NOW() THEN
  --   PERFORM send_push_notification_via_edge(v_notification_id);
  -- END IF;

  RETURN v_notification_id;
END;
$function$;

COMMENT ON FUNCTION public.send_notification_to_user(uuid, text, text, character varying, jsonb, text, text, timestamp with time zone) IS
'Send notification to a user. Inserts into notifications table.
Push delivery is handled automatically by table trigger.';
