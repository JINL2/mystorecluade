-- Fix: role_permissions 체크 시 can_access 컬럼 대신 row 존재 여부로 권한 확인
-- 기존: can_access = true인 경우만 알림 발송
-- 변경: role_permissions에 row가 있으면 알림 발송

CREATE OR REPLACE FUNCTION process_notification_queue(p_limit INT DEFAULT 100)
RETURNS TABLE(processed_count INT, notification_ids UUID[])
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_queue RECORD;
  v_config RECORD;
  v_event_data JSONB;
  v_target_users UUID[];
  v_user_id UUID;
  v_title TEXT;
  v_body TEXT;
  v_processed INT := 0;
  v_notification_ids UUID[] := ARRAY[]::UUID[];
  v_new_id UUID;
  v_push_enabled BOOLEAN;
  v_has_permission BOOLEAN;
  v_pref_enabled BOOLEAN;
  v_user_role_type TEXT;
  v_formatted_amount TEXT;
  v_currency_symbol TEXT;
  v_description_with_products TEXT;
  v_final_description TEXT;
  v_checkin_time TEXT;
  v_checkout_time TEXT;
  v_user_language_code VARCHAR(5);
  v_translation RECORD;
BEGIN
  FOR v_queue IN
    SELECT
      nq.*,
      ve.event_data,
      ve.subject_user_id,
      ve.actor_user_id
    FROM notification_queue nq
    JOIN v_events ve ON nq.source_table = ve.source_table
                    AND nq.source_id = ve.event_id
    WHERE nq.status = 'pending'
    ORDER BY nq.created_at
    LIMIT p_limit
    FOR UPDATE OF nq SKIP LOCKED
  LOOP
    SELECT nc.*, f.feature_id
    INTO v_config
    FROM notification_configs nc
    JOIN features f ON nc.feature_id = f.feature_id
    WHERE nc.event_type = v_queue.event_type
    LIMIT 1;

    IF v_config IS NULL THEN
      UPDATE notification_queue SET status = 'skipped', error_message = 'no config' WHERE queue_id = v_queue.queue_id;
      CONTINUE;
    END IF;

    v_event_data := v_queue.event_data;

    IF v_config.scope_level = 'user' THEN
      v_target_users := ARRAY[v_queue.subject_user_id];
    ELSE
      SELECT ARRAY_AGG(DISTINCT user_id) INTO v_target_users
      FROM (
        SELECT us.user_id FROM user_stores us
        WHERE us.store_id = v_queue.store_id AND us.is_deleted = false
        UNION
        SELECT ur.user_id FROM user_roles ur
        JOIN roles r ON ur.role_id = r.role_id
        WHERE r.company_id = v_queue.company_id AND r.role_type = 'owner' AND ur.is_deleted = false
      ) t;
    END IF;

    IF v_target_users IS NULL OR array_length(v_target_users, 1) IS NULL THEN
      UPDATE notification_queue SET status = 'skipped', error_message = 'no target users' WHERE queue_id = v_queue.queue_id;
      CONTINUE;
    END IF;

    -- 회사의 base currency symbol 가져오기
    SELECT COALESCE(ct.symbol, '')
    INTO v_currency_symbol
    FROM companies c
    LEFT JOIN currency_types ct ON c.base_currency_id = ct.currency_id
    WHERE c.company_id = v_queue.company_id;

    IF v_currency_symbol IS NULL THEN v_currency_symbol := ''; END IF;

    FOREACH v_user_id IN ARRAY v_target_users
    LOOP
      -- 1) push_enabled 체크
      SELECT COALESCE(uns.push_enabled, true)
      INTO v_push_enabled
      FROM user_notification_settings uns
      WHERE uns.user_id = v_user_id;

      IF v_push_enabled IS NULL THEN v_push_enabled := true; END IF;
      IF NOT v_push_enabled THEN CONTINUE; END IF;

      -- 2) role_permissions 체크 (해당 회사만)
      SELECT r.role_type INTO v_user_role_type
      FROM user_roles ur
      JOIN roles r ON ur.role_id = r.role_id
      WHERE ur.user_id = v_user_id
        AND ur.is_deleted = false
        AND r.company_id = v_queue.company_id
      LIMIT 1;

      IF v_user_role_type IS NULL THEN CONTINUE; END IF;

      IF v_user_role_type != 'owner' THEN
        -- 변경: can_access 체크 대신 row 존재 여부만 확인
        SELECT EXISTS(
          SELECT 1
          FROM user_roles ur
          JOIN roles r ON ur.role_id = r.role_id
          JOIN role_permissions rp ON ur.role_id = rp.role_id
          WHERE ur.user_id = v_user_id
            AND ur.is_deleted = false
            AND r.company_id = v_queue.company_id
            AND rp.feature_id = v_config.feature_id
        )
        INTO v_has_permission;

        IF NOT v_has_permission THEN CONTINUE; END IF;
      END IF;

      -- 3) notification_preferences 체크 (회사 + 매장 필터)
      SELECT COALESCE(np.is_enabled, true)
      INTO v_pref_enabled
      FROM notification_preferences np
      WHERE np.user_id = v_user_id
        AND np.feature_id = v_config.feature_id
        AND (np.company_id = v_queue.company_id OR np.company_id IS NULL)
        AND (np.store_id = v_queue.store_id OR np.store_id IS NULL)
      ORDER BY np.store_id NULLS LAST, np.company_id NULLS LAST
      LIMIT 1;

      IF v_pref_enabled IS NULL THEN v_pref_enabled := true; END IF;
      IF NOT v_pref_enabled THEN CONTINUE; END IF;

      -- 4) 사용자 언어 가져오기 (기본값: 'en')
      SELECT COALESCE(l.language_code, 'en')
      INTO v_user_language_code
      FROM users u
      LEFT JOIN languages l ON u.user_language = l.language_id
      WHERE u.user_id = v_user_id;

      IF v_user_language_code IS NULL THEN v_user_language_code := 'en'; END IF;

      -- 5) 해당 언어 템플릿 가져오기 (없으면 영어 fallback)
      SELECT nt.title_template, nt.body_template
      INTO v_translation
      FROM notification_translations nt
      WHERE nt.config_id = v_config.config_id
        AND nt.language_code = v_user_language_code;

      IF v_translation IS NULL THEN
        -- 영어 fallback
        SELECT nt.title_template, nt.body_template
        INTO v_translation
        FROM notification_translations nt
        WHERE nt.config_id = v_config.config_id
          AND nt.language_code = 'en';
      END IF;

      -- 템플릿 설정 (번역이 없으면 기본 config 사용)
      IF v_translation IS NOT NULL THEN
        v_title := v_translation.title_template;
        v_body := v_translation.body_template;
      ELSE
        v_title := v_config.title_template;
        v_body := v_config.body_template;
      END IF;

      -- 숫자 포맷팅 (통화기호 + 000,000 형식)
      v_formatted_amount := v_currency_symbol || COALESCE(
        TO_CHAR((v_event_data->>'amount')::NUMERIC, 'FM999,999,999,999'),
        ''
      );

      -- description + product_names 결합
      v_description_with_products := COALESCE(
        NULLIF(v_event_data->>'product_names', ''),
        NULLIF(v_event_data->>'description', ''),
        ''
      );

      IF v_description_with_products != '' THEN
        v_final_description := ' - ' || v_description_with_products;
      ELSE
        v_final_description := '';
      END IF;

      -- 체크인/체크아웃 시간 포맷팅 (HH:MI 형식)
      v_checkin_time := COALESCE(
        TO_CHAR((v_event_data->>'actual_time_utc')::timestamptz, 'HH24:MI'),
        ''
      );
      v_checkout_time := COALESCE(
        TO_CHAR((v_event_data->>'actual_end_utc')::timestamptz, 'HH24:MI'),
        ''
      );

      -- 템플릿 치환
      v_title := REPLACE(v_title, '{{employee_name}}', COALESCE(v_event_data->>'employee_name', ''));
      v_title := REPLACE(v_title, '{{store_name}}', COALESCE(v_event_data->>'store_name', ''));
      v_title := REPLACE(v_title, '{{amount}}', v_formatted_amount);

      v_body := REPLACE(v_body, '{{employee_name}}', COALESCE(v_event_data->>'employee_name', ''));
      v_body := REPLACE(v_body, '{{store_name}}', COALESCE(v_event_data->>'store_name', ''));
      v_body := REPLACE(v_body, '{{amount}}', v_formatted_amount);
      v_body := REPLACE(v_body, '{{description}}', v_final_description);
      v_body := REPLACE(v_body, '{{late_minutes}}', COALESCE(v_event_data->>'late_minutes', ''));
      v_body := REPLACE(v_body, '{{account_name}}', COALESCE(v_event_data->>'account_name', ''));
      v_body := REPLACE(v_body, '{{product_names}}', COALESCE(v_event_data->>'product_names', ''));
      v_body := REPLACE(v_body, '{{creator_name}}', COALESCE(v_event_data->>'creator_name', ''));
      v_body := REPLACE(v_body, '{{shift_name}}', COALESCE(v_event_data->>'shift_name', ''));
      v_body := REPLACE(v_body, '{{checkin_time}}', v_checkin_time);
      v_body := REPLACE(v_body, '{{checkout_time}}', v_checkout_time);

      INSERT INTO notifications (id, user_id, title, body, category, data, created_at)
      VALUES (gen_random_uuid(), v_user_id, v_title, v_body, v_queue.event_type, v_event_data, NOW())
      RETURNING id INTO v_new_id;

      v_notification_ids := array_append(v_notification_ids, v_new_id);
    END LOOP;

    UPDATE notification_queue SET status = 'sent', processed_at = NOW() WHERE queue_id = v_queue.queue_id;
    v_processed := v_processed + 1;
  END LOOP;

  RETURN QUERY SELECT v_processed, v_notification_ids;
END;
$$;
