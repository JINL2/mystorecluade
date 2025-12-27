-- ============================================================
-- TRADE RPC SQL FIX - 수동 실행 필요
-- ============================================================
-- 생성일: 2025-12-26
-- 목적: Trade RPC 함수들의 컬럼명 버그 수정
--
-- 컬럼명 매핑 (잘못됨 → 올바름):
-- ============================================================
-- trade_letters_of_credit:
--   id → lc_id
--   expiry_date → expiry_date_utc
--   latest_shipment_date → latest_shipment_date_utc
--   currency → currency_id (또는 JOIN으로 가져와야 함)
--   created_at → created_at_utc
--
-- trade_purchase_orders:
--   id → po_id
--   counterparty_id → buyer_id
--   created_at → created_at_utc
--
-- trade_shipments:
--   id → shipment_id
--   etd → (없음, LC의 latest_shipment_date_utc 사용)
--
-- counterparties:
--   id → counterparty_id
--
-- trade_activity_logs:
--   action_type → action
--   action_description → action_detail
--   performed_at → created_at_utc
--   performed_by → created_by
-- ============================================================

-- ============================================================
-- 1. trade_dashboard_summary 함수 수정
-- ============================================================
CREATE OR REPLACE FUNCTION public.trade_dashboard_summary(
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL::uuid,
  p_date_from date DEFAULT NULL::date,
  p_date_to date DEFAULT NULL::date
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_overview JSONB;
  v_by_status JSONB;
  v_alerts JSONB;
  v_recent_activities JSONB;
BEGIN
  -- Overview stats
  SELECT jsonb_build_object(
    'active_pos', (SELECT COUNT(*) FROM trade_purchase_orders WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status NOT IN ('COMPLETED', 'CANCELLED')),
    'active_lcs', (SELECT COUNT(*) FROM trade_letters_of_credit WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')),
    'pending_shipments', (SELECT COUNT(*) FROM trade_shipments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status IN ('PREPARING', 'BOOKED')),
    'pending_payments', (SELECT COUNT(*) FROM trade_payments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status = 'PENDING'),
    'total_lc_value', (SELECT COALESCE(SUM(amount), 0) FROM trade_letters_of_credit WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')),
    'total_received', (SELECT COALESCE(SUM(amount), 0) FROM trade_payments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status = 'COMPLETED')
  ) INTO v_overview;

  -- By status (FIXED: Added COALESCE for empty results)
  SELECT jsonb_build_object(
    'pi', (
      SELECT COALESCE(jsonb_object_agg(status, cnt), '{}'::jsonb) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_proforma_invoices
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ),
    'po', (
      SELECT COALESCE(jsonb_object_agg(status, cnt), '{}'::jsonb) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_purchase_orders
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ),
    'lc', (
      SELECT COALESCE(jsonb_object_agg(status, cnt), '{}'::jsonb) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_letters_of_credit
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ),
    'shipment', (
      SELECT COALESCE(jsonb_object_agg(status, cnt), '{}'::jsonb) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_shipments
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    )
  ) INTO v_by_status;

  -- Alerts (FIXED: expiry_date -> expiry_date_utc, lc.id -> lc.lc_id, etd removed)
  SELECT jsonb_build_object(
    'expiring_lcs', (
      SELECT COUNT(*) FROM trade_letters_of_credit
      WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND expiry_date_utc::date - CURRENT_DATE <= 14
      AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')
    ),
    'overdue_shipments', (
      -- Shipments linked to LCs where latest_shipment_date has passed but not yet shipped
      SELECT COUNT(*) FROM trade_shipments s
      JOIN trade_letters_of_credit lc ON s.lc_id = lc.lc_id
      WHERE s.company_id = p_company_id
      AND (p_store_id IS NULL OR s.store_id = p_store_id)
      AND lc.latest_shipment_date_utc < CURRENT_TIMESTAMP
      AND s.status IN ('PREPARING', 'BOOKED')
      AND s.shipped_date_utc IS NULL
    ),
    'pending_documents', (
      SELECT COUNT(DISTINCT lc.lc_id) FROM trade_letters_of_credit lc
      WHERE lc.company_id = p_company_id
      AND (p_store_id IS NULL OR lc.store_id = p_store_id)
      AND lc.status IN ('ACCEPTED', 'DOCS_IN_PREPARATION')
    )
  ) INTO v_alerts;

  -- Recent activities (FIXED: action_type -> action, action_description -> action_detail, performed_at -> created_at_utc)
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'entity_type', entity_type,
      'entity_id', entity_id,
      'action_type', action,
      'action_description', action_detail,
      'performed_at', created_at_utc
    ) ORDER BY created_at_utc DESC
  ), '[]'::jsonb)
  INTO v_recent_activities
  FROM (
    SELECT entity_type, entity_id, action, action_detail, created_at_utc
    FROM trade_activity_logs
    WHERE company_id = p_company_id
    ORDER BY created_at_utc DESC
    LIMIT 10
  ) sub;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'overview', v_overview,
      'by_status', v_by_status,
      'alerts', v_alerts,
      'recent_activities', v_recent_activities
    )
  );
END;
$function$;

-- ============================================================
-- 2. trade_lc_list 함수 수정
-- ============================================================
CREATE OR REPLACE FUNCTION public.trade_lc_list(
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL::uuid,
  p_status text[] DEFAULT NULL::text[],
  p_counterparty_id uuid DEFAULT NULL::uuid,
  p_expiring_within_days integer DEFAULT NULL::integer,
  p_date_from date DEFAULT NULL::date,
  p_date_to date DEFAULT NULL::date,
  p_search text DEFAULT NULL::text,
  p_page integer DEFAULT 1,
  p_page_size integer DEFAULT 20
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_offset INT := (p_page - 1) * p_page_size;
  v_total_count INT;
  v_data JSONB;
BEGIN
  SELECT COUNT(*)
  INTO v_total_count
  FROM trade_letters_of_credit lc
  LEFT JOIN trade_purchase_orders po ON po.po_id = lc.po_id
  WHERE lc.company_id = p_company_id
    AND (p_store_id IS NULL OR lc.store_id = p_store_id)
    AND (p_status IS NULL OR lc.status = ANY(p_status))
    AND (p_counterparty_id IS NULL OR po.buyer_id = p_counterparty_id)
    AND (p_expiring_within_days IS NULL OR (lc.expiry_date_utc::date - CURRENT_DATE) <= p_expiring_within_days)
    AND (p_date_from IS NULL OR lc.created_at_utc::DATE >= p_date_from)
    AND (p_date_to IS NULL OR lc.created_at_utc::DATE <= p_date_to)
    AND (p_search IS NULL OR lc.lc_number ILIKE '%' || p_search || '%');

  SELECT COALESCE(jsonb_agg(row_data ORDER BY created_at_utc DESC), '[]'::jsonb)
  INTO v_data
  FROM (
    SELECT jsonb_build_object(
      'id', lc.lc_id,
      'lc_number', lc.lc_number,
      'status', lc.status,
      'po_id', lc.po_id,
      'po_number', po.po_number,
      'counterparty_name', c.name,
      'amount', lc.amount,
      'currency_id', lc.currency_id,
      'expiry_date', lc.expiry_date_utc,
      'latest_shipment_date', lc.latest_shipment_date_utc,
      'days_to_expiry', lc.expiry_date_utc::date - CURRENT_DATE,
      'created_at', lc.created_at_utc
    ) as row_data,
    lc.created_at_utc
    FROM trade_letters_of_credit lc
    LEFT JOIN trade_purchase_orders po ON po.po_id = lc.po_id
    LEFT JOIN counterparties c ON c.counterparty_id = po.buyer_id
    WHERE lc.company_id = p_company_id
      AND (p_store_id IS NULL OR lc.store_id = p_store_id)
      AND (p_status IS NULL OR lc.status = ANY(p_status))
      AND (p_counterparty_id IS NULL OR po.buyer_id = p_counterparty_id)
      AND (p_expiring_within_days IS NULL OR (lc.expiry_date_utc::date - CURRENT_DATE) <= p_expiring_within_days)
      AND (p_date_from IS NULL OR lc.created_at_utc::DATE >= p_date_from)
      AND (p_date_to IS NULL OR lc.created_at_utc::DATE <= p_date_to)
      AND (p_search IS NULL OR lc.lc_number ILIKE '%' || p_search || '%')
    ORDER BY lc.created_at_utc DESC
    LIMIT p_page_size OFFSET v_offset
  ) sub;

  RETURN jsonb_build_object(
    'success', true,
    'data', v_data,
    'pagination', jsonb_build_object(
      'page', p_page,
      'page_size', p_page_size,
      'total_count', v_total_count,
      'total_pages', CEIL(v_total_count::DECIMAL / p_page_size)::INT,
      'has_next', (p_page * p_page_size) < v_total_count,
      'has_prev', p_page > 1
    )
  );
END;
$function$;

-- ============================================================
-- 3. trade_alert_generate_daily 함수 수정
-- ============================================================
CREATE OR REPLACE FUNCTION public.trade_alert_generate_daily(p_company_id uuid DEFAULT NULL::uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_alert_count INT := 0;
  v_temp_count INT;
BEGIN
  -- L/C Expiry Alerts (7 days)
  INSERT INTO trade_alerts (company_id, alert_type, priority, title, message, entity_type, entity_id, created_at)
  SELECT
    company_id, 'LC_EXPIRY', 'HIGH',
    'L/C 만료 임박',
    'L/C ' || lc_number || '이(가) ' || (expiry_date_utc::date - CURRENT_DATE) || '일 후 만료됩니다.',
    'LC', lc_id, NOW()
  FROM trade_letters_of_credit
  WHERE (p_company_id IS NULL OR company_id = p_company_id)
    AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')
    AND expiry_date_utc::date - CURRENT_DATE <= 7
    AND expiry_date_utc::date >= CURRENT_DATE
    AND NOT EXISTS(
      SELECT 1 FROM trade_alerts a
      WHERE a.entity_id = trade_letters_of_credit.lc_id
        AND a.alert_type = 'LC_EXPIRY'
        AND a.created_at::DATE = CURRENT_DATE
    );
  GET DIAGNOSTICS v_temp_count = ROW_COUNT;
  v_alert_count := v_alert_count + v_temp_count;

  -- Shipment Date Alerts (3 days)
  INSERT INTO trade_alerts (company_id, alert_type, priority, title, message, entity_type, entity_id, created_at)
  SELECT
    company_id, 'SHIPMENT_DATE', 'HIGH',
    '선적기일 임박',
    'L/C ' || lc_number || '의 선적기일이 ' || (latest_shipment_date_utc::date - CURRENT_DATE) || '일 남았습니다.',
    'LC', lc_id, NOW()
  FROM trade_letters_of_credit
  WHERE (p_company_id IS NULL OR company_id = p_company_id)
    AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')
    AND latest_shipment_date_utc::date - CURRENT_DATE <= 3
    AND latest_shipment_date_utc::date >= CURRENT_DATE
    AND NOT EXISTS(
      SELECT 1 FROM trade_alerts a
      WHERE a.entity_id = trade_letters_of_credit.lc_id
        AND a.alert_type = 'SHIPMENT_DATE'
        AND a.created_at::DATE = CURRENT_DATE
    );
  GET DIAGNOSTICS v_temp_count = ROW_COUNT;
  v_alert_count := v_alert_count + v_temp_count;

  -- Pending Payment Alerts
  INSERT INTO trade_alerts (company_id, alert_type, priority, title, message, entity_type, entity_id, created_at)
  SELECT
    lc.company_id, 'PAYMENT_PENDING', 'MEDIUM',
    '결제 대기중',
    'L/C ' || lc.lc_number || '에 대한 결제가 대기중입니다.',
    'LC', lc.lc_id, NOW()
  FROM trade_letters_of_credit lc
  WHERE (p_company_id IS NULL OR lc.company_id = p_company_id)
    AND lc.status = 'PAYMENT_PENDING'
    AND NOT EXISTS(
      SELECT 1 FROM trade_alerts a
      WHERE a.entity_id = lc.lc_id
        AND a.alert_type = 'PAYMENT_PENDING'
        AND a.created_at::DATE = CURRENT_DATE
    );
  GET DIAGNOSTICS v_temp_count = ROW_COUNT;
  v_alert_count := v_alert_count + v_temp_count;

  RETURN jsonb_build_object('success', true, 'data', jsonb_build_object('alerts_generated', v_alert_count));
END;
$function$;

-- ============================================================
-- 4. trade_lc_check_validity 함수 수정
-- ============================================================
CREATE OR REPLACE FUNCTION public.trade_lc_check_validity(p_company_id uuid, p_lc_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_lc RECORD;
  v_warnings JSONB := '[]'::JSONB;
  v_errors JSONB := '[]'::JSONB;
  v_is_valid BOOLEAN := true;
  v_doc_total INT;
  v_doc_uploaded INT;
  v_missing_docs TEXT[];
BEGIN
  SELECT * INTO v_lc FROM trade_letters_of_credit WHERE lc_id = p_lc_id AND company_id = p_company_id;

  IF v_lc IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', jsonb_build_object('code', 'LC_NOT_FOUND', 'message', 'L/C를 찾을 수 없습니다'));
  END IF;

  -- Check expiry (FIXED: expiry_date -> expiry_date_utc)
  IF v_lc.expiry_date_utc::date < CURRENT_DATE THEN
    v_errors := v_errors || jsonb_build_object('type', 'LC_EXPIRED', 'message', 'L/C가 만료되었습니다');
    v_is_valid := false;
  ELSIF v_lc.expiry_date_utc::date - CURRENT_DATE <= 14 THEN
    v_warnings := v_warnings || jsonb_build_object('type', 'EXPIRY_WARNING', 'message', 'L/C가 ' || (v_lc.expiry_date_utc::date - CURRENT_DATE) || '일 후 만료됩니다', 'days_remaining', v_lc.expiry_date_utc::date - CURRENT_DATE);
  END IF;

  -- Check shipment date (FIXED: latest_shipment_date -> latest_shipment_date_utc)
  IF v_lc.latest_shipment_date_utc::date < CURRENT_DATE THEN
    v_errors := v_errors || jsonb_build_object('type', 'SHIPMENT_DATE_EXCEEDED', 'message', '선적기일이 초과되었습니다');
    v_is_valid := false;
  ELSIF v_lc.latest_shipment_date_utc::date - CURRENT_DATE <= 7 THEN
    v_warnings := v_warnings || jsonb_build_object('type', 'SHIPMENT_WARNING', 'message', '선적기일이 ' || (v_lc.latest_shipment_date_utc::date - CURRENT_DATE) || '일 남았습니다');
  END IF;

  -- Check required documents
  v_doc_total := jsonb_array_length(COALESCE(v_lc.required_documents, '[]'::JSONB));
  SELECT COUNT(*) INTO v_doc_uploaded
  FROM trade_documents d
  WHERE d.entity_type = 'LC' AND d.entity_id = p_lc_id;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'is_valid', v_is_valid,
      'warnings', v_warnings,
      'errors', v_errors,
      'document_checklist', jsonb_build_object(
        'total', v_doc_total,
        'uploaded', v_doc_uploaded
      )
    )
  );
END;
$function$;

-- ============================================================
-- 변경 사항 요약 (총 4개 함수 수정)
-- ============================================================
--
-- 1. trade_dashboard_summary:
--    - expiry_date → expiry_date_utc
--    - lc.id → lc.lc_id
--    - etd → LC JOIN으로 latest_shipment_date_utc 사용
--    - jsonb_object_agg에 COALESCE 추가
--
-- 2. trade_lc_list:
--    - po.id → po.po_id
--    - lc.id → lc.lc_id
--    - c.id → c.counterparty_id
--    - po.counterparty_id → po.buyer_id
--    - expiry_date → expiry_date_utc
--    - latest_shipment_date → latest_shipment_date_utc
--    - currency → currency_id
--    - created_at → created_at_utc
--
-- 3. trade_alert_generate_daily:
--    - expiry_date → expiry_date_utc
--    - latest_shipment_date → latest_shipment_date_utc
--    - id → lc_id
--
-- 4. trade_lc_check_validity:
--    - id → lc_id (WHERE 조건)
--    - expiry_date → expiry_date_utc
--    - latest_shipment_date → latest_shipment_date_utc
-- ============================================================
