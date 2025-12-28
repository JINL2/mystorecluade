-- Fix trade_pi_convert_to_po RPC to use correct column names
-- The existing RPC uses incorrect column names that don't match the actual table schema
--
-- Issues fixed:
-- 1. Uses pi_id instead of id for PI lookup
-- 2. Uses po_id instead of id for PO insertion
-- 3. Maps correct column names between PI and PO items tables
-- 4. Uses lowercase status values to match actual data

CREATE OR REPLACE FUNCTION public.trade_pi_convert_to_po(
  p_pi_id UUID,
  p_company_id UUID,
  p_user_id UUID
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_pi RECORD;
  v_po_id UUID;
  v_po_number TEXT;
  v_now TIMESTAMPTZ := NOW();
  v_seq INT;
  v_date_part TEXT;
BEGIN
  -- Get PI using correct column name (pi_id, not id)
  SELECT * INTO v_pi
  FROM trade_proforma_invoices
  WHERE pi_id = p_pi_id AND company_id = p_company_id;

  IF v_pi IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', jsonb_build_object('code', 'PI_NOT_FOUND', 'message', 'PI를 찾을 수 없습니다'));
  END IF;

  -- Check status (lowercase to match our actual values)
  IF v_pi.status NOT IN ('accepted', 'sent') THEN
    RETURN jsonb_build_object('success', false, 'error', jsonb_build_object('code', 'PI_INVALID_STATUS', 'message', 'sent 또는 accepted 상태의 PI만 변환할 수 있습니다'));
  END IF;

  -- Check if already converted
  IF EXISTS(SELECT 1 FROM trade_purchase_orders WHERE pi_id = p_pi_id) THEN
    RETURN jsonb_build_object('success', false, 'error', jsonb_build_object('code', 'PI_ALREADY_CONVERTED', 'message', '이미 PO로 변환되었습니다'));
  END IF;

  -- Generate PO number (format: PO-YYYYMMDD-XXXX)
  v_date_part := TO_CHAR(CURRENT_DATE, 'YYYYMMDD');

  SELECT COALESCE(MAX(
    NULLIF(regexp_replace(po_number, '^PO-' || v_date_part || '-', ''), '')::INT
  ), 0) + 1
  INTO v_seq
  FROM trade_purchase_orders
  WHERE company_id = p_company_id AND po_number LIKE 'PO-' || v_date_part || '-%';

  v_po_number := 'PO-' || v_date_part || '-' || LPAD(v_seq::TEXT, 4, '0');

  -- Generate new UUID for PO
  v_po_id := gen_random_uuid();

  -- Create PO with correct column names
  INSERT INTO trade_purchase_orders (
    po_id,
    po_number,
    company_id,
    store_id,
    pi_id,
    buyer_id,
    buyer_info,
    currency_id,
    total_amount,
    incoterms_code,
    incoterms_place,
    payment_terms_code,
    order_date_utc,
    partial_shipment_allowed,
    transshipment_allowed,
    notes,
    status,
    version,
    created_by,
    created_at_utc,
    updated_at_utc
  ) VALUES (
    v_po_id,
    v_po_number,
    p_company_id,
    v_pi.store_id,
    p_pi_id,
    v_pi.counterparty_id,  -- buyer_id = counterparty_id from PI
    v_pi.counterparty_info, -- buyer_info = counterparty_info from PI
    v_pi.currency_id,
    v_pi.total_amount,
    v_pi.incoterms_code,
    v_pi.incoterms_place,
    v_pi.payment_terms_code,
    v_now,  -- order_date_utc = now
    v_pi.partial_shipment_allowed,
    v_pi.transshipment_allowed,
    v_pi.notes,
    'draft',
    1,
    p_user_id,
    v_now,
    v_now
  );

  -- Copy items from PI to PO with correct column mappings
  INSERT INTO trade_po_items (
    po_id,
    pi_item_id,
    product_id,
    description,
    sku,
    hs_code,
    quantity_ordered,
    quantity_shipped,
    unit,
    unit_price,
    total_amount,
    sort_order,
    created_at_utc
  )
  SELECT
    v_po_id,
    item_id,        -- pi_item_id references the original PI item
    product_id,
    description,
    sku,
    hs_code,
    quantity,       -- quantity -> quantity_ordered
    0,              -- quantity_shipped starts at 0
    unit,
    unit_price,
    total_amount,
    sort_order,
    v_now
  FROM trade_pi_items WHERE pi_id = p_pi_id;

  -- Update PI status to 'converted'
  UPDATE trade_proforma_invoices SET
    status = 'converted',
    version = version + 1,
    updated_at_utc = v_now
  WHERE pi_id = p_pi_id;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'pi_id', p_pi_id,
      'pi_status', 'converted',
      'po_id', v_po_id,
      'po_number', v_po_number
    )
  );
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', jsonb_build_object('code', 'PI_CONVERT_ERROR', 'message', SQLERRM));
END;
$function$;

-- Fix existing POs that were created without items
-- Copy items from the linked PI for any PO that has a pi_id but no items
INSERT INTO trade_po_items (
  po_id, pi_item_id, product_id, description, sku, hs_code,
  quantity_ordered, quantity_shipped, unit, unit_price, total_amount, sort_order, created_at_utc
)
SELECT
  po.po_id,
  pi_items.item_id,
  pi_items.product_id,
  pi_items.description,
  pi_items.sku,
  pi_items.hs_code,
  pi_items.quantity,
  0,
  pi_items.unit,
  pi_items.unit_price,
  pi_items.total_amount,
  pi_items.sort_order,
  NOW()
FROM trade_purchase_orders po
JOIN trade_pi_items pi_items ON pi_items.pi_id = po.pi_id
WHERE po.pi_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM trade_po_items poi WHERE poi.po_id = po.po_id
  );
